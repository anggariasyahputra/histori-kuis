import appStyles from '~styles/App.module.css';
import styles from '../styles/CreateViewExam.module.css';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useEffect, useState } from 'react';
import { FiSave } from 'react-icons/fi';
import { RxCross2 } from 'react-icons/rx';
import { toast } from 'sonner';
import { apiCreateExam } from '~api/exam';
import { apiGetSubjectById } from '~api/subject';
import { apiSearchUsers } from '~api/user';
import Loading from '~components/Loading';
import { AUTO_COMPLETE_DEBOUNCE } from '~config/env';
import QUERY_KEYS from '~constants/query-keys';
import useDebounce from '~hooks/useDebounce';
import useLanguage from '~hooks/useLanguage';
import { CourseDetail } from '~models/course';
import { UserDetail } from '~models/user';
import createFormUtils from '~utils/create-form-utils';
import css from '~utils/css';
import dateFormat from '~utils/date-format';
import languageUtils from '~utils/language-utils';

type CreateExamProps = {
    courseDetail: CourseDetail;
    onMutateSuccess: () => void;
    setShowPopUp: React.Dispatch<React.SetStateAction<boolean>>;
};
export default function CreateExam({
    courseDetail,
    onMutateSuccess,
    setShowPopUp
}: CreateExamProps) {
    const [totalQuestion, setTotalQuestion] = useState(0);
    const [selectedChapterIndex, setSelectedChapterIndex] = useState<number | null>(null);
    const [durationMinutes, setDurationMinutes] = useState(10);
    const [supervisors, setSupervisors] = useState<UserDetail[]>([]);
    const [queryUser, setQueryUser] = useState('');
    const debounceQueryUser = useDebounce(queryUser, AUTO_COMPLETE_DEBOUNCE);
    const language = useLanguage('component.create_exam');
    const queryClient = useQueryClient();
    const handleClosePopUp = () => {
        setShowPopUp(false);
    };
    const formUtils = createFormUtils(styles);
    const queryData = useQuery({
        queryKey: [QUERY_KEYS.PAGE_SUBJECT, { id: courseDetail.subjectId }],
        queryFn: () => apiGetSubjectById(courseDetail.subjectId)
    });
    const userQueryData = useQuery({
        queryKey: [QUERY_KEYS.ALL_TEACHER, { search: debounceQueryUser }],
        queryFn: () => apiSearchUsers('teacher', debounceQueryUser),
    });
    const handleCreateExam = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        document.querySelector(`.${styles.formData}`)?.querySelectorAll<HTMLInputElement>('input[name]').forEach(node => {
            node.classList.remove('error');
            formUtils.getParentElement(node)?.removeAttribute('data-error');
        });
        const form = e.target as HTMLFormElement;
        const formData = new FormData(form);
        supervisors.forEach(supervisor => {
            formData.append('supervisor_ids[]', String(supervisor.id));
        });
        await apiCreateExam(formData);
        handleClosePopUp();
    };
    const { mutate, isPending } = useMutation({
        mutationFn: handleCreateExam,
        onError: (error) => { formUtils.showFormError(error); },
        onSuccess: onMutateSuccess
    });
    useEffect(() => {
        return () => {
            queryClient.removeQueries({ queryKey: [QUERY_KEYS.ALL_TEACHER] });
        };
    }, [queryClient]);
    return (
        <>
            <div className={
                css(
                    styles.createViewExamContainer,
                )
            }>
                {
                    queryData.isLoading ? <Loading /> : null
                }
                {
                    isPending ? <Loading /> : null
                }
                <div className={
                    css(
                        styles.createViewExamForm,
                    )
                }>
                    <div className={styles.header}>
                        <h2 className={styles.title}>{language?.create}</h2>
                        <div className={styles.escButton}
                            onClick={handleClosePopUp}
                        >
                            <RxCross2 />
                        </div>
                    </div>
                    <div className={styles.formContent}>
                        <form
                            onSubmit={e => { mutate(e); }}
                            className={styles.formData}>
                            <input hidden readOnly name='course_id' value={courseDetail.id} />
                            <input hidden readOnly name='type' value='regular' />
                            <div className={styles.groupInputs}>
                                <div className={styles.sectionTitle}>1. Informasi kuis</div>
                                <div className={styles.wrapItem}>
                                    <label className={appStyles.required} htmlFor='name'>{language?.name}</label>
                                    <input
                                        id='name'
                                        name='name'
                                        className={css(appStyles.input, styles.inputItem)}
                                        type='text' />
                                </div>
                                <div className={styles.wrapItem}>
                                    <label className={appStyles.required} htmlFor='exam_date'>{language?.examDate}</label>
                                    <input
                                        defaultValue={dateFormat.toDateTimeMinuteString(new Date())}
                                        type='datetime-local'
                                        name='exam_date'
                                        id='exam_date'
                                        className={css(appStyles.input, styles.inputItem)}
                                    />
                                </div>
                                {
                                    queryData.data ?
                                        <>
                                            <div className={styles.sectionTitle}>2. Materi dan jumlah soal</div>
                                            {queryData.data.chapters.sort((a, b) =>
                                                a.chapterNumber - b.chapterNumber
                                            ).map((chapter, index) => {
                                                const key = `chapter-${chapter.id}`;
                                                return (
                                                    <div
                                                        className={styles.wrapItem}
                                                        key={key}
                                                    >
                                                        <input
                                                            type='hidden'
                                                            name={`question_counts[${index}]`}
                                                            value={selectedChapterIndex === index ? totalQuestion : ''}
                                                        />
                                                        <input
                                                            type='hidden'
                                                            name={`duration_minutes[${index}]`}
                                                            value={selectedChapterIndex === index ? durationMinutes : ''}
                                                        />
                                                        <label className={styles.chapterChoice}>
                                                            <input
                                                                type='radio'
                                                                name='selected_chapter'
                                                                checked={selectedChapterIndex === index}
                                                                onChange={() => {
                                                                    setSelectedChapterIndex(index);
                                                                    setTotalQuestion(0);
                                                                }}
                                                            />
                                                            Pilih bab ini
                                                        </label>
                                                        <label htmlFor={key}>
                                                            {`${chapter.chapterNumber}. ${chapter.name} (${chapter.questionsCount} ${language?.questions || 'soal'})`}
                                                        </label>
                                                        <input
                                                            id={key}
                                                            onInput={(e) => {
                                                                const target = e.currentTarget;
                                                                if (target.valueAsNumber > chapter.questionsCount) {
                                                                    toast.error(language?.maxChapterQuestionCount
                                                                        .replace('@name', `${chapter.chapterNumber}. ${chapter.name}`)
                                                                        .replace('@questionNumber', String(chapter.questionsCount)));
                                                                }
                                                                setTotalQuestion(target.valueAsNumber || 0);
                                                            }}
                                                            value={selectedChapterIndex === index ? totalQuestion : ''}
                                                            disabled={selectedChapterIndex !== index}
                                                            onBeforeInput={(e: React.CompositionEvent<HTMLInputElement>) => {
                                                                if (e.data === '.') e.preventDefault();
                                                            }}
                                                            className={css(appStyles.input, styles.inputItem)}
                                                            type='number'
                                                            min={0}
                                                        />
                                                    </div>
                                                );
                                            })}
                                            <div className={styles.wrapItem}>
                                                <span>{language?.totalQuestions}: {totalQuestion}</span>
                                            </div>
                                            <div className={styles.sectionTitle}>3. Waktu pengerjaan</div>
                                            <div className={styles.wrapItem}>
                                                <label className={appStyles.required} htmlFor='duration_minutes_visible'>Waktu pengerjaan bab (menit)</label>
                                                <input
                                                    id='duration_minutes_visible'
                                                    value={selectedChapterIndex === null ? '' : durationMinutes}
                                                    disabled={selectedChapterIndex === null}
                                                    onChange={e => setDurationMinutes(e.currentTarget.valueAsNumber || 0)}
                                                    className={css(appStyles.input, styles.inputItem)}
                                                    type='number'
                                                    min={1}
                                                    max={600}
                                                />
                                            </div>
                                            <div className={styles.sectionTitle}>4. Pengawas kuis</div>
                                            <div className={css(styles.wrapItem, styles.dataContainer)}>
                                                <label>{language?.supervisors}</label>
                                                <input
                                                    placeholder={language?.search}
                                                    onInput={e => {
                                                        setQueryUser(e.currentTarget.value);
                                                    }}
                                                    className={css(appStyles.input, styles.inputItem)}
                                                    type='text' />
                                                <label>{language?.joinedSupervisors}</label>
                                                <ul className={styles.joinedSupervisorsContainer}>
                                                    {
                                                        supervisors.map((supervisor, index) => {
                                                            return (
                                                                <li
                                                                    className={styles.joinedSupervisor}
                                                                    key={`joined-supervisor-${supervisor.id}`}
                                                                >
                                                                    <div>
                                                                        <span>
                                                                            {languageUtils.getFullName(supervisor.firstName, supervisor.lastName)}
                                                                        </span>
                                                                        <span
                                                                            style={{ height: '20px' }}
                                                                            onClick={() => {
                                                                                const newSupervisors = structuredClone(supervisors);
                                                                                newSupervisors.splice(index, 1);
                                                                                setSupervisors(newSupervisors);
                                                                            }}
                                                                        >
                                                                            <RxCross2 />
                                                                        </span>
                                                                    </div>
                                                                </li>
                                                            );
                                                        })
                                                    }
                                                </ul>
                                                <label>{language?.allSupervisors}</label>
                                                <ul className={styles.allSupervisorConatiner}>
                                                    {userQueryData.data ?
                                                        userQueryData.data
                                                            .filter(user => !supervisors.find(supervisor => supervisor.id === user.id))
                                                            .map(user => (
                                                                <li
                                                                    onClick={() => {
                                                                        const newSupervisors = structuredClone(supervisors);
                                                                        newSupervisors.push(user);
                                                                        setSupervisors(newSupervisors);
                                                                    }}
                                                                    className={css(appStyles.dashboardCard, styles.card)}
                                                                    key={`user-${user.id}`}
                                                                >
                                                                    <div className={styles.cardLeft}>
                                                                        <span>{languageUtils.getFullName(user.firstName, user.lastName)}</span>
                                                                        <span>{user.faculty?.name}</span>
                                                                    </div>
                                                                </li>
                                                            )) : null
                                                    }
                                                </ul>
                                            </div>
                                        </> : null
                                }
                            </div>
                            <div className={styles.actionItems}>
                                <button name='save'
                                    className={
                                        css(
                                            appStyles.actionItem,
                                            isPending ? 'button-submitting' : ''
                                        )
                                    }><FiSave />{language?.save}</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </>
    );
}
