import appStyles from '~styles/App.module.css';
import styles from './HistoryHub.module.css';

import { useQuery } from '@tanstack/react-query';
import { useEffect, useState } from 'react';
import { FaBookOpen, FaPlus, FaQuestionCircle } from 'react-icons/fa';
import { MdDeleteOutline } from 'react-icons/md';
import { Navigate, Link } from 'react-router';
import { apiGetSubjects } from '~api/subject';
import { apiGetSubjectById } from '~api/subject';
import { apiGetQuestions } from '~api/question';
import { apiDeleteChapter } from '~api/chapter';
import Loading from '~components/Loading';
import YesNoPopUp from '~components/YesNoPopUp';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import { SubjectDetail } from '~models/subject';
import { Chapter } from '~models/chapter';
import css from '~utils/css';
import CreateQuestion from '~pages/Questions/components/CreateQuestion';
import CreateChapter from '~pages/Subjects/components/CreateChapter';
import ViewChapter from '~pages/Subjects/components/ViewChapter';

export default function HistoryHub() {
    const { permissions, appTitle } = useAppContext();
    const language = useLanguage('page.questions');
    const [showCreate, setShowCreate] = useState(false);
    const [showCreateChapter, setShowCreateChapter] = useState(false);
    const [currentChapter, setCurrentChapter] = useState<Chapter>();
    const [showViewChapter, setShowViewChapter] = useState(false);
    const [chapterToDelete, setChapterToDelete] = useState<{ id: number; name: string; }>();
    const subjectsQuery = useQuery({ queryKey: ['history-subjects'], queryFn: () => apiGetSubjects('sejarah'), enabled: permissions.has('subject_view') });
    const subject = subjectsQuery.data?.find(item => item.name.toLowerCase().includes('sejarah'));
    const detailQuery = useQuery({ queryKey: ['history-subject', subject?.id], queryFn: () => apiGetSubjectById(String(subject?.id)), enabled: !!subject?.id });
    const questionsQuery = useQuery({
        queryKey: ['history-questions', subject?.id],
        queryFn: () => apiGetQuestions({ subjectId: String(subject?.id), chapterId: null }),
        enabled: !!subject?.id && permissions.has('question_view')
    });
    useEffect(() => {
        appTitle.setAppTitle('Soal Sejarah');
    }, [appTitle]);
    if (!permissions.has('subject_view') || !permissions.has('question_view')) return <Navigate to='/' />;
    const detail = detailQuery.data as SubjectDetail | undefined;

    return (
        <main className={css(appStyles.dashboard, styles.page)}>
            <header className={styles.header}>
                <div className={styles.icon}><FaBookOpen /></div>
                <div className={styles.headerCopy}><span>BELAJAR SEJARAH</span><h1>Bank Soal</h1><p>Buat dan kelola tantangan sejarah dari satu tempat.</p></div>
            </header>
            {subjectsQuery.isLoading || detailQuery.isLoading || questionsQuery.isLoading ? <Loading /> : null}
            {detail ? <>
                {showViewChapter && currentChapter ?
                    <ViewChapter
                        data={currentChapter}
                        setShowPopUp={setShowViewChapter}
                        onMutateSuccess={() => {
                            detailQuery.refetch();
                            setShowViewChapter(false);
                        }}
                    /> : null
                }
                {chapterToDelete ?
                    <YesNoPopUp
                        message={`Hapus bab "${chapterToDelete.name}"? Semua soal dan materi di dalamnya akan ikut terhapus.`}
                        mutateFunction={() => apiDeleteChapter(chapterToDelete.id)}
                        setShowPopUp={() => setChapterToDelete(undefined)}
                        onMutateSuccess={() => {
                            setChapterToDelete(undefined);
                            detailQuery.refetch();
                            questionsQuery.refetch();
                        }}
                        langYes='Hapus'
                        langNo='Batal'
                    /> : null
                }
                <section className={styles.subjectCard}><div><small>MATERI SEJARAH</small><h2>{detail.name}</h2><p>{detail.chapters.length} bab dan {questionsQuery.data?.length || 0} soal tersedia</p></div><div className={styles.subjectActions}>{permissions.has('question_create') ? <button onClick={() => setShowCreate(true)} className={styles.primary}><FaPlus /> Tambah soal</button> : null}</div></section>
                <section className={styles.chapters}><div className={styles.sectionHeading}><h2>Bab materi</h2>{permissions.has('subject_update') ? <button onClick={() => setShowCreateChapter(true)} className={styles.chapterButton}><FaPlus /> Tambah bab</button> : null}</div><div className={styles.chapterGrid}>{detail.chapters.map(chapter => <div key={chapter.id} className={styles.chapter} onClick={() => { setCurrentChapter(chapter); setShowViewChapter(true); }}><span>{chapter.chapterNumber}</span><div className={styles.chapterInfo}><strong>{chapter.name}</strong><small>{chapter.questionsCount} soal</small></div><button type='button' className={styles.chapterMaterials} onClick={e => { e.stopPropagation(); setCurrentChapter(chapter); setShowViewChapter(true); }}>Kelola materi</button><Link className={styles.chapterQuestions} to={`/subjects/${detail.id}/questions?chapter=${chapter.id}`} onClick={e => e.stopPropagation()}>Kelola soal</Link>{permissions.has('subject_update') ? <button type='button' className={styles.chapterDelete} title='Hapus bab' onClick={e => { e.stopPropagation(); setChapterToDelete({ id: chapter.id, name: chapter.name }); }}><MdDeleteOutline /></button> : null}</div>)}</div></section>
                <section className={styles.questions}><div className={styles.sectionHeading}><h2>Semua soal</h2><span>{questionsQuery.data?.length || 0} soal</span></div><div className={styles.questionTable}>{questionsQuery.data?.map((question, index) => <div className={styles.questionRow} key={question.id}><span className={styles.questionNumber}>{index + 1}</span><p dangerouslySetInnerHTML={{ __html: question.content }} /><span className={styles.level}>{question.level}</span></div>)}</div>{!questionsQuery.data?.length ? <p className={styles.emptyQuestions}>Belum ada soal. Klik Tambah soal untuk membuat soal pertama.</p> : null}</section>
            </> : <section className={styles.empty}>Buat mata pelajaran <strong>Sejarah</strong> terlebih dahulu untuk mulai menambahkan soal.</section>}
            {showCreate && detail ? <CreateQuestion subjectDetail={detail} setShowPopUp={setShowCreate} onMutateSuccess={() => { detailQuery.refetch(); questionsQuery.refetch(); }} /> : null}
            {showCreateChapter && detail ? <CreateChapter subjectId={detail.id} defaultChapterNumber={detail.chapters.length + 1} setShowPopUp={setShowCreateChapter} onMutateSuccess={() => { detailQuery.refetch(); setShowCreateChapter(false); }} /> : null}
        </main>
    );
}
