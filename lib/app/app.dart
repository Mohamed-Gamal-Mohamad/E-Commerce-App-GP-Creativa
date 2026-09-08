// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/shared_prefs_helper.dart';
import '../data/services/product_service.dart';
import '../features/auth/cubit/auth_cubit.dart';
import '../features/cart/cubit/cart_cubit.dart';
import '../features/home/cubit/home_cubit.dart';
import '../features/onboarding/views/splash_screen.dart';
import '../features/product/cubit/product_cubit.dart';
import '../features/orders/cubit/order_cubit.dart';
import '../features/profile/cubit/theme_cubit.dart';
import '../features/profile/cubit/theme_state.dart';
import '../features/wishlist/cubit/wishlist_cubit.dart';
import 'main_shell.dart';

class StoreHubApp extends StatelessWidget {
  final SharedPrefsHelper prefsHelper;

  const StoreHubApp({
    super.key,
    required this.prefsHelper,
  });

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductService>.value(value: productService),
        RepositoryProvider<SharedPrefsHelper>.value(value: prefsHelper),
      ],
      child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(prefsHelper),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(productService)..loadProducts(),
        ),
        BlocProvider<CartCubit>(
          create: (_) => CartCubit(),
        ),
        BlocProvider<WishlistCubit>(
          create: (_) => WishlistCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(),
        ),
        BlocProvider<ManageProductsCubit>(
          create: (_) => ManageProductsCubit(productService),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'StoreHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
            // SplashScreen handles all routing: first-launch → Onboarding,
            // authenticated → MainShell, otherwise → LoginScreen.
            home: const SplashScreen(),
          );
        },
      ),
    ),
  );
}
}
