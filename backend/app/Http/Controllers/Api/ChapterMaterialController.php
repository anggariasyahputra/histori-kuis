<?php

namespace App\Http\Controllers\Api;

use App\Enums\PermissionType;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\ChapterMaterial\StoreRequest;
use App\Models\Chapter;
use App\Models\ChapterMaterial;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ChapterMaterialController extends Controller
{
    public function index(string $chapterId)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::SUBJECT_VIEW), 403);

        $chapter = Chapter::findOrFail($chapterId);
        return Reply::successWithData($chapter->materials, '');
    }

    public function store(StoreRequest $request)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::SUBJECT_UPDATE), 403);
        $validated = $request->validated();
        $chapter = Chapter::findOrFail($validated['chapter_id']);
        $file = $request->file('file');
        $type = $file->getClientOriginalExtension() === 'pdf' ? 'pdf' : 'video';
        $fileName = 'chapter-material-' . Str::uuid() . '.' . $file->getClientOriginalExtension();
        $file->storeAs('', $fileName, 'upload');

        $material = $chapter->materials()->create([
            'title' => $validated['title'],
            'type' => $type,
            'file_path' => '/uploads/' . $fileName,
        ]);

        return Reply::successWithData($material, '');
    }

    public function destroy(string $id)
    {
        $user = $this->getUser();
        abort_if(!$user->hasPermission(PermissionType::SUBJECT_UPDATE), 403);
        $material = ChapterMaterial::findOrFail($id);
        Storage::disk('upload')->delete(basename($material->file_path));
        $material->delete();
        return Reply::success();
    }
}
