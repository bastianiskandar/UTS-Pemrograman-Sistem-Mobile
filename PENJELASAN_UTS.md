# Catatan Penjelasan UTS — Aplikasi Menu Kantin

Mata kuliah: Pemrograman Mobile • Dosen: Royan Habibie Sukarna

Dokumen ini berisi: (1) peta kode terhadap diagram soal, (2) penjelasan bagian-bagian
penting kode, dan (3) kumpulan pertanyaan dosen beserta jawaban yang bisa kamu
paraphrase sendiri.

---

## 1. Gambaran besar & alur data

```
┌────────────────────┐   Get.to()    ┌────────────────────┐
│ DaftarMenuPage     │ ────────────► │ TambahMenuPage     │
│ (StatefulWidget)   │               │ (StatefulWidget)   │
│                    │ ◄──────────── │                    │
│ List menuList      │  Get.back()   │ Form + Validator   │
│ (5 data awal)      │  (result Map) │ TextEditingController│
└────────────────────┘               └────────────────────┘
        │ Get.to()
        ▼
┌────────────────────┐
│ DetailMenuPage     │  ← struktur BEBAS menurut soal
│ (StatelessWidget)  │    kembali via Get.back()
└────────────────────┘
```

**Alur simpan menu (inti Soal 3):**

1. FAB di halaman daftar → `final result = await Get.to(() => TambahMenuPage());`
2. Di halaman tambah, tombol Simpan → `formKey.currentState!.validate()`
3. Jika valid → `Get.back(result: {'nama': ..., 'harga': ...})`
4. Kembali ke daftar → `result != null` → `setState(() => menuList.add(result))`
5. `setState` menandai widget dirty → `build()` jalan ulang → `ListView.builder`
   membaca ulang `menuList.length` → item baru muncul.

---

## 2. Peta diagram → kode

### Gambar 1: Halaman Daftar Menu (`lib/pages/daftar_menu_page.dart`)

| Node pada diagram | Kode |
|---|---|
| Scaffold | `return Scaffold(` |
| Scaffold → AppBar | `appBar: AppBar(` |
| AppBar → Text | `title: const CustomText(...)` (custom widget!) |
| Scaffold → Column | `body: Column(children: [` |
| Column → Padding → Text | `Padding(child: const CustomText('Daftar Menu Tersedia'))` |
| Column → Expanded | `Expanded(child: ListView.builder(...))` |
| Expanded → ListView.builder | `ListView.builder(itemCount: menuList.length, ...)` |
| ListView.builder → Card | `return Card(child: ListTile(...))` |
| Card → ListTile (leading) | `leading: const Icon(Icons.restaurant)` |
| ListTile (title) | `title: CustomText(menu['nama']!)` (custom widget!) |
| ListTile (subtitle) | `subtitle: CustomText(menu['harga']!)` (custom widget!) |
| ListTile (trailing) | `trailing: const Icon(Icons.arrow_forward_ios)` |
| Scaffold → FloatingActionButton → Icon | `floatingActionButton: FloatingActionButton(child: const Icon(Icons.add))` |

Urutan anak pada diagram (kiri → kanan) = urutan di kode (atas → bawah):
`AppBar`, `Column`, `FloatingActionButton` — sudah sesuai.

### Gambar 2: Halaman Tambah Menu (`lib/pages/tambah_menu_page.dart`)

| Node pada diagram | Kode |
|---|---|
| Scaffold → AppBar → Text | `title: const CustomText('Tambah Menu')` |
| Scaffold → Padding → Form | `body: Padding(child: Form(key: formKey, ...))` |
| Form → Column | `child: Column(children: [` |
| Column → TextFormField (nama) | validator: `'Nama menu tidak boleh kosong'` |
| Column → SizedBox | `const SizedBox(height: 16)` |
| Column → TextFormField (harga) | validator kosong + validator angka |
| Column → SizedBox | `const SizedBox(height: 24)` |
| Column → ElevatedButton → Text | `ElevatedButton(child: const CustomText('Simpan'))` |

Urutan anak Column di kode: `TextFormField, SizedBox, TextFormField, SizedBox,
ElevatedButton` — persis kiri-kanan pada diagram.

### Pemetaan syarat ke kode

| Syarat soal | Realisasi |
|---|---|
| Custom widget teks, min. 2 parameter gaya | `CustomText` — `fontSize`, `fontWeight`, (+ `color`) di `lib/widgets/custom_text.dart` |
| Semua node Text = custom widget | 5 dari 5 node Text memakai `CustomText` (kecuali string param `labelText` & pesan validator — memang dikecualikan) |
| Komentar alasan desain 2–3 baris | 3 baris komentar tepat di atas `class CustomText` |
| Daftar = StatefulWidget, List di State, min. 5 data | `_DaftarMenuPageState` + `menuList` berisi 5 menu |
| ListView.builder, nama=title, harga=subtitle | sesuai tabel di atas |
| Tekan item → detail (Get.to) | `Get.to(() => DetailMenuPage(menu: menu))` |
| FAB → tambah (Get.to), nerima result + setState | blok `onPressed` FAB |
| Harga wajib angka + divalidasi | `inputFormatters: [FilteringTextInputFormatter.digitsOnly]` **dan** validator regex `^[0-9]+$` |
| Data valid dikirim dengan `Get.back(result: ...)` | tombol Simpan |
| `Get` hanya untuk navigasi | hanya `GetMaterialApp`, `Get.to()`, `Get.back()` |
| Data awal minimal 5 menu karangan | Nasi Goreng, Mie Ayam, Bakso, Soto Ayam, Es Teh Manis |

---

## 3. Bagian penting kode & alasannya

### 3.1 CustomText (`lib/widgets/custom_text.dart`)

```dart
class CustomText extends StatelessWidget {   // ← stateless karena tidak ada data berubah
  final String text;                         // ← teks yang ditampilkan
  final double fontSize;                     // ← parameter gaya 1
  final FontWeight fontWeight;               // ← parameter gaya 2
  final Color? color;                        // ← parameter gaya opsional

  const CustomText({required this.text, this.fontSize = 14, ...});
  // ↑ const constructor: aman di-const, hemat alokasi, wajib semua field final

  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.poppins(fontSize: ..., fontWeight: ..., color: ...),
  );
}
```

**Kenapa stateless?** Widget ini cuma menerima data lewat konstruktor lalu
menggambar — tidak ada state yang berubah di dalamnya. Stateless lebih murah dan
sederhana dari StatefulWidget.

**Kenapa dibuat custom?** (DRY) Satu sumber gaya teks; kalau besok mau ganti
Poppins → Inter, cukup ubah 1 file. Juga persyaratan soal.

### 3.2 Kenapa `Expanded` membungkus `ListView.builder`

`Column` memberi child tinggi **tak terbatas** (unbounded), sedangkan
`ListView` butuh tinggi **terbatas** untuk menghitung item mana yang terlihat.
Tanpa `Expanded`, Flutter melempar error `RenderFlex overflowed` / `vertical
constraints are unbounded`. `Expanded` mengambil sisa ruang Column → ListView
dapat tinggi pas.

### 3.3 Kenapa `ListView.builder` (bukan `ListView(children: [...])`)

`builder` bersifat **lazy**: widget hanya dibuat saat akan terlihat di layar.
Kalau menu berjumlah 1000, yang di-build cuma ~10 yang tampil → hemat memori &
performa. `ListView(children:)` membangun semuanya sekaligus.

### 3.4 Navigasi GetX + pengiriman data

```dart
// PEMANGGIL (halaman daftar)
final result = await Get.to(() => const TambahMenuPage());
if (result != null) {
  setState(() => menuList.add(result));   // ← state di-update, UI rebuild
}

// PENGIRIM (halaman tambah)
Get.back(result: {'nama': ..., 'harga': ...});
```

- `Get.to()` = menumpuk halaman baru di atas stack (mirip `Navigator.push`),
  dan **mengembalikan `Future`** yang selesai ketika halaman itu ditutup.
- `await` **wajib** supaya baris setelahnya baru jalan ketika halaman tambah
  ditutup — di situ `result` berisi data yang dikirim.
- `Get.back(result: ...)` = menutup halaman atas **sambil membawa nilai**;
  nilai itu diteruskan ke `Future` yang tadi di-await.
- Kalau user menekan tombol back tanpa simpan → `result == null` → `if`
  tidak dieksekusi → daftar tidak berubah (aman).

### 3.5 Kenapa halaman daftar Stateful, halaman detail Stateless

- **Daftar**: punya `menuList` yang *berubah* + `setState` → harus StatefulWidget.
- **Detail**: datanya datang dari luar (`menu`) dan tidak pernah berubah selama
  halaman terbuka → cukup Stateless.
- **Tambah**: awalnya bisa stateless, tapi karena ada `TextEditingController`
  yang harus di-`dispose()`, dijadikan StatefulWidget supaya rapi
  (tidak ada controller yang bocor / menyimpan nilai lama).

### 3.6 Dua lapis pengaman pada kolom harga

```dart
inputFormatters: [FilteringTextInputFormatter.digitsOnly],  // lapis 1: cegah ketikan huruf
validator: (value) {
  if (value.trim().isEmpty) return 'Harga tidak boleh kosong';
  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) return 'Harga hanya boleh angka';
  return null;   // null = lolos validasi
},
keyboardType: TextInputType.number,   // keyboard angka di HP
```

- **Lapis 1 (inputFormatters)**: memblokir huruf sejak awal ketikan/tempel.
- **Lapis 2 (validator)**: jaring pengaman terakhir — dipanggil
  `formKey.currentState!.validate()`. Jika ada satu saja validator mengembalikan
  String (bukan null), `validate()` bernilai `false` dan pesan error tampil di
  bawah kolom.
- Kenapa dua-duanya? Pertahanan berlapis; soal secara eksplisit mensyaratkan
  *"hanya menerima angka **dan** harus divalidasi"*.

### 3.7 Format rupiah biar konsisten

```dart
String _formatRupiah(int angka) {
  final ribuan = angka.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  return 'Rp $ribuan';
}
// 15000 → "Rp 15.000" (sama persis dengan gaya data awal)
```

Cara baca regex: `\B(?=(\d{3})+(?!\d))` = "sisipkan titik di posisi yang tepat
setiap 3 digit dari belakang" — yaitu posisi yang **bukan** batas kata dan tidak
diikuti lagi 3-digit-group. `15000` → titik disisipkan setelah `15` → `15.000`.

### 3.8 Tema (`lib/main.dart`) — bagian B (bebas)

```dart
final warna = ColorScheme.fromSeed(seedColor: Colors.blue);
```

- `ColorScheme.fromSeed` (Material 3) membuat **satu palet utuh** (primary,
  onPrimary, primaryContainer, dll.) dari SATU warna dasar, dengan jaminan
  kontras yang benar.
- Semua `backgroundColor` AppBar, FAB, tombol, fokus input **tidak ditulis
  manual di tiap halaman** — cukup didefinisikan sekali di `ThemeData`.
  Keuntungannya: konsisten + kalau ganti warna tema, ubah 1 baris saja.
- Kenapa `Colors.white` pada judul AppBar tetap ditulis manual? Judul memakai
  `CustomText` yang menimpa style — eksplisit putih supaya dijamin kontras.

---

## 4. Pertanyaan yang kemungkinan ditanya dosen + jawaban

### A. Struktur widget & diagram

**Q: Jelaskan struktur widget halaman daftar sesuai diagram.**
Jawab: `Scaffold` punya tiga anak sesuai urutan diagram: `AppBar` berisi
`CustomText` judul; `body` berupa `Column` yang berisi `Padding` → `CustomText`
judul daftar, lalu `Expanded` → `ListView.builder` → `Card` → `ListTile` dengan
empat parameter `leading` (Icon), `title` (nama menu), `subtitle` (harga),
`trailing` (Icon); dan `floatingActionButton` berisi `Icon`. Urutan anak di kode
saya tulis atas-ke-bawah sesuai urutan kiri-ke-kanan diagram.

**Q: Kenapa urutan anak di Column penting?**
Jawab: karena diagram menetapkannya — urutan kiri-kanan diagram = urutan
atas-bawah dalam `children`. Selain itu urutan menentukan tampilan visual
(teks judul dulu, baru daftar).

**Q: Kenapa pakai Card membungkus ListTile?**
Jawab: `ListTile` menyediakan layout baris baku (leading/title/subtitle/trailing)
yang rapi dan sudah punya ripple saat ditekan; `Card` memberi permukaan
membulat dengan elevasi tipis. Keduanya memang pasangan umum di Material Design
dan persis seperti diagram.

**Q: Apa fungsi Expanded? Kalau dihapus apa yang terjadi?**
Jawab: memberi ListView tinggi tersisa dari Column. Kalau dihapus, ListView
kehilangan batas tinggi → error layout "vertical constraints are unbounded".

**Q: ListView biasa dengan builder, apa bedanya? Mana yang dipakai dan kenapa?**
Jawab: `ListView.builder` lazy — hanya membangun item yang terlihat; lebih
hemat untuk data banyak. Soal mensyaratkan `ListView.builder`, dan itu yang
saya pakai.

**Q: Kenapa Scaffold anaknya AppBar, Column, FAB?**
Jawab: itu memang parameter `Scaffold` (`appBar`, `body`, `floatingActionButton`)
— bukan widget anak biasa, tapi sesuai pembacaan diagram Scaffold → 3 cabang.

### B. Custom widget

**Q: Tunjukkan custom widget kamu. Kenapa memilih font itu?**
Jawab: `CustomText` di `lib/widgets/custom_text.dart` — StatelessWidget dengan
parameter `text`, `fontSize`, `fontWeight`, `color`, memakai `GoogleFonts.poppins`.
Alasan font (ada juga di komentar 3 baris di atas class): Poppins modern, geometric,
mudah dibaca di layar kecil, cocok untuk aplikasi kantin yang kasual.

**Q: Kenapa custom widget-nya stateless?**
Jawab: tidak ada data yang berubah di dalam widget — cukup terima parameter lalu
render. Kalau ada state (misal tombol suka/tidak suka), baru StatefulWidget.

**Q: Semua Text sudah diganti CustomText? Bukti?**
Jawab: 5 node Text pada diagram — judul AppBar daftar, teks dalam Padding, title,
subtitle ListTile, judul AppBar tambah, teks tombol Simpan — semuanya
`CustomText`. Yang tetap string polos hanya `labelText` dan pesan validator,
karena memang bertipe `String` dan dikecualikan soal.

**Q: Kalau saya minta teksnya rata tengah, kamu ubah di mana?**
Jawab: tambahkan parameter `textAlign` di `CustomText` — cukup di satu tempat,
tidak perlu ubah semua pemanggilan. (Itu gunanya custom widget.)

**Q: Apa gunanya `const` di mana-mana?**
Jawab: `const` membuat objek dibuat sekali saat compile, tidak dialokasi ulang
tiap rebuild; syaratnya semua field final dan nilainya konstan. Membuat build
lebih ringan.

### C. State & setState

**Q: Kenapa halaman daftar harus StatefulWidget?**
Jawab: karena menyimpan `menuList` di dalam State dan memanipulasinya lewat
`setState` saat ada menu baru — data dan tampilannya berubah selama halaman hidup.

**Q: Bagaimana setState bekerja sampai item baru muncul?**
Jawab: `setState` menandai State "dirty" → framework menjadwalkan build ulang →
`build()` dieksekui lagi → `ListView.builder` membaca `menuList.length` yang
sudah bertambah → item baru digambar.

**Q: `menuList` dideklarasikan `final`, kok masih bisa ditambah?**
Jawab: `final` mengunci *variabelnya* (tidak bisa di-assign ulang ke list lain),
bukan *isi* list. Method `add()` mengubah isi list, yang tetap diizinkan.

**Q: Kenapa data awal disimpan di dalam State, bukan variabel global?**
Jawab: sesuai ketentuan soal ("List biasa di dalam State"), dan secara teknik
lebih benar — data hidup seumur State, tidak bocor ke pemakaian lain, dan mudah
di-reset/test.

**Q: Map<String, String> — kenapa bukan class model?**
Jawab: boleh dua-duanya (soal membebankan nama class), tapi Map membuat kode
singkat untuk ukuran tugas ini. Kelemahannya: tidak type-safe — salah kunci map
(`menu['hrga']`) baru ketahuan saat runtime. Untuk aplikasi produksi saya akan
buat class `Menu` dengan field `nama` dan `harga`.

### D. Navigasi GetX

**Q: Kenapa pakai GetMaterialApp, bukan MaterialApp?**
Jawab: ketentuan soal membatasi package get hanya untuk navigasi
(`GetMaterialApp`, `Get.to()`, `Get.back()`). Secara teknis `Get.to()` dan
`Get.back()` butuh controller dari `GetMaterialApp`; kalau pakai `MaterialApp`
biasa, navigasinya pakai `Navigator.push`/`Navigator.pop`.

**Q: Get.to() itu apa? Bedanya dengan Navigator.push?**
Jawab: fungsinya sama — menumpuk halaman baru. `Get.to()` adalah wrapper GetX
yang lebih singkat dan mengembalikan `Future` untuk menerima result.

**Q: Bagaimana data dari halaman tambah bisa sampai ke halaman daftar?**
Jawab: halaman daftar meng-await `Future` dari `Get.to()`. Saat halaman tambah
menjalankan `Get.back(result: ...)`, nilai result diteruskan ke Future itu,
lalu `setState(() => menuList.add(result))` memperbarui tampilan.

**Q: Kalau user pencet tombol back tanpa mengisi apa-apa?**
Jawab: `Get.back()` tanpa argumen → result `null` → blok `if (result != null)`
tidak jalan → daftar tidak berubah. Tidak ada error.

**Q: Kenapa `await`-nya di FAB onPressed?**
Jawab: supaya kode setelahnya (penerimaan data + setState) baru dijalankan ketika
halaman tambah ditutup. Tanpa `await`, kita tidak akan pernah mendapat result.

**Q: Kenapa halaman detail pakai Get.back() di tombol panah?**
Jawab: agar konsisten dengan ketentuan "get hanya untuk navigasi" dan
menunjukkan pemakaian `Get.back()`. Sebenarnya panah bawaan AppBar juga bisa
langsung pop, tapi saya tulis eksplisit supaya jelas.

### E. Form & validasi

**Q: Apa fungsi `GlobalKey<FormState>` pada Form?**
Jawab: sebagai "pegangan" ke state milik Form sehingga kita bisa memanggil
`formKey.currentState!.validate()` — satu panggilan untuk memvalidasi SEKALIGUS
semua `TextFormField` di dalamnya.

**Q: Bagaimana alur validasi sampai pesan error tampil?**
Jawab: tombol Simpan → `validate()` memanggil `validator` tiap field → jika
mengembalikan String, field menampilkan pesan itu merah di bawah kolom dan
`validate()` false → `Get.back(result: ...)` TIDAK dieksekui. Jika semua
mengembalikan `null` → baru data dikirim.

**Q: Kenapa harga divalidasi dua kali (formatter + validator)?**
Jawab: `inputFormatters.digitsOnly` mencegah huruf diketik/tempel; validator
adalah jaring pengaman terakhir sekaligus menangani kolom kosong. Soal
mensyaratkan keduanya: "hanya menerima angka DAN harus divalidasi".

**Q: Jelaskan regex `^[0-9]+$`.**
Jawab: `^` awal string, `[0-9]` satu digit, `+` satu atau lebih, `$` akhir
string — artinya SELURUH isi string harus digit. `"20000"` lolos; `"20abc"`,
`"20 000"`, `""` tidak lolos.

**Q: Kenapa pakai TextEditingController? Kenapa ada dispose()?**
Jawab: controller membaca nilai kolom saat tombol ditekan (`namaController.text`).
Controller punya resource (listener) yang harus dilepas — `dispose()` dipanggil
otomatis oleh framework saat widget dihapus, mencegah kebocoran memori dan
nilai lama nyangkut saat halaman dibuka lagi.

**Q: Kenapa trim() dipakai?**
Jawab: `value.trim().isEmpty` menganggap `"   "` (spasi saja) sebagai kosong,
sehingga pengguna tidak bisa mengakali validasi dengan spasi.

**Q: Kenapa harga disimpan sebagai String "Rp 20.000" bukan angka?**
Jawab: agar konsisten dengan data awal yang juga string "Rp 15.000" dan siap
langsung ditampilkan. Di aplikasi nyata, simpan angka `int` di data, lalu
format hanya saat tampil — itu lebih benar secara desain data.

### F. Tema, font, tampilan (bagian B)

**Q: Kenapa warna tidak ditulis di tiap halaman tapi di ThemeData?**
Jawab: satu sumber kebenaran — konsisten dan mudah ganti tema (cukup ubah
`seedColor`). Halaman jadi bersih dari nilai warna hardcode. Ini nilai plus
"kerapian kode".

**Q: Apa itu ColorScheme.fromSeed?**
Jawab: Material 3 membuat seluruh palet warna aplikasi (primary, onPrimary,
primaryContainer, dll.) dari SATU warna dasar, lengkap dengan perhitungan
kontras yang aksesibel.

**Q: google_fonts itu cara kerjanya bagaimana? Butuh internet?**
Jawab: font diunduh saat runtime dari fonts.google.com lalu di-cache ke penyimpanan
device; setelah sekali unduh, offline pun tampil. Jika internet mati saat
unduh pertama, aplikasi TETAP jalan memakai font fallback — tidak error
(syarat "aplikasi harus dapat dijalankan tanpa error" tetap terpenuhi).

**Q: Kenapa font Poppins?**
Jawab: modern, geometric, x-height besar sehingga nyaman dibaca di layar HP kecil;
cocok untuk aplikasi kantin yang santai tapi rapi. (Jawaban boleh diganti
selama punya alasan — yang wajib ada komentar 2–3 baris di atas class.)

### G. Package, aturan soal, dan hal teknis

**Q: Package apa saja yang kamu pakai? Apakah sesuai petunjuk?**
Jawab: minimal `get` dan `google_fonts` sesuai petunjuk umum. `get` saya
gunakan HANYA untuk navigasi (`GetMaterialApp`, `Get.to`, `Get.back`) — tidak
pakai GetX controller/Obx, karena soal membatasi fungsi get untuk navigasi.

**Q: Kalau pakai GetX biasa (GetXController, Obx) lebih bagus?**
Jawab: untuk aplikasi sekelas ini state lokal + `setState` sudah cukup dan malah
lebih sederhana. Soal juga membatasi pemakaian get hanya untuk navigasi, jadi
saya tidak menambahnya.

**Q: Kenapa halaman detail bebas tapi halaman lain ketat?**
Jawab: soal menyatakan "Struktur halaman detail bebas, tetapi harus bisa kembali
ke daftar" — yang dinilai dari diagram adalah halaman daftar (Gambar 1) dan
tambah (Gambar 2).

**Q: Bagaimana kamu memastikan tidak ada error?**
Jawab: dua cara: (1) `flutter analyze` → *No issues found*; (2) widget test di
`test/widget_test.dart` menjalankan alur lengkap: buka daftar → buka detail →
kembali → buka tambah → coba simpan form kosong (validasi harus muncul) →
isi data valid → data baru tampil dengan format `Rp 20.000`. Hasil: *All tests
passed*.

**Q: Apa kelemahan aplikasi ini?**
Jawab: (1) data hanya di memori — hilang saat aplikasi ditutup (solusi:
`shared_preferences`); (2) belum ada edit/hapus menu; (3) penyimpanan pakai
`Map<String, String>`, bukan class model. Semuanya di luar cakupan soal.

**Q: Kalau saya minta tambah fitur hapus menu, bagaimana?**
Jawab: tambahkan aksi pada item (misal ikon trailing yang bisa ditekan) lalu
`setState(() => menuList.removeAt(index))`. Tapi saya perlu pastikan dulu
struktur widget tetap cocok diagram, karena soal melarang menambah/mengurangi
node.

**Q: Kalau saya minta cari/menu filter?**
Jawab: tambah `TextField` di area Padding? — TIDAK boleh sembarangan karena
Padding pada diagram hanya berisi Text. Solusi aman: filter lewat data saja
(tampilan berubah lewat `setState` tanpa widget baru), atau konfirmasi dulu
perubahan diagram.

---

## 5. Script demo singkat (kalau diminta presentasi)

1. "Ini aplikasi kantin dengan 3 halaman: daftar, detail, tambah."
2. Tunjuk struktur widget di debug → flutter inspector / baca kode:
   "Sesuai Gambar 1: AppBar, Column berisi Padding lalu Expanded-ListView,
   dan FAB."
3. Tekan satu menu → "Get.to() membuka detail; tombol back memakai Get.back()."
4. Tekan FAB → isi form kosong → Simpan → "validasi menolak, form tidak lolos."
5. Isi nama + harga angka → Simpan → "Get.back(result:) mengirim data, setState
   menambah item baru — dan format otomatis Rp 20.000."
6. Tutup dengan: "flutter analyze bersih dan widget test lulus semua."

---

## 6. Lokasi file

| File | Isi |
|---|---|
| `lib/main.dart` | `GetMaterialApp` + seluruh tema warna/gaya |
| `lib/widgets/custom_text.dart` | custom widget teks + komentar alasan desain |
| `lib/pages/daftar_menu_page.dart` | Gambar 1 + state data menu + navigasi |
| `lib/pages/tambah_menu_page.dart` | Gambar 2 + form + validasi + kirim data |
| `lib/pages/detail_menu_page.dart` | halaman detail (struktur bebas) |
| `test/widget_test.dart` | smoke test alur lengkap |
