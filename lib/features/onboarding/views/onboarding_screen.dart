// lib/features/onboarding/views/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/shared_prefs_helper.dart';
import '../../../core/widgets/custom_button.dart';
import '../../auth/views/login_screen.dart';

/// Data class for each onboarding page.
class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBgColor;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBgColor,
  });
}

/// Three-page onboarding with smooth_page_indicator.
/// Shown only once on first launch.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.explore_rounded,
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
      iconBgColor: AppColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.verified_rounded,
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
      iconBgColor: Color(0xFF7C3AED),
    ),
    _OnboardingPage(
      icon: Icons.local_shipping_rounded,
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
      iconBgColor: Color(0xFF059669),
    ),
  ];

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await SharedPrefsHelper.markOnboardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ─── Skip ────────────────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    AppStrings.skip,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkSubtitle
                          : AppColors.lightSubtitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // ─── Pages ───────────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ─── Illustration Circle ───────────────────────────
                        Container(
                          width: size.width * 0.55,
                          height: size.width * 0.55,
                          decoration: BoxDecoration(
                            color: page.iconBgColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: size.width * 0.32,
                              height: size.width * 0.32,
                              decoration: BoxDecoration(
                                color: page.iconBgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                page.icon,
                                size: size.width * 0.15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // ─── Title ─────────────────────────────────────────
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Subtitle ──────────────────────────────────────
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: isDark
                                ? AppColors.darkSubtitle
                                : AppColors.lightSubtitle,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ─── Bottom Controls ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
              child: Column(
                children: [
                  // ─── Page Indicator ────────────────────────────────────────
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.primaryLight,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ─── Next / Get Started Button ─────────────────────────────
                  CustomButton(
                    label: _currentPage == _pages.length - 1
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    onPressed: _goToNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

