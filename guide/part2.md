# Checkpoint Project: E-Ticketing Helpdesk Lab Komputer (UAS D4 TI Vokasi)

## Project Overview / Tujuan Utama
Pengembangan aplikasi E-Ticketing Helpdesk untuk Lab Komputer (target penyelesaian untuk draf dan laporan UAS). Fokus utama proyek saat ini adalah memastikan alur *role-based* (Mahasiswa, Admin, Staff Ahli) berjalan lancar, *database* berelasi rapi untuk pemenuhan syarat dokumentasi laporan (ERD, Swagger API & tabel SQL), serta optimalisasi UI.

## Pencapaian & Task Selesai
* **Migrasi Database Skala Penuh:** Sukses melakukan migrasi dari Firebase (NoSQL) ke Supabase (PostgreSQL) untuk memenuhi standar relasional.
* **Setup Skema SQL:** Telah mengimplementasikan 4 tabel utama (`profiles`, `tickets`, `comments`, `notifications`) lengkap dengan *Foreign Key* dan mekanisme *Cascade Delete*.
* **Konfigurasi Autentikasi:** Berhasil mengganti sistem ke Supabase Auth. Fitur *Confirm Email* dimatikan sementara, RLS di-*bypass* (`GRANT ALL`), dan berhasil menyuntikkan kolom kustom `nomor_induk` (NIM/NIP) ke proses registrasi.
* **Fix Error Lingkungan Web:** Menyelesaikan kendala "Passkeys Web SDK" pada *emulator browser* (Edge) dengan penambahan *script* Corbado di `index.html`.
* **Integrasi Flutter - Supabase (Core Flow):**
    * `TicketService`: Kodingan `insert` disesuaikan (*Upload* gambar *multipart* via Cloudinary tetap dipertahankan).
    * `TicketListScreen`: Berhasil menerapkan `StreamBuilder` dengan filter data spesifik `user_id`. *Realtime Live Update* dihidupkan via *SQL Publication*.
    * `AdminDashboardScreen`: *View* spesifik Admin berhasil dibuat tanpa filter *user* agar dapat memantau seluruh tiket masuk.
    * `DashboardScreen` (Mahasiswa): Angka statistik (Total Tiket & Tiket Aktif) berhasil dijadikan dinamis dengan menghitung panjang data dari *Stream*.
    * `ProfileScreen`: *Hardcode* berhasil dibersihkan. Layar otomatis menyesuaikan UI dan merender data (nama, email, role, NIM/NIP) menggunakan `FutureBuilder`. Perbaikan struktur parameter `isAdmin` di *routing* navigasi selesai.

## Konteks Teknis & Aturan (Rules)
* **Teknologi Utama:** Flutter (Frontend, Material 3 UI), Supabase (BaaS, PostgreSQL, Auth), Cloudinary (Image Hosting).
* **Aturan Penamaan:** Wajib menggunakan format *snake_case* saat melakukan pemanggilan kolom *database* (`user_id`, `created_at`, `image_url`).
* **Konvensi Fetching Data:**
    * Wajib gunakan `StreamBuilder` (`.stream()`) untuk data *real-time* atau "CCTV" (list tiket, notifikasi).
    * Wajib gunakan `FutureBuilder` (`.select()`) untuk data statis (profil *user*).
* **Autentikasi:** Dilarang menyimpan/membuat kolom *password* di tabel `profiles`. Keamanan kredensial diserahkan 100% pada sistem internal `auth.users` Supabase.

## Status Terakhir (Work In Progress)
Sistem inti operasional khusus *Role* Mahasiswa (Register, Login, Create Ticket, Lihat List Tiket, Dashboard Kalkulasi, Profile dinamis, dan Logout) sudah *running* 100% dan terhubung mulus ke *database* Supabase relasional. 

## Next Steps (To-Do List)
1.  **Routing Pintu Masuk:** Membuat logika persimpangan di tombol Login untuk mengecek *role* di tabel `profiles` (Mengarahkan ke `MainNavigation` untuk mahasiswa, dan `AdminMainNavigation` untuk admin/helpdesk).
2.  **Rombak Notifikasi:** Mengubah UI *hardcode* di `NotificationScreen` menjadi `StreamBuilder` yang membaca tabel `notifications` milik *user* aktif.
3.  **Sistem Komentar & Detail:** Menyelesaikan integrasi UI *timeline* berbalas pesan di `TicketDetailScreen` (berelasi dengan tabel `comments`).
4.  **Fitur Staff Ahli:** Menyelesaikan alur pendelegasian tiket dari Admin (Helpdesk) ke akun Staff Ahli.
5.  **Kosmetik Aplikasi:** Mengubah logo *blueprint* bawaan Flutter menggunakan *package* `flutter_launcher_icons` sesuai *request* visual Dosen.
6.  **Eksekusi Laporan:** Menarik *Screenshot* UI tabel Supabase dan *auto-generated* API Docs untuk dimasukkan ke draf laporan UAS.