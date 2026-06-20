import '../../customer/data/product_model.dart';
import '../data/admin_repository_impl.dart';

class AddProductUseCase {
  final AdminRepositoryImpl repository;

  AddProductUseCase({required this.repository});

  Future<void> call(ProductModel product) async {
    return await repository.addProduct(product);
  }
}
