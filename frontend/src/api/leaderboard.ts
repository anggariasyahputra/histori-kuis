/* eslint-disable @typescript-eslint/no-explicit-any */
import { LeaderboardClass } from '~models/leaderboard';
import { ApiResponseWithData } from '~models/response';
import apiUtils from '~utils/api-utils';
import request from '../config/api';

export async function apiGetLeaderboards() {
    try {
        const res = await request.get('leaderboards');
        const { data } = res.data as ApiResponseWithData<LeaderboardClass[]>;
        return data;
    } catch (error: any) {
        return apiUtils.handleError(error);
    }
}
