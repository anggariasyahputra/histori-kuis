import appStyles from '~styles/App.module.css';
import styles from './Leaderboards.module.css';

import { useQuery } from '@tanstack/react-query';
import { useEffect } from 'react';
import { FaCrown, FaMedal, FaTrophy, FaStar } from 'react-icons/fa';
import { apiGetLeaderboards } from '~api/leaderboard';
import Loading from '~components/Loading';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import css from '~utils/css';

export default function Leaderboards() {
    const { appTitle } = useAppContext();
    const language = useLanguage('page.dashboard');
    const queryData = useQuery({ queryKey: ['leaderboards'], queryFn: apiGetLeaderboards });

    useEffect(() => {
        appTitle.setAppTitle('Leaderboard');
    }, [appTitle]);
    const getIcon = (position: number) => position === 1 ? <FaCrown /> : position === 2 ? <FaTrophy /> : position === 3 ? <FaMedal /> : null;

    return (
        <main className={css(appStyles.dashboard, styles.page)}>
            <header className={styles.header}>
                <div><span className={styles.eyebrow}>HALL OF FAME</span><h1>Leaderboard</h1><p>Rayakan progres belajar dan lihat siapa yang memimpin minggu ini.</p></div>
                <div className={styles.trophy}><FaTrophy /></div>
            </header>
            {queryData.isLoading ? <Loading /> : null}
            {!queryData.isLoading && !queryData.data?.length ? <section className={styles.empty}>Belum ada siswa yang terdaftar.</section> : null}
            {queryData.data?.map(classBoard => {
                const students = classBoard.students;
                return <section className={styles.classBoard} key={`${classBoard.id}-${classBoard.shortcode}`}>
                    <div className={styles.classHeader}><div><span className={styles.classEyebrow}>KELAS</span><h2>{classBoard.name}</h2></div><span className={styles.classCode}>{classBoard.shortcode}</span></div>
                    <div className={styles.board}>
                        {students.slice(0, 3).map((entry, index) => <div className={css(styles.podium, styles[`place${index + 1}` as keyof typeof styles])} key={entry.id}>
                            <div className={styles.podiumIcon}>{getIcon(index + 1)}</div>
                            <div className={styles.avatar}>{entry.firstName.charAt(0)}</div>
                            <div className={styles.rank}>{index + 1}</div>
                            <strong>{entry.firstName} {entry.lastName}</strong>
                            <span><FaStar /> {entry.totalScore} Poin</span>
                        </div>)}
                        <ol className={styles.list}>{students.slice(3).map((entry, index) => <li key={entry.id}><span className={styles.listRank}>{index + 4}</span><span className={styles.listName}>{entry.firstName} {entry.lastName}</span><strong>{entry.totalScore} Poin</strong></li>)}</ol>
                    </div>
                </section>;
            })}
            <p className={styles.note}>{language?.todayExams ? 'Poin dihitung dari jawaban benar pada setiap kuis.' : 'Poin dihitung dari jawaban benar.'}</p>
        </main>
    );
}
