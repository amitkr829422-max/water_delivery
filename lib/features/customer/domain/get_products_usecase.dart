import '../data/customer_repository_impl.dart';
import '../data/product_model.dart';

class GetProductsUseCase {
  final CustomerRepositoryImpl repository;

  GetProductsUseCase({required this.repository});

  // यह फ़ंक्शन रिपॉजिटरी से प्रोडक्ट्स की लिस्ट लाकर ब्लॉक (Bloc) को देगा
  Future<List<ProductModel>> call() async {
    return await repository.getProducts();
  }
}
