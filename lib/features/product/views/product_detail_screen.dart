// lib/features/product/views/product_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../wishlist/cubit/wishlist_cubit.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

/// Full product detail screen with image carousel, info, reviews, and Add to Cart.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ProductCubit(context.read<ProductService>())..loadProduct(product.id),
      child: _ProductDetailView(initialProduct: product),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView({required this.initialProduct});

  final ProductModel initialProduct;

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          final product = state is ProductLoaded
              ? state.product
              : widget.initialProduct;
          final reviews = state is ProductLoaded ? state.reviews : <ReviewModel>[];

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // ─── App Bar ────────────────────────────────────────────
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.width * 0.85,
                    pinned: true,
                    backgroundColor: isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    leading: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                            Icons.arrow_back_ios_new_rounded, size: 18),
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    actions: [
                      // Wishlist toggle in app bar
                      BlocBuilder<WishlistCubit, WishlistState>(
                        builder: (context, wishlistState) {
                          final isWishlisted = wishlistState.items
                              .any((p) => p.id == product.id);
                          return GestureDetector(
                            onTap: () => context
                                .read<WishlistCubit>()
                                .toggleWishlist(product),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSurface
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isWishlisted
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isWishlisted
                                    ? AppColors.primary
                                    : AppColors.lightSubtitle,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildImageSection(product, isDark),
                    ),
                  ),

                  // ─── Product Info ────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand
                            if (product.brand.isNotEmpty)
                              Text(
                                product.brand.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                  color: AppColors.primary,
                                ),
                              ),

                            const SizedBox(height: 6),

                            // Title
                            Text(
                              product.title,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Price + Rating Row
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                if (product.discountPercentage > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.error
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '-${product.discountPercentage.toStringAsFixed(0)}%',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                RatingBarIndicator(
                                  rating: product.rating,
                                  itemBuilder: (_, __) => const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.star,
                                  ),
                                  itemCount: 5,
                                  itemSize: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.darkSubtitle
                                        : AppColors.lightSubtitle,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Stock
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: product.stock > 0
                                        ? AppColors.success
                                        : AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  product.stock > 0
                                      ? '${product.stock} in stock'
                                      : 'Out of stock',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: product.stock > 0
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // ─── Description ──────────────────────────────
                            Text(
                              'Description',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.darkSubtitle
                                    : AppColors.lightSubtitle,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ─── Reviews ──────────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reviews',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${reviews.length} reviews',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isDark
                                        ? AppColors.darkSubtitle
                                        : AppColors.lightSubtitle,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            if (state is ProductLoading)
                              const LoadingWidget()
                            else if (reviews.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'No reviews yet',
                                    style: GoogleFonts.poppins(
                                      color: isDark
                                          ? AppColors.darkSubtitle
                                          : AppColors.lightSubtitle,
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...reviews.map((r) => _ReviewCard(review: r,
                                  isDark: isDark)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ─── Fixed Bottom Bar ────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: CustomButton(
                    label:
                        'Add to Cart  •  \$${product.price.toStringAsFixed(2)}',
                    icon: Icons.shopping_cart_outlined,
                    onPressed: product.stock > 0
                        ? () {
                            context.read<CartCubit>().addToCart(product);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text('${product.title} added to cart!'),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                          }
                        : null,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection(ProductModel product, bool isDark) {
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _selectedImageIndex = i),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.contain,
                placeholder: (_, __) => Container(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  child: const Center(child: LoadingWidget()),
                ),
                errorWidget: (_, __, ___) => const Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: AppColors.lightSubtitle),
              );
            },
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: i == _selectedImageIndex ? 16 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i == _selectedImageIndex
                        ? AppColors.primary
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A single review card widget.
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.isDark});

  final ReviewModel review;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final initial = review.reviewerName.isNotEmpty
        ? review.reviewerName[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: review.rating.toDouble(),
                      itemBuilder: (_, __) => const Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                      ),
                      itemCount: 5,
                      itemSize: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isDark ? AppColors.darkSubtitle : AppColors.lightSubtitle,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

