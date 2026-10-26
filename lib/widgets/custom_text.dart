import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Font Poppins dipilih karena bentuknya modern dan mudah dibaca di layar ponsel.
// Parameter fontSize dan fontWeight disediakan agar widget fleksibel
// dan dapat dipakai ulang di berbagai tempat dengan gaya teks yang berbeda.
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
