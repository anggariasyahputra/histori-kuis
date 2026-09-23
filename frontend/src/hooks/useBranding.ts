import { useEffect, useState } from 'react';
import { apiGetBranding } from '~api/settings';
import { API_HOST } from '~config/env';

export default function useBranding() {
    const [schoolLogo, setSchoolLogo] = useState<string>();

    useEffect(() => {
        apiGetBranding().then(data => {
            if (data?.schoolLogo) setSchoolLogo(`${API_HOST}${data.schoolLogo}`);
        });
    }, []);

    return schoolLogo;
}