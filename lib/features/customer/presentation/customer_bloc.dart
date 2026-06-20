import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';
import '../domain/get_products_usecase.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetProductsUseCase getProductsUseCase;

  CustomerBloc({required this.getProductsUseCase}) : super(CustomerInitial()) {
    
    // जब LoadProductsEvent ट्रि格 होगा (यानी स्क्रीन लोड होगी)
    on<LoadProductsEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        // UseCase के ज़रिए Firestore से डेटा मंगाना
        final products = await getProductsUseCase.call();
        emit(ProductsLoadedState(products: products));
      } catch (e) {
        emit(CustomerErrorState(errorMessage: e.toString()));
      }
    });
  }
}
