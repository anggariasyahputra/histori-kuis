import appStyles from '~styles/App.module.css';
import styles from '~styles/CreateModel.module.css';

import { useMutation, useQuery } from '@tanstack/react-query';
import { SyntheticEvent, useState } from 'react';
import { FiSave } from 'react-icons/fi';
import { RxCross2 } from 'react-icons/rx';
import { apiAutoCompleteSchoolClass } from '~api/school-class';
import { apiCreateUser } from '~api/user';
import CustomDataList from '~components/CustomDataList';
import CustomSelect from '~components/CustomSelect';
import Loading from '~components/Loading';
import { AUTO_COMPLETE_DEBOUNCE } from '~config/env';
import QUERY_KEYS from '~constants/query-keys';
import useDebounce from '~hooks/useDebounce';
import useLanguage from '~hooks/useLanguage';
import { RoleName } from '~models/role';
import createFormUtils from '~utils/create-form-utils';
import css from '~utils/css';
import dateFormat from '~utils/date-format';

type CreateUserProps = {
    role: RoleName;
    onMutateSuccess: () => void;
    setShowPopUp: React.Dispatch<React.SetStateAction<boolean>>;
};

export default function CreateUser({ role, onMutateSuccess, setShowPopUp }: CreateUserProps) {
    const [resetIndex, setResetIndex] = useState(0);
    const [queryClass, setQueryClass] = useState('');
    const language = useLanguage('component.create_user');
    const formUtils = createFormUtils(styles);
    const debounceQueryClass = useDebounce(queryClass, AUTO_COMPLETE_DEBOUNCE);
    const classQueryData = useQuery({
        queryKey: [QUERY_KEYS.AUTO_COMPLETE_SCHOOL_CLASS, { search: debounceQueryClass }],
        queryFn: () => apiAutoCompleteSchoolClass(debounceQueryClass),
        enabled: role === 'student' && !!debounceQueryClass
    });
    const handleCreateUser = async (e: SyntheticEvent<HTMLFormElement, SubmitEvent>) => {
        e.preventDefault();
        document.querySelector(`.${styles.formData}`)?.querySelectorAll<HTMLInputElement>('input[name]').forEach(node => {
            node.classList.remove('error');
            formUtils.getParentElement(node)?.removeAttribute('data-error');
        });
        const submitter = e.nativeEvent.submitter as HTMLButtonElement;
        const formData = new FormData(e.target as HTMLFormElement);
        formData.append('role', role);
        await apiCreateUser(formData);
        if (submitter.name === 'save') setShowPopUp(false);
        else setResetIndex(previous => previous + 1);
    };
    const { mutate, isPending } = useMutation({
        mutationFn: handleCreateUser,
        onError: error => formUtils.showFormError(error),
        onSuccess: onMutateSuccess
    });
    const genderOptions = [
        { value: 'male', label: language?.genders.male },
        { value: 'female', label: language?.genders.female }
    ];
    return <div key={resetIndex} className={styles.createModelContainer}>
        {isPending ? <Loading /> : null}
        <div className={styles.createModelForm}>
            <div className={styles.header}>
                <h2 className={styles.title}>{[language?.create, language && role ? language[role] : ''].join(' ')}</h2>
                <div className={styles.escButton} onClick={() => setShowPopUp(false)}><RxCross2 /></div>
            </div>
            <div className={styles.formContent}>
                <form onSubmit={e => mutate(e)} onInput={e => formUtils.handleOnInput(e)} className={styles.formData}>
                    <div className={styles.groupInputs}>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='email'>{language?.email}</label><input id='email' name='email' className={css(appStyles.input, styles.inputItem)} type='text' /></div>
                        <div className={styles.wrapItem}><label htmlFor='phone_number'>{language?.phoneNumber}</label><input id='phone_number' name='phone_number' className={css(appStyles.input, styles.inputItem)} type='text' /></div>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='first_name'>{language?.firstName}</label><input id='first_name' name='first_name' className={css(appStyles.input, styles.inputItem)} type='text' /></div>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='last_name'>{language?.lastName}</label><input id='last_name' name='last_name' className={css(appStyles.input, styles.inputItem)} type='text' /></div>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='shortcode'>{language?.shortcode}</label><input id='shortcode' name='shortcode' className={css(appStyles.input, styles.inputItem)} type='text' /></div>
                        {role === 'student' ? <div style={{ zIndex: 2 }} className={styles.wrapItem}><label className={appStyles.required} htmlFor='school_class_id'>{language?.class}</label><CustomDataList name='school_class_id' onInput={e => setQueryClass(e.currentTarget.value)} options={classQueryData.data?.map(item => ({ label: item.name, value: String(item.id) })) || []} /></div> : null}
                        <div className={styles.wrapItem}><label className={appStyles.required}>{language?.genders.gender}</label><CustomSelect name='gender' defaultOption={genderOptions[0]} options={genderOptions} className={styles.customSelect} /></div>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='address'>{language?.address}</label><input id='address' name='address' className={css(appStyles.input, styles.inputItem)} type='text' /></div>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='birth_date'>{language?.birthDate}</label><input defaultValue={dateFormat.toDateString(new Date())} max={dateFormat.toDateString(new Date())} type='date' id='birth_date' name='birth_date' className={css(appStyles.input, styles.inputItem)} /></div>
                        <div className={styles.wrapItem}><label className={appStyles.required} htmlFor='password'>{language?.password}</label><input id='password' name='password' className={css(appStyles.input, styles.inputItem)} type='password' /></div>
                    </div>
                    <div className={styles.actionItems}><button name='save' className={css(appStyles.actionItem, isPending ? appStyles.buttonSubmitting : '')}><FiSave />{language?.save}</button><button name='save-more' className={css(appStyles.actionItemWhite, isPending ? appStyles.buttonSubmitting : '')}><FiSave />{language?.saveMore}</button></div>
                </form>
            </div>
        </div>
    </div>;
}
