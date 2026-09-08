// lib/data/services/product_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

/// Service class for all DummyJSON product API calls.
/// Base URL: https://dummyjson.com
class ProductService {
  ProductService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add logging interceptor for debug builds.
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    );
  }

  late final Dio _dio;

  // ─── Fetch All Products ─────────────────────────────────────────────────────

  /// Fetches all products (with pagination support).
  /// [limit] defaults to 100 to load a full catalog.
  Future<List<ProductModel>> fetchAllProducts({int limit = 100}) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {'limit': limit, 'skip': 0},
    );
    final List<dynamic> data = response.data['products'] as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Fetch Products by Category ─────────────────────────────────────────────

  /// Fetches products filtered by [category].
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final response = await _dio.get('/products/category/$category');
    final List<dynamic> data = response.data['products'] as List<dynamic>;
    return data
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Fetch Single Product ───────────────────────────────────────────────────

  /// Fetches full details of a single product by [id].
  Future<ProductModel> fetchProductById(int id) async {
    final response = await _dio.get('/products/$id');
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  // ─── Fetch Product Reviews ──────────────────────────────────────────────────

  /// Fetches reviews for a product by [productId].
  Future<List<ReviewModel>> fetchProductReviews(int productId) async {
    final response = await _dio.get('/products/$productId');
    final data = response.data as Map<String, dynamic>;
    final List<dynamic> reviews =
        data['reviews'] as List<dynamic>? ?? [];
    return reviews
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Fetch Categories ────────────────────────────────────────────────────────

  /// Fetches the list of available product categories.
  Future<List<String>> fetchCategories() async {
    final response = await _dio.get('/products/categories');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((e) {
      if (e is Map<String, dynamic>) {
        return e['slug'] as String? ?? e['name'] as String? ?? '';
      }
      return e.toString();
    }).where((s) => s.isNotEmpty).toList();
  }

  // ─── Add Product (POST) ──────────────────────────────────────────────────────

  /// Adds a new product via POST. Returns the created product.
  /// Note: DummyJSON does not persist new products; this is UI-only.
  Future<ProductModel> addProduct({
    required String title,
    required double price,
    required String description,
    required String category,
    required String brand,
    String? thumbnail,
  }) async {
    final response = await _dio.post(
      '/products/add',
      data: {
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'brand': brand,
        if (thumbnail != null) 'thumbnail': thumbnail,
      },
    );
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  // ─── Delete Product (DELETE) ─────────────────────────────────────────────────

  /// Sends a DELETE request for the product with [id].
  /// Note: DummyJSON does not actually delete; this is a simulation.
  Future<bool> deleteProduct(int id) async {
    final response = await _dio.delete('/products/$id');
    final data = response.data as Map<String, dynamic>;
    return data['isDeleted'] as bool? ?? false;
  }
}
