// lib/features/cart/views/cart_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../orders/cubit/order_cubit.dart';
import '../../profile/views/order_history_screen.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

/// Shopping cart screen showing all items, quantities, and order summary.
class CartScreen extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const CartScreen({super.key, this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Column(
              children: [
                // ─── Header ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        'Cart',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (state.totalItemCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${state.totalItemCount}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (state.items.isNotEmpty)
                        TextButton(
                          onPressed: () => _confirmClearCart(context),
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.poppins(
                              color: AppColors.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ─── Empty State ─────────────────────────────────────────
                if (state.items.isEmpty)
                  const Expanded(
                    child: EmptyStateWidget(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Your cart is empty',
                      subtitle: 'Add items to get started',
                    ),
                  )
                else ...[
                  // ─── Items List ────────────────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _CartItemCard(isDark: isDark, item: item);
                      },
                    ),
                  ),

                  // ─── Order Summary ─────────────────────────────────────
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).padding.bottom + 20,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Shipping
                        _SummaryRow(
                          label: 'Shipping',
                          value: 'Free',
                          isDark: isDark,
                          valueColor: AppColors.success,
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        // Total
                        _SummaryRow(
                          label: 'Total',
                          value: '\$${state.totalPrice.toStringAsFixed(2)}',
                          isDark: isDark,
                          valueColor: AppColors.primary,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          label: 'Proceed to Checkout',
                          onPressed: () => _proceedToCheckout(context, state),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmClearCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Clear Cart',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content:
            Text('Remove all items?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CartCubit>().clearCart();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context, CartState state) {
    if (state.items.isEmpty) return;

    // 1. Pass current cart items into OrderCubit
    context.read<OrderCubit>().placeOrderFromCart(state.items, state.totalPrice);

    // 2. Clear cart items
    context.read<CartCubit>().clearCart();

    // 3. Show a success message
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Order placed successfully! 🎉',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

    // 4. Navigate user to My Orders screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
    );
  }
}

/// A single cart item card.
class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item, required this.isDark});

  final dynamic item; // CartItemModel
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ─── Thumbnail ───────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.product.thumbnail,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppColors.lightSurfaceVariant,
                child: const Icon(Icons.image_outlined),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ─── Info ────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // ─── Quantity Controls ───────────────────────────────────────────
          Row(
            children: [
              // Decrement
              GestureDetector(
                onTap: () => context
                    .read<CartCubit>()
                    .decrementQuantity(item.product.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.remove, size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${item.quantity}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Increment
              GestureDetector(
                onTap: () => context
                    .read<CartCubit>()
                    .incrementQuantity(item.product.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Summary row for shipping/total lines.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? AppColors.darkSubtitle : AppColors.lightSubtitle,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

