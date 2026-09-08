// lib/features/home/cubit/home_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/product_service.dart';
import 'home_state.dart';

/// Cubit for the Home screen.
/// Manages product list fetching and category-based filtering.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._productService) : super(const HomeInitial());

  final ProductService _productService;

  static const String _allCategory = 'all';

  // ─── Load Products ───────────────────────────────────────────────────────

  /// Fetches all products and extracts unique categories.
  Future<void> loadProducts() async {
    emit(const HomeLoading());
    try {
      final products = await _productService.fetchAllProducts(limit: 100);

      // Extract unique, sorted categories from product data.
      final rawCategories = products
          .map((p) => p.category.toLowerCase())
          .toSet()
          .toList()
        ..sort();

      // Prepend 'All' as the first/default selection.
      final categories = [_allCategory, ...rawCategories];

      emit(HomeLoaded(
        allProducts: products,
        filteredProducts: products,
        categories: categories,
        selectedCategory: _allCategory,
      ));
    } catch (e) {
      emit(HomeError(message: AppStrings.errorOccurred));
    }
  }

  // ─── Filter by Category ──────────────────────────────────────────────────

  /// Filters the product list by [category].
  /// Passing [_allCategory] resets to show all products.
  void filterByCategory(String category) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final filtered = category == _allCategory
        ? currentState.allProducts
        : currentState.allProducts
            .where((p) => p.category.toLowerCase() == category.toLowerCase())
            .toList();

    emit(currentState.copyWith(
      filteredProducts: filtered,
      selectedCategory: category,
    ));
  }

  // ─── Search ──────────────────────────────────────────────────────────────

  /// Filters products by search [query] within the selected category.
  void search(String query) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final sourceList = currentState.selectedCategory == _allCategory
        ? currentState.allProducts
        : currentState.allProducts
            .where((p) =>
                p.category.toLowerCase() ==
                currentState.selectedCategory.toLowerCase())
            .toList();

    final filtered = query.isEmpty
        ? sourceList
        : sourceList
            .where((p) =>
                p.title.toLowerCase().contains(query.toLowerCase()) ||
                p.brand.toLowerCase().contains(query.toLowerCase()))
            .toList();

    emit(currentState.copyWith(filteredProducts: filtered));
  }
}

