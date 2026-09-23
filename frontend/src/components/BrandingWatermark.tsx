import styles from './styles/BrandingWatermark.module.css';
import useBranding from '~hooks/useBranding';
import { useEffect } from 'react';

export default function BrandingWatermark({ visible = true }: { visible?: boolean; }) {
    const schoolLogo = useBranding();

    useEffect(() => {
        document.documentElement.style.setProperty(
            '--school-logo-background',
            schoolLogo ? `url("${schoolLogo}")` : 'none'
        );
        return () => document.documentElement.style.removeProperty('--school-logo-background');
    }, [schoolLogo]);

    if (!schoolLogo || !visible) return null;
    return <div className={styles.watermark} style={{ backgroundImage: `url("${schoolLogo}")` }} aria-hidden='true' />;
}