# 📌 Checkpoint Development: E-Ticketing IT Helpdesk

Dokumen ini berisi rangkuman arsitektur, alur kerja (business logic), dan fitur yang telah diselesaikan untuk aplikasi Helpdesk. Gunakan dokumen ini sebagai panduan atau pengingat (*guideline*) untuk pengembangan fitur selanjutnya.

## 🛠️ Tech Stack & Architecture
- **Framework:** Flutter
- **Backend / Database:** Supabase (PostgreSQL)
- **Storage:** Cloudinary (untuk *upload* gambar/bukti tiket)
- **State Management & Routing:** Stateful/Stateless Widgets dengan Standard `Navigator.push`.
- **Real-time Engine:** Supabase Streams (`.stream()`) untuk *monitoring* tiket dan komentar secara langsung.

---

## 👥 Matriks Role & Alur Status (Business Logic)
Sistem ini menggunakan 3 *Role* utama dengan batasan hak akses (Authorization) yang ketat:

### 1. Mahasiswa (Pelapor)
- **Hak Akses:** Hanya dapat melihat, membuat, dan membalas tiket miliknya sendiri.
- **Alur Notifikasi:** Menerima notifikasi jika tiketnya di-*assign* ke teknisi, jika ada balasan baru, dan jika tiketnya ditutup (Selesai).

### 2. Admin (Resepsionis / Pengawas)
- **Hak Akses:** Melihat seluruh tiket masuk. Memiliki layar khusus **Kelola Pengguna** untuk mengubah *role* pengguna lain.
- **Tugas Utama:** Membaca keluhan dan mendelegasikan (*assign*) tiket ke Staff Ahli.
- **Alur Status:** Saat Admin memilih teknisi dari *dropdown*, status tiket **otomatis** berubah menjadi `in_progress`.
- **Alur Notifikasi:** Menerima notifikasi saat ada tiket baru masuk, dan jika ada tiket yang dibalas atau ditutup oleh Staff Ahli.

### 3. Staff Ahli (Teknisi)
- **Hak Akses:** Memiliki *Dashboard* Statistik khusus. Hanya dapat melihat tiket yang di-*assign* kepadanya (atau yang ia buat sendiri).
- **Tugas Utama:** Mengerjakan tiket, memberikan *update* di kolom komentar, dan menekan tombol **"Selesaikan Pekerjaan (Close)"**.
- **Alur Status:** Staff tidak memiliki *dropdown* status. Tombol *Close* akan **otomatis** mengubah status menjadi `closed`.
- **Alur Notifikasi:** Menerima notifikasi saat Admin memberikan tugas baru atau jika ada balasan di tiket yang sedang ia tangani.

---

## 🗄️ Struktur Database & Catatan Penting
Skema *database* menggunakan relasi yang saling mengunci (*Foreign Key*). Pastikan berpatokan pada struktur berikut:

1. **Table `profiles`**
   - Kolom Primary: `id` (UUID dari Supabase Auth).
   - *Catatan:* Selalu gunakan `name` (bukan `nama`) untuk menyeragamkan pemanggilan variabel di Flutter.

2. **Table `tickets`**
   - Kolom Primary: `id` (UUID - *Default Value* di-set ke `gen_random_uuid()`).
   - Kolom Relasi: `user_id` (pembuat tiket), `assigned_to` (teknisi).
   - Kolom Ekstra: `nama_pelapor` disisipkan agar UI Admin tidak perlu melakukan *JOIN* (*heavy query*).

3. **Table `comments`**
   - Menyimpan riwayat komunikasi / balasan per `ticket_id`.

4. **Table `notifications`**
   - *Design Pattern:* Menggunakan metode **Tukang Pos Anti-Mogok** (`_notifyUserSafely`). 
   - *Fungsi:* Menggunakan blok `try-catch` terpisah. Jika sistem mencoba mengirim notifikasi ke `user_id` yang sudah terhapus/tidak valid, sistem hanya akan mengabaikan notifikasi tersebut tanpa membuat aplikasi *crash* atau membatalkan proses utama (seperti *update* status tiket).

---

## ✅ Fitur yang Sudah Selesai (Done)
- [x] Autentikasi (Login/Register) dengan *routing* otomatis berdasarkan *role*.
- [x] UI & Fungsionalitas Profil (termasuk tombol rahasia "Kelola Pengguna" untuk Admin).
- [x] Layar Admin: Dashboard, List Antrean, Detail Tiket (Delegasi otomatis).
- [x] Layar Staff: Dashboard Statistik Personal, List Tugas, Detail Tiket (Auto-close & Komentar).
- [x] Integrasi Cloudinary untuk *upload* gambar.
- [x] Sistem *Broadcast* Notifikasi (Trigger aman lintas role).

## 🚀 Next Steps (Rencana Kedepan)
- membuat launcher icon (assets/media) 
- build apk di andro studio