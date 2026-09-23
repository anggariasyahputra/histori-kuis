<?php

namespace App\Http\Controllers\Api;

use App\Enums\PermissionType;
use App\Enums\RoleType;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Models\User;

class LeaderboardController extends Controller
{
    public function index()
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::EXAM_VIEW), 403);

        try {
            $students = User::query()
                ->where('role_id', RoleType::STUDENT->value)
                ->with('school_class:id,name,shortcode')
                ->withSum('exam_results as total_score', 'correct_count')
                ->orderByDesc('total_score')
                ->orderBy('first_name')
                ->get(['id', 'first_name', 'last_name', 'school_class_id']);

            $students->each(function ($student) {
                $student->total_score = (int) ($student->total_score ?? 0);
            });

            $classes = $students->groupBy(fn ($student) => $student->school_class_id ?? 'unassigned')
                ->map(function ($classStudents, $classKey) {
                    $schoolClass = $classStudents->first()->school_class;
                    return [
                        'id' => $schoolClass?->id ?? 0,
                        'name' => $schoolClass?->name ?? 'Belum memiliki kelas',
                        'shortcode' => $schoolClass?->shortcode ?? '-',
                        'students' => $classStudents->values(),
                    ];
                })
                ->values();

            return Reply::successWithData($classes, '');
        } catch (\Exception $error) {
            return $this->handleException($error);
        }
    }
}
