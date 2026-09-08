// lib/features/home/views/widgets/category_chip.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

/// Maps category slugs to display icons.
IconData _categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'all':
      return Icons.grid_view_rounded;
    case 'smartphones':
    case 'mobile-accessories':
      return Icons.smartphone_rounded;
    case 'laptops':
    case 'tablets':
      return Icons.laptop_rounded;
    case 'electronics':
      return Icons.electrical_services_rounded;
    case 'fragrances':
    case 'beauty':
    case 'skin-care':
      return Icons.spa_rounded;
    case 'groceries':
      return Icons.local_grocery_store_rounded;
    case 'home-decoration':
    case 'furniture':
    case 'kitchen-accessories':
      return Icons.chair_rounded;
    case 'womens-clothing':
    case 'mens-shirts':
    case 'tops':
      return Icons.checkroom_rounded;
    case 'mens-shoes':
    case 'womens-shoes':
    case 'sports-accessories':
      return Icons.fitness_center_rounded;
    case 'sunglasses':
    case 'womens-bags':
    case 'mens-watches':
    case 'womens-watches':
    case 'womens-jewellery':
      return Icons.watch_rounded;
    case 'automotive':
    case 'vehicle':
      return Icons.directions_car_rounded;
    case 'motorcycle':
      return Icons.two_wheeler_rounded;
    default:
      return Icons.category_rounded;
  }
}

/// A circular category chip with icon + label, matching StoreHub design.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  String get _displayLabel {
    if (category == 'all') return 'All';
    return category
        .split('-')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Icon Circle ─────────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.darkCategoryInactive
                        : AppColors.lightCategoryInactive),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _categoryIcon(category),
                size: 26,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkOnBackground
                        : AppColors.lightOnBackground),
              ),
            ),

            const SizedBox(height: 6),

            // ─── Label ───────────────────────────────────────────────────────
            Text(
              _displayLabel,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.darkSubtitle
                        : AppColors.lightSubtitle),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

