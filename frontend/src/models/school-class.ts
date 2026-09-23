import { Faculty } from './faculty';
import { User } from './user';

export type SchoolClass = {
    id: number;
    shortcode: string;
    name: string;
    facultyId: number;
    createdAt: string;
    updatedAt: string;
};

export type SchoolClassDetail = SchoolClass & {
    faculty: Faculty;
    students?: User[];
};
export type QuerySchoolClassType = {
    page?: number;
    perPage?: number;
    search?: string;
};
