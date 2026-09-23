<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('chapters', function (Blueprint $table) {
            $table->enum('level', ['easy', 'medium', 'hard'])->default('easy')->after('name');
            $table->unsignedInteger('duration_minutes')->default(10)->after('level');
        });
    }

    public function down(): void
    {
        Schema::table('chapters', function (Blueprint $table) {
            $table->dropColumn(['level', 'duration_minutes']);
        });
    }
};