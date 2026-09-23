import styles from '../styles/SubjectSidebar.module.css';

import React from 'react';
import { Chapter } from '~models/chapter';
import css from '~utils/css';
import languageUtils from '~utils/language-utils';

type Props = {
    chapters: Chapter[];
    currentChapterId?: number;
    onSelect: (chapter: Chapter) => void;
    canCreate?: boolean;
    onCreate?: () => void;
};

export default function MaterialSidebar({ chapters, currentChapterId, onSelect, canCreate, onCreate }: Props) {
    return (
        <aside className={styles.sidebar}>
            <div className={styles.header}>
                <h3>Materi</h3>
                {canCreate && onCreate ? <button className={styles.addBtn} onClick={onCreate}>+</button> : null}
            </div>
            <ul className={styles.list}>
                {chapters.sort((a,b)=>a.chapterNumber-b.chapterNumber).map(chapter => (
                    <li key={chapter.id} className={css(styles.item, chapter.id === currentChapterId ? styles.active : '')} onClick={() => onSelect(chapter)}>
                        <div className={styles.number}>{chapter.chapterNumber}.</div>
                        <div className={styles.title}>{chapter.name}</div>
                    </li>
                ))}
            </ul>
        </aside>
    );
}
