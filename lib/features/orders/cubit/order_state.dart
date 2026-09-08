// lib/features/orders/cubit/order_state.dart
import 'package:equatable/equatable.dart';
import '../../../data/models/order_model.dart';

/// State for the orders feature.
class OrderState extends Equatable {
  final List<OrderModel> orders;

  const OrderState({this.orders = const []});

  OrderState copyWith({List<OrderModel>? orders}) {
    return OrderState(orders: orders ?? this.orders);
  }

  @override
  List<Object?> get props => [orders];
}
