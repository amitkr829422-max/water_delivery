import '../data/admin_repository_impl.dart';

class DeleteProductUseCase {
  final AdminRepositoryImpl repository;

  DeleteProductUseCase({required this.repository});

  Future<void> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
