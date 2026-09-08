// lib/features/home/views/widgets/promo_banner.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';

/// Data model for a single promotional banner.
class PromoBannerData {
  final String badge;
  final String title;
  final String subtitle;
  final Color startColor;
  final Color endColor;
  final IconData icon;

  const PromoBannerData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.startColor,
    required this.endColor,
    required this.icon,
  });
}

/// The carousel of promotional banners shown at the top of the Home screen.
class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({super.key});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  int _currentIndex = 0;

  final List<PromoBannerData> _banners = const [
    PromoBannerData(
      badge: '40% OFF',
      title: 'Mega Tech Sale',
      subtitle: 'Up to 40% off headphones & wearables',
      startColor: Color(0xFFF97316),
      endColor: Color(0xFFFB923C),
      icon: Icons.headphones_rounded,
    ),
    PromoBannerData(
      badge: 'NEW ARRIVALS',
      title: 'Fashion Week',
      subtitle: 'Explore the latest styles & trends',
      startColor: Color(0xFF7C3AED),
      endColor: Color(0xFF9D5CFF),
      icon: Icons.checkroom_rounded,
    ),
    PromoBannerData(
      badge: 'FREE SHIPPING',
      title: 'Home Essentials',
      subtitle: 'Free delivery on orders over \$50',
      startColor: Color(0xFF059669),
      endColor: Color(0xFF34D399),
      icon: Icons.chair_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Carousel ─────────────────────────────────────────────────────────
        CarouselSlider.builder(
          itemCount: _banners.length,
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.92,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (i, _) => setState(() => _currentIndex = i),
          ),
          itemBuilder: (context, index, _) {
            final banner = _banners[index];
            return _BannerCard(banner: banner);
          },
        ),

        const SizedBox(height: 12),

        // ─── Dot Indicator ────────────────────────────────────────────────────
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: _banners.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: AppColors.primary,
            dotColor: AppColors.primaryLight,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}

/// A single gradient promotional banner card.
class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final PromoBannerData banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [banner.startColor, banner.endColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // ─── Background Circle Decoration ────────────────────────────────
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ─── Content ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          banner.badge,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Title
                      Text(
                        banner.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        banner.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Icon ─────────────────────────────────────────────────
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(banner.icon, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

