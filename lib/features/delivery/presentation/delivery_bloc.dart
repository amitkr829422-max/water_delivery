import 'package:flutter_bloc/flutter_bloc.dart';
import 'delivery_event.dart';
import 'delivery_state.dart';
import '../domain/get_pending_orders_usecase.dart';
import '../domain/mark_order_delivered_usecase.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final GetPendingOrdersUseCase getPendingOrdersUseCase;
  final MarkOrderDeliveredUseCase markOrderDeliveredUseCase;

  DeliveryBloc({
    required this.getPendingOrdersUseCase,
    required this.markOrderDeliveredUseCase,
  }) : super(DeliveryInitial()) {
    
    // 1. जब पेंडिंग ऑर्डर्स लोड करने का इवेंट आएगा
    on<LoadPendingOrdersEvent>((event, emit) async {
      emit(DeliveryLoading());
      try {
        final orders = await getPendingOrdersUseCase.call();
        emit(PendingOrdersLoadedState(orders: orders));
      } catch (e) {
        emit(DeliveryErrorState(errorMessage: e.toString()));
      }
    });

    // 2. जब किसी ऑर्डर को डिलीवर मार्क करने का इवेंट आएगा
    on<MarkDeliveredEvent>((event, emit) async {
      emit(DeliveryLoading());
      try {
        await markOrderDeliveredUseCase.call(event.orderId);
        emit(OrderMarkedSuccessState());
        
        // स्टेटस अपडेट होने के बाद लिस्ट को दोबारा ऑटोमैटिक लोड करना
        final orders = await getPendingOrdersUseCase.call();
        emit(PendingOrdersLoadedState(orders: orders));
      } catch (e) {
        emit(DeliveryErrorState(errorMessage: e.toString()));
      }
    });
  }
}
