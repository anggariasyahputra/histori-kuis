import styles from './styles/Sidebar.module.css';

import { useEffect } from 'react';
import { IoSettingsOutline } from 'react-icons/io5';
import {
    PiChalkboardTeacherLight,
    PiExam,
    PiStudent,
} from 'react-icons/pi';
import { RiAdminLine } from 'react-icons/ri';
import {
    RxDashboard
} from 'react-icons/rx';
import {
    SiGoogleclassroom
} from 'react-icons/si';
import { TbBrandAuth0 } from 'react-icons/tb';
import { FaTrophy } from 'react-icons/fa';
import { FaBookOpen } from 'react-icons/fa';
import { Link, useLocation } from 'react-router';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import css from '~utils/css';
import toriMascot from '../pages/Auth/Maskot_Tori.png';

const STRICT_WIDTH = 800;

export default function Sidebar() {
    const { DOM, permissions, user } = useAppContext();
    const location = useLocation();
    const isAdmin = user.user?.roleId === 1;
    const language = useLanguage('component.sidebar');
    const isCurrent = (path: string) => {
        const currentPath = location.pathname.replace(/^\//, '');
        if (path === '') return currentPath === '';
        if (path === 'exams') return currentPath === 'exams' || (currentPath.startsWith('exams/') && !currentPath.startsWith('exams/new'));
        return currentPath === path || currentPath.startsWith(`${path}/`);
    };
    const sidebarItems = [
        {
            name: language?.dashboard,
            to: '',
            icon: <RxDashboard />,
            isActive: true
        },
        {
            name: language?.admins,
            to: 'admins',
            icon: <RiAdminLine />,
            isActive: isAdmin && permissions.has('user_view')
        },
        {
            name: language?.teachers,
            to: 'teachers',
            icon: <PiChalkboardTeacherLight />,
            isActive: isAdmin && permissions.has('user_view')
        },
        {
            name: language?.students,
            to: 'students',
            icon: <PiStudent />,
            isActive: isAdmin && permissions.has('user_view')
        },
        // {
        //     name: language?.faculty,
        //     to: 'faculties',
        //     icon: <LuSchool />,
        //     isActive: permissions.has('faculty_view')
        // },
        {
            name: 'Kelas',
            to: 'school-classes',
            icon: <SiGoogleclassroom />,
            isActive: permissions.has('school_class_view')
        },
        {
            name: 'Leaderboard',
            to: 'leaderboards',
            icon: <FaTrophy />,
            isActive: true
        },
        {
            name: 'Soal Sejarah',
            to: 'history-questions',
            icon: <FaBookOpen />,
            isActive: permissions.has('question_view') && permissions.has('subject_view')
        },
        {
            name: 'Buat Kuis',
            to: 'exams/new',
            icon: <PiExam />,
            isActive: permissions.has('exam_create')
        },
        {
            name: 'Daftar Kuis',
            to: 'exams',
            icon: <PiExam />,
            isActive: permissions.has('exam_view')
        },
        {
            name: language?.permission,
            to: 'permissions',
            icon: <TbBrandAuth0 />,
            isActive: isAdmin && permissions.has('role_permission_view')
        },
        {
            name: language?.settings,
            to: 'settings',
            icon: <IoSettingsOutline />,
            isActive: isAdmin
        },
    ];
    useEffect(() => {
        function updateSize() {
            if (window.innerWidth < STRICT_WIDTH) DOM.sideBarRef.current?.classList.add(styles.hide);
            else DOM.sideBarRef.current?.classList.remove(styles.hide);
        }
        window.addEventListener('resize', updateSize);
        return () => window.removeEventListener('resize', updateSize);
    }, [DOM.sideBarRef]);
    return (
        <nav ref={DOM.sideBarRef} className={
            css(
                styles.sidebar,
                window.innerWidth < STRICT_WIDTH ? styles.hide : ''
            )
        }>
            <div className={styles.brandBlock}>
                <img className={styles.brandMascot} src={toriMascot} alt='Tori' />
                <div><strong>HistoriKuis</strong><small>PLAY • LEARN • LEVEL UP</small></div>
            </div>
            <Link to='profile' className={styles.playerCard}>
                <div className={styles.playerAvatar}>{user.user?.firstName.charAt(0) || 'Q'}</div>
                <div className={styles.playerInfo}>
                    <strong>{user.user ? `${user.user.firstName} ${user.user.lastName}` : 'Quiz player'}</strong>
                    {user.user?.role.name === 'student' ?
                        <span><i /> Level up your skills</span> :
                        <span><i /> {user.user?.role.name === 'admin' ? 'Administrator • Akses penuh' : 'Guru • Kelola kuis dan kelas'}</span>
                    }
                </div>
            </Link>
            <ul className={styles.list}>{
                sidebarItems.map((feature, index) => {
                    if (feature.isActive === false) return;
                    return (
                        <li onClick={() => {
                            if (window.innerWidth < STRICT_WIDTH) DOM.sideBarRef.current?.classList.add(styles.hide);
                        }} key={index} className={
                            css(
                                styles.listItem,
                                isCurrent(feature.to) ? styles.current : ''
                            )
                        }>
                            <Link to={feature.to}>
                                {feature.icon}
                                {feature.name}
                            </Link>
                        </li>
                    );
                })
            }</ul>
            <div className={styles.footer}>
                <div className={styles.links}>
                    <span>{language?.term}</span>
                    <span>{language?.privacy}</span>
                    <span>{language?.security}</span>
                    <span>{language?.contact}</span>
                    <span>{language?.docs}</span>
                </div>
                <div className={styles.appInfos}>
                    <small>App version: {__APP_VERSION__}</small> <br />
                    <small>Build date: {__APP_BUILD_DATE__}</small> <br />
                    <small>&#169; {new Date().getFullYear()} HistoriKuis</small>
                </div>
            </div>
        </nav>
    );
}
