import { Course } from './course';
import { Subject } from './subject';
import { User } from './user';
import { ChapterMaterial } from './chapter-material';

export type Exam = {
    id: number;
    courseId: number;
    name: string;
    examDate: string;
    examTime: number;
    type: 'regular' | 'pretest' | 'posttest';
    startedAt: string | null;
    cancelledAt: string | null;
    createdAt: string;
    updatedAt: string;
};

export type ExamInMonth = Exam & {
    course: Course & {
        subject: Subject;
    };
};

export type ExamDetail = Exam & {
    questionsCount: number;
    materials: ChapterMaterial[];
    supervisors: (User & {
        pivot: {
            examId: number;
            userId: number;
            id: number;
            createdAt: string;
            updatedAt: string;
        };
    })[];
};

export type ExamWithQuestion = {
    examData: Exam & {
        questions: ExamQuestion[];
    };
    answersCache: number[] | null;
};

export type QueryExamType = {
    month?: string;
    year?: string;
    subject?: string;
};

export type ExamQuestion = {
    id: number;
    content: string;
    videoUrl?: string | null;
    pivot: Pivot;
    questionOptions: QuestionOption[];
};

type Pivot = {
    examId: number;
    questionId: number;
    id: number;
    createdAt: string;
    updatedAt: string;
};

type QuestionOption = {
    id: number;
    questionId: number;
    content: string;
};
