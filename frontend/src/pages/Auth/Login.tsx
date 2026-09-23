import appStyles from '~styles/App.module.css';
import styles from './styles/Login.module.css';
import kuisnesiaLogo from './HistoriKuis.png';
import popupImage from './Tori Menyapa.png';

import { useEffect, useRef, useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router';
import { apiLogin, apiSendEmailVerification } from '~api/auth';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import css from '~utils/css';
import getCookieValue from '~utils/get-cookie-value';

export default function Login() {
    const language = useLanguage('page.login');
    const [blockSubmit, setBlockSubmit] = useState(true);
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [showWelcomePopup, setShowWelcomePopup] = useState(false);
    const [showRulesPopup, setShowRulesPopup] = useState(false);
    const [welcomeUserId, setWelcomeUserId] = useState<number | null>(null);
    const [errorMessage, setErrorMessage] = useState<string | null>(null);
    const [rulesChecked, setRulesChecked] = useState(false);
    const buttonRef = useRef<HTMLButtonElement>(null);
    const { appTitle } = useAppContext();
    const navigate = useNavigate();
    const location = useLocation();
    const prePage = location.state?.from;
    const welcomePopupKey = (userId: number) => `histori-kuis-welcome-seen-${userId}`;
    
    // Function to close popup and navigate
    const closePopupAndNavigate = () => {
        setShowWelcomePopup(false);
        setShowRulesPopup(false);
        setRulesChecked(false);
        setTimeout(() => {
            navigate(prePage || '/');
        }, 100);
    };
    const handleNextPopup = () => {
        setShowWelcomePopup(false);
        setShowRulesPopup(true);
    };
    const handlePreventSubmit = (e: React.FormEvent<HTMLFormElement>) => {
        const formData = new FormData(e.currentTarget);
        for (const pair of formData.entries()) {
            const value = pair[1] as string;
            if (!value.trim()) {
                return setBlockSubmit(true);
            }
        }
        setBlockSubmit(false);
    };
    const handleLogin = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        setErrorMessage(null);
        if (blockSubmit) return;
        setBlockSubmit(true);
        setIsSubmitting(true);
        const formData = new FormData(e.currentTarget);
        buttonRef.current?.classList.add(styles.submitting);
        try {
            const data = await apiLogin(formData);
            if (!data.token && !data.user.emailVerifiedAt) {
                await apiSendEmailVerification(data.user.email);
                navigate('/auth/verify-email', { state: data.user });
            } else if (data.token) {
                if (data.user.role.name === 'student' && !localStorage.getItem(welcomePopupKey(data.user.id))) {
                    setWelcomeUserId(data.user.id);
                    setShowWelcomePopup(true);
                } else {
                    navigate(prePage || '/');
                }
            } else {
                setErrorMessage('Email atau password salah.');
            }
        } catch (error) {
            setErrorMessage('Terjadi kesalahan pada server.');
            console.error('Login failed:', error);
        } finally {
            setBlockSubmit(false);
            setIsSubmitting(false);
            buttonRef.current?.classList.remove(styles.submitting);
        }
    };
    useEffect(() => {
        if (language) appTitle.setAppTitle(language.login);
    }, [appTitle, language]);
    
    return (
        <>
            {/* Welcome Popup */}
            {showWelcomePopup && (
                <div 
                    className={styles.welcomePopup} 
                    onClick={() => {}}
                >
                    <div 
                        className={styles.welcomeContentSmall} 
                        onClick={e => e.stopPropagation()}
                    >
                        <img
                            src={popupImage}
                            alt="Welcome Mascot"
                            className={styles.welcomeImage}
                        />
                        <h2 className={styles.welcomeTitle}>Selamat Datang!</h2>
                        <p className={styles.welcomeMessage}>
                            Login berhasil! Selamat datang di HistoriKuis.
                        </p>
                        <button 
                            onClick={handleNextPopup}
                            className={styles.welcomeButton}
                        >
                            Next
                        </button>
                    </div>
                </div>
            )}
            {/* Rules Popup */}
            {showRulesPopup && (
                <div className={styles.welcomePopup}>
                    <div className={styles.welcomeContentSmall} onClick={e => e.stopPropagation()}>
                        <h2 className={styles.welcomeTitle}>Rules Penggunaan Sistem</h2>
                        <ul className={styles.rulesList}>
                            <li>Dilarang membagikan akun ke orang lain.</li>
                            <li>Gunakan data yang valid dan benar.</li>
                            <li>Ikuti instruksi guru atau pengawas saat ujian.</li>
                            <li>Segala bentuk kecurangan akan dikenakan sanksi.</li>
                        </ul>
                        <label style={{display:'block',margin:'16px 0'}}>
                            <input type="checkbox" checked={rulesChecked} onChange={e => setRulesChecked(e.target.checked)} /> Saya telah membaca rules
                        </label>
                        <button 
                            onClick={() => {
                                if (welcomeUserId) localStorage.setItem(welcomePopupKey(welcomeUserId), 'true');
                                closePopupAndNavigate();
                            }}
                            className={styles.welcomeButton}
                            disabled={!rulesChecked}
                            style={{opacity: rulesChecked ? 1 : 0.5, cursor: rulesChecked ? 'pointer' : 'not-allowed'}}
                        >
                            Close
                        </button>
                    </div>
                </div>
            )}
            
            <main className={styles.loginPage}>
            <form onSubmit={handleLogin} className={styles.form} onInput={handlePreventSubmit}>
                {errorMessage && (
                  <div style={{color: 'red', marginBottom: 10, textAlign: 'center'}}>{errorMessage}</div>
                )}
                <img
                    src={kuisnesiaLogo}
                    alt="HistoriKuis"
                    style={{ display: 'block', margin: '0 auto 10px auto', maxWidth: 320 }}
                />
                <h2>{language?.login}</h2>
                <div className={styles.wrapInput}>
                    <input name='email'
                        autoFocus
                        className={css(appStyles.input, styles.input)}
                        type='email'
                        placeholder={language?.email}
                    ></input>
                </div>
                <div className={styles.wrapInput}>
                    <input name='password'
                        className={css(appStyles.input, styles.input)}
                        type='password'
                        placeholder={language?.password}
                    />
                </div>
                <Link className={styles.forgotPassword} to='/auth/forgot-password'>{language?.forgotPassword}</Link>
                <div className={styles.wrapInput}>
                    <button
                        ref={buttonRef}
                        className={
                            css(
                                appStyles.actionItem,
                                styles.submit,
                                blockSubmit && !buttonRef.current?.classList.contains(styles.submitting) ? styles.blocking : ''
                            )
                        }>
                        {!isSubmitting && language?.login}
                    </button>
                </div>
                {
                    getCookieValue('demo_credentials')
                        ?
                        <div className={styles.wrapInput}>
                            <button
                                onClick={() => {
                                    const demoCredentials = getCookieValue('demo_credentials')!;
                                    const email: string = JSON.parse(demoCredentials).email;
                                    const password: string = JSON.parse(demoCredentials).password;
                                    document.querySelector<HTMLInputElement>('input[name="email"]')!.value = email;
                                    document.querySelector<HTMLInputElement>('input[name="password"]')!.value = password;

                                    const event = new Event('input', { bubbles: true });
                                    document.querySelector('form')!.dispatchEvent(event);
                                }}
                                type='button'
                                className={
                                    css(
                                        appStyles.actionItemWhite,
                                        styles.submit,
                                    )
                                }>
                                {language?.demoAccount}
                            </button>
                        </div>
                        : null
                }
            </form>
        </main>
        </>
    );
}
