import appStyles from '~styles/App.module.css';
import styles from './styles/Dashboard.module.css';
import toriMascot from '../Auth/Maskot_Tori.png';

import { useQuery } from '@tanstack/react-query';
import { useEffect } from 'react';
import {
    PiChalkboardTeacherLight,
    PiStudent
} from 'react-icons/pi';
import { FaMedal, FaTrophy, FaCrown, FaStar, FaBolt, FaBullseye, FaGamepad, FaCalendarCheck } from 'react-icons/fa';
import { Link } from 'react-router';
import { apiGetDashboard } from '~api/dashboard';
import Loading from '~components/Loading';
import QUERY_KEYS from '~constants/query-keys';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import css from '~utils/css';
import DashboardCard from './components/DashboardCard';

export default function Dashboard() {
    const { permissions, appLanguage, appTitle, user } = useAppContext();
    const language = useLanguage('page.dashboard');
    const queryData = useQuery({
        queryKey: [QUERY_KEYS.PAGE_DASHBOARD],
        queryFn: apiGetDashboard
    });
    const formatNumber = (number: number) => {
        return number.toLocaleString(appLanguage.language, {
            notation: 'compact'
        });
    };

    const getBadge = (totalScore: number) => {
        if (totalScore >= 61 && totalScore <= 80) {
            return { icon: <FaCrown style={{ color: '#FFD700' }} />, name: 'Panutan' };
        } else if (totalScore >= 41 && totalScore <= 60) {
            return { icon: <FaTrophy style={{ color: '#C0C0C0' }} />, name: 'Cendekia Muda' };
        } else if (totalScore >= 21 && totalScore <= 40) {
            return { icon: <FaMedal style={{ color: '#CD7F32' }} />, name: 'Si Penjelajah' };
        } else if (totalScore >= 0 && totalScore <= 20) {
            return { icon: <FaStar style={{ color: '#87CEEB' }} />, name: 'Si Pemula' };
        }
        return null;
    };
    useEffect(() => {
        if (language) appTitle.setAppTitle(language.dashboard);
    }, [appTitle, language]);
    
    const currentScore = queryData.data?.leaderboard?.find(entry => entry.userId === user.user?.id)?.totalScore || 0;
    const isStudent = user.user?.role.name === 'student';
    const currentLevel = currentScore >= 61 ? 4 : currentScore >= 41 ? 3 : currentScore >= 21 ? 2 : 1;
    const levelStart = [0, 21, 41, 61][currentLevel - 1];
    const levelEnd = [20, 40, 60, 80][currentLevel - 1];
    const levelProgress = Math.min(100, Math.max(0, ((currentScore - levelStart) / (levelEnd - levelStart + 1)) * 100));
    const currentBadge = getBadge(currentScore);
    return (
        <main className={css(appStyles.dashboard, styles.dashboard)}>
            {
                queryData.isLoading ? <Loading /> : null
            }
            {
                !queryData.isError && queryData.data ?
                    <>
                        {isStudent ?
                            <section className={styles.hero}>
                                <div className={styles.heroCopy}>
                                    <span className={styles.eyebrow}><FaBolt /> MISI SEJARAH HARI INI</span>
                                    <h1>Jelajahi sejarah, satu kuis setiap hari.</h1>
                                    <p>Uji pemahamanmu tentang tokoh, peristiwa, dan perjalanan sejarah Indonesia.</p>
                                    <div className={styles.heroActions}>
                                        <Link to='exams' className={styles.primaryAction}><FaBullseye /> Mulai kuis sejarah</Link>
                                        <span className={styles.streak}><FaStar /> Total poin terkumpul: {currentScore}</span>
                                    </div>
                                </div>
                                <div className={styles.levelOrb}>
                                    <div className={styles.orbInner}><span>LEVEL</span><strong>{currentLevel}</strong></div>
                                    <div className={styles.orbBadge}>{currentBadge?.icon || <FaStar />}</div>
                                </div>
                                <div className={styles.xpBlock}>
                                    <div className={styles.xpLabel}><span>PROGRES BELAJAR</span><strong>{currentScore} / {levelEnd}</strong></div>
                                    <div className={styles.xpTrack}><div style={{ width: `${levelProgress}%` }} /></div>
                                    <small>{Math.max(0, levelEnd - currentScore)} poin lagi menuju level berikutnya</small>
                                </div>
                            </section> : null
                        }
                        <section className={styles.wrapDashboardItem}>
                            <DashboardCard
                                to={permissions.has('user_view') ? '/students' : undefined}
                                color='magenta'
                                content={language?.items.numberOfStudents}
                                data={formatNumber(queryData.data?.numberOfStudents)}
                                icon={<PiStudent />} />
                            <DashboardCard
                                to={permissions.has('user_view') ? '/teachers' : undefined}
                                color='red'
                                content={language?.items.numberOfTeachers}
                                data={formatNumber(queryData.data?.numberOfTeachers)}
                                icon={<PiChalkboardTeacherLight />} />
                            {isStudent ?
                                <DashboardCard
                                    color='green'
                                    content='Total Poin Belajar'
                                    data={formatNumber(queryData.data?.totalPoints)}
                                    icon={<FaStar />} /> : null
                            }
                            {!isStudent ?
                                <DashboardCard
                                    to={permissions.has('exam_view') ? '/exams' : undefined}
                                    color='green'
                                    content='Kuis Hari Ini'
                                    data={formatNumber(queryData.data?.todayExams.length || 0)}
                                    icon={<FaCalendarCheck />} /> : null
                            }
                            <DashboardCard
                                to={permissions.has('exam_view') ? '/exams' : undefined}
                                color='blue'
                                content='Kuis Diselesaikan'
                                data={formatNumber(queryData.data?.completedQuizzes)}
                                icon={<FaGamepad />} />
                        </section>
                        {isStudent ?
                            <div className={css(styles.wrapSections)}>
                                <section className={css(styles.section, styles.badgeSection)}>
                                <div className={styles.guideIntro}>
                                    <img src={toriMascot} alt='Tori' className={styles.guideAvatar} />
                                    <div className={styles.guideText}>
                                        <b>Halo, Tori di sini.</b><br/>
                                        Kumpulkan poin dari jawaban benar dan buka gelar sejarah baru.
                                    </div>
                                </div>
                                <button className={styles.guideButton}>Lihat koleksi gelar sejarah</button>
                                <div className={styles.badgeTableWrap}>
                                <table className={styles.badgeTable}>
                                    <thead>
                                        <tr>
                                            <th>Badge</th><th>Level</th><th>Poin</th><th>Gelar</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><FaCrown style={{color:'#FFD700', fontSize:22}} /></td>
                                            <td>Level 4</td>
                                            <td>61-80 Poin</td>
                                            <td>Panutan</td>
                                        </tr>
                                        <tr>
                                            <td><FaTrophy style={{color:'#C0C0C0', fontSize:22}} /></td>
                                            <td>Level 3</td>
                                            <td>41-60 Poin</td>
                                            <td>Cendekia Muda</td>
                                        </tr>
                                        <tr>
                                            <td><FaMedal style={{color:'#CD7F32', fontSize:22}} /></td>
                                            <td>Level 2</td>
                                            <td>21-40 Poin</td>
                                            <td>Si Penjelajah</td>
                                        </tr>
                                        <tr>
                                            <td><FaStar style={{color:'#87CEEB', fontSize:22}} /></td>
                                            <td>Level 1</td>
                                            <td>0-20 Poin</td>
                                            <td>Si Pemula</td>
                                        </tr>
                                    </tbody>
                                </table>
                                </div>
                                </section>
                            </div> : null
                        }
                        {/* Quiz hari ini di bawah */}
                        <section className={css(styles.section)}>
                            <h2 className={styles.sectionTitle} style={{ marginBottom: '10px' }}>
                                {language?.todayExams}
                            </h2>
                            <ul className={styles.todayExamsList}>
                                {
                                    queryData.data.todayExams.map(exam => {
                                        return (
                                            <li
                                                key={`exam-${exam.id}`}
                                                className={css(appStyles.dashboardCard, styles.todayExamsItem)}
                                            >
                                                <Link to={`exams/${exam.id}`}>
                                                    <span>{exam.name}</span>
                                                    <span>{new Date(exam.examDate).toLocaleTimeString(appLanguage.language)}</span>
                                                </Link>
                                            </li>
                                        );
                                    })
                                }
                            </ul>
                        </section>
                    </>
                    : null
            }
        </main >
    );
}
