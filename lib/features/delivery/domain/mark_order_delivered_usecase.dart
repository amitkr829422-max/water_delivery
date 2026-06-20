import '../data/delivery_repository_impl.dart';

class MarkOrderDeliveredUseCase {
  final DeliveryRepositoryImpl repository;

  MarkOrderDeliveredUseCase({required this.repository});

  // यह फ़ंक्शन विशिष्ट ऑर्डर को 'delivered' मार्क करने के लिए रिपॉजिटरी को कॉल करेगा
  Future<void> call(String orderId) async {
    return await repository.markAsDelivered(orderId);
  }
}
