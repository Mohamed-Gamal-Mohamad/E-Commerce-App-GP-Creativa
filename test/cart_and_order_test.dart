// test/cart_and_order_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:store_hub/data/models/cart_item_model.dart';
import 'package:store_hub/data/models/product_model.dart';
import 'package:store_hub/features/cart/cubit/cart_cubit.dart';
import 'package:store_hub/features/orders/cubit/order_cubit.dart';

void main() {
  group('Cart & Order Cubit Tests', () {
    const testProduct = ProductModel(
      id: 101,
      title: 'Wireless Headphones',
      description: 'Noise cancelling headphones',
      category: 'electronics',
      price: 99.99,
      discountPercentage: 10.0,
      rating: 4.8,
      stock: 25,
      brand: 'AudioTech',
      thumbnail: 'https://dummyjson.com/image.png',
      images: ['https://dummyjson.com/image.png'],
    );

    test('CartItemModel inequality when quantity changes', () {
      const item1 = CartItemModel(product: testProduct, quantity: 1);
      final item2 = item1.copyWith(quantity: 2);

      expect(item1 == item2, isFalse,
          reason: 'Item with quantity 2 must not equal item with quantity 1');
      expect(item2.totalPrice, 199.98);
    });

    test('CartCubit increments quantity correctly', () {
      final cartCubit = CartCubit();

      // Add product
      cartCubit.addToCart(testProduct);
      expect(cartCubit.state.items.length, 1);
      expect(cartCubit.state.items.first.quantity, 1);
      expect(cartCubit.state.totalPrice, 99.99);

      // Increment
      cartCubit.incrementQuantity(101);
      expect(cartCubit.state.items.first.quantity, 2);
      expect(cartCubit.state.totalPrice, 199.98);

      // Decrement
      cartCubit.decrementQuantity(101);
      expect(cartCubit.state.items.first.quantity, 1);
      expect(cartCubit.state.totalPrice, 99.99);

      // Clear
      cartCubit.clearCart();
      expect(cartCubit.state.items.isEmpty, isTrue);
    });

    test('OrderCubit places order from cart items', () {
      final orderCubit = OrderCubit();
      final initialCount = orderCubit.state.orders.length;

      const item = CartItemModel(product: testProduct, quantity: 2);
      final order = orderCubit.placeOrderFromCart([item], 199.98);

      expect(orderCubit.state.orders.length, initialCount + 1);
      expect(orderCubit.state.orders.first.id, order.id);
      expect(orderCubit.state.orders.first.status, 'Placed');
      expect(orderCubit.state.orders.first.itemCount, 2);
      expect(orderCubit.state.orders.first.total, 199.98);
      expect(orderCubit.state.orders.first.items, contains('Wireless Headphones'));
    });
  });
}
