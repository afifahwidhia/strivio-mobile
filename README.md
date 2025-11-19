# Strivio
<details>
<summary><b>Tugas Individu 7</b></summary>
<br>

### Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget.
Widget tree adalah struktur hierarkis yang merepresentasikan susunan seluruh widget di layar Flutter. Setiap elemen UI mulai dari aplikasi, halaman, hingga tombol dan teks, adalah widget yang saling bertumpuk dalam hubungan parent-child.
- Parent bertanggung jawab menempatkan, memberi batas, dan me-layout child-nya (mis. Column mengatur posisi vertikal anak-anaknya).
- Child mewarisi konteks dari parent (tema, navigator, scaffold, dll.) serta memberi tahu parent ukuran/kebutuhannya melalui fase layout.
Perubahan di satu cabang tree hanya memicu rebuild pada cabang terkait, sehingga efisien. Secara sederhana: MaterialApp (parent) → Scaffold (child) → AppBar, Body (child) → di dalam body terdapat Column → berisi Row, GridView, dll. Setiap level menentukan bagaimana child ditata dan dirender.

### Widget yang digunakan dalam proyek ini dan jelaskan fungsinya
1. **MaterialApp** – Pembungkus utama aplikasi berbasis Material Design; menyediakan theme, navigation, localization, dan pengaturan routing.
2. **Scaffold** – Kerangka halaman Material (menyediakan appBar, body, floatingActionButton, dsb.).
3. **AppBar** – Bilah atas aplikasi yang menampilkan judul.
4. **Text** – Menampilkan teks statis seperti judul dan isi kartu.
5. **Padding** – Memberi jarak di sekitar child dengan EdgeInsets.
6. **Column** – Menyusun widget secara vertikal.
7. **Row** – Menyusun widget secara horizontal (dipakai untuk tiga InfoCard).
8. **Card** – Kartu Material dengan elevasi/bayangan (dipakai di InfoCard).
9. **Container** – Pembungkus serbaguna untuk ukuran, padding, dan dekorasi.
10. **SizedBox** – Spacer/ukuran tetap (jarak vertikal). 
11. **Center** – Memusatkan child. 
12. **GridView.count** – Grid dengan jumlah kolom tetap (menampilkan kumpulan ItemCard). 
13. **Material** – Memberi konteks material (warna, ink effects) untuk InkWell. 
14. **InkWell** – Efek gelombang/klik dan deteksi gesture pada kartu. 
15. **Icon** – Menampilkan ikon di dalam kartu. 
16. **Widget kustom InfoCard (extends StatelessWidget)** – Kartu info sederhana berisi judul dan konten. 
17. **Widget kustom ItemCard (extends StatelessWidget)** – Kartu menu yang bisa ditekan, menampilkan ikon dan nama item. 
18. **Widget kustom MyHomePage (extends StatelessWidget)** – Halaman utama yang menyusun semua komponen di atas.

### Fungsi dari widget MaterialApp? Jelaskan mengapa widget ini sering digunakan sebagai widget root.
MaterialApp menyediakan infrastruktur aplikasi Material Design:
* Manajemen navigasi & route (Navigator, onGenerateRoute, dsb.).
* Tema global (ThemeData, ColorScheme, Typography) yang bisa diakses dengan Theme.of(context).
* Localizations dan pengaturan locale.
* Default text direction, debug banner, title, dan lain-lain.
Karena semua halaman dan komponen di bawahnya memerlukan akses ke theme, navigator, dan localization, MaterialApp hampir selalu diletakkan sebagai widget root sehingga seluruh subtree mewarisi layanan tersebut melalui BuildContext.

### Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?
**StatelessWidget**
* Tidak menyimpan state internal yang berubah seiring waktu.
* Immutable; rebuild hanya ketika input (properties) atau ancestor berubah.
* Contoh: teks statis, ikon, tombol yang tampilannya tidak bergantung pada perubahan internal.
* Dipilih jika UI murni fungsi dari props dan konteks.

**StatefulWidget**
* Memiliki objek State terpisah yang menyimpan state mutable (counter, status loading, hasil fetch).
* Dapat memanggil setState() untuk memicu rebuild saat state berubah.
* Cocok untuk interaksi, animasi, input form, atau data yang dinamis.
* Dipilih jika UI harus bereaksi terhadap perubahan yang terjadi setelah konstruksi widget.
Pada kode saat ini, MyHomePage, InfoCard, dan ItemCard adalah StatelessWidget karena tampilannya ditentukan oleh properti yang diberikan dan tidak membutuhkan perubahan internal.

### Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?
BuildContext adalah referensi ke lokasi suatu widget di dalam widget tree. Melalui konteks ini, widget dapat:
* Mengakses inherited widgets seperti Theme, MediaQuery, Navigator, ScaffoldMessenger.
* Menemukan ancestor tertentu (contoh: ScaffoldMessenger.of(context) untuk menampilkan SnackBar).
* Menggunakan utilitas yang tergantung lokasi (contoh: Theme.of(context).colorScheme.primary atau Navigator.of(context).push(...)).
Pada metode build, BuildContext digunakan untuk mengambil nilai yang bergantung pada posisi widget. Misalnya, warna AppBar diambil dari tema aplikasi melalui Theme.of(context).colorScheme.primary, sementara pemanggilan ScaffoldMessenger.of(context).showSnackBar(...) menggunakan konteks yang berada di bawah Scaffold, agar snackbar bisa ditampilkan pada halaman yang benar. Tanpa konteks yang tepat, banyak fungsi Flutter tidak dapat berjalan karena tidak mengetahui letak widget yang memanggilnya di dalam tree.

### Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".
Flutter menyediakan fitur **hot reload** untuk mempercepat proses pengembangan. Dengan hot reload, perubahan kode disuntikkan langsung ke Dart Virtual Machine, lalu widget tree dibangun ulang tanpa menghapus state yang sedang berjalan. Artinya, jika sebuah halaman sudah berada pada kondisi tertentu (misalnya input sudah terisi atau navigasi sudah berada di halaman ke-3), kondisi tersebut tetap dipertahankan setelah hot reload. Fitur ini sangat berguna untuk mencoba perubahan tampilan UI atau logika ringan secara cepat.

Sedangkan, **hot restart** akan menjalankan ulang aplikasi dari awal, sama seperti ketika aplikasi pertama kali dibuka. Semua state yang tersimpan di memori di-reset, termasuk variabel dalam StatefulWidget, posisi halaman, bahkan nilai counter sederhana sekalipun. Hot restart lebih lambat dibanding hot reload, namun diperlukan ketika perubahan kode bersifat struktural, seperti mengubah inisialisasi variabel state atau menambah field baru dalam sebuah class state.
</details>

<details>
<summary><b>Tugas Individu 8</b></summary>
<br>

### Jelaskan perbedaan antara `Navigator.push()` dan `Navigator.pushReplacement()` pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?
`Navigator.push()` dan `Navigator.pushReplacement()` sama-sama digunakan untuk berpindah halaman di Flutter, namun perbedaan utamanya ada pada cara keduanya mengelola stack halaman.

`Navigator.push()` **menambahkan halaman baru di atas halaman yang sedang dibuka**, sehingga pengguna masih dapat kembali ke halaman sebelumnya menggunakan tombol back. Misalnya pada aplikasi Strivio, saat pengguna berada di halaman utama (MyHomePage) lalu menekan tombol **"Create Product"**, kita menggunakan `Navigator.push()` agar setelah menyimpan data, pengguna bisa menekan tombol back untuk kembali ke halaman utama tanpa kehilangan konteks.

Sementara itu, `Navigator.pushReplacement()` **mengganti halaman yang sedang aktif dengan halaman baru**, sehingga halaman sebelumnya dihapus dari stack. Pendekatan ini cocok ketika halaman lama tidak perlu diakses kembali, misalnya setelah login berhasil, halaman login digantikan oleh halaman dashboard agar pengguna tidak bisa kembali ke layar login dengan tombol back.

Jadi, dalam konteks Strivio, `Navigator.push()` digunakan untuk navigasi antar fitur (seperti membuka form produk), sedangkan `Navigator.pushReplacement()` cocok untuk transisi yang sifatnya final seperti logout atau berpindah antar halaman utama.

### Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?
Dalam aplikasi Flutter, **Scaffold** berperan sebagai fondasi setiap halaman. Ia menyediakan struktur dasar seperti **AppBar**, **Body**, dan **Drawer**, sehingga setiap halaman memiliki tampilan yang konsisten tanpa harus menulis ulang struktur layout berulang kali.

Pada aplikasi Strivio, setiap halaman—baik halaman utama maupun halaman form tambah produk—dibangun menggunakan Scaffold.  
- **AppBar** digunakan untuk menampilkan judul aplikasi “Strivio” dengan warna tema utama (pink). Hal ini membantu pengguna selalu tahu di aplikasi mana mereka berada.  
- **Body** berisi konten utama seperti grid tombol pada MyHomePage dan form input pada ProductFormPage.  
- **Drawer** berfungsi sebagai menu navigasi samping yang menyediakan akses cepat ke halaman “Home” dan “Create Product”.  

Dengan memanfaatkan hierarchy ini, aplikasi terlihat lebih terorganisir, setiap halaman memiliki tampilan yang seragam, dan navigasi antar fitur menjadi lebih mudah serta konsisten di seluruh aplikasi.

### Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.
Layout widget seperti **Padding**, **SingleChildScrollView**, dan **ListView** digunakan untuk meningkatkan kenyamanan visual dan fungsionalitas form agar tetap responsif pada berbagai ukuran layar.

- **Padding** digunakan untuk memberi jarak antar elemen, sehingga input field tidak terlalu rapat dan lebih mudah dibaca.  
  Contohnya pada `ProductFormPage`, setiap `TextFormField` dibungkus oleh `Padding(const EdgeInsets.all(8.0))` untuk menjaga jarak antar field.  

- **SingleChildScrollView** membuat halaman dapat di-scroll saat konten form melebihi tinggi layar. Ini penting terutama saat form memiliki banyak input (misalnya nama, harga, deskripsi, kategori, thumbnail, dan toggle unggulan), sehingga pengguna tidak perlu khawatir field bagian bawah tertutup keyboard.  

- **ListView** (meski belum digunakan secara eksplisit di form) bisa menjadi alternatif jika input field-nya dinamis atau sangat banyak karena `ListView` hanya merender elemen yang terlihat di layar (lebih efisien).

Dengan kombinasi widget tersebut, form Strivio tetap nyaman digunakan di berbagai device, tidak terpotong, dan terlihat proporsional tanpa elemen yang berhimpitan.

### Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?
Untuk menjaga identitas visual yang konsisten, Strivio menggunakan skema warna pinkish yang berbeda dari nuansa biru pada Football News sebelumnya. Penyesuaian ini dilakukan melalui properti **ThemeData** pada `MaterialApp`.

Contohnya:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.pink,
  ).copyWith(
    secondary: Colors.pinkAccent[100],
  ),
),
```

primarySwatch menentukan warna utama aplikasi yang digunakan pada AppBar, FloatingActionButton, dan elemen penting lainnya. secondary digunakan untuk elemen pendukung seperti warna latar belakang tombol atau efek klik pada kartu produk.

Dengan cara ini, semua halaman dalam aplikasi (termasuk MyHomePage, Drawer, dan ProductFormPage) secara otomatis mengikuti skema warna yang sama.
Hasilnya, aplikasi Strivio tampil dengan gaya yang kohesif dan profesional, memperkuat brand identity Football Shop sebagai platform yang modern, ceria, dan mudah diingat.
</details>


<details>
<summary><b>Tugas Individu 9</b></summary>
<br>

### Alasan Perlunya Model Dart dalam Pengolahan Data JSON
Pada proses komunikasi antara Flutter dan Django, pembuatan model Dart berfungsi sebagai representasi terstruktur dari data JSON yang diterima atau dikirimkan. Model ini memastikan bahwa setiap data memiliki tipe yang jelas, konsisten, dan aman dari kesalahan pemetaan. Tanpa model, aplikasi harus mengandalkan `Map<String, dynamic>`, yang tidak menyediakan validasi tipe maupun jaminan null-safety. Hal tersebut dapat menimbulkan berbagai konsekuensi, seperti tipe data yang tidak sesuai, kesalahan akibat key yang salah ketik, error saat runtime, serta meningkatnya kompleksitas dan risiko bug ketika aplikasi berkembang. Dengan model Dart, seluruh sistem menjadi lebih mudah dirawat, mudah dibaca, dan jauh lebih aman.

### Fungsi Package `http` dan `CookieRequest` serta Perbedaannya
Package `http` pada Flutter merupakan library dasar yang digunakan untuk melakukan request HTTP standar seperti GET atau POST. Namun, library ini tidak menangani cookie atau autentikasi berbasis sesi. Sebaliknya, `CookieRequest`, yang disediakan oleh PBP Django Auth, didesain khusus untuk berkomunikasi dengan backend Django yang menggunakan session-based authentication. Objek ini menyimpan dan mengelola cookie sesi, sehingga setiap request yang dilindungi tetap menyertakan informasi autentikasi yang diperlukan. Dengan demikian, `http` berperan sebagai pengirim request umum, sedangkan `CookieRequest` berfungsi sebagai jembatan autentikasi antara Flutter dan Django.

### Alasan CookieRequest Dibagikan ke Seluruh Komponen Flutter
Karena proses autentikasi Django mengandalkan sesi dan cookie, maka seluruh bagian aplikasi Flutter yang memerlukan akses ke endpoint Django harus menggunakan instance `CookieRequest` yang sama. Hal ini diperlukan agar state login pengguna, cookie session, dan data identitas pengguna tetap konsisten di seluruh halaman aplikasi. Jika setiap widget membuat instance baru, maka cookie tidak akan tersimpan dan pengguna dianggap belum terautentikasi di setiap request, sehingga aplikasi tidak dapat mengakses endpoint yang membutuhkan login. Dengan membagikan instance ini melalui `Provider`, aplikasi dapat menjaga autentikasi, state, dan pengalaman pengguna secara menyeluruh.

### Konfigurasi Konektivitas Flutter-Django
Agar Flutter dapat terhubung dengan Django, diperlukan beberapa konfigurasi khusus. Pertama, penambahan `10.0.2.2` ke dalam `ALLOWED_HOSTS` Django diperlukan karena Android emulator tidak menggunakan `localhost`, melainkan meneruskan permintaan ke host melalui alamat tersebut. Kedua, aktivasi CORS diperlukan karena Flutter, terutama ketika dijalankan melalui browser, menggunakan protokol yang berbeda, sehingga Django harus memberikan izin lintas domain. Ketiga, pengaturan cookie seperti `SameSite=None` dan `Secure=True` memastikan bahwa cookie sesi dapat dikirim dalam konteks lintas-origin. Terakhir, aplikasi Android memerlukan izin akses internet pada `AndroidManifest.xml`. Jika salah satu konfigurasi ini diabaikan, Flutter akan gagal mengirim request, cookie tidak terkirim, atau Django menolak permintaan dengan kesalahan keamanan.

### Mekanisme Pengiriman Data dari Input ke Tampilan Flutter
Alur pengiriman data dimulai ketika pengguna mengisi formulir di Flutter. Setelah data divalidasi, Flutter mengirimnya dalam format JSON melalui `postJson()` ke Django. Backend kemudian memproses data, melakukan sanitasi maupun validasi ulang, menyimpannya ke dalam database, lalu mengembalikan respons JSON kepada Flutter. Pada sisi Flutter, data yang telah disimpan dapat diambil kembali melalui endpoint JSON menggunakan `get()`, kemudian didekode ke model Dart, dan akhirnya ditampilkan pada antarmuka pengguna. Proses ini memastikan sinkronisasi antara input pengguna, penyimpanan server, dan data yang muncul pada aplikasi.

### Mekanisme Autentikasi Login, Register, dan Logout
Proses autentikasi yang diimplementasikan mencakup tiga tahap: pendaftaran akun, login, dan logout. Pada tahap register, Flutter mengirim data pendaftaran ke Django, yang kemudian membuat akun baru setelah memvalidasi seluruh input. Pada tahap login, Flutter mengirim username dan password ke Django melalui `CookieRequest.login()`. Jika kredensial valid, Django membuat sesi dan mengembalikan cookie sesi kepada Flutter, yang kemudian disimpan oleh `CookieRequest`. Seluruh request berikutnya tetap membawa cookie tersebut sehingga server mengenali pengguna. Logout dilakukan melalui `CookieRequest.logout()`, di mana Django menghapus sesi pengguna, dan Flutter menghapus cookie lokal sehingga status autentikasi di-reset sepenuhnya. Setelah logout, pengguna dikembalikan ke halaman login.

### Penjelasan Implementasi Checklist Secara Step-by-Step
1. Setup Django Models dan Endpoint
* Membuat model Product dengan atribut seperti name, price, description, category, dan relasi user.
* Menyediakan endpoint JSON untuk menampilkan daftar produk dalam format terstruktur.
* Membuat endpoint POST untuk menerima data produk baru dari Flutter.
* Menambahkan dekorator @csrf_exempt karena proses pengiriman data menggunakan JSON, bukan form HTML.

2. Konfigurasi Autentikasi di Django
* Mengaktifkan mekanisme login dan logout menggunakan modul PBP Django Auth.
* Melakukan pengujian login melalui browser untuk memastikan cookie tersimpan dengan benar.
* Memastikan sesi pengguna bekerja sebelum menghubungkannya dengan Flutter.

3. Setup Lingkungan Flutter
* Menambahkan dependensi seperti provider, pbp_django_auth, dan http.
* Menginisialisasi Provider untuk membagikan instance CookieRequest ke seluruh widget aplikasi.
* Melakukan percobaan sederhana untuk mengambil JSON sebagai uji konektivitas awal dengan server Django.

4. Pembuatan Model Dart
* Membangun class Dart untuk merepresentasikan data produk dari Django.
* Mengimplementasikan metode fromJson() dan toJson() untuk proses serialisasi dan deserialisasi.

5. Halaman Daftar Produk
* Menggunakan FutureBuilder untuk mengambil data produk dari backend secara asinkron.
* Menampilkan setiap produk menggunakan widget ProductEntryCard.

6. Halaman Detail Produk
* Mengirim objek produk melalui constructor untuk ditampilkan pada halaman detail.
* Menyusun tampilan lengkap informasi produk, termasuk gambar, deskripsi, dan atribut pendukung lainnya.

7. Halaman Formulir Produk
* Menyusun input menggunakan TextFormField dengan validasi untuk setiap field.
* Mengirim data ke Django menggunakan metode postJson() pada CookieRequest.
* Melakukan navigasi kembali ke halaman utama setelah penyimpanan berhasil.

8. Fitur My Products (Filtering Berdasarkan User Login)
* Mengambil seluruh produk dari endpoint JSON.
* Melakukan filter berdasarkan username yang tersimpan pada request.jsonData["username"].
* Menampilkan hanya produk milik pengguna yang sedang login.

9. Fitur Logout
* Mengimplementasikan proses logout menggunakan request.logout().
* Menghapus sesi pengguna dan mengarahkan kembali ke halaman login.

10. Styling dan Peningkatan UX
* Menyesuaikan ikon, warna, dan jarak antar elemen agar tampilan lebih konsisten.
* Mengatur ulang layout beranda menjadi grid yang lebih informatif.
* Melakukan penyesuaian teks, overflow, dan padding untuk pengalaman pengguna yang lebih baik.

11. Integrasi GitHub
* Melakukan commit perubahan secara berkala.
* Melakukan push ke repository GitHub untuk dokumentasi dan backup.
* Memperbarui README dengan penjelasan konsep dan hasil implementasi.
</details>