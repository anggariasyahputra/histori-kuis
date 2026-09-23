export type ChapterMaterial = {
    id: number;
    chapterId: number;
    title: string;
    type: 'video' | 'pdf';
    filePath: string;
    fileUrl: string;
};
