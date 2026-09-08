// lib/features/home/views/home_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_widget.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'widgets/category_chip.dart';
import 'widgets/promo_banner.dart';
import 'widgets/product_card.dart';

/// Main Home screen with greeting, search, categories, banners, and product grid.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load products on first build.
    final cubit = context.read<HomeCubit>();
    if (cubit.state is HomeInitial) {
      cubit.loadProducts();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<HomeCubit>().loadProducts(),
          child: CustomScrollView(
            slivers: [
              // ─── Header ───────────────────────────────────────────────────
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  final user = FirebaseAuth.instance.currentUser;
                  final authName = authState is AuthAuthenticated
                      ? authState.displayName
                      : null;
                  final rawName = (authName != null && authName.trim().isNotEmpty)
                      ? authName.trim()
                      : (user?.displayName != null &&
                              user!.displayName!.trim().isNotEmpty
                          ? user.displayName!.trim()
                          : null);
                  final email =
                      (authState is AuthAuthenticated && authState.email.isNotEmpty)
                          ? authState.email
                          : (user?.email ?? '');
                  final emailPrefix =
                      email.contains('@') ? email.split('@').first : '';
                  final displayName = rawName ??
                      (emailPrefix.isNotEmpty ? emailPrefix : 'Shopper');

                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : 'U',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.hello,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.darkSubtitle
                                    : AppColors.lightSubtitle,
                              ),
                            ),
                            Text(
                              displayName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Notification bell
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.notifications_none_rounded,
                                size: 22,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

              // ─── Search Bar ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: context.read<HomeCubit>().search,
                            decoration: InputDecoration(
                              hintText: AppStrings.searchProducts,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.darkSubtitle
                                    : AppColors.lightSubtitle,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.lightSubtitle,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── Content ─────────────────────────────────────────────────
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            PromoBannerCarousel(),
                            SizedBox(height: 24),
                            ProductGridShimmer(),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is HomeError) {
                    return SliverFillRemaining(
                      child: AppErrorWidget(
                        message: state.message,
                        onRetry: () =>
                            context.read<HomeCubit>().loadProducts(),
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        // ─── Categories ──────────────────────────────────────
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final cat = state.categories[index];
                              return CategoryChip(
                                category: cat,
                                isSelected:
                                    state.selectedCategory == cat,
                                onTap: () => context
                                    .read<HomeCubit>()
                                    .filterByCategory(cat),
                              );
                            },
                          ),
                        ),

                        // ─── Promo Banners ────────────────────────────────────
                        const SizedBox(height: 20),
                        const PromoBannerCarousel(),

                        // ─── Section Header ───────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.popularProducts,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context
                                    .read<HomeCubit>()
                                    .filterByCategory('all'),
                                child: Text(
                                  AppStrings.seeAll,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ─── Product Grid ─────────────────────────────────────
                        if (state.filteredProducts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(48),
                            child: Center(
                              child: Text(
                                'No products found',
                                style: GoogleFonts.poppins(
                                  color: isDark
                                      ? AppColors.darkSubtitle
                                      : AppColors.lightSubtitle,
                                ),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.70,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: state.filteredProducts.length,
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: state.filteredProducts[index],
                                );
                              },
                            ),
                          ),
                      ]),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

