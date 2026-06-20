import 'package:cloud_firestore/cloud_firestore.dart';
import '../../customer/data/product_model.dart';

class AdminRepositoryImpl {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Firestore में नया प्रोडक्ट जोड़ना (Add Product)
  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).set({
        'name': product.name,
        'price': product.price,
        'isAvailable': product.isAvailable,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('प्रोडक्ट जोड़ने में विफलता: ${e.toString()}');
    }
  }

  // 2. पुराने प्रोडक्ट की डिटेल्स अपडेट करना (Update Product)
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).update({
        'name': product.name,
        'price': product.price,
        'isAvailable': product.isAvailable,
      });
    } catch (e) {
      throw Exception('प्रोडक्ट अपडेट करने में विफलता: ${e.toString()}');
    }
  }

  // 3. प्रोडक्ट को डिलीट करना (Delete Product)
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('प्रोडक्ट डिलीट करने में विफलता: ${e.toString()}');
    }
  }
}
