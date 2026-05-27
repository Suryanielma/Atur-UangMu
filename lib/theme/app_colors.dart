import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds ──────────────────────────────────────
  static const Color background     = Color(0xFFFAF4F0); // warm cream page
  static const Color surface        = Color(0xFFFBF6F2); // slightly warmer surface
  static const Color cardBackground = Color(0xFFFFFFFF); // pure white cards
  static const Color cardElevated   = Color(0xFFF2E8E0); // warm elevated / modal

  // ── Text ─────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF2E1F18); // deep espresso
  static const Color textSecondary = Color(0xFF7A5C50); // warm brown-grey
  static const Color textHint      = Color(0xFFB8998C); // muted warm

  // ── Brand Accents ────────────────────────────────────
  static const Color rose          = Color(0xFFC97B8A); // dusty rose — primary CTA
  static const Color roseLight     = Color(0xFFE4AEBA); // lighter rose
  static const Color roseBg        = Color(0xFFFAEEF0); // rose tint surface
  static const Color sand          = Color(0xFFC8A882); // warm sand — secondary
  static const Color sandLight     = Color(0xFFE8D5BC); // lighter sand
  static const Color sandBg        = Color(0xFFFDF8F4); // sand tint surface

  // ── Status ───────────────────────────────────────────
  static const Color incomeGreen   = Color(0xFF5BAF85);
  static const Color incomeBg      = Color(0xFFC8ECD8);
  static const Color expenseRed    = Color(0xFFD96B6B);
  static const Color expenseBg     = Color(0xFFF5D8D8);
  static const Color warningAmber  = Color(0xFFE8B86A);

  // ── Borders ──────────────────────────────────────────
  static const Color borderSubtle  = Color(0xFFEDE0D8);
  static const Color borderDefault = Color(0xFFD9C4B8);

  // ── Button backgrounds (legacy compat) ───────────────
  static const Color buttonBg       = Color(0xFFF2E8E0);
  static const Color buttonBgPurple = Color(0xFFFAEEF0);

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