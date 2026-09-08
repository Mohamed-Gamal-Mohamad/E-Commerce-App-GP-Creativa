// lib/core/constants/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized text styles using Poppins font.
class AppTextStyles {
  AppTextStyles._();

  // ─── Display ────────────────────────────────────────────────────────────────
  static TextStyle displayLarge(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700);

  static TextStyle displayMedium(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700);

  // ─── Headings ───────────────────────────────────────────────────────────────
  static TextStyle headingLarge(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700);

  static TextStyle headingMedium(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle headingSmall(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  // ─── Body ───────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400);

  static TextStyle bodyMedium(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle bodySmall(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400);

  // ─── Label ──────────────────────────────────────────────────────────────────
  static TextStyle labelLarge(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle labelMedium(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle labelSmall(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500);

  // ─── Price ──────────────────────────────────────────────────────────────────
  static TextStyle price(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700);

  static TextStyle priceLarge(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700);

  // ─── Brand / Category Caption ────────────────────────────────────────────────
  static TextStyle brandLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      );

  // ─── Button ─────────────────────────────────────────────────────────────────
  static TextStyle button(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  // ─── Nav Label ──────────────────────────────────────────────────────────────
  static TextStyle navLabel(BuildContext context) =>
      GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500);
}

