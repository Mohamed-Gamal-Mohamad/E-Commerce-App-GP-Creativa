// lib/data/models/order_model.dart
import 'package:equatable/equatable.dart';

/// Represents a customer order in StoreHub.
class OrderModel extends Equatable {
  final String id;
  final String date;
  final String status;
  final double total;
  final int itemCount;
  final List<String> items;

  const OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.itemCount,
    required this.items,
  });

  OrderModel copyWith({
    String? id,
    String? date,
    String? status,
    double? total,
    int? itemCount,
    List<String>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'status': status,
      'total': total,
      'itemCount': itemCount,
      'items': items,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'Placed',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      itemCount: json['itemCount'] as int? ?? 1,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, date, status, total, itemCount, items];
}
