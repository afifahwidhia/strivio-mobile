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