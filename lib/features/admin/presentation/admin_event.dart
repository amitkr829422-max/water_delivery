import '../../customer/data/product_model.dart';

abstract class AdminEvent {}

// 1. नया प्रोडक्ट जोड़ने का इवेंट
class AdminAddProductEvent extends AdminEvent {
  final ProductModel product;
  AdminAddProductEvent({required this.product});
}

// 2. प्रोडक्ट को अपडेट करने का इवेंट
class AdminUpdateProductEvent extends AdminEvent {
  final ProductModel product;
  AdminUpdateProductEvent({required this.product});
}

// 3. प्रोडक्ट को डिलीट करने का इवेंट
class AdminDeleteProductEvent extends AdminEvent {
  final String productId;
  AdminDeleteProductEvent({required this.productId});
}
