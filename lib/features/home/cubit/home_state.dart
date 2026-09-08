// lib/features/home/cubit/home_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/models/product_model.dart';

/// States for the Home screen (product list + category filter).
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading all products for the first time.
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Products and categories loaded successfully.
class HomeLoaded extends HomeState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<String> categories;
  final String selectedCategory;

  const HomeLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.categories,
    required this.selectedCategory,
  });

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        categories,
        selectedCategory,
      ];

  HomeLoaded copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<String>? categories,
    String? selectedCategory,
  }) {
    return HomeLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// An error occurred while loading.
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

