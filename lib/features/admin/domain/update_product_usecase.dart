import '../../customer/data/product_model.dart';
import '../data/admin_repository_impl.dart';

class UpdateProductUseCase {
  final AdminRepositoryImpl repository;

  UpdateProductUseCase({required this.repository});

  Future<void> call(ProductModel product) async {
    return await repository.updateProduct(product);
  }
}
