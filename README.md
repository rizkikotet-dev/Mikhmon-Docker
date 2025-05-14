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
    build: .
    #image: rizkikotet/mikhmon:latest
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    command: 
      - /bin/bash
      - -c
      - /etc/supervisor/conf.d/supervisord.conf
    volumes:
      - mikhmon_data:/var/www/html
```

### Konfigurasi CasaOS Compose

File `docker-casaos-compose.yml` yang tersedia:
```yaml
name: mikhmon
services:
  mikhmon:
    cpu_shares: 90
    command:
      - /usr/bin/supervisord
      - -c
      - /etc/supervisor/conf.d/supervisord.conf
    container_name: mikhmon
    deploy:
      resources:
        limits:
          memory: 6000M
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    hostname: mikhmon
    image: rizkikotet/mikhmon:latest
    labels:
      icon: https://raw.githubusercontent.com/laksa19/mikhmonv3/refs/heads/master/img/favicon.png
    ports:
      - target: 80
        published: "1111"
        protocol: tcp
    restart: unless-stopped
    volumes:
      - type: bind
        source: /DATA/AppData/mikhmon
        target: /var/www/html
    x-casaos:
      envs:
        - container: PATH
          description:
            en_us: ""
      image: ""
      ports:
        - container: "80"
          description:
            en_us: ""
      volumes:
        - container: /var/www/html
          description:
            en_us: ""
    devices: []
    cap_add: []
    network_mode: rizkikotet_mikhmon_default
    privileged: false
x-casaos:
  architectures:
    - amd64
  author: CasaOS User
  category: unknown
  description:
    en_us: ""
  developer: unknown
  hostname: ""
  icon: https://raw.githubusercontent.com/laksa19/mikhmonv3/refs/heads/master/img/favicon.png
  image: null
  index: /
  is_uncontrolled: false
  main: mikhmon
  port_map: "1111"
  scheme: http
  store_app_id: mikhmon
  tagline:
    en_us: This is a compose app converted from a legacy app (CasaOS v0.4.3 or
      earlier)
  thumbnail: ""
  tips:
    custom: This is a compose app converted from a legacy app (CasaOS v0.4.3 or
      earlier)
  title:
    custom: Mikhmon
    en_us: Mikhmon
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

## Backup dan Restore

### Backup Data
Data Mikhmon disimpan dalam volume Docker `mikhmon_data`. Untuk backup:

```bash
docker run --rm -v mikhmon_data:/source -v $(pwd):/backup alpine tar -czf /backup/mikhmon_backup.tar.gz -C /source .
```

### Restore Data
Untuk restore data dari backup:

```bash
docker run --rm -v mikhmon_data:/target -v $(pwd):/backup alpine sh -c "rm -rf /target/* && tar -xzf /backup/mikhmon_backup.tar.gz -C /target"
```

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