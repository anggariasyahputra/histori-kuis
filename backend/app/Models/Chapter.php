<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Chapter
 *
 * @property int $id
 * @property int $subject_id
 * @property int $chapter_number
 * @property string $name
 * @property string $level
 * @property int $duration_minutes
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 *
 * @property Subject $subject
 * @property Collection|Question[] $questions
 *
 * @package App\Models
 */
class Chapter extends Model
{
    protected $table = 'chapters';

    protected function casts()
    {
        return [
            'subject_id' => 'int',
            'chapter_number' => 'int'
            , 'duration_minutes' => 'int'
        ];
    }

    protected $fillable = [
        'subject_id',
        'chapter_number',
        'name',
        'level',
        'duration_minutes'
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
        'questions'
    ];

    protected $appends = ['difficulty_levels'];

    public function getDifficultyLevelsAttribute(): array
    {
        return $this->relationLoaded('questions')
            ? $this->questions->pluck('level')->unique()->values()->all()
            : $this->questions()->pluck('level')->unique()->values()->all();
    }

    public function subject()
    {
        return $this->belongsTo(Subject::class);
    }

    public function questions()
    {
        return $this->hasMany(Question::class);
    }

    public function materials()
    {
        return $this->hasMany(ChapterMaterial::class);
    }
}
