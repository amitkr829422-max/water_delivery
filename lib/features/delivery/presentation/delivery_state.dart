import '../data/order_model.dart';

abstract class DeliveryState {}

// 1. शुरुआती स्थिति (Initial State)
class DeliveryInitial extends DeliveryState {}

// 2. लोडिंग स्थिति (जब Firestore से ऑर्डर्स आ रहे हों या स्टेटस अपडेट हो रहा हो)
class DeliveryLoading extends DeliveryState {}

// 3. डेटा लोड सक्सेस स्थिति (जब पेंडिंग ऑर्डर्स सफलतापूर्वक मिल जाएं)
class PendingOrdersLoadedState extends DeliveryState {
  final List<OrderModel> orders;
  PendingOrdersLoadedState({required this.orders});
}

// 4. ऑर्डर सफलतापूर्वक डिलीवर मार्क होने की स्थिति
class OrderMarkedSuccessState extends DeliveryState {}

// 5. एरर स्थिति (अगर कोई नेटवर्क या डेटाबेस एरर आए)
class DeliveryErrorState extends DeliveryState {
  final String errorMessage;
  DeliveryErrorState({required this.errorMessage});
}
