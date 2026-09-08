// lib/features/product/cubit/product_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';
import 'product_state.dart';

/// Cubit for the Product Detail screen.
class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._productService) : super(const ProductInitial());

  final ProductService _productService;

  /// Loads full product details and reviews for the given [productId].
  Future<void> loadProduct(int productId) async {
    emit(const ProductLoading());
    try {
      final product = await _productService.fetchProductById(productId);
      final reviews = await _productService.fetchProductReviews(productId);
      emit(ProductLoaded(product: product, reviews: reviews));
    } catch (e) {
      emit(const ProductError(message: 'Failed to load product details.'));
    }
  }
}

/// Cubit for the Manage Products screen (add / delete).
class ManageProductsCubit extends Cubit<ManageProductsState> {
  ManageProductsCubit(this._productService)
      : super(const ManageProductsInitial());

  final ProductService _productService;
  final List<ProductModel> _localProducts = [];

  /// Loads a subset of products to manage.
  Future<void> loadProducts() async {
    emit(const ManageProductsLoading());
    try {
      final products = await _productService.fetchAllProducts(limit: 20);
      _localProducts
        ..clear()
        ..addAll(products);
      emit(ManageProductsLoaded(products: List.from(_localProducts)));
    } catch (e) {
      emit(const ManageProductsError(message: 'Failed to load products.'));
    }
  }

  /// Adds a new product via DummyJSON POST.
  Future<void> addProduct({
    required String title,
    required double price,
    required String description,
    required String category,
    required String brand,
  }) async {
    emit(const ManageProductsLoading());
    try {
      final newProduct = await _productService.addProduct(
        title: title,
        price: price,
        description: description,
        category: category,
        brand: brand,
      );
      _localProducts.insert(0, newProduct);
      emit(ManageProductsActionSuccess(
        message: 'Product "${newProduct.title}" added successfully!',
        products: List.from(_localProducts),
      ));
    } catch (e) {
      emit(const ManageProductsError(message: 'Failed to add product.'));
    }
  }

  /// Deletes a product by [productId] via DummyJSON DELETE.
  Future<void> deleteProduct(int productId) async {
    final previousProducts = List.from(_localProducts);
    // Optimistically remove.
    _localProducts.removeWhere((p) => p.id == productId);
    emit(ManageProductsLoaded(products: List.from(_localProducts)));
    try {
      await _productService.deleteProduct(productId);
      emit(ManageProductsActionSuccess(
        message: 'Product deleted successfully.',
        products: List.from(_localProducts),
      ));
    } catch (_) {
      // Restore on failure.
      _localProducts
        ..clear()
        ..addAll(previousProducts.cast<ProductModel>());
      emit(ManageProductsError(
        message: 'Failed to delete product.',
      ));
    }
  }
}

