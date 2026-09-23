import appStyles from '~styles/App.module.css';
import styles from './styles/CreateExamPage.module.css';

import { useQuery } from '@tanstack/react-query';
import { useEffect, useState } from 'react';
import { FaBookOpen, FaChevronRight } from 'react-icons/fa';
import { Navigate } from 'react-router';
import { apiGetHistoryCourseForClass } from '~api/course';
import { apiGetSchoolClasses } from '~api/school-class';
import Loading from '~components/Loading';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import { CourseDetail } from '~models/course';
import { SchoolClassDetail } from '~models/school-class';
import css from '~utils/css';
import CreateExam from '~pages/Courses/components/CreateExam';

export default function CreateExamPage() {
    const { permissions, appTitle } = useAppContext();
    const language = useLanguage('page.exams');
    const [selectedCourse, setSelectedCourse] = useState<CourseDetail>();
    const classesQuery = useQuery({ queryKey: ['history-quiz-create-classes'], queryFn: () => apiGetSchoolClasses({ perPage: 50 }), enabled: permissions.has('exam_create') });
    useEffect(() => {
        appTitle.setAppTitle('Buat Kuis Sejarah');
    }, [appTitle]);
    if (!permissions.has('exam_create')) return <Navigate to='/' />;

    return (
        <main className={css(appStyles.dashboard, styles.page)}>
            <header className={styles.header}><div className={styles.icon}><FaBookOpen /></div><div><span>QUIZ BUILDER</span><h1>Buat Kuis Sejarah</h1><p>Pilih kelas tujuan, lalu atur tantangan dan soalnya.</p></div></header>
            {classesQuery.isLoading ? <Loading /> : null}
            {!selectedCourse ? <section className={styles.content}><div className={styles.sectionTitle}><h2>Pilih kelas Sejarah</h2><span>{classesQuery.data?.total || 0} kelas tersedia</span></div><div className={styles.courseGrid}>{classesQuery.data?.data.map((schoolClass: SchoolClassDetail) => <button className={styles.course} key={schoolClass.id} onClick={async () => setSelectedCourse(await apiGetHistoryCourseForClass(schoolClass.id))}><div className={styles.courseIcon}><FaBookOpen /></div><div><strong>{schoolClass.name}</strong><small>{schoolClass.shortcode} • {schoolClass.students?.length || 0} siswa</small></div><FaChevronRight className={styles.arrow} /></button>)}</div>{classesQuery.error ? <p className={styles.empty}>Data kelas gagal dimuat. Periksa koneksi backend atau permission akun.</p> : null}{!classesQuery.error && !classesQuery.isLoading && !classesQuery.data?.data.length ? <p className={styles.empty}>Belum ada kelas. Tambahkan kelas dan siswa terlebih dahulu.</p> : null}</section> : <CreateExam courseDetail={selectedCourse} setShowPopUp={() => setSelectedCourse(undefined)} onMutateSuccess={() => setSelectedCourse(undefined)} />}
        </main>
    );
}
