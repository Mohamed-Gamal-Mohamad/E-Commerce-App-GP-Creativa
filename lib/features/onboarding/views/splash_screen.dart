// lib/features/onboarding/views/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/shared_prefs_helper.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../../auth/views/login_screen.dart';
import '../../../app/main_shell.dart';
import 'onboarding_screen.dart';

/// Animated splash screen that handles routing logic:
/// - First launch → Onboarding
/// - Returning logged-out user → Login
/// - Returning logged-in user → MainShell
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ─── Animation Controllers ──────────────────────────────────────────────────
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _dotsController;

  // ─── Logo Animations ────────────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // ─── Text / Tagline Animations ──────────────────────────────────────────────
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  // ─── Dots (loading indicator) ───────────────────────────────────────────────
  late final Animation<double> _dot1;
  late final Animation<double> _dot2;
  late final Animation<double> _dot3;

  @override
  void initState() {
    super.initState();

    // Logo: scale + fade in over 900 ms with elastic bounce.
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text: slides up + fades in after a short delay.
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // Dots: sequential pulse loop.
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _dot1 = _buildDotAnim(0.0, 0.33);
    _dot2 = _buildDotAnim(0.2, 0.53);
    _dot3 = _buildDotAnim(0.4, 0.73);

    // Sequence: logo → text → navigate.
    _logoController.forward().then((_) {
      _textController.forward();
    });

    Future.delayed(const Duration(milliseconds: 2600), _navigate);
  }

  Animation<double> _buildDotAnim(double start, double end) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: Interval(start, end, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  void _navigate() {
    if (!mounted) return;
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(_fadeRoute(const MainShell()));
        } else if (state is AuthUnauthenticated) {
          if (!SharedPrefsHelper.hasSeenOnboarding) {
            Navigator.of(context)
                .pushReplacement(_fadeRoute(const OnboardingScreen()));
          } else {
            Navigator.of(context)
                .pushReplacement(_fadeRoute(const LoginScreen()));
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF8C38), // warm bright orange
                AppColors.primary, // #F97316
                Color(0xFFEA580C), // deep burnt orange
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // ─── Decorative Circles ───────────────────────────────────────
                Positioned(
                  top: -60,
                  right: -60,
                  child: _decorCircle(220, Colors.white.withValues(alpha: 0.07)),
                ),
                Positioned(
                  bottom: 80,
                  left: -80,
                  child: _decorCircle(280, Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 140,
                  left: -40,
                  child: _decorCircle(120, Colors.white.withValues(alpha: 0.06)),
                ),

                // ─── Main Content ─────────────────────────────────────────────
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: _buildLogoCard(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // App name + tagline
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: _buildBranding(),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Pulsing Dots Loader ──────────────────────────────────────
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: _buildDotsLoader(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Logo Card ──────────────────────────────────────────────────────────────

  Widget _buildLogoCard() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 36,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.25),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            'assets/images/app_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // ─── Branding Text ──────────────────────────────────────────────────────────

  Widget _buildBranding() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.appName,
          style: GoogleFonts.poppins(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Text(
            AppStrings.appTagline,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Pulsing Dots Indicator ─────────────────────────────────────────────────

  Widget _buildDotsLoader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(_dot1),
        const SizedBox(width: 8),
        _buildDot(_dot2),
        const SizedBox(width: 8),
        _buildDot(_dot3),
      ],
    );
  }

  Widget _buildDot(Animation<double> scaleAnim) {
    return AnimatedBuilder(
      animation: scaleAnim,
      builder: (_, __) {
        return Transform.scale(
          scale: scaleAnim.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Widget _decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  PageRoute _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
