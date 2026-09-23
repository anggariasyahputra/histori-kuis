import appStyles from '~styles/App.module.css';
import styles from '~styles/ViewModel.module.css';

import { useMutation, useQuery } from '@tanstack/react-query';
import { SyntheticEvent, useState } from 'react';
import { FiSave } from 'react-icons/fi';
import { MdDeleteOutline } from 'react-icons/md';
import { RxCross2 } from 'react-icons/rx';
import { apiDeleteChapter, apiUpdateChapter } from '~api/chapter';
import { apiCreateChapterMaterial, apiDeleteChapterMaterial, apiGetChapterMaterials } from '~api/chapter-material';
import Loading from '~components/Loading';
import YesNoPopUp from '~components/YesNoPopUp';
import useAppContext from '~hooks/useAppContext';
import useLanguage from '~hooks/useLanguage';
import { Chapter } from '~models/chapter';
import createFormUtils from '~utils/create-form-utils';
import css from '~utils/css';

type ViewChapterProps = {
    data: Chapter;
    onMutateSuccess: () => void;
    setShowPopUp: React.Dispatch<React.SetStateAction<boolean>>;
};

export default function ViewChapter({
    data,
    onMutateSuccess,
    setShowPopUp
}: ViewChapterProps) {
    const [showDeletePopUp, setShowDeletePopUp] = useState(false);
    const language = useLanguage('component.view_chapter');
    const { permissions } = useAppContext();
    const handleClosePopUp = () => {
        setShowPopUp(false);
    };
    const formUtils = createFormUtils(styles);
    const disabledUpdate = !permissions.has('subject_update');
    const materialsQuery = useQuery({
        queryKey: ['chapter-materials', data.id],
        queryFn: () => apiGetChapterMaterials(data.id),
    });
    const handleUpdateChapter = async (e: SyntheticEvent<HTMLFormElement, SubmitEvent>) => {
        e.preventDefault();
        document.querySelector(`.${styles.formData}`)?.querySelectorAll<HTMLInputElement>('input[name]').forEach(node => {
            node.classList.remove('error');
            formUtils.getParentElement(node)?.removeAttribute('data-error');
        });
        const form = e.target as HTMLFormElement;
        const formData = new FormData(form);
        await apiUpdateChapter(formData, data.id);
    };
    const handleDeleteChapter = async () => {
        await apiDeleteChapter(data.id);
    };
    const handleUploadMaterial = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const formData = new FormData(e.currentTarget);
        formData.append('chapter_id', String(data.id));
        await apiCreateChapterMaterial(formData);
        e.currentTarget.reset();
        await materialsQuery.refetch();
    };
    const handleDeleteMaterial = async (id: number) => {
        await apiDeleteChapterMaterial(id);
        await materialsQuery.refetch();
    };
    const { mutate, isPending } = useMutation({
        mutationFn: handleUpdateChapter,
        onError: (error) => { formUtils.showFormError(error); },
        onSuccess: onMutateSuccess
    });
    return (
        <>
            {showDeletePopUp === true ?
                <YesNoPopUp
                    message={language?.deleteMessage || ''}
                    mutateFunction={handleDeleteChapter}
                    setShowPopUp={setShowDeletePopUp}
                    onMutateSuccess={() => { onMutateSuccess(); handleClosePopUp(); }}
                    langYes={language?.langYes}
                    langNo={language?.langNo}
                /> : null}
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
                        <h2 className={styles.title}>{data.name}</h2>
                        <div className={styles.escButton}
                            onClick={handleClosePopUp}
                        >
                            <RxCross2 />
                        </div>
                    </div>
                    <>
                        <div className={styles.formContent}>
                            <form onSubmit={(e: SyntheticEvent<HTMLFormElement, SubmitEvent>) => {
                                mutate(e);
                            }}
                                onInput={(e) => { formUtils.handleOnInput(e); }}
                                className={styles.formData}>
                                <div className={styles.groupInputs}>
                                    <div className={styles.wrapItem}>
                                        <label className={appStyles.required} htmlFor='chapter_number'>{language?.chapterNumber}</label>
                                        <input
                                            id='chapter_number'
                                            name='chapter_number'
                                            disabled={disabledUpdate}
                                            defaultValue={data.chapterNumber}
                                            className={css(appStyles.input, styles.inputItem)}
                                            type='text' />
                                    </div>
                                    <div className={styles.wrapItem}>
                                        <label className={appStyles.required} htmlFor='name'>{language?.name}</label>
                                        <input
                                            id='name'
                                            disabled={disabledUpdate}
                                            defaultValue={data.name}
                                            name='name'
                                            className={css(appStyles.input, styles.inputItem)}
                                            type='text' />
                                    </div>
                                </div>
                                {
                                    permissions.has('subject_update') ?
                                        <div className={styles.actionItems}>
                                            <button type='submit' name='save'
                                                className={
                                                    css(
                                                        appStyles.actionItem,
                                                        isPending ? 'button-submitting' : ''
                                                    )
                                                }
                                            ><FiSave />{language?.save}
                                            </button>
                                            <button
                                                type='button'
                                                onClick={() => {
                                                    setShowDeletePopUp(true);
                                                }}
                                                className={appStyles.actionItemWhiteBorderRed}
                                                title='Hapus bab'>
                                                <MdDeleteOutline /> {language?.delete}
                                            </button>
                                        </div>
                                        : null
                                }
                            </form>
                        </div>
                        <div className={styles.formContent}>
                            <h3>Materi Bab</h3>
                            {permissions.has('subject_update') ?
                                <form onSubmit={handleUploadMaterial} className={styles.formData}>
                                    <div className={styles.wrapItem}>
                                        <label htmlFor='material-title'>Judul materi</label>
                                        <input id='material-title' name='title' required className={css(appStyles.input, styles.inputItem)} />
                                    </div>
                                    <div className={styles.wrapItem}>
                                        <label htmlFor='material-file'>Upload video atau PDF</label>
                                        <input id='material-file' name='file' required accept='video/mp4,video/webm,video/ogg,application/pdf' type='file' />
                                        <small>Video/PDF, maksimal 50 MB.</small>
                                    </div>
                                    <button className={appStyles.actionItem} type='submit'><FiSave /> Simpan Materi</button>
                                </form> : null
                            }
                            <div className={styles.materialList}>
                                {materialsQuery.data?.map(material => (
                                    <div key={material.id} className={styles.materialItem}>
                                        <strong>{material.title}</strong>
                                        {material.type === 'video' ?
                                            <video controls src={material.fileUrl} style={{ maxWidth: '100%', maxHeight: 180 }} /> :
                                            <a href={material.fileUrl} target='_blank' rel='noreferrer'>Buka materi PDF</a>
                                        }
                                        {permissions.has('subject_update') ?
                                            <button type='button' onClick={() => handleDeleteMaterial(material.id)} className={appStyles.actionItemWhiteBorderRed}>
                                                <MdDeleteOutline /> Hapus
                                            </button> : null
                                        }
                                    </div>
                                ))}
                                {!materialsQuery.isLoading && !materialsQuery.data?.length ? <small>Belum ada materi untuk bab ini.</small> : null}
                            </div>
                        </div>
                    </>
                </div>
            </div>
        </>
    );
}
