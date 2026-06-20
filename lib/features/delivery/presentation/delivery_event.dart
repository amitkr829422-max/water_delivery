abstract class DeliveryEvent {}

// 1. जब डिलीवरी स्क्रीन खुलेगी, तब पेंडिंग ऑर्डर्स लोड करने के लिए यह इवेंट ट्रिगर होगा
class LoadPendingOrdersEvent extends DeliveryEvent {}

// 2. जब डिलीवरी बॉय किसी ऑर्डर को 'Delivered' मार्क करेगा, तब यह इवेंट ट्रिगर होगा
class MarkDeliveredEvent extends DeliveryEvent {
  final String orderId;
  MarkDeliveredEvent({required this.orderId});
}
