import { LANG_KEY } from '../config/env';

const languagesSupported = [
    'vi'
];

const languageLabels: Record<string, string> = {
    vi: 'Indonesia',
    en: 'English'
};

const divMod = (n: number, m: number): [number, number] => [Math.floor(n / m), n % m];

const languageUtils = {
    languageCodeName: languagesSupported.map(item => ({
        value: item,
        label: languageLabels[item] ?? item
    })),

    getLanguage() {
        const localLanguage = localStorage.getItem(LANG_KEY) as string;
        if (languagesSupported.includes(localLanguage)) return localLanguage;
        return 'vi';
    },

    setLanguage(value: string) {
        localStorage.setItem(LANG_KEY, languagesSupported.includes(value) ? value : 'vi');
    },

    getFullName(firstName?: string, lastName?: string) {
        if (this.getLanguage() === 'vi') return [firstName, lastName].join(' ');
        return [firstName, lastName].join(' ');
    },

    getLetterFromIndex(index: number) {
        let letters = '';
        while (index >= 0) {
            letters = String.fromCharCode((index % 26) + 65) + letters;
            index = Math.floor(index / 26) - 1;
        }
        return letters;
    },

    getShortHand(content: string) {
        return content.split(' ').map(item => {
            if (!item) return undefined;
            return item.trim()[0].toUpperCase();
        }).join('').replace(/Đ/g, 'D').normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    },

    createDurationFormatter(locale: string, unitDisplay: 'long' | 'short' | 'narrow' = 'long', separator: string = ' ') {
        const timeUnitFormatter = (unit: 'hour' | 'minute') =>
            new Intl.NumberFormat(locale, { style: 'unit', unit, unitDisplay }).format;

        const fmtHours = timeUnitFormatter('hour');
        const fmtMinutes = timeUnitFormatter('minute');

        return (minutes: number): string => {
            const [hrs, mins] = divMod(minutes, 60);
            let result = [hrs ? fmtHours(hrs) : null, mins ? fmtMinutes(mins) : null]
                .filter((v): v is string => v !== null)
                .join(separator);
            
            // Replace "phút" with "menit" for Vietnamese locale
            if (locale === 'vi' || locale.startsWith('vi')) {
                result = result.replace(/phút/g, 'menit');
            }
            
            return result;
        };
    }
};

export default Object.freeze(languageUtils);