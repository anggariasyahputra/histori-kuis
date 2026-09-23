export type LeaderboardStudent = {
    id: number;
    firstName: string;
    lastName: string;
    totalScore: number;
};

export type LeaderboardClass = {
    id: number;
    name: string;
    shortcode: string;
    students: LeaderboardStudent[];
};
