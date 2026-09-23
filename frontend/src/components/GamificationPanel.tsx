import styles from './styles/GamificationPanel.module.css';

import { useMemo } from 'react';
import { useQuery } from '@tanstack/react-query';
import useAppContext from '~hooks/useAppContext';
import { apiGetExamResultsByUser } from '~api/exam-result';
import css from '~utils/css';
import { PiFire } from 'react-icons/pi';

export default function GamificationPanel() {
    const { user } = useAppContext();
    const userId = user.user?.id;
    const { data: results } = useQuery({
        queryKey: ['exam-results-user', { id: userId }],
        queryFn: () => apiGetExamResultsByUser(String(userId), { subjectId: '' }),
        enabled: !!userId,
        staleTime: 1000 * 60 * 5
    });

    const totalPoints = useMemo(() => {
        if (!results) return 0;
        return results.reduce((s, r) => s + (r.correctCount || 0), 0);
    }, [results]);

    // simple level thresholds
    const thresholds = [0, 50, 150, 300, 500];
    let level = 1;
    for (let i = 1; i < thresholds.length; i++) {
        if (totalPoints > thresholds[i]) level = i + 1;
        else break;
    }
    const prevThreshold = thresholds[Math.max(0, level - 1)];
    const nextThreshold = thresholds[Math.min(level, thresholds.length - 1)];
    const progress = nextThreshold === prevThreshold ? 1 : Math.min(1, Math.max(0, (totalPoints - prevThreshold) / (nextThreshold - prevThreshold)));

    return (
        <div className={styles.container}>
            <div className={styles.header}>
                <div className={styles.avatar}>{user.user ? user.user.firstName.charAt(0) : 'U'}</div>
                <div>
                    <div className={styles.name}>{user.user ? `${user.user.firstName} ${user.user.lastName}` : 'Guest'}</div>
                    <div className={styles.level}>Level {level} <span className={styles.levelIcon}><PiFire /></span></div>
                </div>
            </div>
            <div className={styles.progressWrap}>
                <div className={styles.progressBar}>
                    <div className={styles.progress} style={{ width: `${progress * 100}%` }} />
                </div>
                <div className={styles.points}>{totalPoints} Poin</div>
            </div>
            <div className={styles.badges}>
                <div className={css(styles.badge, totalPoints >= 50 ? styles.earned : '')}>Bronze</div>
                <div className={css(styles.badge, totalPoints >= 150 ? styles.earned : '')}>Silver</div>
                <div className={css(styles.badge, totalPoints >= 300 ? styles.earned : '')}>Gold</div>
            </div>
        </div>
    );
}
