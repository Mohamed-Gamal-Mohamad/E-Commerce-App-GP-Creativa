// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

/// Central color palette for StoreHub.
/// Matches the reference design at storehub-ui.lovable.app
class AppColors {
  AppColors._();

  // ─── Brand / Primary ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFF97316); // Orange
  static const Color primaryLight = Color(0xFFFED7AA); // Light orange tint
  static const Color primaryDark = Color(0xFFEA6A0A); // Darker orange
  static const Color secondary = Color(0xFF0EA5E9); // Sky blue accent

  // ─── Light Mode ─────────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF5F0EA); // Warm cream
  static const Color lightSurface = Color(0xFFFFFFFF); // White cards
  static const Color lightSurfaceVariant = Color(0xFFF3EDE6); // Slightly warm
  static const Color lightOnBackground = Color(0xFF1C1C1C); // Near-black text
  static const Color lightOnSurface = Color(0xFF1C1C1C);
  static const Color lightSubtitle = Color(0xFF6B7280); // Gray
  static const Color lightDivider = Color(0xFFE5DDD5);
  static const Color lightBorder = Color(0xFFE5DDD5);
  static const Color lightNavBar = Color(0xFFFFFFFF);
  static const Color lightCategoryInactive = Color(0xFFF0EAE3);

  // ─── Dark Mode ──────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF1A1208); // Very dark brown
  static const Color darkSurface = Color(0xFF2A1F14); // Dark card
  static const Color darkCard = Color(0xFF2A1F14);
  static const Color darkSurfaceVariant = Color(0xFF342618);
  static const Color darkOnBackground = Color(0xFFF5F0EA); // Cream text
  static const Color darkOnSurface = Color(0xFFF5F0EA);
  static const Color darkSubtitle = Color(0xFF9CA3AF);
  static const Color darkDivider = Color(0xFF3D2D1E);
  static const Color darkBorder = Color(0xFF3D2D1E);
  static const Color darkNavBar = Color(0xFF1E150C);
  static const Color darkCategoryInactive = Color(0xFF2A1F14);

  // ─── Semantic & Text ─────────────────────────────────────────────────────────
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color star = Color(0xFFFBBF24); // Rating star yellow
  static const Color wishlistActive = Color(0xFFF97316); // filled heart
  static const Color wishlistInactive = Color(0xFF9CA3AF);
}

