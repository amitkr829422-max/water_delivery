import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class CustomerRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Firestore से सभी उपलब्ध प्रोडक्ट्स (Water Jars) की लिस्ट लाना
  Future<List<ProductModel>> getProducts() async {
    try {
      // 'products' कलेक्शन से केवल वही जार लाएंगे जो उपलब्ध (isAvailable = true) हैं
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('isAvailable', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('प्रोडक्ट्स लोड करने में विफल: ${e.toString()}');
    }
  }

  // 2. नया ऑर्डर प्लेस करना (इसे हम आगे आने वाले स्टेप्स में इस्तेमाल करेंगे)
  Future<void> placeOrder({
    required String customerId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String deliveryAddress,
  }) async {
    try {
      await _firestore.collection('orders').add({
        'customerId': customerId,
        'items': items,
        'totalAmount': totalAmount,
        'deliveryAddress': deliveryAddress,
        'status': 'pending', // शुरुआती स्टेटस हमेशा pending रहेगा
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('ऑर्डर प्लेस करने में विफल: ${e.toString()}');
    }
  }
}
