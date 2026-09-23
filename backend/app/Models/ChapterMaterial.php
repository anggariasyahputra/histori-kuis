<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class ChapterMaterial extends Model
{
    protected $table = 'chapter_materials';

    protected $fillable = ['chapter_id', 'title', 'type', 'file_path'];

    protected $appends = ['file_url'];

    public function chapter()
    {
        return $this->belongsTo(Chapter::class);
    }

    public function getFileUrlAttribute(): string
    {
        return request()->getSchemeAndHttpHost() . '/uploads/' . basename($this->file_path);
    }
}
