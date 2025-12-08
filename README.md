<div align="center">

# 🔐 ENIGMORPH

```text
  _____                                          _       
 | ____|_ __ (_) __ _ _ __ ___   ___  _ __ _ __ | |__    
 |  __|| '_ \  |/ _` | '_ ` _ \ / _ \| '__| '_ \| '_ \   
 | |___| | | | | (_| | | | | | | (_) | |  | |_) | | | |  
 |_____|_| |_|_|\__, |_| |_| |_|\___/|_|  | .__/|_| |_|  
                |___/                     |_|            
```

![C++](https://img.shields.io/badge/C++-Full-blue.svg?style=for-the-badge&logo=c%2B%2B)
![Status](https://img.shields.io/badge/Status-Stable-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

**Next-Gen CLI Encryption Tool Inspired by The Enigma Machine**

[Tentang](#-tentang-proyek) • [Fitur Utama](#-fitur-utama) • [Cara Menggunakan](#-cara-menggunakan) • [Logika Enkripsi](#-logika-di-balik-layar)

</div>

---

## 📖 Tentang Proyek

**Enigmorph** adalah proyek *Final Project* untuk mata kuliah Algoritma dan Pemrograman. Alat ini adalah simulator enkripsi pesan berbasis terminal (CLI) yang terinspirasi dari mesin legendaris Perang Dunia II, **Enigma**.

Berbeda dengan Caesar Cipher biasa, Enigmorph menggunakan konsep **Dynamic Positional Shifting**. Artinya, huruf 'A' di awal kalimat akan dienkripsi menjadi karakter yang berbeda dengan huruf 'A' di akhir kalimat, bergantung pada kombinasi **PIN (Rotor)** dan **Password (Plugboard)** yang dimasukkan pengguna.

## ✨ Fitur Utama

* 🛡️ **Double Layer Security:** Menggunakan kombinasi 4 digit PIN dan Password String.
* 🌊 **Dynamic Morphing:** Pola enkripsi berubah setiap karakter berdasarkan posisinya (Anti-Frequency Analysis).
* ⌨️ **Robust Input System:** Input PIN cerdas yang bisa membaca format `1945`, `1 9 4 5`, atau `1-9-4-5` tanpa *crash*.
* 🔣 **Full ASCII Support:** Mendukung enkripsi huruf, angka, spasi, dan tanda baca.
* 💻 **Cross-Platform:** Berjalan lancar di Windows, Linux, dan macOS.

## 🚀 Cara Menggunakan

### 1. Compile Kode
Pastikan Anda memiliki compiler C++ (seperti G++) terinstal.

```bash
g++ enigmorph.cpp -o enigmorph
```

### 2. Jalankan Program
```bash
./enigmorph  # Untuk Linux/Mac
enigmorph.exe # Untuk Windows
```

### 3. Alur Penggunaan
1.  Masukkan **PIN** (Contoh: `1945`).
2.  Masukkan **Password** (Contoh: `Rahasia`).
3.  Pilih menu **1. Enkripsi** untuk mengacak pesan.
4.  Bagikan *Ciphertext* (teks acak) ke teman Anda.
5.  Teman Anda harus menggunakan PIN dan Password yang **sama persis** di menu **2. Dekripsi** untuk membaca pesan.

## 🧠 Logika di Balik Layar

Enigmorph menggunakan rumus matematis untuk menentukan pergeseran (*shift*) setiap karakter ASCII (32-126):

```cpp
Shift = (Nilai_Password + Angka_PIN + Posisi_Huruf) % 95
```

* **Nilai_Password**: ASCII dari karakter password yang berulang.
* **Angka_PIN**: Salah satu dari 4 digit PIN yang berputar (Rotor).
* **Posisi_Huruf**: Indeks huruf dalam kalimat. Ini adalah kunci agar pola tidak berulang.

---

<div align="center">

Dibuat dengan ❤️ menggunakan C++
<br>
*Jangan lupa berikan bintang (⭐) jika proyek ini bermanfaat!*

</div>