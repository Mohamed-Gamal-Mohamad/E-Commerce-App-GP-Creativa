// lib/features/orders/cubit/order_cubit.dart
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import 'order_state.dart';

export 'order_state.dart';

/// Cubit managing customer orders and checkout history.
class OrderCubit extends Cubit<OrderState> {
  OrderCubit()
      : super(
          const OrderState(
            orders: [
              OrderModel(
                id: 'ORD-98234-SH',
                date: 'Sep 05, 2026',
                status: 'Delivered',
                total: 189.99,
                itemCount: 3,
                items: [
                  'Essence Mascara Lash Princess',
                  'Eyeshadow Palette with Mirror',
                  'Powder Canister',
                ],
              ),
              OrderModel(
                id: 'ORD-87123-SH',
                date: 'Aug 28, 2026',
                status: 'In Transit',
                total: 49.99,
                itemCount: 1,
                items: ['Knoll Saarinen Executive Conference Chair'],
              ),
              OrderModel(
                id: 'ORD-76541-SH',
                date: 'Aug 14, 2026',
                status: 'Delivered',
                total: 120.50,
                itemCount: 2,
                items: ['Calvin Klein CK One', 'Chanel Coco Mademoiselle'],
              ),
            ],
          ),
        );

  /// Places a new order using the current cart items.
  OrderModel placeOrderFromCart(List<CartItemModel> items, double total) {
    final randomNum = 10000 + Random().nextInt(90000);
    final orderId = 'ORD-$randomNum-SH';
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final formattedDate =
        '${months[now.month - 1]} ${now.day.toString().padLeft(2, '0')}, ${now.year}';
    final totalCount = items.fold(0, (sum, item) => sum + item.quantity);
    final itemTitles = items.map((i) => i.product.title).toList();

    final newOrder = OrderModel(
      id: orderId,
      date: formattedDate,
      status: 'Placed',
      total: total,
      itemCount: totalCount,
      items: itemTitles,
    );

    final updatedOrders = [newOrder, ...state.orders];
    emit(state.copyWith(orders: updatedOrders));
    return newOrder;
  }
}
