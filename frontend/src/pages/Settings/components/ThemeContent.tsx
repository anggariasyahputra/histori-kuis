import appStyles from '~styles/App.module.css';
import settingsStyles from '../styles/SettingsContent.module.css';
import styles from '../styles/ThemeContent.module.css';

import React from 'react';
import { useState } from 'react';
import { apiUploadSchoolLogo } from '~api/settings';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import useBranding from '~hooks/useBranding';
import { API_HOST } from '~config/env';
import css from '~utils/css';
import themeUtils from '~utils/theme-utils';

export default function ThemeContent() {
    const { user } = useAppContext();
    const language = useLanguage('component.settings_content');
    const currentLogo = useBranding();
    const [logoPreview, setLogoPreview] = useState<string>();
    const [selectedLogo, setSelectedLogo] = useState<File>();
    const [isUploading, setIsUploading] = useState(false);
    const handleUploadLogo = async () => {
        if (!selectedLogo) return;
        const formData = new FormData();
        formData.append('logo', selectedLogo);
        setIsUploading(true);
        const data = await apiUploadSchoolLogo(formData);
        if (data?.schoolLogo) {
            setLogoPreview(`${API_HOST}${data.schoolLogo}`);
            setSelectedLogo(undefined);
        }
        setIsUploading(false);
    };
    const colors = [
        'var(--color-blue)',
        // 'var(--color-red)',
        // 'var(--color-green)',
        // 'var(--color-yellow)',
        // 'var(--color-gray)',
        // 'var(--color-soft-yellow)',
        'var(--color-soft-magenta)',
        // 'var(--color-soft-blue)',
        // 'var(--color-soft-red)',
        'var(--color-soft-green)',
    ];
    return (
        <>
            <article className={settingsStyles.article}>
                <h3>Identitas SMA</h3>
                <p>Unggah logo SMA untuk menampilkannya sebagai watermark pada halaman login dan dashboard.</p>
                {user.user?.role.name === 'admin' ?
                    <>
                        <input
                            accept='image/png,image/jpeg,image/webp'
                            type='file'
                            onChange={e => {
                                const file = e.currentTarget.files?.[0];
                                if (!file) return;
                                const preview = URL.createObjectURL(file);
                                setSelectedLogo(file);
                                setLogoPreview(preview);
                            }}
                        />
                        <small>Format: PNG, JPG, atau WEBP. Maksimal 5 MB.</small>
                        {logoPreview || currentLogo ?
                            <img
                                src={logoPreview || currentLogo}
                                alt='Pratinjau logo SMA'
                                style={{ maxWidth: 180, maxHeight: 120, objectFit: 'contain' }}
                            /> : null
                        }
                        <div className={settingsStyles.actionItems}>
                            <button
                                type='button'
                                onClick={handleUploadLogo}
                                disabled={!selectedLogo || isUploading}
                                className={css(appStyles.actionItem, settingsStyles.buttonItem)}
                            >
                                {isUploading ? 'Menyimpan...' : 'Simpan Logo'}
                            </button>
                        </div>
                        {isUploading ? <small>Mengunggah logo...</small> : null}
                    </> :
                    <small>Logo SMA dikelola oleh administrator.</small>
                }
            </article>
            <article className={settingsStyles.article}>
                <h3>{language?.theme.primaryColor}</h3>
                <div className={styles.primaryColorContainer}>
                    {
                        colors.map(color => {
                            return (
                                // Cannot add key prop to <>, use React.Fragment instead
                                <React.Fragment key={color}>
                                    <div
                                        onClick={() => { themeUtils.setPrimaryColor(color); }}
                                        className={styles.primaryColorItem}
                                        style={{
                                            borderColor: color
                                        }}>
                                        <div className={styles.primaryColorSidebar}>
                                            {
                                                new Array(5).fill(0).map((_, index) => {
                                                    return (
                                                        <div
                                                            key={index}
                                                            className={styles.primaryColorSidebarItem}
                                                            style={{
                                                                background: index === 0 ? color : 'var(--color-background)',
                                                            }}
                                                        ></div>
                                                    );
                                                })
                                            }
                                        </div>
                                        <div className={styles.primaryColorMainContent}>
                                            <div className={styles.primaryColorHead}>
                                                {
                                                    new Array(3).fill(0).map((_, index) => {
                                                        return (
                                                            <div
                                                                key={index}
                                                                className={styles.primaryColorHeadItem}
                                                                style={{
                                                                    backgroundColor: color,
                                                                }}></div>
                                                        );
                                                    })
                                                }
                                            </div>
                                            <div className={styles.primaryColorBody}></div>
                                        </div>
                                    </div>
                                </React.Fragment>
                            );
                        })
                    }
                </div>
                <div>
                    <h4>{language?.theme.primaryColorCustom}</h4>
                    <input
                        defaultValue={themeUtils.getPrimaryColor() || themeUtils.getVariable('color-primary')}
                        onChange={e => {
                            const selectedColor = e.currentTarget.value;
                            themeUtils.setPrimaryColor(selectedColor);
                        }}
                        type='color'
                    />
                </div>
                <div className={settingsStyles.actionItems}>
                    <button
                        onClick={() => { themeUtils.setPrimaryColor(colors[0]); }}
                        className={css(appStyles.actionItemWhite, settingsStyles.buttonItem)}>
                        {language?.reset}
                    </button>
                </div>
            </article>
        </>
    );
}
