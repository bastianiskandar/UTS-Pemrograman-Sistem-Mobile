import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/daftar_menu_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Satu sumber warna: semua warna aplikasi diturunkan dari biru ini.
    // Kalau mau ganti tema, cukup ganti satu baris di sini.
    final warna = ColorScheme.fromSeed(seedColor: Colors.blue);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iannn Canteen',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: warna,
        // Semua teks aplikasi sudah pakai Poppins lewat CustomText,
        // jadi theme textTheme cukup default; label form disamakan di bawah
        // AppBar otomatis biru dengan teks putih tanpa perlu
        // menulis warna di setiap halaman
        appBarTheme: AppBarTheme(
          backgroundColor: warna.primary,
          foregroundColor: warna.onPrimary,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: warna.primary,
          foregroundColor: warna.onPrimary,
        ),
        // Card membulat, rapi, dan tidak ada bayangan berlebih
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: warna.primary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: warna.primary,
            foregroundColor: warna.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationThemeData(
          // Label dan hint memakai Poppins agar sama dengan CustomText
          labelStyle: GoogleFonts.poppins(fontSize: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: warna.primary, width: 2),
          ),
        ),
      ),
      home: const DaftarMenuPage(),
    );
  }
}
