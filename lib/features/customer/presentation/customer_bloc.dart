import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';
import '../domain/get_products_usecase.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetProductsUseCase getProductsUseCase;

  CustomerBloc({required this.getProductsUseCase}) : super(CustomerInitial()) {
    
    // 1. प्रोडक्ट्स लोड करने का लॉजिक (पुराना)
    on<LoadProductsEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        final products = await getProductsUseCase.call();
        emit(ProductsLoadedState(products: products));
      } catch (e) {
        emit(CustomerErrorState(errorMessage: e.toString()));
      }
    });

    // 2. नया लॉजिक: ऑर्डर प्लेस करने का
    on<PlaceOrderEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        // अभी के लिए हम 'dummy_customer_id' यूज़ कर रहे हैं, बाद में इसे Firebase Auth से जोड़ेंगे
        await getProductsUseCase.repository.placeOrder(
          customerId: 'dummy_customer_id',
          items: event.items,
          totalAmount: event.totalAmount,
          deliveryAddress: event.deliveryAddress,
        );
        emit(OrderSuccessState());
      } catch (e) {
        emit(CustomerErrorState(errorMessage: e.toString()));
      }
    });
  }
}

