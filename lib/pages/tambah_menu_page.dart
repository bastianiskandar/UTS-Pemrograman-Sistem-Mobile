import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';

class TambahMenuPage extends StatefulWidget {
  const TambahMenuPage({super.key});

  @override
  State<TambahMenuPage> createState() => _TambahMenuPageState();
}

class _TambahMenuPageState extends State<TambahMenuPage> {
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaController = TextEditingController();

  // Controller di-dispose agar tidak bocor dan tidak menyimpan
  // nilai lama saat halaman dibuka lagi.
  @override
  void dispose() {
    namaController.dispose();
    hargaController.dispose();
    super.dispose();
  }

  // Mengubah angka mentah menjadi format rupiah yang sama
  // dengan data awal, misal 15000 -> Rp 15.000
  String _formatRupiah(int angka) {
    final ribuan = angka.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
    return 'Rp $ribuan';
  }

  @override
  Widget build(BuildContext context) {
    // Struktur: Scaffold → AppBar + Padding (body)
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Tambah Menu',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        // Warna AppBar diambil dari tema (lihat main.dart)
      ),
      // body: Padding → Form → Column
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // TextFormField (nama)
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              // SizedBox
              const SizedBox(height: 16),
              // TextFormField (harga) — hanya menerima angka
              TextFormField(
                controller: hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Harga hanya boleh angka';
                  }
                  return null;
                },
              ),
              // SizedBox
              const SizedBox(height: 24),
              // ElevatedButton → Text
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Kirim data kembali ke halaman daftar,
                    // harga diformat agar konsisten dengan data awal
                    Get.back(result: {
                      'nama': namaController.text.trim(),
                      'harga': _formatRupiah(
                        int.parse(hargaController.text.trim()),
                      ),
                    });
                  }
                },
                child: const CustomText(
                  text: 'Simpan',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
