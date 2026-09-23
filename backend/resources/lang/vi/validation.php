<?php

return [
    'required' => 'Silakan isi :attribute.',
    'string' => ':attribute harus berupa string.',
    'integer' => ':attribute harus berupa bilangan bulat.',
    'in' => 'Nilai yang dipilih untuk :attribute tidak valid.',
    'unique' => ':attribute sudah terdaftar di sistem.',
    'email' => ':attribute harus berupa alamat email yang valid.',
    'alpha_dash' => ':attribute hanya boleh berisi huruf, angka, tanda hubung, dan garis bawah.',
    'max' => [
        'string' => ':attribute tidak boleh lebih dari :max karakter.',
    ],
    'min' => [
        'array' => ':attribute harus memiliki minimal :min item.'
    ],
    'size' => [
        'string' => ':attribute harus berisi :size karakter.',
    ],
    'regex' => ':attribute memiliki format yang tidak valid.',
    'date' => ':attribute harus berupa tanggal yang valid.',
    'before' => ':attribute harus berupa tanggal sebelum :date.',
    'after' => ':attribute harus berupa tanggal setelah :date.',
    'required_if' => ':attribute wajib diisi ketika :other adalah :value.',
    'attributes' => [
        'name' => 'nama',
        'first_name' => 'nama depan',
        'last_name' => 'nama belakang',
        'shortcode' => 'kode',
        'role' => 'peran',
        'email' => 'email',
        'address' => 'alamat',
        'phone_number' => 'nomor telepon',
        'birth_date' => 'tanggal lahir',
        'school_class_id' => 'kelas',
        'faculty_id' => 'fakultas',
        'password' => 'kata sandi',
        'chapter_number' => 'nomor bab',
        'content' => 'konten',
        'start_date' => 'tanggal mulai',
        'end_date' => 'tanggal selesai',
        'teacher_id' => 'guru',
        'exam_date' => 'tanggal ujian',
        'exam_time' => 'waktu ujian',
        'question_counts' => 'jumlah soal',
        'cancellation_reason' => 'alasan pembatalan',
    ],
    'custom' => [
        'role' => [
            'in' => 'Peran yang dipilih tidak valid. Silakan pilih siswa, guru, atau admin.',
        ],
        'shortcode' => [
            'unique' => 'Kode sudah digunakan. Silakan pilih kode lain.',
        ],
        'email' => [
            'unique' => 'Alamat email sudah digunakan. Silakan pilih alamat lain.',
        ],
        'phone_number' => [
            'unique' => 'Nomor telepon sudah digunakan. Silakan pilih nomor lain.',
            'regex' => 'Nomor telepon harus diawali dengan 0 dan terdiri dari 10 digit.'
        ],
        'birth_date' => [
            'before' => 'Tanggal lahir harus sebelum hari ini.',
        ],
        'school_class_id' => [
            'required_if' => 'Kolom kelas wajib diisi ketika peran adalah siswa.',
        ],
        'faculty_id' => [
            'required_if' => 'Kolom fakultas wajib diisi ketika peran adalah guru.',
        ],
        'password' => [
            'confirmed' => 'Konfirmasi kata sandi tidak cocok.',
            'min' => 'Kata sandi minimal harus :min karakter.',
        ],
        'chapter_number' => [
            'unique' => 'Bab ini sudah ada pada mata pelajaran tersebut.'
        ],
        'options.*' => [
            'required' => 'Silakan isi jawaban.',
            'distinct' => 'Isi jawaban tidak boleh sama.'
        ],
        'true_option' => [
            '*' => 'Silakan pilih jawaban benar untuk soal ini.'
        ],
        'options' => [
            'min' => [
                'array' => 'Silakan isi minimal 2 jawaban.'
            ]
        ],
        'supervisor_ids' => [
            'required' => 'Silakan pilih minimal 1 pengawas.'
        ],
        'question_counts.*.min' => 'Jumlah soal minimal adalah :min.',
    ],
    'attribute_sum_min' => 'Total :attribute minimal harus :min',
    'attribute_sum_max' => 'Total :attribute tidak boleh lebih dari :max',
];
