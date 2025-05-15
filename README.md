# Mikhmon-Docker

![Mikhmon Logo](https://raw.githubusercontent.com/laksa19/laksa19.github.io/master/img/mikhmonv3.png)

Mikhmon-Docker adalah implementasi Docker untuk Mikhmon (MikroTik Hotspot Monitor), sebuah aplikasi berbasis PHP untuk monitoring dan manajemen hotspot MikroTik.

## Tentang Project

Mikhmon-Docker mengemas aplikasi [Mikhmon](https://laksa19.github.io/?mikhmon/v3) dalam container Docker, memudahkan instalasi dan penggunaan Mikhmon tanpa perlu mengonfigurasi lingkungan server web secara manual. Project ini memungkinkan Anda untuk:

- Menjalankan Mikhmon di lingkungan terisolasi
- Memudahkan deployment di berbagai platform
- Mempertahankan data konfigurasi dengan volume Docker
- Mengakses Mikhmon dari browser web di port yang telah dikonfigurasi

## Fitur

- **Manajemen Hotspot**: Monitor dan kelola pengguna hotspot MikroTik
- **Manajemen Voucher**: Buat dan cetak voucher hotspot
- **Dashboard Informatif**: Lihat statistik dan informasi pengguna
- **Manajemen Pengguna**: Tambah, edit, dan hapus akun pengguna
- **Laporan**: Akses laporan penggunaan dan pendapatan
- **Multi-Router**: Kelola beberapa router MikroTik dalam satu aplikasi
- **Konfigurasi Persisten**: Data tersimpan dalam volume Docker

## Persyaratan

- Docker dan Docker Compose terinstal
- Koneksi jaringan ke router MikroTik
- Router MikroTik dengan API yang diaktifkan

## Penggunaan

### Metode Quick Start

1. Clone repository ini:
   ```bash
   git clone https://github.com/rizkikotet-dev/mikhmon-docker.git
   cd mikhmon-docker
   ```

2. Jalankan dengan Docker Compose:
   ```bash
   docker-compose up -d
   ```

3. Akses Mikhmon melalui browser:
   ```
   http://localhost:80
   ```

### Konfigurasi Docker Compose

File `docker-compose.yml` yang tersedia:
```yaml
services:
  mikhmon:
    container_name: Mikhmon
    pull_policy: always
    image: rizkikotet/mikhmon:latest
    restart: unless-stopped
    ports:
      - "80:80"
      #- "443:443"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Jakarta
```

### Konfigurasi Awal Mikhmon

1. Setelah mengakses Mikhmon melalui browser, Anda akan melihat halaman login.
2. Gunakan kredensial default:
   - Username: `mikhmon`
   - Password: `1234`
3. Ubah password default segera setelah login pertama.
4. Tambahkan router MikroTik dengan mengklik "Add Router":
   - Masukkan nama untuk router
   - Masukkan alamat IP router
   - Masukkan username dan password API
   - Klik "Save"

## Pembaruan

Untuk memperbarui ke versi terbaru:

```bash
docker-compose down
git pull
docker-compose up -d --build
```

## Troubleshooting

- **Tidak dapat terhubung ke Mikhmon**: Pastikan port 80 tidak digunakan oleh aplikasi lain
- **Tidak dapat terhubung ke router**: Verifikasi bahwa API MikroTik diaktifkan dan kredensial benar
- **Data hilang setelah restart**: Pastikan volume `mikhmon_data` dikonfigurasi dengan benar

## Referensi dan Sumber

Mikhmon dikembangkan oleh laksa19: [https://laksa19.github.io/?mikhmon/v3](https://laksa19.github.io/?mikhmon/v3)

Project ini adalah implementasi Docker tidak resmi untuk memudahkan deployment Mikhmon.

## Kontribusi

Kontribusi sangat diterima! Silakan fork repository ini dan kirimkan pull request.

## Lisensi

Project ini dilisensikan di bawah [MIT License](LICENSE) dengan penghormatan ke proyek asli Mikhmon.

---

&copy; 2025 Mikhmon-Docker | Mikhmon &copy; [laksa19](https://github.com/laksa19)