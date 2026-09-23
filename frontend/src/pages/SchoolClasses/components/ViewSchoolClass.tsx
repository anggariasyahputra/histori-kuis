import appStyles from '~styles/App.module.css';
import styles from '~styles/ViewModel.module.css';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { SyntheticEvent, useEffect } from 'react';
import { FiSave } from 'react-icons/fi';
import { RxCross2 } from 'react-icons/rx';
import { apiGetSchoolClassById, apiUpdateSchoolClass } from '~api/school-class';
import Loading from '~components/Loading';
import QUERY_KEYS from '~constants/query-keys';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import createFormUtils from '~utils/create-form-utils';
import css from '~utils/css';

type ViewSchoolClassProps = {
    id: number;
    onMutateSuccess: () => void;
    setShowPopUp: React.Dispatch<React.SetStateAction<boolean>>;
};

export default function ViewSchoolClass({
    id,
    onMutateSuccess,
    setShowPopUp
}: ViewSchoolClassProps) {
    const language = useLanguage('component.view_school_class');
    const { permissions } = useAppContext();
    const queryClient = useQueryClient();
    const handleClosePopUp = () => {
        setShowPopUp(false);
    };
    const disabledUpdate = !permissions.has('school_class_update');
    const formUtils = createFormUtils(styles);
    const queryData = useQuery({
        queryKey: [QUERY_KEYS.SCHOOL_CLASS_DETAIL, id],
        queryFn: () => apiGetSchoolClassById(id)
    });
    const handleUpdateSchoolClass = async (e: SyntheticEvent<HTMLFormElement, SubmitEvent>) => {
        e.preventDefault();
        document.querySelector(`.${styles.formData}`)?.querySelectorAll<HTMLInputElement>('input[name]').forEach(node => {
            node.classList.remove('error');
            formUtils.getParentElement(node)?.removeAttribute('data-error');
        });
        const form = e.target as HTMLFormElement;
        const formData = new FormData(form);
        await apiUpdateSchoolClass(formData, id);
    };
    const { mutate, isPending } = useMutation({
        mutationFn: handleUpdateSchoolClass,
        onError: (error) => { formUtils.showFormError(error); },
        onSuccess: onMutateSuccess
    });
    useEffect(() => {
        return () => {
            queryClient.removeQueries({ queryKey: [QUERY_KEYS.SCHOOL_CLASS_DETAIL, { id: id }] });
        };
    }, [id, queryClient]);
    return (
        <div
            className={
                css(
                    styles.viewModelContainer,
                )
            }>
            {
                isPending ? <Loading /> : null
            }
            <div
                className={
                    css(
                        styles.viewModelForm,
                    )
                }>
                <div className={styles.header}>
                    <h2 className={styles.title}>{queryData.data?.name}</h2>
                    <div className={styles.escButton}
                        onClick={handleClosePopUp}
                    >
                        <RxCross2 />
                    </div>
                </div>
                <>
                    {
                        queryData.isLoading ? <Loading /> : null
                    }
                    <div className={styles.formContent}>
                        {
                            queryData.data ? (
                                <form onSubmit={(e: SyntheticEvent<HTMLFormElement, SubmitEvent>) => {
                                    mutate(e);
                                }}
                                    onInput={(e) => { formUtils.handleOnInput(e); }}
                                    className={styles.formData}>
                                    <div className={styles.groupInputs}>
                                        <div className={styles.wrapItem}>
                                            <label className={appStyles.required} htmlFor='shortcode'>{language?.shortcode}</label>
                                            <input
                                                id='shortcode'
                                                disabled={disabledUpdate}
                                                defaultValue={queryData.data.shortcode}
                                                name='shortcode'
                                                className={css(appStyles.input, styles.inputItem)}
                                                type='text' />
                                        </div>
                                        <div className={styles.wrapItem}>
                                            <label className={appStyles.required} htmlFor='name'>{language?.name}</label>
                                            <input
                                                id='name'
                                                disabled={disabledUpdate}
                                                defaultValue={queryData.data.name}
                                                name='name'
                                                className={css(appStyles.input, styles.inputItem)}
                                                type='text' />
                                        </div>
                                    </div>
                                    {
                                        permissions.has('school_class_update') ?
                                            <div className={styles.actionItems}>
                                                <button name='save'
                                                    className={
                                                        css(
                                                            appStyles.actionItem,
                                                            isPending ? appStyles.buttonSubmitting : ''
                                                        )
                                                    }>
                                                    <FiSave />
                                                    {language?.save}
                                                </button>
                                            </div>
                                            : null
                                    }
                                </form>
                            ) : null
                        }
                        {queryData.data?.students ?
                            <div style={{ padding: '0 20px 20px' }}>
                                <h3 style={{ marginBottom: '10px' }}>Siswa dalam kelas ({queryData.data.students.length})</h3>
                                {queryData.data.students.length > 0 ?
                                    <ul style={{ display: 'grid', gap: '6px', padding: 0, listStyle: 'none' }}>
                                        {queryData.data.students.map(student =>
                                            <li key={student.id} style={{ padding: '8px 10px', borderRadius: '6px', background: '#f5f6f8' }}>
                                                {student.firstName} {student.lastName} <small>({student.shortcode})</small>
                                            </li>
                                        )}
                                    </ul>
                                    : <p>Belum ada siswa di kelas ini.</p>}
                            </div>
                            : null}
                    </div>
                </>
            </div>
        </div>
    );
}
