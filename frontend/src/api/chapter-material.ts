/* eslint-disable @typescript-eslint/no-explicit-any */
import { ChapterMaterial } from '~models/chapter-material';
import { ApiResponseWithData } from '~models/response';
import apiUtils from '~utils/api-utils';
import request from '../config/api';

const prefix = 'chapter-materials';

export async function apiGetChapterMaterials(chapterId: number) {
    try {
        const res = await request.get(`${prefix}/chapter/${chapterId}`);
        const { data } = res.data as ApiResponseWithData<ChapterMaterial[]>;
        return data;
    } catch (error: any) {
        return apiUtils.handleError(error);
    }
}

export async function apiCreateChapterMaterial(formData: FormData) {
    try {
        const res = await request.post(prefix, formData);
        const { data } = res.data as ApiResponseWithData<ChapterMaterial>;
        return data;
    } catch (error: any) {
        return apiUtils.handleError(error);
    }
}

export async function apiDeleteChapterMaterial(id: number) {
    try {
        await request.delete(`${prefix}/${id}`);
    } catch (error: any) {
        return apiUtils.handleError(error);
    }
}
