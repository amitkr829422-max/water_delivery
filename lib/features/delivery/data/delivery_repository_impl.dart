import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_model.dart';

class DeliveryRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Firestore से केवल Pending ऑर्डर्स की लिस्ट लोड करना
  Future<List<OrderModel>> getPendingOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('पेंडिंग ऑर्डर्स लोड करने में विफल: ${e.toString()}');
    }
  }

  // 2. ऑर्डर का स्टेटस बदलकर 'delivered' मार्क करना
  Future<void> markAsDelivered(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'delivered',
        'deliveredAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('ऑर्डर अपडेट करने में विफल: ${e.toString()}');
    }
  }
}
