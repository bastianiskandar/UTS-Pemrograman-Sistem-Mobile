import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';
import 'detail_menu_page.dart';
import 'tambah_menu_page.dart';

class DaftarMenuPage extends StatefulWidget {
  const DaftarMenuPage({super.key});

  @override
  State<DaftarMenuPage> createState() => _DaftarMenuPageState();
}

class _DaftarMenuPageState extends State<DaftarMenuPage> {
  // Data menu disimpan dalam List biasa di dalam State
  final List<Map<String, String>> menuList = [
    {'nama': 'Nasi Goreng', 'harga': 'Rp 15.000'},
    {'nama': 'Mie Ayam', 'harga': 'Rp 12.000'},
    {'nama': 'Bakso', 'harga': 'Rp 13.000'},
    {'nama': 'Soto Ayam', 'harga': 'Rp 14.000'},
    {'nama': 'Es Teh Manis', 'harga': 'Rp 5.000'},
  ];

  @override
  Widget build(BuildContext context) {
    // Struktur: Scaffold → AppBar + Column + FloatingActionButton
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Menu Kantin',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        // Warna AppBar diambil dari tema (lihat main.dart)
      ),
      body: Column(
        children: [
          // Padding → Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: const CustomText(
              text: 'Daftar Menu Tersedia',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Expanded → ListView.builder
          Expanded(
            child: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final menu = menuList[index];
                // Card → ListTile
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    // leading: Icon
                    leading: const Icon(Icons.restaurant),
                    // title: Text (nama menu)
                    title: CustomText(
                      text: menu['nama']!,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // subtitle: Text (harga)
                    subtitle: CustomText(
                      text: menu['harga']!,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    // trailing: Icon
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Buka halaman detail menggunakan Get.to()
                      Get.to(() => DetailMenuPage(menu: menu));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // FloatingActionButton → Icon
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Buka halaman tambah menu menggunakan Get.to()
          final result = await Get.to(() => const TambahMenuPage());
          if (result != null) {
            setState(() {
              menuList.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
