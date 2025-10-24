# INDIVIDUAL PROJECT 3E

### PEMROGRAMAN MOBILE (IF-44-03)

| Nama | NIM |
| :--- | :--- |
| Siti Alifia Azzahra M. | 2341760019 |

---

Aplikasi katalog makanan **CityFood** yang memungkinkan pengguna menelusuri produk, membuat pesanan dengan alur keranjang belanja, dan secara otomatis melacak semua pesanan sebagai pengeluaran di fitur "Jurnal Jajan" yang dinamis.

## Screenshots

| Halaman | Tampilan |
| :--- | :--- |
| Register | <img src="[assets/register.png]" width="300"> |
| Login | <img src="[assets/login.png]" width="300"> |
| Home (Katalog) | <img src="[assets/homekatalog.png]" width="300"> |
| Home (Keranjang Aktif) | <img src="[assets/homekatalogaktif.png]" width="300"> |
| Ringkasan Pesanan (Checkout) | <img src="[assets/checkout.png]" width="300"> |
| Jurnal Jajan (Daftar) | <img src="[assets/jurnaljajan.png]" width="300"> |
| Halaman Statistik | <img src="[assets/statistik.png]" width="300"> |
| Kelola Kategori | <img src="[assets/kelolakategori.png]" width="300"> |
| Profil | <img src="[assets/profile.png]" width="300"> |
| Settings | <img src="[assets/setting.png]" width="300"> |

## Fitur

- **Autentikasi Pengguna**: Register dan Login pengguna baru.
- **Katalog Produk**: Menampilkan daftar produk makanan & minuman dari `ExpenseService`.
- **Keranjang Belanja (Cart)**:
  - Memilih beberapa item dari katalog.
  - Menampilkan total harga secara dinamis.
  - Tombol "Next" untuk melanjutkan ke checkout.
- **Ringkasan Pesanan (Checkout)**:
  - Menampilkan rincian item yang dibeli dan total harga.
  - Memungkinkan penambahan deskripsi dan pemilihan kategori.
  - Tombol "Bayar" untuk mengonfirmasi pesanan.
- **Jurnal Jajan (Expense Tracker)**:
  - Pesanan yang "Dibayar" otomatis tersimpan sebagai entri pengeluaran baru.
  - Fungsionalitas CRUD (Create, Read, Update, Delete) penuh untuk setiap entri jajan.
  - **Penyimpanan Permanen**: Data jajan dan kategori disimpan di memori HP menggunakan `shared_preferences` (data tidak hilang saat aplikasi ditutup).
- **Manajemen Kategori**:
  - Halaman khusus untuk menambah atau menghapus kategori pengeluaran.
  - Menghapus kategori juga akan menghapus semua data jajan yang terkait.
- **Statistik Pengeluaran**:
  - Halaman statistik dengan **Pie Chart** (`fl_chart`) yang menampilkan persentase pengeluaran berdasarkan kategori.
  - Menampilkan total pengeluaran dan rincian per kategori.
- **Ekspor Data**:
  - Fitur untuk mengekspor semua data "Jurnal Jajan" ke dalam file `.csv`.
  - Membutuhkan izin akses penyimpanan (`permission_handler`).
- **Profil & Pengaturan**: Halaman untuk menampilkan info pengguna dan aplikasi.

## Teknologi

- Flutter
- Dart
- `intl` (Format Mata Uang & Tanggal)
- `shared_preferences` (Penyimpanan Lokal)
- `fl_chart` (Grafik Statistik)
- `uuid` (ID Unik)
- `csv` (Ekspor Data)
- `path_provider` & `permission_handler` (Manajemen File & Izin)

