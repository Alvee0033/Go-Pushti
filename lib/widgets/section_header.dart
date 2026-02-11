import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? color;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color ?? Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
