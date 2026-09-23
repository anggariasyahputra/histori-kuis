<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('questions')
            ->where('level', 'expert')
            ->update(['level' => 'hard']);
    }

    public function down(): void
    {
    }
};
