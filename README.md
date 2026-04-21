# 🚀 Portfolio - Taufiq Ikhsan Muzaky

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Vibe](https://img.shields.io/badge/Vibe-Cyberpunk-red?style=for-the-badge)](https://github.com/mzkyzak)

Sebuah aplikasi atau semua os, karena portofolio ini interaktif yang dibangun murni menggunakan **Flutter**. Proyek ini tidak hanya  desain visual (UI) bernuansa *Sci-Fi* dan *Glassmorphism*, tetapi juga fungsionalitas tingkat lanjut (UX) termasuk pengiriman pesan *real-time* ke email.

---

## 📱 Preview Aplikasi 

<p align="center">
  <img width="32%" alt="contoh_1" src="https://github.com/user-attachments/assets/64bbd700-6f92-469f-880c-3accbe402920" />
  <img width="32%" alt="contoh_2" src="https://github.com/user-attachments/assets/01bd7604-5ad6-4976-863a-9bf286bdea7c" />
  <img width="32%" alt="contoh_3" src="https://github.com/user-attachments/assets/bdc145e6-a4c1-4d81-8e59-3273d26a0255" />
</p>

---
## ✨ Fitur Lengkap (by Section)

### 🛸 1. Preloader Screen (System Booting)
Sebelum masuk ke aplikasi, pengunjung disambut dengan animasi *Booting System* ala Jarvis. Menggunakan **Hexagon CustomPainter** dan animasi persentase 0-100% yang disinkronisasi dengan delay waktu, menciptakan transisi *zoom & fade* yang mewah ke halaman utama.

### 🏠 2. Home Section
- **Floating Animated Background:** Latar belakang memiliki efek bola cahaya raksasa (merah, biru, ungu) yang terus bergerak secara matematis menggunakan fungsi *Sin* dan *Cos*.
- **Dynamic Typing Text:** Judul dilengkapi animasi efek mengetik (Typewriter) menggunakan `AnimatedTextKit` yang otomatis berulang pada kata kunci *"Kreatif, Inovatif, Usaha"*.
- **CapCut Reveal:** Setiap elemen di-scroll akan muncul dari bawah dengan efek pantulan (ElasticOut), diadaptasi dari gaya transisi video modern.

### 👨‍💻 3. About & Profile Section
- **Responsive Layout:** Tampilan cerdas yang otomatis menyesuaikan diri; membelah menjadi dua kolom di Desktop/Web, dan memanjang ke bawah di layar Mobile.
- **Glassmorphism Identity Card:** Penjelasan "About Me" dibungkus dalam material kaca transparan (`BackdropFilter` dengan blur 10px).
- **Direct CV Download:** Integrasi `url_launcher` untuk mengarahkan pengunjung langsung ke file PDF Curriculum Vitae di Google Drive hanya dengan satu klik.

### 💼 4. Portfolio & Showcase Section
Sistem *Tab Navigation* dengan animasi transisi warna yang interaktif. Terdiri dari:
- **Projects:** Menampilkan daftar karya. Jika diklik, akan memunculkan *Pop-up Dialog* interaktif (berisi *Project Overview*, gambar detail, dan tombol *direct link* ke GitHub/Website proyek tersebut).
- **Certificates:** Galeri grid sertifikat yang telah terverifikasi. dan bisa untuk melihat detail sertifikat dengan jelas.
- **Tech, Design & OS Stack:** Menampilkan deretan ikon teknologi (HTML, CSS, Flutter, MySQL, React, dll) menggunakan *DevIcons SVG* dan gambar lokal.

### 📞 5. Contact & Active Form Submit (Real Backend Integration)
Bukan sekadar pajangan! Form kontak ini benar-benar berfungsi layaknya website profesional:
- **Form Validasi:** Memastikan kolom Nama, Email, dan Pesan tidak boleh kosong sebelum menekan tombol kirim.
- **Real-Time HTTP Request:** Menggunakan package `http` terintegrasi dengan API **FormSubmit.co**. Pesan yang diketik pengunjung di aplikasi akan **langsung terkirim ke email pribadi saya (Gmail)** secara *real-time*.
- **Loading State:** Tombol berubah menjadi "MENGIRIM PESAN..." dengan *CircularProgressIndicator* saat memproses data, mencegah *spam click*.
- **Smart Notification:** Menampilkan *SnackBar* hijau jika pesan sukses terkirim, dan *SnackBar* merah jika gagal atau tidak ada koneksi.

---

## 🛠️ Library & Dependencies

- `google_fonts`: Tipografi modern (Outfit & Plus Jakarta Sans).
- `animated_text_kit`: Efek teks mesin tik dan transisi teks.
- `flutter_svg` & `font_awesome_flutter`: Rendering ikon vektor tajam.
- `url_launcher`: Membuka link eksternal (Sosmed, GitHub, Google Drive).
- `http`: Menangani *Asynchronous POST Request* untuk fitur Form Email.

---

## 🚀 Cara Menjalankan Project

1. **Clone Repository**
   ```cmd
   git clone https://github.com/mzkyzak/App_Portfolio_Flutter.git
   cd App_Portfolio_Flutter
   
2. Konfigurasi Contact Form (Penting!)
Agar fitur pesan di bagian Contact berfungsi dan masuk ke email Anda sendiri, buka file lib/main.dart dan cari baris kode berikut:
 ```cmd
  // Ganti email di bawah ini dengan email aktif Anda
Uri.parse('[https://formsubmit.co/ajax/taufiqikhsanmuzaky18@gmail.com]
 ```
4. lalu Install Dependencies :

   ```cmd
   flutter pub get
   ```
5. Baru di jalankan  :

   ```cmd
   flutter run
   ```
6. build aplikasi?  :

   ```cmd
   flutter build apk
   ```
   
