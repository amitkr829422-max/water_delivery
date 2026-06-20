import '../data/delivery_repository_impl.dart';
import '../data/order_model.dart';

class GetPendingOrdersUseCase {
  final DeliveryRepositoryImpl repository;

  GetPendingOrdersUseCase({required this.repository});

  // यह फ़ंक्शन रिपॉजिटरी से पेंडिंग ऑर्डर्स की लिस्ट लाएगा
  Future<List<OrderModel>> call() async {
    return await repository.getPendingOrders();
  }
}
