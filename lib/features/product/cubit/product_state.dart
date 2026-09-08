// lib/features/product/cubit/product_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/models/product_model.dart';

/// States for the Product Detail screen.
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final ProductModel product;
  final List<ReviewModel> reviews;

  const ProductLoaded({required this.product, required this.reviews});

  @override
  List<Object?> get props => [product, reviews];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── Manage Products States ──────────────────────────────────────────────────

abstract class ManageProductsState extends Equatable {
  const ManageProductsState();

  @override
  List<Object?> get props => [];
}

class ManageProductsInitial extends ManageProductsState {
  const ManageProductsInitial();
}

class ManageProductsLoading extends ManageProductsState {
  const ManageProductsLoading();
}

class ManageProductsLoaded extends ManageProductsState {
  final List<ProductModel> products;

  const ManageProductsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ManageProductsActionSuccess extends ManageProductsState {
  final String message;
  final List<ProductModel> products;

  const ManageProductsActionSuccess({
    required this.message,
    required this.products,
  });

  @override
  List<Object?> get props => [message, products];
}

class ManageProductsError extends ManageProductsState {
  final String message;

  const ManageProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}

