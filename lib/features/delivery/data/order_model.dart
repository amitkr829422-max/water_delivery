import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String customerId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String deliveryAddress;
  final String status; // pending, delivered, cancelled
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.status,
    required this.createdAt,
  });

  // Firestore से ऑर्डर डेटा रीड करने के लिए
  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      customerId: map['customerId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      deliveryAddress: map['deliveryAddress'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
