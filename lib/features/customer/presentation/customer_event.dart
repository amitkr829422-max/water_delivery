import '../data/product_model.dart';

abstract class CustomerEvent {}

// 1. प्रोडक्ट्स लोड करने के लिए पुराना इवेंट
class LoadProductsEvent extends CustomerEvent {}

// 2. नया इवेंट: ऑर्डर प्लेस करने के लिए
class PlaceOrderEvent extends CustomerEvent {
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String deliveryAddress;

  PlaceOrderEvent({
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
  });
}
abstract class CustomerEvent {}

// 1. जब होम स्क्रीन खुलेगी, तब प्रोडक्ट्स लोड करने के लिए यह इवेंट ट्रिगर होगा
class LoadProductsEvent extends CustomerEvent {}
