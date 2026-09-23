import styles from './styles/Header.module.css';
import sidebarStyles from './styles/Sidebar.module.css';
import toriMascot from '../pages/Auth/Maskot_Tori.png';

import { useEffect, useRef } from 'react';
import {
    BiLogOut
} from 'react-icons/bi';
import { LuCircleUserRound } from 'react-icons/lu';
import { RxHamburgerMenu } from 'react-icons/rx';
import { Link } from 'react-router';
import { apiLogout } from '~api/auth';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import languageUtils from '~utils/language-utils';

export default function Header() {
    const { DOM, user, appTitle } = useAppContext();
    const language = useLanguage('component.header');
    const profileDropdownRef = useRef<HTMLDivElement>(null);
    const handleLogout = () => {
        apiLogout()
            .finally(() => {
                window.location.pathname = '/';
            });
    };
    const handleToggleDropdownProfile = () => {
        profileDropdownRef.current?.classList.toggle(styles.show);
    };
    useEffect(() => {
        const handleClickOutside = (e: MouseEvent) => {
            const element = e.target as HTMLElement;
            if (element && !profileDropdownRef.current?.contains(element)) {
                profileDropdownRef.current?.classList.remove(styles.show);
            }
        };
        document.addEventListener('click', handleClickOutside);
        return () => {
            document.removeEventListener('click', handleClickOutside);
        };
    }, []);
    return (
        <header className={styles.header}>
            <div id='loader'></div>
            <div className={styles.leftItems}>
                {
                    user.user ?
                        <>
                            <div className={styles.toggle} onClick={() => {
                                DOM.sideBarRef.current?.classList.toggle(sidebarStyles.hide);
                            }}>
                                <RxHamburgerMenu />
                            </div>
                        </> : null
                }
                <Link to='/'>
                    <img className={styles.headerMascot} src={toriMascot} alt='Tori' />
                </Link>
                <h1 className={styles.appTitle}>{appTitle.title}</h1>
            </div>
            <div className={styles.rightItems}>
                {
                    user.user ?
                        <>
                            <div
                                ref={profileDropdownRef}
                                onClick={handleToggleDropdownProfile} className={styles.profileItem}>
                                <LuCircleUserRound />
                                <div className={styles.userFullName}>{languageUtils.getFullName(user.user.firstName, user.user.lastName)}</div>
                                <div onClick={handleToggleDropdownProfile} className={styles.dropDown}>
                                    <Link
                                        onClick={handleToggleDropdownProfile}
                                        to='/profile'
                                        className={styles.dropItem}
                                        title={languageUtils.getFullName(user.user?.firstName, user.user?.lastName)}
                                    >
                                        <LuCircleUserRound />
                                        <span>{language?.profile}</span>
                                    </Link>
                                    <div onClick={handleLogout} className={styles.dropItem}>
                                        <BiLogOut style={{ color: 'var(--color-red)' }} />
                                        <span>{language?.logout}</span>
                                    </div>
                                </div>
                            </div>
                        </> : null
                }
            </div>
        </header>
    );
}
