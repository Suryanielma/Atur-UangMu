import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds ──────────────────────────────────────
  static const Color background     = Color(0xFFFFF8E7); // Ivory Mist
  static const Color surface        = Color(0xFFFFF3D6); // warm surface
  static const Color cardBackground = Color(0xFFFFFFFF); // putih untuk card netral
  static const Color cardElevated   = Color(0xFFF2D9A4); // Soft Peach untuk modal/dialog

  // ── Card per section ─────────────────────────────────
  static const Color cardChart       = Color(0xFFEAF2FD); // Cornflower bg — chart
  static const Color cardBudget      = Color(0xFFEAF2FD); // Cornflower bg — budget
  static const Color cardTransaction = Color(0xFFFFECEC); // Rose bg — transaksi

  // ── Text ─────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A0A00);
  static const Color textSecondary = Color(0xFF5A2020);
  static const Color textHint      = Color(0xFF8A5A3A);

  // ── Brand Accents ────────────────────────────────────
  static const Color rose          = Color(0xFF930500); // Sangria — primary CTA
  static const Color roseLight     = Color(0xFFBF3030);
  static const Color roseBg        = Color(0xFFFFECEC);
  static const Color sand          = Color(0xFF95BBEA); // Cornflower — secondary
  static const Color sandLight     = Color(0xFFBDD3F3);
  static const Color sandBg        = Color(0xFFEAF2FD);

  // ── Status ───────────────────────────────────────────
  static const Color incomeGreen   = Color(0xFF4A6B3A);
  static const Color incomeBg      = Color(0xFFD2E5C5);
  static const Color expenseRed    = Color(0xFF930500);
  static const Color expenseBg     = Color(0xFFFFECEC);
  static const Color warningAmber  = Color(0xFF828700);

  // ── Borders ──────────────────────────────────────────
  static const Color borderSubtle  = Color(0xFFC8A878);
  static const Color borderDefault = Color(0xFFAD8A5A);

  // ── Button backgrounds ───────────────────────────────
  static const Color buttonBg       = Color(0xFFFFECEC);
  static const Color buttonBgPurple = Color(0xFFEAF2FD);

  // ── Backward-compatibility aliases ───────────────────
  static const Color cardBackgroundPurple = surface;
  static const Color violet               = rose;
  static const Color violetLight          = roseLight;
  static const Color lavender             = roseBg;

  // ── Gradients ────────────────────────────────────────
  static const List<Color> gradientPrimary = [roseLight, rose];
  static const List<Color> gradientSand    = [sandLight, sand];
  static const List<Color> gradientSave    = [rose, sand];
}