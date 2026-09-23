import { Exam } from './exam';

export type DashboarData = {
    numberOfTeachers: number;
    numberOfStudents: number;
    totalPoints: number;
    completedQuizzes: number;
    examsEachMonth: number[];
    todayExams: Exam[];
    leaderboard?: LeaderboardEntry[];
};

export type LeaderboardEntry = {
    userId: number;
    totalScore: number;
    user: {
        id: number;
        firstName: string;
        lastName: string;
    };
};
