<?php

namespace App\Http\Controllers\Api;

use App\Enums\PermissionType;
use App\Enums\RoleType;
use App\Exports\ExamResultsExport;
use App\Helper\NumberHelper;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\Exam\IndexRequest;
use App\Http\Requests\Exam\StoreRequest;
use App\Http\Requests\Exam\SubmitRequest;
use App\Http\Requests\Exam\SyncAnswerCacheRequest;
use App\Http\Requests\Exam\UpdateRequest;
use App\Http\Requests\Exam\UpdateStatusRequest;
use App\Models\Chapter;
use App\Models\Course;
use App\Models\Exam;
use App\Models\ExamQuestion;
use App\Models\ExamQuestionsOrder;
use App\Models\ExamResult;
use App\Models\ExamSupervisor;
use App\Models\ExamQuestionsAnswer;
use App\Models\Question;
use App\Models\Setting;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;

class ExamController extends Controller
{
    const QUESTIONS_CACHE_KEY = 'exam:@exam_id:-user:@user_id-questions';
    const ANSWERS_CACHE_KEY = 'exam:@exam_id:-user:@user_id-answers';

    public function index(IndexRequest $request)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_VIEW), 403);
        $validated = $request->validated();
        $date = Carbon::now();
        $relations = [
            'course',
            'course.subject',
            // 'exam_supervisors.user',
            // 'course.teacher',
        ];
        if (!empty($validated['month']) && !empty($validated['year'])) {
            $date->setYear((int) $validated['year']);
            $date->setMonth((int) $validated['month']);
        }

        try {
            $data = Exam::with($relations)->orderBy('exam_date');
            if (!empty($validated['month']) && !empty($validated['year'])) {
                $data->whereMonth('exam_date', '=', $date->month)
                    ->whereYear('exam_date', '=', $date->year);
            }
            if (!empty($validated['subject'])) {
                $data->whereHas('course.subject', function ($query) use ($validated) {
                    $query->where('name', 'like', '%' . $validated['subject'] . '%');
                });
            }

            switch ($user->role_id) {
                case RoleType::ADMIN->value:
                    $data = $data->get();
                    break;
                case RoleType::STUDENT->value:
                    $data = $data
                        ->whereHas('course.enrollments', function ($query) use ($user) {
                            $query->where('student_id', '=', $user->id);
                        })
                        ->get();
                    break;
                case RoleType::TEACHER->value:
                    $data = $data
                        ->whereHas('course.teacher', function ($query) use ($user) {
                            $query->where('id', '=', $user->id);
                        })
                        ->orWhereHas('supervisors', function ($query) use ($user) {
                            $query->where('user_id', '=', $user->id);
                        })
                        ->get();
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            return Reply::successWithData($data, '');
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }

    public function store(StoreRequest $request)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_CREATE), 403);
        $validated = $request->validated();

        DB::beginTransaction();
        try {
            $hard_count = $validated['hard_count'] ?? 0;
            $medium_count = $validated['medium_count'] ?? 0;

            $selectedChapterCount = collect($validated['question_counts'])
                ->filter(fn ($count) => $count !== null && $count !== '' && (int) $count > 0)
                ->count();
            if ($selectedChapterCount !== 1) {
                return Reply::error('Pilih tepat satu bab untuk membuat kuis.', 422);
            }

            // Validate phrase
            if (
                array_sum([$hard_count, $medium_count])
                > array_sum(array_values($validated['question_counts']))
            ) {
                return Reply::error(trans('exam.question_level_limit_error'));
            }
            # Check permission
            $course = Course::select('*');
            switch ($user->role_id) {
                case RoleType::TEACHER->value:
                    $course = $course->whereHas('teacher', function ($query) use ($user) {
                        $query->where('id', '=', $user->id);
                    })
                        ->findOrFail($validated['course_id']);
                    break;
                case RoleType::ADMIN->value:
                    $course = $course->findOrFail($validated['course_id']);
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }

            $course_end_date = Carbon::parse($course->semester->end_date);
            if ($course->isOver()) {
                return Reply::error(trans('app.errors.semester_end'), 400);
            }
            $exam_date = Carbon::parse($validated['exam_date']);
            if ($exam_date->greaterThanOrEqualTo($course_end_date)) {
                return Reply::error(trans('app.errors.exam_date_greater_than_semester', [
                    'date' => $course_end_date
                ], 400));
            }
            $chapters = Chapter::withCount('questions')
                ->where('subject_id', '=', $course->subject_id)
                ->orderBy('chapter_number')
                ->get();
            foreach ($chapters as $key => $chapter) {
                $chapter->max_select_question = $validated['question_counts'][$key];
                $chapter->selected_duration = $validated['duration_minutes'][$key] ?? null;
                if ($chapter->max_select_question && !$chapter->selected_duration) {
                    return Reply::error('Durasi wajib diisi untuk bab yang dipilih.', 422);
                }
            }
            $chapters = $chapters->filter(function ($chapter) {
                return $chapter->max_select_question != null;
            })->shuffle();

            $question_ids = [];
            foreach ($chapters as $chapter) {
                $chapter_question_ids = Question::where('subject_id', '=', $course->subject_id)
                    ->where('chapter_id', '=', $chapter->id)
                    ->inRandomOrder()
                    ->take($chapter->max_select_question)
                    ->pluck('id')
                    ->toArray();
                // If still not enough, send error
                if (count($chapter_question_ids) != $chapter->max_select_question) {
                    DB::rollBack();
                    return Reply::error(trans('app.errors.max_chapter_question_count', [
                        'name' => "$chapter->chapter_number. $chapter->name",
                        'number' => $chapter->questions_count
                    ], 400));
                }
                $question_ids = array_merge($question_ids, $chapter_question_ids);
            }
            shuffle($question_ids);
            $durationMinutes = $chapters->sum('selected_duration');
            $exam = Exam::create([
                'course_id' => $validated['course_id'],
                'name' => $validated['name'],
                'type' => $validated['type'] ?? 'regular',
                'exam_date' => $exam_date,
                'exam_time' => max(1, (int) $durationMinutes),
            ]);
            foreach ($question_ids as $question_id) {
                ExamQuestion::create([
                    'exam_id' => $exam->id,
                    'question_id' => $question_id
                ]);
            }
            $supervisor_ids = User::where('role_id', '=', RoleType::TEACHER)
                ->whereIn('id', $validated['supervisor_ids'])
                ->pluck('id');
            foreach ($supervisor_ids as $supervisor_id) {
                ExamSupervisor::create([
                    'exam_id' => $exam->id,
                    'user_id' => $supervisor_id
                ]);
            }
            DB::commit();
            return Reply::successWithMessage(trans('app.successes.record_save_success'));
        } catch (\Exception $error) {
            DB::rollBack();
            return $this->handleException($error);
        }
    }

    public function show(string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_VIEW), 403);
        $relations = [
            // 'exam_supervisors.user',
            'supervisors',
        ];

        try {
            $exam = Exam::with($relations);
            switch ($user->role_id) {
                case RoleType::ADMIN->value:
                    break;
                case RoleType::STUDENT->value:
                    $exam = $exam
                        ->whereHas('course.enrollments', function ($query) use ($user) {
                            $query->where('student_id', '=', $user->id);
                        });
                    break;
                case RoleType::TEACHER->value:
                    $exam = $exam
                        ->whereHas('course.teacher', function ($query) use ($user) {
                            $query->where('id', '=', $user->id);
                        })
                        ->orWhereHas('supervisors', function ($query) use ($user) {
                            $query->where('user_id', '=', $user->id);
                        });
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            $exam = $exam->findOrFail($id);
            $exam->load('questions.chapter.materials');
            $exam->setRelation(
                'materials',
                $exam->questions->pluck('chapter.materials')->flatten()->unique('id')->values()
            );
            return Reply::successWithData($exam, '');
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }

    public function update(UpdateRequest $request, string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_UPDATE), 403);
        $data = collect($request->validated())->except(['supervisor_ids'])->toArray();

        DB::beginTransaction();
        try {
            $target_exam = Exam::select('*');
            switch ($user->role_id) {
                case RoleType::TEACHER->value:
                    $target_exam = $target_exam->whereHas('course.teacher', function ($query) use ($user) {
                        $query->where('id', '=', $user->id);
                    })
                        ->findOrFail($id);
                    break;
                case RoleType::ADMIN->value:
                    $target_exam = $target_exam->findOrFail($id);
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            $exam_started_at = $target_exam->started_at != null
                ? Carbon::parse($target_exam->started_at) : null;
            if (
                $exam_started_at != null &&
                Carbon::now()->greaterThan($exam_started_at)
            ) {
                return Reply::error(trans('app.errors.exam_has_end'));
            }
            $data['exam_date'] = Carbon::parse($data['exam_date']);
            $durationMinutes = $target_exam->questions()
                ->with('chapter')
                ->get()
                ->pluck('chapter')
                ->filter()
                ->unique('id')
                ->sum('duration_minutes');
            $data['exam_time'] = max(1, (int) $durationMinutes);
            $target_exam->update($data);

            $supervisor_ids = User::where('role_id', '=', RoleType::TEACHER)
                ->whereIn('id', $request->input('supervisor_ids') ?? [])
                ->pluck('id');
            $target_exam->supervisors->sync($supervisor_ids);
            DB::commit();
            return Reply::successWithMessage(trans('app.successes.record_save_success'));
        } catch (\Exception $error) {
            DB::rollBack();
            return $this->handleException($error);
        }
    }

    public function destroy(string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_DELETE), 403);

        DB::beginTransaction();
        try {
            $exam = Exam::select('*');
            switch ($user->role_id) {
                case RoleType::TEACHER->value:
                    $exam = $exam->whereHas('course.teacher', function ($query) use ($user) {
                        $query->where('id', '=', $user->id);
                    })
                        ->findOrFail($id);
                    break;
                case RoleType::ADMIN->value:
                    $exam = $exam->findOrFail($id);
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            $exam_started_at = $exam->started_at != null
                ? Carbon::parse($exam->started_at) : null;
            if (
                $exam_started_at != null &&
                Carbon::now()->greaterThan($exam_started_at)
            ) {
                return Reply::error(trans('app.errors.exam_has_start'));
            }
            $exam->delete();
            DB::commit();
            return Reply::successWithMessage(trans('app.successes.record_delete_success'));
        } catch (\Exception $error) {
            DB::rollBack();
            return $this->handleException($error);
        }
    }

    public function updateStatus(UpdateStatusRequest $request, string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_UPDATE), 403);
        $now = Carbon::now();
        $validated = $request->validated();

        DB::beginTransaction();
        try {
            $target_exam = Exam::findOrFail($id);
            $has_update_status_permission = $target_exam->exam_supervisors()
                ->where('user_id', '=', $user->id)
                ->exists();
            if (!$user->isAdmin() && !$has_update_status_permission) {
                return Reply::error(trans('app.errors.403'), 403);
            }
            // Check is exam over
            $is_exam_over = false;
            if ($target_exam->started_at) {
                $started_at = Carbon::parse($target_exam->started_at);
                if ($now->greaterThan($started_at->addMinutes($target_exam->exam_time))) {
                    $is_exam_over = true;
                }
            }
            if ($is_exam_over) {
                return Reply::error(trans('app.errors.exam_has_end'));
            }
            switch ($validated['status']) {
                case 'start':
                    if ($target_exam->cancelled_at != null) {
                        return Reply::error(trans('app.errors.exam_has_cancel'));
                    }
                    if ($now->lessThan(Carbon::parse($target_exam->exam_date))) {
                        return Reply::error(trans('app.errors.not_yet_time_for_exam'));
                    }
                    if ($target_exam->started_at == null) {
                        $target_exam->update([
                            'started_at' => $now
                        ]);
                    } else return Reply::error(trans('app.errors.exam_has_start'));
                    break;
                case 'cancel':
                    if ($target_exam->cancelled_at == null) {
                        $target_exam->update([
                            'cancelled_at' => $now
                        ]);
                    } else return Reply::error(trans('app.errors.exam_has_cancel'));
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            DB::commit();
            return Reply::successWithMessage(trans('app.successes.success'));
        } catch (\Exception $error) {
            DB::rollBack();
            return $this->handleException($error);
        }
    }

    public function take(string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_SUBMIT), 403);
        $now = Carbon::now();

        DB::beginTransaction();
        try {
            $data = (object)[];
            $question_cache_key = str_replace(
                ['@exam_id', '@user_id'],
                [$id, $user->id],
                self::QUESTIONS_CACHE_KEY
            );
            $answers_cache_key = str_replace(
                ['@exam_id', '@user_id'],
                [$id, $user->id],
                self::ANSWERS_CACHE_KEY
            );
            $data->answers_cache = Cache::get($answers_cache_key);
            if (Cache::has($question_cache_key)) {
                $data->exam_data = Cache::get($question_cache_key);
                return Reply::successWithData($data, '');
            }

            $exam_questions_order = ExamQuestionsOrder::firstOrCreate([
                'exam_id' => $id,
                'user_id' => $user->id
            ]);

            $exam = Exam::with(['questions' => function ($query) use ($exam_questions_order) {
                $query
                    ->select('questions.id', 'content', 'video_path')
                    ->with(['question_options' => function ($query)  use ($exam_questions_order) {
                        $query->select('id', 'question_id', 'content')
                            ->inRandomOrder($exam_questions_order->id);
                    }])
                    ->inRandomOrder($exam_questions_order->id);
            }])
                ->whereHas('course.enrollments', function ($query) use ($user) {
                    $query->where('student_id', '=', $user->id);
                })
                ->whereDoesntHave('exam_questions_answers', function ($query)  use ($user) {
                    $query->where('user_id', '=', $user->id);
                })
                ->whereNotNull('started_at')
                ->whereNull('cancelled_at')
                ->findOrFail($id);

            $exam_started_at = Carbon::parse($exam->started_at);
            $allow_late_submit_seconds = (int)Setting::get('exam_allow_late_submit_seconds');
            $exam_ended_at = $exam_started_at->copy()->addMinutes($exam->exam_time + $allow_late_submit_seconds / 60);
            if ($now->lessThan($exam_started_at)) {
                return Reply::error(trans('app.errors.exam_not_start'));
            }
            if ($now->greaterThan($exam_ended_at)) {
                return Reply::error(trans('app.errors.exam_has_end'));
            }
            Cache::put($question_cache_key, $exam, $exam_ended_at);
            DB::commit();
            $data->exam_data = $exam;
            return Reply::successWithData($data, '');
        } catch (\Exception $error) {
            DB::rollBack();
            return $this->handleException($error);
        }
    }

    public function submit(SubmitRequest $request, string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_SUBMIT), 403);
        $now = Carbon::now();
        $validated = $request->validated();
        $answers = $validated['answers'];

        DB::beginTransaction();
        try {
            $questions_cache_key = str_replace(
                ['@exam_id', '@user_id'],
                [$id, $user->id],
                self::QUESTIONS_CACHE_KEY
            );
            $answers_cache_key = str_replace(
                ['@exam_id', '@user_id'],
                [$id, $user->id],
                self::ANSWERS_CACHE_KEY
            );
            $exam_questions_order = ExamQuestionsOrder::where('exam_id', '=', $id)
                ->where('user_id', '=', $user->id)
                ->firstOrFail();

            $exam = Exam::with(['questions' => function ($query) use ($exam_questions_order) {
                $query->select('questions.id', 'video_path')
                    ->with(['question_options' => function ($query)  use ($exam_questions_order) {
                        $query->select('id', 'question_id', 'is_correct')
                            ->inRandomOrder($exam_questions_order->id);
                    }])
                    ->inRandomOrder($exam_questions_order->id);
            }])
                ->whereHas('course.enrollments', function ($query) use ($user) {
                    $query->where('student_id', '=', $user->id);
                })
                ->whereDoesntHave('exam_questions_answers', function ($query)  use ($user) {
                    $query->where('user_id', '=', $user->id);
                })
                ->whereNotNull('started_at')
                ->whereNull('cancelled_at')
                ->findOrFail($id);

            $exam_date = Carbon::parse($exam->exam_date);
            $exam_end_date = $exam_date->copy()->addMinutes($exam->exam_time);

            $allow_late_submit_seconds = (int)Setting::get('exam_allow_late_submit_seconds');
            $exam_end_date = $exam_end_date->addSeconds($allow_late_submit_seconds);

            if ($now->lessThan($exam_date)) {
                return Reply::error(trans('app.errors.exam_not_start'));
            }

            if ($now->greaterThan($exam_end_date)) {
                return Reply::error(trans('app.errors.exam_has_end'));
            }

            # Save and caculate score
            $correct_count = 0;

            foreach ($exam->questions as $key => $question) {
                $answer = $answers[$key];
                $is_correct = false;
                $answer_id = null;

                if ($question->question_options->has((int)$answer)) {
                    $question_option = $question->question_options[$answer];
                    $answer_id = $question_option->id;
                    $is_correct = $question_option->is_correct;
                    if ($is_correct) $correct_count++;
                }
                ExamQuestionsAnswer::create([
                    'user_id' => $user->id,
                    'exam_id' => $exam->id,
                    'question_id' => $question->pivot->id,
                    'answer_id' => $answer_id,
                    'is_correct' => $is_correct
                ]);
            }
            $result_data = ExamResult::create([
                'exam_id' => $exam->id,
                'user_id' => $user->id,
                'correct_count' => $correct_count,
                'question_count' => count($exam->questions),
                'ip' => $request->ip(),
                'user_agent' => $request->userAgent(),
            ]);
            Cache::forget($questions_cache_key);
            Cache::forget($answers_cache_key);
            DB::commit();
            return Reply::successWithData($result_data, '');
        } catch (\Exception $error) {
            DB::rollBack();
            return $this->handleException($error);
        }
    }

    public function getResults(string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_VIEW), 403);

        try {
            $exam = Exam::query();
            switch ($user->role_id) {
                case RoleType::ADMIN->value:
                    break;
                case RoleType::STUDENT->value:
                    $exam = $exam
                        ->whereHas('course.enrollments', function ($query) use ($user) {
                            $query->where('student_id', '=', $user->id);
                        });
                    break;
                case RoleType::TEACHER->value:
                    $exam = $exam
                        ->whereHas('course.teacher', function ($query) use ($user) {
                            $query->where('id', '=', $user->id);
                        })
                        ->orWhereHas('supervisors', function ($query) use ($user) {
                            $query->where('user_id', '=', $user->id);
                        });
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            $exam = $exam->findOrFail($id);
            $results = [];

            $students = Course::with([
                'students' => function ($query) {
                    $query->with([
                        'school_class',
                    ]);
                }
            ])->findOrFail($exam->course_id)
                ->students;

            $exam_results = $exam->exam_results;

            foreach ($students as $student) {
                $exam_result = $exam_results->where('user_id', '=', $student->id)->first();
                $results[] = [
                    'user' => $student,
                    'result' => $exam_result,
                ];
            }
            return Reply::successWithData($results, '');
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }

    public function exportResults(string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_VIEW), 403);
        $now = Carbon::now();

        try {
            $data = [];
            $exam = Exam::with('course.enrollments.user');
            switch ($user->role_id) {
                case RoleType::ADMIN->value:
                    break;
                case RoleType::STUDENT->value:
                    $exam = $exam
                        ->whereHas('course.enrollments', function ($query) use ($user) {
                            $query->where('student_id', '=', $user->id);
                        });
                    break;
                case RoleType::TEACHER->value:
                    $exam = $exam
                        ->whereHas('course.teacher', function ($query) use ($user) {
                            $query->where('id', '=', $user->id);
                        });
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
                    break;
            }
            $exam = $exam->findOrFail($id);
            $question_count = $exam->questions()->count();

            $students = Course::with([
                'students' => function ($query) {
                    $query->with([
                        'school_class',
                    ]);
                }
            ])->findOrFail($exam->course_id)
                ->students;

            $exam_results = $exam->exam_results;

            $base_score_scale = (int)Setting::get('exam_base_score_scale');

            foreach ($students as $student) {
                $exam_result = $exam_results->where('user_id', '=', $student->id)->first();
                $score = NumberHelper::caculateScore($exam_result?->correct_count, $question_count, $base_score_scale);
                $data[] = [
                    'student_shortcode' => $student->shortcode,
                    'first_name' => $student->first_name,
                    'last_name' => $student->last_name,
                    'school_class_shortcode' => $student->school_class->shortcode,
                    'score' => NumberHelper::formatScore($score)
                ];
            }
            return Excel::download(
                new ExamResultsExport(collect($data)),
                "$id-$exam->name-result-$now.xlsx"
            );
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }

    public function syncCache(SyncAnswerCacheRequest $request, string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_SUBMIT), 403);
        $now = Carbon::now();
        $validated = $request->validated();

        try {
            $answers_cache_key = str_replace(
                ['@exam_id', '@user_id'],
                [$id, $user->id],
                self::ANSWERS_CACHE_KEY
            );
            $exam = Exam::whereHas('course.enrollments', function ($query) use ($user) {
                $query->where('student_id', '=', $user->id);
            })
                ->whereDoesntHave('exam_questions_answers', function ($query)  use ($user) {
                    $query->where('user_id', '=', $user->id);
                })
                ->whereNotNull('started_at')
                ->whereNull('cancelled_at')
                ->findOrfail($id);

            $exam_started_at = Carbon::parse($exam->started_at);
            $exam_ended_at = $exam_started_at->copy()->addMinutes($exam->exam_time);
            if ($now->lessThan($exam_started_at)) {
                return Reply::error(trans('app.errors.exam_not_start'));
            }
            if ($now->greaterThan($exam_ended_at)) {
                return Reply::error(trans('app.errors.exam_has_end'));
            }
            $allow_late_submit_seconds = (int)Setting::get('exam_allow_late_submit_seconds');
            Cache::put(
                $answers_cache_key,
                array_map('intval', $validated['answers']),
                Carbon::parse($exam->started_at)->addMinutes($exam->exam_time + $allow_late_submit_seconds / 60)
            );
            return Reply::success();
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }
}
