<?php

namespace Database\Seeders;

use App\Models\Exam;
use App\Models\ExamResult;
use App\Models\User;
use App\Enums\RoleType;
use Illuminate\Database\Seeder;

class ExamResultSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get some students and exams
        $students = User::where('role_id', RoleType::STUDENT)->take(10)->get();
        $exams = Exam::take(5)->get();

        if ($students->count() > 0 && $exams->count() > 0) {
            foreach ($students as $student) {
                foreach ($exams as $exam) {
                    // Random chance to have exam result (70% chance)
                    if (rand(1, 10) <= 7) {
                        ExamResult::create([
                            'exam_id' => $exam->id,
                            'user_id' => $student->id,
                            'correct_count' => rand(1, 20), // Random correct answers
                            'question_count' => 20, // Assume 20 questions per exam
                            'ip' => '127.0.0.1',
                            'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                        ]);
                    }
                }
            }
        }
    }
}
