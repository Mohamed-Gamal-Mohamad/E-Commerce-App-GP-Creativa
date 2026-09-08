// lib/features/wishlist/cubit/wishlist_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/product_model.dart';
import 'wishlist_state.dart';
export 'wishlist_state.dart';

/// Cubit managing saved favorite products in Wishlist.
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  void toggleWishlist(ProductModel product) {
    final currentItems = List<ProductModel>.from(state.items);
    final existsIndex = currentItems.indexWhere((item) => item.id == product.id);

    if (existsIndex >= 0) {
      currentItems.removeAt(existsIndex);
    } else {
      currentItems.add(product);
    }

    emit(state.copyWith(items: currentItems));
  }

  void removeFromWishlist(int productId) {
    final currentItems = List<ProductModel>.from(state.items)
      ..removeWhere((item) => item.id == productId);
    emit(state.copyWith(items: currentItems));
  }

  void clearWishlist() {
    emit(const WishlistState(items: []));
  }
}

