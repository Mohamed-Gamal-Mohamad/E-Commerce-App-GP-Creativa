// lib/features/cart/cubit/cart_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/models/cart_item_model.dart';

/// State for the shopping cart.
class CartState extends Equatable {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  /// Total number of items (sum of quantities).
  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  /// Total price of all items in cart.
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

