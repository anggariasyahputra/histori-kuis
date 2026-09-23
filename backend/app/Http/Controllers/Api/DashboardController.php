<?php

namespace App\Http\Controllers\Api;

use App\Enums\RoleType;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Models\Exam;
use App\Models\User;
use App\Models\ExamResult;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $user = $this->getUser();
        $data = (object)[];
        $now = now();
        try {
            # Section 1: 4 Cards
            $data->number_of_teachers = User::where('role_id', '=', RoleType::TEACHER)->count();
            $data->number_of_students = User::where('role_id', '=', RoleType::STUDENT)->count();
            $data->total_points = ExamResult::sum('correct_count');
            $data->completed_quizzes = ExamResult::count();
            # Section 2
            $data->today_exams = Exam::whereDate('exam_date', $now);

            $exams_each_month = Exam::select(DB::raw('MONTH(exam_date) as month'), DB::raw('COUNT(*) as count'))
                ->whereYear('exam_date', $now->year)
                ->groupBy('month')
                ->orderBy('month');

            #
            switch ($user->role_id) {
                case RoleType::ADMIN->value:
                    $data->today_exams = $data->today_exams->get();
                    break;
                case RoleType::TEACHER->value:
                    $data->today_exams = $data->today_exams->whereHas('course.teacher', function ($query) use ($user) {
                        $query->where('id', '=', $user->id);
                    })->get();
                    $exams_each_month = $exams_each_month
                        ->whereHas('course.teacher', function ($query) use ($user) {
                            $query->where('id', '=', $user->id);
                        })
                        ->orWhereHas('supervisors', function ($query) use ($user) {
                            $query->where('user_id', '=', $user->id);
                        });
                    break;
                case RoleType::STUDENT->value:
                    $data->today_exams = $data->today_exams->whereHas('course.enrollments', function ($query) use ($user) {
                        $query->where('student_id', '=', $user->id);
                    })->get();
                    $exams_each_month = $exams_each_month
                        ->whereHas('course.enrollments', function ($query) use ($user) {
                            $query->where('student_id', '=', $user->id);
                        });
                    break;
                default:
                    return Reply::error(trans('app.errors.something_went_wrong'), 500);
            }
            $exams_each_month = $exams_each_month->pluck('count', 'month')
                ->toArray();
            $data->exams_each_month = array_values(array_replace(array_fill(1, 12, 0), $exams_each_month));

            // Add leaderboard data with debugging
            $leaderboardQuery = ExamResult::select('user_id', DB::raw('SUM(correct_count) as total_score'))
                ->groupBy('user_id')
                ->orderByDesc('total_score')
                ->with('user:id,first_name,last_name')
                ->take(10);

            $data->leaderboard = $leaderboardQuery->get();
            
            // Debug: Log leaderboard data
            \Log::info('Leaderboard query count: ' . ExamResult::count());
            \Log::info('Leaderboard data: ' . $data->leaderboard->toJson());

            return Reply::successWithData($data, '');
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }
}
