import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_event.dart';
import 'admin_state.dart';
import '../domain/add_product_usecase.dart';
import '../domain/update_product_usecase.dart';
import '../domain/delete_product_usecase.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  AdminBloc({
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(AdminInitial()) {
    
    // 1. नया प्रोडक्ट जोड़ने का लॉजिक
    on<AdminAddProductEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        await addProductUseCase.call(event.product);
        emit(AdminActionSuccessState(message: '🎉 प्रोडक्ट सफलतापूर्वक जोड़ दिया गया है!'));
      } catch (e) {
        emit(AdminErrorState(errorMessage: e.toString()));
      }
    });

    // 2. प्रोडक्ट को अपडेट करने का लॉजिक
    on<AdminUpdateProductEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        await updateProductUseCase.call(event.product);
        emit(AdminActionSuccessState(message: '🔄 प्रोडक्ट सफलतापूर्वक अपडेट कर दिया गया है!'));
      } catch (e) {
        emit(AdminErrorState(errorMessage: e.toString()));
      }
    });

    // 3. प्रोडक्ट को डिलीट करने का लॉजिक
    on<AdminDeleteProductEvent>((event, emit) async {
      emit(AdminLoading());
      try {
        await deleteProductUseCase.call(event.productId);
        emit(AdminActionSuccessState(message: '🗑️ प्रोडक्ट सफलतापूर्वक डिलीट कर दिया गया है!'));
      } catch (e) {
        emit(AdminErrorState(errorMessage: e.toString()));
      }
    });
  }
}
