-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Sep 2026 pada 16.46
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `historikuis1`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `chapters`
--

CREATE TABLE `chapters` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `subject_id` bigint(20) UNSIGNED NOT NULL,
  `chapter_number` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `level` enum('easy','medium','hard') NOT NULL DEFAULT 'easy',
  `duration_minutes` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `chapters`
--

INSERT INTO `chapters` (`id`, `subject_id`, `chapter_number`, `name`, `level`, `duration_minutes`, `created_at`, `updated_at`) VALUES
(202, 1, 1, 'Bertukar atau Membayar', 'easy', 10, '2025-06-10 09:26:47', '2025-06-10 09:26:47'),
(203, 53, 1, 'Kemerdekaan', 'easy', 10, '2026-09-03 19:38:26', '2026-09-03 19:38:26'),
(204, 53, 2, 'Periodisasi Zaman Praaksara Berdasarkan Arkeologi', 'easy', 10, '2026-09-05 17:37:53', '2026-09-05 17:37:53'),
(206, 53, 3, 'UJIAN UJI COBA 1', 'easy', 10, '2026-09-08 12:16:30', '2026-09-08 12:16:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `chapter_materials`
--

CREATE TABLE `chapter_materials` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `chapter_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `type` enum('video','pdf') NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `chapter_materials`
--

INSERT INTO `chapter_materials` (`id`, `chapter_id`, `title`, `type`, `file_path`, `created_at`, `updated_at`) VALUES
(2, 206, 'PERIODISASI ZAMAN PRAAKSARA BERDASARKAN ARKEOLOGI', 'pdf', '/uploads/chapter-material-2c5f0e03-2858-458c-81c8-b08476d42e61.pdf', '2026-09-08 06:09:45', '2026-09-08 06:09:45');

-- --------------------------------------------------------

--
-- Struktur dari tabel `courses`
--

CREATE TABLE `courses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `teacher_id` bigint(20) UNSIGNED NOT NULL,
  `subject_id` bigint(20) UNSIGNED NOT NULL,
  `semester_id` bigint(20) UNSIGNED NOT NULL,
  `shortcode` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `courses`
--

INSERT INTO `courses` (`id`, `teacher_id`, `subject_id`, `semester_id`, `shortcode`, `name`, `created_at`, `updated_at`) VALUES
(10, 642, 53, 2, 'SEJ-01', 'Kuis Sejarah - 10 A', '2026-09-08 12:24:06', '2026-09-08 12:24:06'),
(11, 642, 53, 2, 'SEJ-K001', 'Kuis Sejarah - 11.1', '2026-09-09 13:19:18', '2026-09-09 13:19:18');

-- --------------------------------------------------------

--
-- Struktur dari tabel `enrollments`
--

CREATE TABLE `enrollments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` bigint(20) UNSIGNED NOT NULL,
  `student_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `enrollments`
--

INSERT INTO `enrollments` (`id`, `course_id`, `student_id`, `created_at`, `updated_at`) VALUES
(41, 10, 643, '2026-09-08 12:24:06', '2026-09-08 12:24:06'),
(42, 10, 644, '2026-09-08 12:24:06', '2026-09-08 12:24:06'),
(43, 10, 645, '2026-09-08 12:24:06', '2026-09-08 12:24:06'),
(44, 10, 646, '2026-09-08 12:24:06', '2026-09-08 12:24:06'),
(45, 10, 647, '2026-09-08 12:24:06', '2026-09-08 12:24:06');

-- --------------------------------------------------------

--
-- Struktur dari tabel `exams`
--

CREATE TABLE `exams` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `course_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'regular',
  `exam_date` datetime NOT NULL,
  `exam_time` int(10) UNSIGNED NOT NULL,
  `started_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `exams`
--

INSERT INTO `exams` (`id`, `course_id`, `name`, `type`, `exam_date`, `exam_time`, `started_at`, `cancelled_at`, `created_at`, `updated_at`) VALUES
(34, 10, 'YUK KERJAIN 1', 'regular', '2026-09-08 12:31:00', 10, '2026-09-08 12:31:08', NULL, '2026-09-08 12:29:52', '2026-09-08 12:31:08'),
(35, 10, 'test materi 1', 'regular', '2026-09-08 13:13:00', 10, '2026-09-08 13:13:24', NULL, '2026-09-08 13:12:04', '2026-09-08 13:13:24'),
(36, 10, 'COBA KE 3', 'regular', '2026-09-08 13:24:00', 10, '2026-09-08 13:24:04', NULL, '2026-09-08 13:23:08', '2026-09-08 13:24:04');

-- --------------------------------------------------------

--
-- Struktur dari tabel `exam_questions`
--

CREATE TABLE `exam_questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `exam_id` bigint(20) UNSIGNED NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `exam_questions`
--

INSERT INTO `exam_questions` (`id`, `exam_id`, `question_id`, `created_at`, `updated_at`) VALUES
(240, 34, 343, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(241, 34, 339, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(242, 34, 342, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(243, 34, 338, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(244, 34, 344, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(245, 34, 340, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(246, 34, 345, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(247, 34, 346, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(248, 34, 347, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(249, 34, 341, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(250, 35, 343, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(251, 35, 344, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(252, 35, 342, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(253, 35, 345, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(254, 35, 341, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(255, 35, 340, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(256, 35, 339, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(257, 35, 338, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(258, 35, 346, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(259, 35, 347, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(260, 36, 343, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(261, 36, 346, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(262, 36, 339, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(263, 36, 347, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(264, 36, 345, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(265, 36, 338, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(266, 36, 342, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(267, 36, 344, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(268, 36, 341, '2026-09-08 13:23:08', '2026-09-08 13:23:08'),
(269, 36, 340, '2026-09-08 13:23:08', '2026-09-08 13:23:08');

-- --------------------------------------------------------

--
-- Struktur dari tabel `exam_questions_answers`
--

CREATE TABLE `exam_questions_answers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `exam_id` bigint(20) UNSIGNED NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `answer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `exam_questions_answers`
--

INSERT INTO `exam_questions_answers` (`id`, `user_id`, `exam_id`, `question_id`, `answer_id`, `is_correct`, `created_at`, `updated_at`) VALUES
(264, 643, 34, 243, 1343, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(265, 643, 34, 241, 1349, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(266, 643, 34, 245, 1354, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(267, 643, 34, 246, 1371, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(268, 643, 34, 244, 1370, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(269, 643, 34, 248, 1382, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(270, 643, 34, 247, 1376, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(271, 643, 34, 240, 1363, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(272, 643, 34, 249, 1355, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(273, 643, 34, 242, 1361, 1, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(274, 644, 34, 242, 1361, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(275, 644, 34, 249, 1355, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(276, 644, 34, 241, 1348, 0, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(277, 644, 34, 245, 1354, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(278, 644, 34, 247, 1375, 0, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(279, 644, 34, 246, 1371, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(280, 644, 34, 248, 1382, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(281, 644, 34, 244, 1369, 0, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(282, 644, 34, 243, 1343, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(283, 644, 34, 240, 1363, 1, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(284, 645, 34, 244, 1370, 1, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(285, 645, 34, 240, 1363, 1, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(286, 645, 34, 247, 1376, 1, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(287, 645, 34, 241, 1347, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(288, 645, 34, 245, 1353, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(289, 645, 34, 243, 1345, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(290, 645, 34, 242, 1359, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(291, 645, 34, 249, 1358, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(292, 645, 34, 246, 1373, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(293, 645, 34, 248, NULL, 0, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(294, 643, 35, 257, 1343, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(295, 643, 35, 258, 1376, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(296, 643, 35, 256, 1349, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(297, 643, 35, 252, 1361, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(298, 643, 35, 259, 1382, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(299, 643, 35, 250, 1363, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(300, 643, 35, 253, 1371, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(301, 643, 35, 254, 1355, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(302, 643, 35, 255, 1354, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(303, 643, 35, 251, 1370, 1, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(304, 643, 36, 265, 1343, 1, '2026-09-08 13:25:25', '2026-09-08 13:25:25'),
(305, 643, 36, 261, 1376, 1, '2026-09-08 13:25:25', '2026-09-08 13:25:25'),
(306, 643, 36, 263, 1382, 1, '2026-09-08 13:25:25', '2026-09-08 13:25:25'),
(307, 643, 36, 268, 1355, 1, '2026-09-08 13:25:25', '2026-09-08 13:25:25'),
(308, 643, 36, 266, 1361, 1, '2026-09-08 13:25:25', '2026-09-08 13:25:25'),
(309, 643, 36, 260, 1363, 1, '2026-09-08 13:25:25', '2026-09-08 13:25:25'),
(310, 643, 36, 262, 1349, 1, '2026-09-08 13:25:26', '2026-09-08 13:25:26'),
(311, 643, 36, 264, 1371, 1, '2026-09-08 13:25:26', '2026-09-08 13:25:26'),
(312, 643, 36, 269, 1354, 1, '2026-09-08 13:25:26', '2026-09-08 13:25:26'),
(313, 643, 36, 267, 1370, 1, '2026-09-08 13:25:26', '2026-09-08 13:25:26');

-- --------------------------------------------------------

--
-- Struktur dari tabel `exam_questions_orders`
--

CREATE TABLE `exam_questions_orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `exam_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `exam_questions_orders`
--

INSERT INTO `exam_questions_orders` (`id`, `exam_id`, `user_id`, `created_at`, `updated_at`) VALUES
(22, 34, 643, '2026-09-08 12:32:07', '2026-09-08 12:32:07'),
(23, 34, 644, '2026-09-08 12:33:30', '2026-09-08 12:33:30'),
(24, 34, 645, '2026-09-08 12:35:47', '2026-09-08 12:35:47'),
(25, 35, 643, '2026-09-08 13:18:21', '2026-09-08 13:18:21'),
(26, 36, 643, '2026-09-08 13:24:59', '2026-09-08 13:24:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `exam_results`
--

CREATE TABLE `exam_results` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `exam_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `correct_count` int(10) UNSIGNED NOT NULL,
  `question_count` int(10) UNSIGNED NOT NULL,
  `ip` varchar(255) NOT NULL,
  `user_agent` text NOT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancellation_reason` text DEFAULT NULL,
  `cancelled_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `remark_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `exam_results`
--

INSERT INTO `exam_results` (`id`, `exam_id`, `user_id`, `correct_count`, `question_count`, `ip`, `user_agent`, `cancelled_at`, `cancellation_reason`, `cancelled_by_user_id`, `remark_by_user_id`, `created_at`, `updated_at`) VALUES
(21, 34, 643, 10, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '2026-09-08 12:32:54', '2026-09-08 12:32:54'),
(22, 34, 644, 7, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '2026-09-08 12:33:59', '2026-09-08 12:33:59'),
(23, 34, 645, 3, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '2026-09-08 12:36:21', '2026-09-08 12:36:21'),
(24, 35, 643, 10, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '2026-09-08 13:18:45', '2026-09-08 13:18:45'),
(25, 36, 643, 10, 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, '2026-09-08 13:25:26', '2026-09-08 13:25:26');

-- --------------------------------------------------------

--
-- Struktur dari tabel `exam_supervisors`
--

CREATE TABLE `exam_supervisors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `exam_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `exam_supervisors`
--

INSERT INTO `exam_supervisors` (`id`, `exam_id`, `user_id`, `created_at`, `updated_at`) VALUES
(40, 34, 642, '2026-09-08 12:29:52', '2026-09-08 12:29:52'),
(41, 35, 642, '2026-09-08 13:12:04', '2026-09-08 13:12:04'),
(42, 36, 642, '2026-09-08 13:23:08', '2026-09-08 13:23:08');

-- --------------------------------------------------------

--
-- Struktur dari tabel `faculties`
--

CREATE TABLE `faculties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `shortcode` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `leader_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `faculties`
--

INSERT INTO `faculties` (`id`, `shortcode`, `name`, `email`, `phone_number`, `leader_id`, `created_at`, `updated_at`) VALUES
(15, 'SDK01', 'Kelas 1', NULL, NULL, NULL, '2025-06-05 00:12:05', '2025-06-05 00:12:05'),
(16, 'SDK02', 'Kelas 2', NULL, NULL, NULL, '2025-06-05 00:12:42', '2025-06-05 00:12:42'),
(17, 'SDK03', 'Kelas 3', NULL, NULL, NULL, '2025-06-05 00:13:06', '2025-06-05 00:13:06'),
(18, 'SDK04', 'Kelas 4', NULL, NULL, NULL, '2025-06-05 00:14:22', '2025-06-05 00:14:22'),
(19, 'SDK05', 'Kelas 5', NULL, NULL, NULL, '2025-06-05 00:14:45', '2025-06-05 00:14:45'),
(20, 'SDK06', 'Kelas 6', NULL, NULL, NULL, '2025-06-05 00:14:57', '2025-06-05 00:15:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(2, '2019_08_19_000000_create_failed_jobs_table', 1),
(3, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(4, '2023_09_24_055840_create_roles_table', 1),
(5, '2023_09_24_055946_create_users_table', 1),
(6, '2023_09_24_060041_create_semesters_table', 1),
(7, '2023_09_24_060108_create_subjects_table', 1),
(8, '2023_09_24_060141_create_chapters_table', 1),
(9, '2023_09_24_060142_create_courses_table', 1),
(10, '2023_09_24_060215_create_questions_table', 1),
(11, '2023_09_24_060254_create_question_options_table', 1),
(12, '2023_09_24_060351_create_enrollments_table', 1),
(13, '2023_09_24_060447_create_exams_table', 1),
(14, '2023_09_24_060511_create_exam_questions_table', 1),
(15, '2023_12_12_055047_create_faculties_table', 1),
(16, '2023_12_12_055650_create_school_classes_table', 1),
(17, '2023_12_12_055756_modify_users_table', 1),
(18, '2024_01_12_124732_create_permissions_table', 1),
(19, '2024_01_12_125030_create_role_permissions_table', 1),
(20, '2024_04_10_120025_create_exam_questions_orders_table', 1),
(21, '2024_04_10_130122_create_exam_supervisors_table', 1),
(22, '2024_04_10_142226_add_columns_to_exams_table', 1),
(23, '2024_07_17_164629_create_exam_results_table', 1),
(24, '2024_07_18_124447_create_exam_questions_answers_table', 1),
(25, '2024_07_27_083736_create_jobs_table', 1),
(26, '2024_08_17_092653_create_otp_codes_table', 1),
(27, '2024_11_30_053337_add_ip_and_user_agent_to_personal_access_tokens', 1),
(28, '2024_12_03_042539_add_deleted_at_to_questions_table', 1),
(29, '2024_12_05_035442_add_remark_by_cancelled_by_to_exam_results_table', 1),
(30, '2024_12_05_040447_rename_created_by_last_updated_by_to_questions_table', 1),
(31, '2024_12_23_115239_add_deleted_at_to_question_options_table', 1),
(32, '2025_01_04_084757_create_settings_table', 1),
(33, '2025_01_08_080040_add_column_group_to_settings_table', 1),
(34, '2026_08_16_000000_add_type_to_exams_table', 2),
(35, '2026_09_03_000001_convert_expert_questions_to_hard', 2),
(36, '2026_09_07_000001_add_quiz_settings_to_chapters_table', 3),
(37, '2026_09_07_000002_add_video_path_to_questions_table', 3),
(38, '2026_09_07_000003_create_chapter_materials_table', 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `otp_codes`
--

CREATE TABLE `otp_codes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL COMMENT 'Handle enum in code',
  `expires_at` datetime NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `otp_codes`
--

INSERT INTO `otp_codes` (`id`, `user_id`, `code`, `type`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 1, '749466', 'verify_email', '2025-04-15 18:30:30', '2025-04-15 18:20:30', '2025-04-15 18:20:30');

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'role_permission_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(2, 'role_permission_grant', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(3, 'user_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(4, 'user_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(5, 'user_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(6, 'user_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(7, 'school_class_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(8, 'school_class_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(9, 'school_class_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(10, 'school_class_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(11, 'faculty_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(12, 'faculty_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(13, 'faculty_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(14, 'faculty_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(15, 'subject_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(16, 'subject_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(17, 'subject_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(18, 'subject_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(19, 'question_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(20, 'question_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(21, 'question_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(22, 'question_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(23, 'course_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(24, 'course_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(25, 'course_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(26, 'course_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(27, 'exam_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(28, 'exam_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(29, 'exam_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(30, 'exam_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(31, 'exam_submit', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(32, 'semester_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(33, 'semester_create', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(34, 'semester_update', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(35, 'semester_delete', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(36, 'exam_result_view', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(37, 'exam_result_remark', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(38, 'exam_result_cancel', '2025-04-15 18:01:33', '2025-04-15 18:01:33');

-- --------------------------------------------------------

--
-- Struktur dari tabel `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `ip`, `user_agent`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(11, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', '0572935a46af0fff8ff77c5f82e0088cc0f0111f231af6d70b042c27db2071c5', '[\"*\"]', '2025-04-25 08:42:56', '2025-05-25 08:42:56', '2025-04-25 15:16:59', '2025-04-25 15:42:56'),
(12, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', '790c03be090b320de6d1cdf65c6ad6984f234a92dfd2986066e45553b90adb64', '[\"*\"]', '2025-05-01 07:57:54', '2025-05-31 07:57:54', '2025-05-01 14:52:47', '2025-05-01 14:57:54'),
(15, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', '6995ad3b64b5113bf6848a148b3ee0c0ad957670ed25e22b855b0e318f711d77', '[\"*\"]', '2025-05-01 08:10:08', '2025-05-31 08:10:08', '2025-05-01 15:09:05', '2025-05-01 15:10:08'),
(17, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'e4d83df3b904470eaa5a0b4a1ea1dc6ceb3f4c4f1f89aa327b6640d4171972f5', '[\"*\"]', '2025-05-05 08:22:50', '2025-06-04 08:22:50', '2025-05-01 15:41:34', '2025-05-05 15:22:50'),
(22, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', 'e0244ec9cda504ff4b8f722559c7996b4362bda7f1388e851644e0b73c8d0d5a', '[\"*\"]', '2025-06-04 17:50:02', '2025-07-04 17:50:02', '2025-06-04 16:05:46', '2025-06-05 00:50:02'),
(45, 'App\\Models\\User', 615, 'student token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '8f21c67ff167ccd8d1f5d1afec8c49ae2887d093fc6e627f44670641f0959d58', '[\"*\"]', '2025-06-24 17:03:15', '2025-07-24 17:03:15', '2025-06-24 23:08:17', '2025-06-25 00:03:15'),
(52, 'App\\Models\\User', 622, 'student token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '7376ea4a6dbe2cbb038f956342a08bde98ef00d0aa45603ffdade588e91a3a71', '[\"*\"]', '2025-06-26 17:04:18', '2025-07-26 17:04:18', '2025-06-26 23:53:14', '2025-06-27 00:04:18'),
(61, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36 Edg/137.0.0.0', '75276abc4b6c973569a6dd92a8df5470de2ba07a015274e5c7dae069bce44a72', '[\"*\"]', '2025-07-04 08:33:45', '2025-08-03 08:33:45', '2025-07-04 13:31:26', '2025-07-04 15:33:45'),
(65, 'App\\Models\\User', 620, 'student token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '37ead0e89669c2a2045180e626d59b6f6698b9bdaae85de807b7a82b8226f18a', '[\"*\"]', '2025-07-04 07:32:20', '2025-08-03 07:32:20', '2025-07-04 14:16:56', '2025-07-04 14:32:20'),
(69, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36', '00df4f083a77998ba045c2a3c2e7c93164f0029dc173d573dae8b7459db93f1d', '[\"*\"]', '2025-07-07 17:11:21', '2025-08-06 17:11:21', '2025-07-04 15:56:55', '2025-07-08 00:11:21'),
(71, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '26f7b55988eb65002cb0922b2e2cf95266be65b08f096dba91b6c7b10798d144', '[\"*\"]', '2025-12-05 15:08:56', '2026-01-04 15:08:56', '2025-12-03 12:43:14', '2025-12-05 22:08:56'),
(73, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '34629f66be3ebf32df4c1d2cd7230666f03a39cbf5239001b8c85abdd43dc2b0', '[\"*\"]', '2026-01-14 14:15:26', '2026-02-13 14:15:26', '2026-01-13 12:11:52', '2026-01-14 21:15:26'),
(75, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '7d22105fc261f3360f00b8dddcca12be80cf1e23ecc567a9dd1431a74ee614e8', '[\"*\"]', '2026-01-20 08:21:15', '2026-02-19 08:21:15', '2026-01-20 15:16:10', '2026-01-20 15:21:15'),
(76, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '716e1df1b4d5befc686eb8c5f1c5887d5862ed12ce74fc845c67557b4a98d846', '[\"*\"]', '2026-04-29 13:46:20', '2026-05-29 13:46:20', '2026-04-09 22:17:26', '2026-04-29 20:46:20'),
(81, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '3ba0cec352fbf019ac6c340437591f46da1819092c91453df98afd6d92b93d80', '[\"*\"]', '2026-08-17 08:44:08', '2026-09-16 08:44:08', '2026-08-17 15:30:44', '2026-08-17 15:44:08'),
(100, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '6170cbfb8bf6f5efbbe30bd2ad1e7fa30b62882d3d597590040b005e4d3b4363', '[\"*\"]', '2026-09-07 06:48:31', '2026-10-07 06:48:31', '2026-09-05 13:28:42', '2026-09-07 13:48:31'),
(103, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', '0849faf942c6a16907e0bbd699e9918ecc8b36631312136c22f38ceceb56900e', '[\"*\"]', NULL, '2026-10-07 16:23:02', '2026-09-07 23:23:02', '2026-09-07 23:23:02'),
(122, 'App\\Models\\User', 643, 'student token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'bdaeb3dc900a02ff0de6feddc82f6c8940ddf7a4cc679032df594d600e7efa3a', '[\"*\"]', '2026-09-08 06:26:14', '2026-10-08 06:26:14', '2026-09-08 13:24:24', '2026-09-08 13:26:14'),
(129, 'App\\Models\\User', 1, 'admin token', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'e26b2e7c5534023037dd55eca44ea408d7b17155e4d672bc09aa7ff6f05914a0', '[\"*\"]', '2026-09-14 14:22:07', '2026-10-14 14:22:07', '2026-09-14 19:50:08', '2026-09-14 21:22:07');

-- --------------------------------------------------------

--
-- Struktur dari tabel `questions`
--

CREATE TABLE `questions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `last_updated_by_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `subject_id` bigint(20) UNSIGNED NOT NULL,
  `chapter_id` bigint(20) UNSIGNED DEFAULT NULL,
  `level` enum('easy','medium','hard','expert') NOT NULL DEFAULT 'easy',
  `content` longtext NOT NULL,
  `video_path` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `questions`
--

INSERT INTO `questions` (`id`, `created_by_user_id`, `last_updated_by_user_id`, `subject_id`, `chapter_id`, `level`, `content`, `video_path`, `created_at`, `updated_at`, `deleted_at`) VALUES
(290, 1, NULL, 1, NULL, 'easy', '<p>Siapa namamu?</p>\n', NULL, '2025-04-25 15:20:02', '2025-06-13 17:03:40', '2025-06-13 17:03:40'),
(291, 1, NULL, 1, NULL, 'easy', '<p>Asal mana kamu?</p>\n', NULL, '2025-04-25 15:20:45', '2025-06-13 17:03:50', '2025-06-13 17:03:50'),
(292, 1, NULL, 1, NULL, 'medium', '<p>Hewan kaki 2?</p>\n', NULL, '2025-04-25 15:22:17', '2025-06-13 17:03:57', '2025-06-13 17:03:57'),
(293, 1, NULL, 1, NULL, 'hard', '<p>sinonim</p>\n', NULL, '2025-06-03 04:35:58', '2025-06-13 17:04:05', '2025-06-13 17:04:05'),
(294, 1, NULL, 1, 202, 'easy', '<p>Ayah membelikan sepeda baru untuk Adi. Harga sepeda baru Adi adalah sembilan ratus sembilan puluh sembilan ribu rupiah. Harga sepeda Adi jika ditulis dalam bentuk angka adalah ....</p>\n', NULL, '2025-06-10 09:35:03', '2025-06-10 09:35:03', NULL),
(295, 1, NULL, 1, 202, 'easy', '<p>Salah satu kelemahan celengan adalah ....</p>\n', NULL, '2025-06-10 09:37:26', '2025-06-10 09:37:26', NULL),
(296, 1, NULL, 1, 202, 'easy', '<p>Kalimat berikut yang merupakan kalimat perintah adalah ....</p>\n', NULL, '2025-06-10 09:41:05', '2025-06-10 09:41:05', NULL),
(297, 1, NULL, 1, 202, 'easy', '<p>Farah membeli tas seharga Rp.239.700,00.<p>Nilai uang pada kalimat tersebut jika dituliskan dalam huruf adalah ....</p></p>\n', NULL, '2025-06-10 09:45:24', '2025-06-10 09:45:24', NULL),
(298, 1, NULL, 1, 202, 'easy', '<p>Maya menabung di koperasi sekolah sebesar Rp25.500,00.<p>Uang yang ditabung Maya jika ditulis dalam bentuk huruf adalah ....</p></p>\n', NULL, '2025-06-10 09:50:14', '2025-06-10 09:50:14', NULL),
(299, 1, NULL, 1, 202, 'medium', '<p>Teks prosedur berisi tentang ....</p>\n', NULL, '2025-06-10 09:52:37', '2025-06-10 09:52:37', NULL),
(300, 1, NULL, 1, 202, 'medium', '<p>Tujuan dari teks prosedur adalah ....</p>\n', NULL, '2025-06-10 09:55:03', '2025-06-10 09:55:03', NULL),
(301, 1, NULL, 1, 202, 'medium', '<p>Saat membeli barang, kita sebaiknya ....</p>\n', NULL, '2025-06-10 10:01:32', '2025-06-10 10:01:32', NULL),
(302, 1, NULL, 1, 202, 'medium', '<p>Kalimat berikut yang menunjukkan kegiatan membayar adalah ....</p>\n', NULL, '2025-06-10 10:02:40', '2025-06-10 10:02:40', NULL),
(303, 1, NULL, 1, 202, 'medium', '<p>Apa yang sebaiknya dilakukan setelah membeli barang?</p>\n', NULL, '2025-06-10 10:03:40', '2025-06-10 10:03:40', NULL),
(304, 1, NULL, 1, 202, 'hard', '<p>Dalam kegiatan pertukaran barang, mengapa penting untuk saling setuju?</p>\n', NULL, '2025-06-10 10:05:32', '2025-06-10 10:05:32', NULL),
(305, 1, NULL, 1, 202, 'hard', '<p>Pilih kalimat yang menggunakan kata \"membayar\" secara tepat:</p>\n', NULL, '2025-06-10 10:06:43', '2025-06-10 10:06:43', NULL),
(306, 1, NULL, 1, 202, 'hard', '<p>Kata \"imbalan\" dalam kalimat &ldquo;Rani mendapatkan imbalan setelah membantu ibunya&rdquo; berarti ....</p>\n', NULL, '2025-06-10 10:08:01', '2025-06-10 10:08:01', NULL),
(307, 1, NULL, 1, 202, 'hard', '<p>Dalam teks nonfiksi tentang kegiatan jual beli, informasi yang harus ada adalah ....</p>\n', NULL, '2025-06-10 10:09:16', '2025-06-10 10:09:16', NULL),
(308, 1, NULL, 1, 202, 'hard', '<p>Kalimat berikut yang menunjukkan sikap jujur dalam kegiatan jual beli adalah ....</p>\n', NULL, '2025-06-10 10:12:02', '2025-06-10 10:12:02', NULL),
(309, 1, NULL, 1, 202, 'easy', '<p>Rina pergi ke warung untuk membeli satu liter minyak goreng. Ia membayar kepada penjual menggunakan uang. Kegiatan yang dilakukan Rina disebut dengan ....</p>\n', NULL, '2025-06-17 09:35:01', '2025-06-17 09:35:01', NULL),
(310, 1, NULL, 1, 202, 'easy', '<p>Saat Ani ingin mendapatkan mainan dari temannya, ia memberikan buku cerita miliknya sebagai gantinya. Kegiatan tersebut disebut ....</p>\n', NULL, '2025-06-17 09:36:20', '2025-06-17 09:36:20', NULL),
(311, 1, NULL, 1, 202, 'easy', '<p>Budi membeli sebatang pensil seharga Rp2.000. Ia membayar menggunakan uang Rp5.000. Maka ia akan menerima kembali ....</p>\n', NULL, '2025-06-17 09:37:42', '2025-06-17 09:37:42', NULL),
(312, 1, NULL, 1, 202, 'easy', '<p>Orang yang menerima uang sebagai pengganti barang yang dijual disebut ....</p>\n', NULL, '2025-06-17 09:38:52', '2025-06-17 09:38:52', NULL),
(313, 1, NULL, 1, 202, 'easy', '<p>Tindakan saling memberikan barang dengan orang lain tanpa menggunakan uang disebut ....</p>\n', NULL, '2025-06-17 09:41:26', '2025-06-17 09:41:26', NULL),
(314, 1, 1, 1, 202, 'hard', '<p><p>logo apa ini?</p><p><img src=\"/uploads/dbfb9925-788a-4516-bbb8-175f76ff5b50-1750954750.png.webp\"></p><p></p></p>\n', NULL, '2025-06-24 22:42:50', '2025-07-04 14:57:15', '2025-07-04 14:57:15'),
(315, 1, NULL, 1, 202, 'easy', '<p>Apa arti dari kata \"membayar\"?</p>\n', NULL, '2025-07-04 15:00:49', '2025-07-04 15:00:49', NULL),
(316, 1, NULL, 1, 202, 'easy', '<p>Saat membeli makanan, kita harus ....</p>\n', NULL, '2025-07-04 15:02:05', '2025-07-04 15:02:05', NULL),
(317, 1, NULL, 1, 202, 'easy', '<p>Apa yang biasa digunakan untuk membayar?</p>\n', NULL, '2025-07-04 15:03:14', '2025-07-04 15:03:14', NULL),
(318, 1, NULL, 1, 202, 'easy', '<p>Bertukar dilakukan agar ....</p>\n', NULL, '2025-07-04 15:04:24', '2025-07-04 15:04:24', NULL),
(319, 1, NULL, 1, 202, 'easy', '<p>Saat membeli mainan, kita harus ....</p>\n', NULL, '2025-07-04 15:07:25', '2025-07-04 15:07:25', NULL),
(320, 1, NULL, 1, 202, 'easy', '<p>Uang digunakan untuk ....</p>\n', NULL, '2025-07-04 15:10:07', '2025-07-04 15:10:07', NULL),
(321, 1, NULL, 1, 202, 'easy', '<p>Menjual artinya ....</p>\n', NULL, '2025-07-04 15:18:39', '2025-07-04 15:18:39', NULL),
(322, 1, NULL, 1, 202, 'easy', '<p>Barang yang biasa ditukar anak-anak adalah ....</p>\n', NULL, '2025-07-04 15:20:52', '2025-07-04 15:20:52', NULL),
(323, 1, NULL, 1, 202, 'easy', '<p>Orang yang menjual disebut ....</p>\n', NULL, '2025-07-04 15:27:14', '2025-07-04 15:27:14', NULL),
(324, 1, NULL, 1, 202, 'easy', '<p>Penjual akan memberi barang jika kita ....</p>\n', NULL, '2025-07-04 15:28:12', '2025-07-04 15:28:12', NULL),
(325, 1, NULL, 1, 202, 'easy', '<p>Contoh pembayaran non-tunai adalah ....</p>\n', NULL, '2025-07-04 15:33:21', '2025-07-04 15:33:21', NULL),
(326, 1, NULL, 1, 202, 'easy', '<p>Bertukar harus dilakukan dengan ....</p>\n', NULL, '2025-07-04 15:39:12', '2025-07-04 15:39:12', NULL),
(327, 1, NULL, 1, 202, 'easy', '<p>Jika harga barang Rp5.000 dan kita bayar Rp10.000, maka ....</p>\n', NULL, '2025-07-04 15:40:53', '2025-07-04 15:40:53', NULL),
(328, 1, NULL, 1, 202, 'easy', '<p>Kegiatan jual beli mengajarkan kita untuk ....</p>\n', NULL, '2025-07-04 15:41:40', '2025-07-04 15:41:40', NULL),
(329, 1, NULL, 1, 202, 'easy', '<p>Membayar utang adalah sikap ....</p>\n', NULL, '2025-07-04 15:42:32', '2025-07-04 15:42:32', NULL),
(330, 1, NULL, 53, 203, 'easy', '<p>cek</p>\n', NULL, '2026-09-03 22:35:51', '2026-09-03 22:35:51', NULL),
(331, 1, NULL, 53, 203, 'easy', '<p>soal 1 A</p>\n', NULL, '2026-09-08 00:42:06', '2026-09-08 00:42:06', NULL),
(332, 1, NULL, 53, 203, 'easy', '<p>2 B</p>\n', NULL, '2026-09-08 00:42:51', '2026-09-08 00:42:51', NULL),
(333, 1, NULL, 53, 203, 'easy', '<p>3 C</p>\n', NULL, '2026-09-08 00:43:15', '2026-09-08 00:43:15', NULL),
(334, 1, NULL, 53, 203, 'easy', '<p>4 D</p>\n', NULL, '2026-09-08 00:43:36', '2026-09-08 00:43:36', NULL),
(335, 1, NULL, 53, 203, 'easy', '<p>6 A</p>\n', NULL, '2026-09-08 00:44:09', '2026-09-08 00:44:09', NULL),
(336, 1, NULL, 53, 203, 'hard', '<p>SULIT 1 (A)</p>\n', NULL, '2026-09-08 00:44:34', '2026-09-08 00:44:34', NULL),
(337, 1, NULL, 53, NULL, 'easy', '<p><img src=\"/uploads/af73888b-daa4-4b57-9c23-e2994d7f1162-1788844685.png.webp\">Logo Apa?</p>\n', NULL, '2026-09-08 12:18:06', '2026-09-08 12:18:06', NULL),
(338, 1, NULL, 53, 206, 'easy', '<p>jawabannya Motor<img src=\"/uploads/d8f6355d-3a77-4249-8c8d-5e3c5f6db422-1788844754.png.webp\"></p>\n', NULL, '2026-09-08 12:19:14', '2026-09-08 12:19:14', NULL),
(339, 1, NULL, 53, 206, 'easy', '<p>jawab mobil</p>\n', NULL, '2026-09-08 12:19:53', '2026-09-08 12:19:53', NULL),
(340, 1, NULL, 53, 206, 'easy', '<p>kopi</p>\n', NULL, '2026-09-08 12:20:16', '2026-09-08 12:20:16', NULL),
(341, 1, NULL, 53, 206, 'easy', '<p>teh</p>\n', NULL, '2026-09-08 12:20:37', '2026-09-08 12:20:37', NULL),
(342, 1, NULL, 53, 206, 'easy', '<p>kursi</p>\n', NULL, '2026-09-08 12:21:06', '2026-09-08 12:21:06', NULL),
(343, 1, NULL, 53, 206, 'easy', '<p>rumah</p>\n', NULL, '2026-09-08 12:21:32', '2026-09-08 12:21:32', NULL),
(344, 1, NULL, 53, 206, 'easy', '<p>meja</p>\n', NULL, '2026-09-08 12:22:05', '2026-09-08 12:22:05', NULL),
(345, 1, NULL, 53, 206, 'easy', '<p>lampu</p>\n', NULL, '2026-09-08 12:22:28', '2026-09-08 12:22:28', NULL),
(346, 1, NULL, 53, 206, 'easy', '<p>susu</p>\n', NULL, '2026-09-08 12:22:53', '2026-09-08 12:22:53', NULL),
(347, 1, NULL, 53, 206, 'easy', '<p><strong>TV</strong> <em>jawabannya</em></p>\n', NULL, '2026-09-08 12:23:47', '2026-09-08 12:23:47', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `question_options`
--

CREATE TABLE `question_options` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `question_id` bigint(20) UNSIGNED NOT NULL,
  `content` longtext NOT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `question_options`
--

INSERT INTO `question_options` (`id`, `question_id`, `content`, `is_correct`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1156, 290, '<p>Zilong</p>\n', 1, '2025-04-25 15:20:02', '2025-04-25 15:20:02', NULL),
(1157, 290, '<p>Denis</p>\n', 0, '2025-04-25 15:20:02', '2025-04-25 15:20:02', NULL),
(1158, 290, '<p>Adit</p>\n', 0, '2025-04-25 15:20:02', '2025-04-25 15:20:02', NULL),
(1159, 291, '<p>Jawa</p>\n', 1, '2025-04-25 15:20:45', '2025-04-25 15:20:45', NULL),
(1160, 291, '<p>Sumatera</p>\n', 0, '2025-04-25 15:20:45', '2025-04-25 15:20:45', NULL),
(1161, 291, '<p>Bali</p>\n', 0, '2025-04-25 15:20:45', '2025-04-25 15:20:45', NULL),
(1162, 292, '<p>Anjing</p>\n', 0, '2025-04-25 15:22:17', '2025-04-25 15:22:17', NULL),
(1163, 292, '<p>Babi</p>\n', 0, '2025-04-25 15:22:17', '2025-04-25 15:22:17', NULL),
(1164, 292, '<p>Ayam</p>\n', 1, '2025-04-25 15:22:17', '2025-04-25 15:22:17', NULL),
(1165, 293, '<p>s</p>\n', 1, '2025-06-03 04:35:58', '2025-06-03 04:35:58', NULL),
(1166, 293, '<p>a</p>\n', 0, '2025-06-03 04:35:58', '2025-06-03 04:35:58', NULL),
(1167, 293, '<p>b</p>\n', 0, '2025-06-03 04:35:58', '2025-06-03 04:35:58', NULL),
(1168, 293, '<p>c</p>\n', 0, '2025-06-03 04:35:58', '2025-06-03 04:35:58', NULL),
(1169, 294, '<p>Rp900.990,00</p>\n', 0, '2025-06-10 09:35:03', '2025-06-10 09:35:03', NULL),
(1170, 294, '<p>Rp900.900,00</p>\n', 0, '2025-06-10 09:35:03', '2025-06-10 09:35:03', NULL),
(1171, 294, '<p>999.000,00</p>\n', 1, '2025-06-10 09:35:03', '2025-06-10 09:35:03', NULL),
(1172, 294, '<p>99.990,00</p>\n', 0, '2025-06-10 09:35:03', '2025-06-10 09:35:03', NULL),
(1173, 295, '<p>Kemungkinan uang rentan rusak</p>\n', 1, '2025-06-10 09:37:26', '2025-06-10 09:37:26', NULL),
(1174, 295, '<p>keamanan uang terjamin</p>\n', 0, '2025-06-10 09:37:26', '2025-06-10 09:37:26', NULL),
(1175, 295, '<p>dapat menabung kapan saja</p>\n', 0, '2025-06-10 09:37:26', '2025-06-10 09:37:26', NULL),
(1176, 295, '<p>tidak dibatasi nominal uang tabungannya</p>\n', 0, '2025-06-10 09:37:26', '2025-06-10 09:37:26', NULL),
(1177, 296, '<p>Yuk, kita buka puasa bersama!</p>\n', 0, '2025-06-10 09:41:05', '2025-06-10 09:41:05', NULL),
(1178, 296, '<p>Mari, kita membantu korban bencana alam!</p>\n', 0, '2025-06-10 09:41:05', '2025-06-10 09:41:05', NULL),
(1179, 296, '<p>Ayo, kita pergi berenang saat hari minggu nanti!</p>\n', 0, '2025-06-10 09:41:05', '2025-06-10 09:41:05', NULL),
(1180, 296, '<p>Buanglah sampah pada tempatnya!</p>\n', 1, '2025-06-10 09:41:05', '2025-06-10 09:41:05', NULL),
(1181, 297, '<p>dua ratus tiga sembilan ribu tujuh ratus rupiah</p>\n', 0, '2025-06-10 09:45:24', '2025-06-10 09:45:24', NULL),
(1182, 297, '<p>dua ratus tiga puluh sembilan ribu tujuh ratus rupiah</p>\n', 1, '2025-06-10 09:45:24', '2025-06-10 09:45:24', NULL),
(1183, 297, '<p>dua tiga sembilan ribu tujuh ratus rupiah</p>\n', 0, '2025-06-10 09:45:24', '2025-06-10 09:45:24', NULL),
(1184, 297, '<p>dua ratus tiga puluh sembilan tujuh ratus ribu rupiah</p>\n', 0, '2025-06-10 09:45:24', '2025-06-10 09:45:24', NULL),
(1185, 298, '<p>rupiah dua puluh lima ribu lima ratus</p>\n', 0, '2025-06-10 09:50:14', '2025-06-10 09:50:14', NULL),
(1186, 298, '<p>dua puluh lima ribu lima ratus rupiah</p>\n', 1, '2025-06-10 09:50:14', '2025-06-10 09:50:14', NULL),
(1187, 298, '<p>dua puluh lima ribu lima rupiah</p>\n', 0, '2025-06-10 09:50:14', '2025-06-10 09:50:14', NULL),
(1188, 298, '<p>dua lima lima ratus rupiah</p>\n', 0, '2025-06-10 09:50:14', '2025-06-10 09:50:14', NULL),
(1189, 299, '<p>petunjuk pemakaian sesuatu</p>\n', 1, '2025-06-10 09:52:37', '2025-06-10 09:52:37', NULL),
(1190, 299, '<p>larangan melakukan sesuatu</p>\n', 0, '2025-06-10 09:52:37', '2025-06-10 09:52:37', NULL),
(1191, 299, '<p>petunjuk melakukan sesuatu sesuai aturan</p>\n', 0, '2025-06-10 09:52:37', '2025-06-10 09:52:37', NULL),
(1192, 299, '<p>perintah melakukan sesuatu</p>\n', 0, '2025-06-10 09:52:37', '2025-06-10 09:52:37', NULL),
(1193, 300, '<p>memberi petunjuk cara-cara melakukan sesuatu</p>\n', 1, '2025-06-10 09:55:03', '2025-06-10 09:55:03', NULL),
(1194, 300, '<p>mengungkapkan informasi terkini</p>\n', 0, '2025-06-10 09:55:03', '2025-06-10 09:55:03', NULL),
(1195, 300, '<p>membedakan fakta dan opini</p>\n', 0, '2025-06-10 09:55:03', '2025-06-10 09:55:03', NULL),
(1196, 300, '<p>memaparkan sesuatu agar pengetahuan pembaca bertambah</p>\n', 0, '2025-06-10 09:55:03', '2025-06-10 09:55:03', NULL),
(1197, 301, '<p>Menawar dengan kasar</p>\n', 0, '2025-06-10 10:01:32', '2025-06-10 10:01:32', NULL),
(1198, 301, '<p>Mengambil barang tanpa izin</p>\n', 0, '2025-06-10 10:01:32', '2025-06-10 10:01:32', NULL),
(1199, 301, '<p>Membayar sesuai harga</p>\n', 1, '2025-06-10 10:01:32', '2025-06-10 10:01:32', NULL),
(1200, 301, '<p>Marah jika tidak diberi diskon</p>\n', 0, '2025-06-10 10:01:32', '2025-06-10 10:01:32', NULL),
(1201, 302, '<p>Rina menukar baju dengan tas</p>\n', 0, '2025-06-10 10:02:40', '2025-06-10 10:02:40', NULL),
(1202, 302, '<p>Edo membeli buku dengan uang sakunya</p>\n', 1, '2025-06-10 10:02:40', '2025-06-10 10:02:40', NULL),
(1203, 302, '<p>Sari meminjam penghapus dari temannya</p>\n', 0, '2025-06-10 10:02:40', '2025-06-10 10:02:40', NULL),
(1204, 302, '<p>Toni menjahit baju</p>\n', 0, '2025-06-10 10:02:40', '2025-06-10 10:02:40', NULL),
(1205, 303, '<p>Mencatat pengeluaran</p>\n', 1, '2025-06-10 10:03:40', '2025-06-10 10:03:40', NULL),
(1206, 303, '<p>Menyembunyikan barang</p>\n', 0, '2025-06-10 10:03:40', '2025-06-10 10:03:40', NULL),
(1207, 303, '<p>Membanting barang</p>\n', 0, '2025-06-10 10:03:40', '2025-06-10 10:03:40', NULL),
(1208, 303, '<p>Memberikan barang ke orang lain</p>\n', 0, '2025-06-10 10:03:40', '2025-06-10 10:03:40', NULL),
(1209, 304, '<p>Agar tidak rugi sendiri</p>\n', 1, '2025-06-10 10:05:32', '2025-06-10 10:05:32', NULL),
(1210, 304, '<p>Agar bisa cepat selesai</p>\n', 0, '2025-06-10 10:05:32', '2025-06-10 10:05:32', NULL),
(1211, 304, '<p>Agar barang tidak rusak</p>\n', 0, '2025-06-10 10:05:32', '2025-06-10 10:05:32', NULL),
(1212, 304, '<p>Agar bisa menjual kembali</p>\n', 0, '2025-06-10 10:05:32', '2025-06-10 10:05:32', NULL),
(1213, 305, '<p>Ibu membayar waktu untuk bersantai</p>\n', 0, '2025-06-10 10:06:43', '2025-06-10 10:06:43', NULL),
(1214, 305, '<p>Dito membayar uang jajan kepada adiknya</p>\n', 0, '2025-06-10 10:06:43', '2025-06-10 10:06:43', NULL),
(1215, 305, '<p>Lani membayar belanjaan di kasir dengan uang tunai</p>\n', 1, '2025-06-10 10:06:43', '2025-06-10 10:06:43', NULL),
(1216, 305, '<p>Dika membayar udara bersih dengan senyuman</p>\n', 0, '2025-06-10 10:06:43', '2025-06-10 10:06:43', NULL),
(1217, 306, '<p>Hukuman</p>\n', 0, '2025-06-10 10:08:01', '2025-06-10 10:08:01', NULL),
(1218, 306, '<p>Bayaran atau hadiah</p>\n', 1, '2025-06-10 10:08:01', '2025-06-10 10:08:01', NULL),
(1219, 306, '<p>Tugas tambahan</p>\n', 0, '2025-06-10 10:08:01', '2025-06-10 10:08:01', NULL),
(1220, 306, '<p>Uang simpanan</p>\n', 0, '2025-06-10 10:08:01', '2025-06-10 10:08:01', NULL),
(1221, 307, '<p>Harga dan proses pembayaran</p>\n', 1, '2025-06-10 10:09:16', '2025-06-10 10:09:16', NULL),
(1222, 307, '<p>Warna barang</p>\n', 0, '2025-06-10 10:09:16', '2025-06-10 10:09:16', NULL),
(1223, 307, '<p>Nama teman bermain</p>\n', 0, '2025-06-10 10:09:16', '2025-06-10 10:09:16', NULL),
(1224, 307, '<p>Tempat rekreasi</p>\n', 0, '2025-06-10 10:09:16', '2025-06-10 10:09:16', NULL),
(1225, 308, '<p>Dimas menjual mainan bekas tapi mengatakan itu masih baru.</p>\n', 0, '2025-06-10 10:12:02', '2025-06-10 10:12:02', NULL),
(1226, 308, '<p>Rika memberikan kembali uang kelebihan kembalian kepada pembeli.</p>\n', 1, '2025-06-10 10:12:02', '2025-06-10 10:12:02', NULL),
(1227, 308, '<p>Seno menyembunyikan kerusakan barang agar cepat laku.</p>\n', 0, '2025-06-10 10:12:02', '2025-06-10 10:12:02', NULL),
(1228, 308, '<p>Lina meminta harga lebih mahal dari harga sebenarnya.</p>\n', 0, '2025-06-10 10:12:02', '2025-06-10 10:12:02', NULL),
(1229, 309, '<p>Bertamu</p>\n', 0, '2025-06-17 09:35:01', '2025-06-17 09:35:01', NULL),
(1230, 309, '<p>Bertukar pikiran</p>\n', 0, '2025-06-17 09:35:01', '2025-06-17 09:35:01', NULL),
(1231, 309, '<p>Membeli</p>\n', 1, '2025-06-17 09:35:01', '2025-06-17 09:35:01', NULL),
(1232, 309, '<p>Menyimpan</p>\n', 0, '2025-06-17 09:35:01', '2025-06-17 09:35:01', NULL),
(1233, 310, '<p>Menjual</p>\n', 0, '2025-06-17 09:36:20', '2025-06-17 09:36:20', NULL),
(1234, 310, '<p>Menabung</p>\n', 0, '2025-06-17 09:36:20', '2025-06-17 09:36:20', NULL),
(1235, 310, '<p>Bertukar</p>\n', 1, '2025-06-17 09:36:20', '2025-06-17 09:36:20', NULL),
(1236, 310, '<p>Membayar</p>\n', 0, '2025-06-17 09:36:20', '2025-06-17 09:36:20', NULL),
(1237, 311, '<p>Rp2.000</p>\n', 0, '2025-06-17 09:37:42', '2025-06-17 09:37:42', NULL),
(1238, 311, '<p>Rp3.000</p>\n', 1, '2025-06-17 09:37:42', '2025-06-17 09:37:42', NULL),
(1239, 311, '<p>Rp4.000</p>\n', 0, '2025-06-17 09:37:42', '2025-06-17 09:37:42', NULL),
(1240, 311, '<p>Rp5.000</p>\n', 0, '2025-06-17 09:37:42', '2025-06-17 09:37:42', NULL),
(1241, 312, '<p>Pembeli</p>\n', 0, '2025-06-17 09:38:52', '2025-06-17 09:38:52', NULL),
(1242, 312, '<p>Penjual</p>\n', 1, '2025-06-17 09:38:52', '2025-06-17 09:38:52', NULL),
(1243, 312, '<p>Tukang</p>\n', 0, '2025-06-17 09:38:52', '2025-06-17 09:38:52', NULL),
(1244, 312, '<p>Petugas</p>\n', 0, '2025-06-17 09:38:52', '2025-06-17 09:38:52', NULL),
(1245, 313, '<p>Menjual</p>\n', 0, '2025-06-17 09:41:26', '2025-06-17 09:41:26', NULL),
(1246, 313, '<p>Membayar</p>\n', 0, '2025-06-17 09:41:26', '2025-06-17 09:41:26', NULL),
(1247, 313, '<p>Bertukar</p>\n', 1, '2025-06-17 09:41:26', '2025-06-17 09:41:26', NULL),
(1248, 313, '<p>Berbelanja</p>\n', 0, '2025-06-17 09:41:26', '2025-06-17 09:41:26', NULL),
(1249, 314, '<p>Quiznesia</p>\n', 1, '2025-06-24 22:42:50', '2025-06-26 23:19:10', NULL),
(1250, 314, '<p>Shopee</p>\n', 0, '2025-06-24 22:42:50', '2025-06-26 23:19:10', NULL),
(1251, 314, '<p>Lazada</p>\n', 0, '2025-06-26 23:19:10', '2025-06-26 23:19:10', NULL),
(1252, 314, '<p>Instagram</p>\n', 0, '2025-06-26 23:19:10', '2025-06-26 23:19:10', NULL),
(1253, 315, '<p>Menerima uang</p>\n', 0, '2025-07-04 15:00:49', '2025-07-04 15:00:49', NULL),
(1254, 315, '<p>Memberi uang untuk membeli sesuatu</p>\n', 1, '2025-07-04 15:00:49', '2025-07-04 15:00:49', NULL),
(1255, 315, '<p>Menyimpan uang</p>\n', 0, '2025-07-04 15:00:49', '2025-07-04 15:00:49', NULL),
(1256, 315, '<p>Meminjam uang</p>\n', 0, '2025-07-04 15:00:49', '2025-07-04 15:00:49', NULL),
(1257, 316, '<p>Meminta gratis</p>\n', 0, '2025-07-04 15:02:05', '2025-07-04 15:02:05', NULL),
(1258, 316, '<p>Berteriak</p>\n', 0, '2025-07-04 15:02:05', '2025-07-04 15:02:05', NULL),
(1259, 316, '<p>Membayar</p>\n', 1, '2025-07-04 15:02:05', '2025-07-04 15:02:05', NULL),
(1260, 316, '<p>Mengeluh</p>\n', 0, '2025-07-04 15:02:05', '2025-07-04 15:02:05', NULL),
(1261, 317, '<p>Kartu identitas</p>\n', 0, '2025-07-04 15:03:14', '2025-07-04 15:03:14', NULL),
(1262, 317, '<p>Uang</p>\n', 1, '2025-07-04 15:03:14', '2025-07-04 15:03:14', NULL),
(1263, 317, '<p>Surat</p>\n', 0, '2025-07-04 15:03:14', '2025-07-04 15:03:14', NULL),
(1264, 317, '<p>Pensil</p>\n', 0, '2025-07-04 15:03:14', '2025-07-04 15:03:14', NULL),
(1265, 318, '<p>Saling rugi</p>\n', 0, '2025-07-04 15:04:24', '2025-07-04 15:04:24', NULL),
(1266, 318, '<p>Mendapat yang diinginkan</p>\n', 1, '2025-07-04 15:04:24', '2025-07-04 15:04:24', NULL),
(1267, 318, '<p>Menyakiti</p>\n', 0, '2025-07-04 15:04:24', '2025-07-04 15:04:24', NULL),
(1268, 318, '<p>Menghindari teman</p>\n', 0, '2025-07-04 15:04:24', '2025-07-04 15:04:24', NULL),
(1269, 319, '<p>Menukar dengan baju</p>\n', 0, '2025-07-04 15:07:25', '2025-07-04 15:07:25', NULL),
(1270, 319, '<p>Meminjam</p>\n', 0, '2025-07-04 15:07:25', '2025-07-04 15:07:25', NULL),
(1271, 319, '<p>Mencuri</p>\n', 0, '2025-07-04 15:07:25', '2025-07-04 15:07:25', NULL),
(1272, 319, '<p>Membayar sesuai harga</p>\n', 1, '2025-07-04 15:07:25', '2025-07-04 15:07:25', NULL),
(1273, 320, '<p>Dibuang</p>\n', 0, '2025-07-04 15:10:07', '2025-07-04 15:10:07', NULL),
(1274, 320, '<p>Dibakar</p>\n', 0, '2025-07-04 15:10:07', '2025-07-04 15:10:07', NULL),
(1275, 320, '<p>Membayar sesuatu</p>\n', 1, '2025-07-04 15:10:07', '2025-07-04 15:10:07', NULL),
(1276, 320, '<p>Dimakan</p>\n', 0, '2025-07-04 15:10:07', '2025-07-04 15:10:07', NULL),
(1277, 321, '<p>Membeli</p>\n', 0, '2025-07-04 15:18:39', '2025-07-04 15:18:39', NULL),
(1278, 321, '<p>Memberi hadiah</p>\n', 0, '2025-07-04 15:18:39', '2025-07-04 15:18:39', NULL),
(1279, 321, '<p>Memberikan barang dengan menerima uang</p>\n', 1, '2025-07-04 15:18:39', '2025-07-04 15:18:39', NULL),
(1280, 321, '<p>Menyumbang</p>\n', 0, '2025-07-04 15:18:39', '2025-07-04 15:18:39', NULL),
(1281, 322, '<p>Uang</p>\n', 0, '2025-07-04 15:20:52', '2025-07-04 15:20:52', NULL),
(1282, 322, '<p>Buku pelajaran</p>\n', 0, '2025-07-04 15:20:52', '2025-07-04 15:20:52', NULL),
(1283, 322, '<p>Mainan</p>\n', 1, '2025-07-04 15:20:52', '2025-07-04 15:20:52', NULL),
(1284, 322, '<p>Laptop</p>\n', 0, '2025-07-04 15:20:52', '2025-07-04 15:20:52', NULL),
(1285, 323, '<p>Pembeli</p>\n', 0, '2025-07-04 15:27:14', '2025-07-04 15:27:14', NULL),
(1286, 323, '<p>Tukang cukur</p>\n', 0, '2025-07-04 15:27:14', '2025-07-04 15:27:14', NULL),
(1287, 323, '<p>Penjual</p>\n', 1, '2025-07-04 15:27:14', '2025-07-04 15:27:14', NULL),
(1288, 323, '<p>Polisi</p>\n', 0, '2025-07-04 15:27:14', '2025-07-04 15:27:14', NULL),
(1289, 324, '<p>Marah</p>\n', 0, '2025-07-04 15:28:12', '2025-07-04 15:28:12', NULL),
(1290, 324, '<p>Membayar</p>\n', 1, '2025-07-04 15:28:12', '2025-07-04 15:28:12', NULL),
(1291, 324, '<p>Diam</p>\n', 0, '2025-07-04 15:28:12', '2025-07-04 15:28:12', NULL),
(1292, 324, '<p>Minta Gratis</p>\n', 0, '2025-07-04 15:28:12', '2025-07-04 15:28:12', NULL),
(1293, 325, '<p>Kartu ATM</p>\n', 1, '2025-07-04 15:33:21', '2025-07-04 15:33:21', NULL),
(1294, 325, '<p>Surat</p>\n', 0, '2025-07-04 15:33:21', '2025-07-04 15:33:21', NULL),
(1295, 325, '<p>Sepeda</p>\n', 0, '2025-07-04 15:33:21', '2025-07-04 15:33:21', NULL),
(1296, 325, '<p>Kue</p>\n', 0, '2025-07-04 15:33:21', '2025-07-04 15:33:21', NULL),
(1297, 326, '<p>Paksaan</p>\n', 0, '2025-07-04 15:39:12', '2025-07-04 15:39:12', NULL),
(1298, 326, '<p>Curang</p>\n', 0, '2025-07-04 15:39:12', '2025-07-04 15:39:12', NULL),
(1299, 326, '<p>Sukarela</p>\n', 1, '2025-07-04 15:39:12', '2025-07-04 15:39:12', NULL),
(1300, 326, '<p>Terpaksa</p>\n', 0, '2025-07-04 15:39:12', '2025-07-04 15:39:12', NULL),
(1301, 327, '<p>Tidak ada kembalian</p>\n', 0, '2025-07-04 15:40:53', '2025-07-04 15:40:53', NULL),
(1302, 327, '<p>Harus diberi kembali Rp5.000</p>\n', 1, '2025-07-04 15:40:53', '2025-07-04 15:40:53', NULL),
(1303, 327, '<p>Kita rugi</p>\n', 0, '2025-07-04 15:40:53', '2025-07-04 15:40:53', NULL),
(1304, 327, '<p>Penjual marah</p>\n', 0, '2025-07-04 15:40:53', '2025-07-04 15:40:53', NULL),
(1305, 328, '<p>Malas</p>\n', 0, '2025-07-04 15:41:40', '2025-07-04 15:41:40', NULL),
(1306, 328, '<p>Curang</p>\n', 0, '2025-07-04 15:41:40', '2025-07-04 15:41:40', NULL),
(1307, 328, '<p>Jujur</p>\n', 1, '2025-07-04 15:41:40', '2025-07-04 15:41:40', NULL),
(1308, 328, '<p>Sombong</p>\n', 0, '2025-07-04 15:41:40', '2025-07-04 15:41:40', NULL),
(1309, 329, '<p>Tidak penting</p>\n', 0, '2025-07-04 15:42:32', '2025-07-04 15:42:32', NULL),
(1310, 329, '<p>Ceroboh</p>\n', 0, '2025-07-04 15:42:32', '2025-07-04 15:42:32', NULL),
(1311, 329, '<p>Bertanggung jawab</p>\n', 1, '2025-07-04 15:42:32', '2025-07-04 15:42:32', NULL),
(1312, 329, '<p>Pelit</p>\n', 0, '2025-07-04 15:42:32', '2025-07-04 15:42:32', NULL),
(1313, 330, '<p>1</p>\n', 1, '2026-09-03 22:35:51', '2026-09-03 22:35:51', NULL),
(1314, 330, '<p>2</p>\n', 0, '2026-09-03 22:35:51', '2026-09-03 22:35:51', NULL),
(1315, 331, '<p>AA</p>\n', 1, '2026-09-08 00:42:06', '2026-09-08 00:42:06', NULL),
(1316, 331, '<p>BB</p>\n', 0, '2026-09-08 00:42:06', '2026-09-08 00:42:06', NULL),
(1317, 331, '<p>CC</p>\n', 0, '2026-09-08 00:42:06', '2026-09-08 00:42:06', NULL),
(1318, 331, '<p>DD</p>\n', 0, '2026-09-08 00:42:06', '2026-09-08 00:42:06', NULL),
(1319, 332, '<p>AA</p>\n', 0, '2026-09-08 00:42:51', '2026-09-08 00:42:51', NULL),
(1320, 332, '<p>BB</p>\n', 1, '2026-09-08 00:42:51', '2026-09-08 00:42:51', NULL),
(1321, 332, '<p>CC</p>\n', 0, '2026-09-08 00:42:51', '2026-09-08 00:42:51', NULL),
(1322, 332, '<p>DD</p>\n', 0, '2026-09-08 00:42:51', '2026-09-08 00:42:51', NULL),
(1323, 333, '<p>AA</p>\n', 0, '2026-09-08 00:43:15', '2026-09-08 00:43:15', NULL),
(1324, 333, '<p>BB</p>\n', 0, '2026-09-08 00:43:15', '2026-09-08 00:43:15', NULL),
(1325, 333, '<p>CC</p>\n', 1, '2026-09-08 00:43:15', '2026-09-08 00:43:15', NULL),
(1326, 333, '<p>DD</p>\n', 0, '2026-09-08 00:43:15', '2026-09-08 00:43:15', NULL),
(1327, 334, '<p>AA</p>\n', 0, '2026-09-08 00:43:36', '2026-09-08 00:43:36', NULL),
(1328, 334, '<p>BB</p>\n', 0, '2026-09-08 00:43:36', '2026-09-08 00:43:36', NULL),
(1329, 334, '<p>CC</p>\n', 0, '2026-09-08 00:43:36', '2026-09-08 00:43:36', NULL),
(1330, 334, '<p>DD</p>\n', 1, '2026-09-08 00:43:36', '2026-09-08 00:43:36', NULL),
(1331, 335, '<p>AA</p>\n', 1, '2026-09-08 00:44:09', '2026-09-08 00:44:09', NULL),
(1332, 335, '<p>BB</p>\n', 0, '2026-09-08 00:44:09', '2026-09-08 00:44:09', NULL),
(1333, 335, '<p>CC</p>\n', 0, '2026-09-08 00:44:09', '2026-09-08 00:44:09', NULL),
(1334, 335, '<p>DD</p>\n', 0, '2026-09-08 00:44:09', '2026-09-08 00:44:09', NULL),
(1335, 336, '<p>AA</p>\n', 1, '2026-09-08 00:44:34', '2026-09-08 00:44:34', NULL),
(1336, 336, '<p>BB</p>\n', 0, '2026-09-08 00:44:34', '2026-09-08 00:44:34', NULL),
(1337, 336, '<p>CC</p>\n', 0, '2026-09-08 00:44:34', '2026-09-08 00:44:34', NULL),
(1338, 336, '<p>DD</p>\n', 0, '2026-09-08 00:44:34', '2026-09-08 00:44:34', NULL),
(1339, 337, '<p>A</p>\n', 0, '2026-09-08 12:18:06', '2026-09-08 12:18:06', NULL),
(1340, 337, '<p>B</p>\n', 0, '2026-09-08 12:18:06', '2026-09-08 12:18:06', NULL),
(1341, 337, '<p>SMA 1 DUKUHWARU</p>\n', 1, '2026-09-08 12:18:06', '2026-09-08 12:18:06', NULL),
(1342, 337, '<p>Mbuh</p>\n', 0, '2026-09-08 12:18:06', '2026-09-08 12:18:06', NULL),
(1343, 338, '<p>motor</p>\n', 1, '2026-09-08 12:19:14', '2026-09-08 12:19:14', NULL),
(1344, 338, '<p>a</p>\n', 0, '2026-09-08 12:19:14', '2026-09-08 12:19:14', NULL),
(1345, 338, '<p>b</p>\n', 0, '2026-09-08 12:19:14', '2026-09-08 12:19:14', NULL),
(1346, 338, '<p>c</p>\n', 0, '2026-09-08 12:19:14', '2026-09-08 12:19:14', NULL),
(1347, 339, '<p>a</p>\n', 0, '2026-09-08 12:19:53', '2026-09-08 12:19:53', NULL),
(1348, 339, '<p>b</p>\n', 0, '2026-09-08 12:19:53', '2026-09-08 12:19:53', NULL),
(1349, 339, '<p>mobil</p>\n', 1, '2026-09-08 12:19:53', '2026-09-08 12:19:53', NULL),
(1350, 339, '<p>y</p>\n', 0, '2026-09-08 12:19:53', '2026-09-08 12:19:53', NULL),
(1351, 340, '<p>a</p>\n', 0, '2026-09-08 12:20:16', '2026-09-08 12:20:16', NULL),
(1352, 340, '<p>b</p>\n', 0, '2026-09-08 12:20:16', '2026-09-08 12:20:16', NULL),
(1353, 340, '<p>c</p>\n', 0, '2026-09-08 12:20:16', '2026-09-08 12:20:16', NULL),
(1354, 340, '<p>kopi</p>\n', 1, '2026-09-08 12:20:16', '2026-09-08 12:20:16', NULL),
(1355, 341, '<p>teh</p>\n', 1, '2026-09-08 12:20:37', '2026-09-08 12:20:37', NULL),
(1356, 341, '<p>a</p>\n', 0, '2026-09-08 12:20:37', '2026-09-08 12:20:37', NULL),
(1357, 341, '<p>ss</p>\n', 0, '2026-09-08 12:20:37', '2026-09-08 12:20:37', NULL),
(1358, 341, '<p>e</p>\n', 0, '2026-09-08 12:20:37', '2026-09-08 12:20:37', NULL),
(1359, 342, '<p>a</p>\n', 0, '2026-09-08 12:21:06', '2026-09-08 12:21:06', NULL),
(1360, 342, '<p>b</p>\n', 0, '2026-09-08 12:21:06', '2026-09-08 12:21:06', NULL),
(1361, 342, '<p>kursi</p>\n', 1, '2026-09-08 12:21:06', '2026-09-08 12:21:06', NULL),
(1362, 342, '<p>s</p>\n', 0, '2026-09-08 12:21:06', '2026-09-08 12:21:06', NULL),
(1363, 343, '<p>rumah</p>\n', 1, '2026-09-08 12:21:32', '2026-09-08 12:21:32', NULL),
(1364, 343, '<p>q</p>\n', 0, '2026-09-08 12:21:32', '2026-09-08 12:21:32', NULL),
(1365, 343, '<p>w</p>\n', 0, '2026-09-08 12:21:32', '2026-09-08 12:21:32', NULL),
(1366, 343, '<p>t</p>\n', 0, '2026-09-08 12:21:32', '2026-09-08 12:21:32', NULL),
(1367, 344, '<p>s</p>\n', 0, '2026-09-08 12:22:05', '2026-09-08 12:22:05', NULL),
(1368, 344, '<p>e</p>\n', 0, '2026-09-08 12:22:05', '2026-09-08 12:22:05', NULL),
(1369, 344, '<p>u</p>\n', 0, '2026-09-08 12:22:05', '2026-09-08 12:22:05', NULL),
(1370, 344, '<p>meja</p>\n', 1, '2026-09-08 12:22:05', '2026-09-08 12:22:05', NULL),
(1371, 345, '<p>lampu</p>\n', 1, '2026-09-08 12:22:28', '2026-09-08 12:22:28', NULL),
(1372, 345, '<p>w</p>\n', 0, '2026-09-08 12:22:28', '2026-09-08 12:22:28', NULL),
(1373, 345, '<p>q</p>\n', 0, '2026-09-08 12:22:28', '2026-09-08 12:22:28', NULL),
(1374, 345, '<p>n</p>\n', 0, '2026-09-08 12:22:28', '2026-09-08 12:22:28', NULL),
(1375, 346, '<p>a</p>\n', 0, '2026-09-08 12:22:53', '2026-09-08 12:22:53', NULL),
(1376, 346, '<p>susu</p>\n', 1, '2026-09-08 12:22:53', '2026-09-08 12:22:53', NULL),
(1377, 346, '<p>x</p>\n', 0, '2026-09-08 12:22:53', '2026-09-08 12:22:53', NULL),
(1378, 346, '<p>xx</p>\n', 0, '2026-09-08 12:22:53', '2026-09-08 12:22:53', NULL),
(1379, 347, '<p>a</p>\n', 0, '2026-09-08 12:23:47', '2026-09-08 12:23:47', NULL),
(1380, 347, '<p>b</p>\n', 0, '2026-09-08 12:23:47', '2026-09-08 12:23:47', NULL),
(1381, 347, '<p>d</p>\n', 0, '2026-09-08 12:23:47', '2026-09-08 12:23:47', NULL),
(1382, 347, '<p>TV</p>\n', 1, '2026-09-08 12:23:47', '2026-09-08 12:23:47', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'admin', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(2, 'teacher', '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(3, 'student', '2025-04-15 18:01:33', '2025-04-15 18:01:33');

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 2, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 3, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 4, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 5, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 6, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 7, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 8, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 9, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 10, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 11, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 12, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 13, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 14, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 15, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 16, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 17, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 18, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 19, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 20, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 21, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 22, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 23, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 24, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 25, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 26, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 27, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 28, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 29, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 30, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 31, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 32, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 33, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 34, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 35, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 36, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 37, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(1, 38, '2025-04-15 18:01:33', '2025-04-15 18:01:33'),
(2, 3, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 4, '2026-09-07 23:35:59', '2026-09-07 23:35:59'),
(2, 7, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 8, '2026-09-07 23:35:59', '2026-09-07 23:35:59'),
(2, 10, '2026-09-07 23:35:59', '2026-09-07 23:35:59'),
(2, 11, '2025-06-17 11:24:43', '2025-06-17 11:24:43'),
(2, 19, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 20, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 21, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 22, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 27, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 28, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 29, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 30, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 31, '2025-06-17 09:53:19', '2025-06-17 09:53:19'),
(2, 32, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 33, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 34, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 35, '2025-06-13 17:14:06', '2025-06-13 17:14:06'),
(2, 36, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 37, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(2, 38, '2025-04-25 14:09:41', '2025-04-25 14:09:41'),
(3, 3, '2025-04-25 14:07:23', '2025-04-25 14:07:23'),
(3, 7, '2025-06-13 17:15:05', '2025-06-13 17:15:05'),
(3, 15, '2025-04-25 14:07:23', '2025-04-25 14:07:23'),
(3, 23, '2025-04-25 14:07:23', '2025-04-25 14:07:23'),
(3, 27, '2025-04-25 14:07:23', '2025-04-25 14:07:23'),
(3, 31, '2025-04-25 14:07:23', '2025-04-25 14:07:23'),
(3, 32, '2025-04-25 14:07:23', '2025-04-25 14:07:23'),
(3, 36, '2025-04-25 14:07:23', '2025-04-25 14:07:23');

-- --------------------------------------------------------

--
-- Struktur dari tabel `school_classes`
--

CREATE TABLE `school_classes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `shortcode` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `faculty_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `school_classes`
--

INSERT INTO `school_classes` (`id`, `shortcode`, `name`, `faculty_id`, `created_at`, `updated_at`) VALUES
(52, '01', '10 A', NULL, '2026-09-03 23:09:22', '2026-09-03 23:09:22'),
(53, 'K001', '11.1', NULL, '2026-09-08 13:56:52', '2026-09-08 13:56:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `semesters`
--

CREATE TABLE `semesters` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `semesters`
--

INSERT INTO `semesters` (`id`, `name`, `start_date`, `end_date`, `created_at`, `updated_at`) VALUES
(1, 'Genap', '2025-05-02', '2025-07-19', '2025-04-25 14:56:36', '2025-06-26 23:09:17'),
(2, 'Periode Sejarah 2026', '2026-09-03', '2027-09-03', '2026-09-03 23:31:08', '2026-09-03 23:31:08');

-- --------------------------------------------------------

--
-- Struktur dari tabel `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `group` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `group`, `created_at`, `updated_at`) VALUES
(1, 'exam_base_score_scale', '10', 'exam', '2025-04-15 11:03:54', '2025-04-15 11:03:54'),
(2, 'exam_allow_late_submit_seconds', '60', 'exam', '2025-04-15 11:03:54', '2025-04-15 11:03:54'),
(3, 'exam_auto_cancel_after_seconds', '300', 'exam', '2025-04-15 11:03:54', '2025-04-15 11:03:54'),
(4, 'exam_can_remark_within_days', '60', 'exam', '2025-04-15 11:03:54', '2025-04-15 11:03:54'),
(5, 'school_logo', '/uploads/school-logo-12a14dd6-d158-4c3e-acf9-87e3c6277a71.png', 'branding', '2026-09-07 16:46:35', '2026-09-07 16:46:35');

-- --------------------------------------------------------

--
-- Struktur dari tabel `subjects`
--

CREATE TABLE `subjects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `shortcode` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `subjects`
--

INSERT INTO `subjects` (`id`, `shortcode`, `name`, `created_at`, `updated_at`) VALUES
(1, 'PLDC01', 'Bahasa Indonesia', '2025-04-15 18:03:54', '2025-06-09 21:22:19'),
(53, '002', 'Sejarah Indonesia', '2025-12-03 12:11:41', '2025-12-03 12:11:41');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `shortcode` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `gender` enum('male','female') NOT NULL DEFAULT 'male',
  `address` varchar(255) NOT NULL,
  `birth_date` date NOT NULL,
  `school_class_id` bigint(20) UNSIGNED DEFAULT NULL,
  `faculty_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `role_id`, `shortcode`, `first_name`, `last_name`, `email`, `phone_number`, `gender`, `address`, `birth_date`, `school_class_id`, `faculty_id`, `is_active`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 1, 'SYSADMIN', 'Gabriela', 'Anting', 'gabrielaanting87@gmail.com', NULL, 'female', 'Purwokerto', '2000-10-14', NULL, NULL, 1, '2025-04-15 18:21:48', '$2y$10$5Zbp11L7LOd4/RcaXmTuiuTrm0zmtdT6tC3bl738aYgoz3X9YVKNy', NULL, '2025-04-15 18:03:54', '2026-01-13 12:13:10'),
(642, 2, 'GR001', 'Noviana', 'Savitri, S.Pd', 'noviana@gmail.com', NULL, 'female', 'Dukuhwaru', '1997-08-17', NULL, NULL, 1, NULL, '$2y$10$tiL5IxZBVyV6BDASOF6j1eVYe9DyC4n7z7/4LOlav86oAQnXlcvsm', NULL, '2026-09-08 12:08:48', '2026-09-08 12:08:48'),
(643, 3, 'S001', 'siswa', '1', 'siswa1@gmail.com', NULL, 'male', 'SLAWI', '2013-06-06', 52, NULL, 1, NULL, '$2y$10$IKbe1tAqAZG5eQKizD5NP.IzT2e.7yE64/dbHQVcVyVvu.SFZumWe', NULL, '2026-09-08 12:11:49', '2026-09-08 12:11:49'),
(644, 3, 'S002', 'siswa', '2', 'siswa2@gmail.com', NULL, 'female', 'TEGAL', '2011-02-22', 52, NULL, 1, NULL, '$2y$10$9pMQsHJOyCeEOYcIHjCRJOTxIKQJxx0NF3j3UnYGU3vYK0NUwqDMe', NULL, '2026-09-08 12:13:02', '2026-09-08 12:13:02'),
(645, 3, 'S003', 'siswa', '3', 'siswa3@gmail.com', NULL, 'male', 'SLAWI', '2012-06-26', 52, NULL, 1, NULL, '$2y$10$Iffhk81gS9r/Qo35i.OzROPJyj8NqBd6IKIeiI7jIUtW0IhZgvTUe', NULL, '2026-09-08 12:13:49', '2026-09-08 12:13:49'),
(646, 3, 'S004', 'siswa', '4', 'siswa4@gmail.com', NULL, 'female', 'PWT', '2009-12-10', 52, NULL, 1, NULL, '$2y$10$IIGam5zPsXinSOfNCUhJP.ehvuKNG7u6SI.1Z6XInQEmLXyuJslii', NULL, '2026-09-08 12:14:55', '2026-09-08 12:14:55'),
(647, 3, 'S005', 'siswa', '5', 'siswa5@gmail.com', NULL, 'male', 'BATANG', '2010-12-02', 52, NULL, 1, NULL, '$2y$10$gTMqP7s3UdDtrjZRnEoJ4OvknurBum1vv9K3VNi2hWFhipOywxQUy', NULL, '2026-09-08 12:15:42', '2026-09-08 12:15:42');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `chapters`
--
ALTER TABLE `chapters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chapters_subject_id_foreign` (`subject_id`);

--
-- Indeks untuk tabel `chapter_materials`
--
ALTER TABLE `chapter_materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chapter_materials_chapter_id_foreign` (`chapter_id`);

--
-- Indeks untuk tabel `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `courses_shortcode_unique` (`shortcode`),
  ADD KEY `courses_teacher_id_foreign` (`teacher_id`),
  ADD KEY `courses_subject_id_foreign` (`subject_id`),
  ADD KEY `courses_semester_id_foreign` (`semester_id`);

--
-- Indeks untuk tabel `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `enrollments_course_id_student_id_unique` (`course_id`,`student_id`),
  ADD KEY `enrollments_student_id_foreign` (`student_id`);

--
-- Indeks untuk tabel `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exams_course_id_foreign` (`course_id`);

--
-- Indeks untuk tabel `exam_questions`
--
ALTER TABLE `exam_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_questions_exam_id_foreign` (`exam_id`),
  ADD KEY `exam_questions_question_id_foreign` (`question_id`);

--
-- Indeks untuk tabel `exam_questions_answers`
--
ALTER TABLE `exam_questions_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_questions_answers_user_id_foreign` (`user_id`),
  ADD KEY `exam_questions_answers_exam_id_foreign` (`exam_id`),
  ADD KEY `exam_questions_answers_question_id_foreign` (`question_id`),
  ADD KEY `exam_questions_answers_answer_id_foreign` (`answer_id`);

--
-- Indeks untuk tabel `exam_questions_orders`
--
ALTER TABLE `exam_questions_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_questions_orders_exam_id_foreign` (`exam_id`),
  ADD KEY `exam_questions_orders_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `exam_results`
--
ALTER TABLE `exam_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_results_exam_id_foreign` (`exam_id`),
  ADD KEY `exam_results_user_id_foreign` (`user_id`),
  ADD KEY `exam_results_cancelled_by_user_id_foreign` (`cancelled_by_user_id`),
  ADD KEY `exam_results_remark_by_user_id_foreign` (`remark_by_user_id`);

--
-- Indeks untuk tabel `exam_supervisors`
--
ALTER TABLE `exam_supervisors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_supervisors_exam_id_foreign` (`exam_id`),
  ADD KEY `exam_supervisors_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `faculties`
--
ALTER TABLE `faculties`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `faculties_shortcode_unique` (`shortcode`),
  ADD KEY `faculties_leader_id_foreign` (`leader_id`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `otp_codes`
--
ALTER TABLE `otp_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `otp_codes_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Indeks untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indeks untuk tabel `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `questions_created_by_foreign` (`created_by_user_id`),
  ADD KEY `questions_last_updated_by_foreign` (`last_updated_by_user_id`),
  ADD KEY `questions_subject_id_foreign` (`subject_id`),
  ADD KEY `questions_chapter_id_foreign` (`chapter_id`);
ALTER TABLE `questions` ADD FULLTEXT KEY `questions_content_fulltext` (`content`);

--
-- Indeks untuk tabel `question_options`
--
ALTER TABLE `question_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_options_question_id_foreign` (`question_id`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Indeks untuk tabel `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD UNIQUE KEY `role_permissions_role_id_permission_id_unique` (`role_id`,`permission_id`),
  ADD KEY `role_permissions_permission_id_foreign` (`permission_id`);

--
-- Indeks untuk tabel `school_classes`
--
ALTER TABLE `school_classes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `school_classes_shortcode_unique` (`shortcode`),
  ADD KEY `school_classes_faculty_id_foreign` (`faculty_id`);

--
-- Indeks untuk tabel `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_key_unique` (`key`);

--
-- Indeks untuk tabel `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subjects_shortcode_unique` (`shortcode`);
ALTER TABLE `subjects` ADD FULLTEXT KEY `subjects_name_fulltext` (`name`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_shortcode_unique` (`shortcode`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_phone_number_unique` (`phone_number`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_school_class_id_foreign` (`school_class_id`),
  ADD KEY `users_faculty_id_foreign` (`faculty_id`);
ALTER TABLE `users` ADD FULLTEXT KEY `users_first_name_last_name_address_fulltext` (`first_name`,`last_name`,`address`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `chapters`
--
ALTER TABLE `chapters`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=207;

--
-- AUTO_INCREMENT untuk tabel `chapter_materials`
--
ALTER TABLE `chapter_materials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT untuk tabel `exams`
--
ALTER TABLE `exams`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT untuk tabel `exam_questions`
--
ALTER TABLE `exam_questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=270;

--
-- AUTO_INCREMENT untuk tabel `exam_questions_answers`
--
ALTER TABLE `exam_questions_answers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=314;

--
-- AUTO_INCREMENT untuk tabel `exam_questions_orders`
--
ALTER TABLE `exam_questions_orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT untuk tabel `exam_results`
--
ALTER TABLE `exam_results`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `exam_supervisors`
--
ALTER TABLE `exam_supervisors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT untuk tabel `faculties`
--
ALTER TABLE `faculties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT untuk tabel `otp_codes`
--
ALTER TABLE `otp_codes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT untuk tabel `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT untuk tabel `questions`
--
ALTER TABLE `questions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=348;

--
-- AUTO_INCREMENT untuk tabel `question_options`
--
ALTER TABLE `question_options`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1383;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `school_classes`
--
ALTER TABLE `school_classes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT untuk tabel `semesters`
--
ALTER TABLE `semesters`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=648;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `chapters`
--
ALTER TABLE `chapters`
  ADD CONSTRAINT `chapters_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `chapter_materials`
--
ALTER TABLE `chapter_materials`
  ADD CONSTRAINT `chapter_materials_chapter_id_foreign` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_semester_id_foreign` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `courses_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `courses_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `exams_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `exam_questions`
--
ALTER TABLE `exam_questions`
  ADD CONSTRAINT `exam_questions_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_questions_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `exam_questions_answers`
--
ALTER TABLE `exam_questions_answers`
  ADD CONSTRAINT `exam_questions_answers_answer_id_foreign` FOREIGN KEY (`answer_id`) REFERENCES `question_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_questions_answers_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_questions_answers_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `exam_questions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_questions_answers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `exam_questions_orders`
--
ALTER TABLE `exam_questions_orders`
  ADD CONSTRAINT `exam_questions_orders_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_questions_orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `exam_results`
--
ALTER TABLE `exam_results`
  ADD CONSTRAINT `exam_results_cancelled_by_user_id_foreign` FOREIGN KEY (`cancelled_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `exam_results_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_results_remark_by_user_id_foreign` FOREIGN KEY (`remark_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `exam_results_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `exam_supervisors`
--
ALTER TABLE `exam_supervisors`
  ADD CONSTRAINT `exam_supervisors_exam_id_foreign` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_supervisors_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `faculties`
--
ALTER TABLE `faculties`
  ADD CONSTRAINT `faculties_leader_id_foreign` FOREIGN KEY (`leader_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `otp_codes`
--
ALTER TABLE `otp_codes`
  ADD CONSTRAINT `otp_codes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_chapter_id_foreign` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `questions_created_by_foreign` FOREIGN KEY (`created_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `questions_last_updated_by_foreign` FOREIGN KEY (`last_updated_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `questions_subject_id_foreign` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `question_options`
--
ALTER TABLE `question_options`
  ADD CONSTRAINT `question_options_question_id_foreign` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `school_classes`
--
ALTER TABLE `school_classes`
  ADD CONSTRAINT `school_classes_faculty_id_foreign` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_faculty_id_foreign` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `users_school_class_id_foreign` FOREIGN KEY (`school_class_id`) REFERENCES `school_classes` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
