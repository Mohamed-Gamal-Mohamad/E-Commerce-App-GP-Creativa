// lib/features/cart/cubit/cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';
import 'cart_state.dart';

/// Cubit managing the shopping cart state in memory.
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  // ─── Add to Cart ─────────────────────────────────────────────────────────

  /// Adds a [product] to the cart. If it already exists, increments quantity.
  void addToCart(ProductModel product) {
    final items = List<CartItemModel>.from(state.items);
    final existingIndex = items.indexWhere((i) => i.product.id == product.id);

    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + 1,
      );
    } else {
      items.add(CartItemModel(product: product, quantity: 1));
    }

    emit(state.copyWith(items: items));
  }

  // ─── Remove from Cart ─────────────────────────────────────────────────────

  /// Removes the item with [productId] from the cart entirely.
  void removeFromCart(int productId) {
    final items = state.items.where((i) => i.product.id != productId).toList();
    emit(state.copyWith(items: items));
  }

  // ─── Increment Quantity ───────────────────────────────────────────────────

  /// Increments the quantity of the item with [productId] by 1.
  void incrementQuantity(int productId) {
    final items = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: items));
  }

  // ─── Decrement Quantity ───────────────────────────────────────────────────

  /// Decrements the quantity of the item with [productId].
  /// Removes the item if quantity reaches 0.
  void decrementQuantity(int productId) {
    final items = <CartItemModel>[];
    for (final item in state.items) {
      if (item.product.id == productId) {
        if (item.quantity > 1) {
          items.add(item.copyWith(quantity: item.quantity - 1));
        }
        // else: drop the item (quantity = 0)
      } else {
        items.add(item);
      }
    }
    emit(state.copyWith(items: items));
  }

  // ─── Clear Cart ───────────────────────────────────────────────────────────

  /// Removes all items from the cart.
  void clearCart() => emit(const CartState());
}

