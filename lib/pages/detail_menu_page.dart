import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';

// Struktur halaman detail bebas (sesuai ketentuan soal),
// jadi boleh dibuat lebih menarik daripada diagram.
class DetailMenuPage extends StatelessWidget {
  final Map<String, String> menu;

  const DetailMenuPage({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Detail Menu',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        // Tombol kembali memakai Get.back() sesuai ketentuan soal
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ikon dibungkus lingkaran berwarna agar fokus ke menu
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: warna.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 56,
                  color: warna.primary,
                ),
              ),
              const SizedBox(height: 24),
              CustomText(
                text: menu['nama']!,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: menu['harga']!,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: warna.primary,
              ),
              const SizedBox(height: 32),
              // Kartu keterangan kecil agar halaman tidak terasa kosong
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const CustomText(
                    text: 'Harga per porsi',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  subtitle: const CustomText(
                    text: 'Harga dapat berubah sewaktu-waktu',
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
