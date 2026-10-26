import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_kantin/main.dart';

void main() {
  testWidgets(
      'Alur lengkap: daftar → detail → kembali → tambah → data baru muncul',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // 1. Halaman daftar tampil dengan data awal minimal 5 menu
    expect(find.text('Menu Kantin'), findsOneWidget);
    expect(find.text('Daftar Menu Tersedia'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh Manis'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    // 2. Tekan item → halaman detail terbuka (Get.to)
    await tester.tap(find.text('Nasi Goreng'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Menu'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsWidgets);

    // 3. Kembali ke daftar (Get.back)
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Menu Kantin'), findsOneWidget);

    // 4. Tekan FloatingActionButton → halaman tambah menu
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Menu'), findsOneWidget);

    // 5. Validasi: form kosong tidak boleh lolos
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama menu tidak boleh kosong'), findsOneWidget);
    expect(find.text('Harga tidak boleh kosong'), findsOneWidget);

    // 6. Isi form dengan data valid
    await tester.enterText(find.byType(TextFormField).at(0), 'Sate Ayam');
    await tester.enterText(find.byType(TextFormField).at(1), '20000');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Simpan'));
    await tester.pumpAndSettle();

    // 7. Kembali ke daftar, data baru tampil dan format harganya konsisten
    expect(find.text('Menu Kantin'), findsOneWidget);
    expect(find.text('Sate Ayam'), findsOneWidget);
    expect(find.text('Rp 20.000'), findsOneWidget);
  });
}
