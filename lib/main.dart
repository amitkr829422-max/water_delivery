import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/config/theme.dart';
// Auth Imports
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/domain/send_otp_usecase.dart';
import 'features/auth/domain/verify_otp_usecase.dart';
import 'features/auth/presentation/auth_bloc.dart';
import 'features/auth/presentation/login_screen.dart';
// Customer Imports
import 'features/customer/data/customer_repository_impl.dart';
import 'features/customer/domain/get_products_usecase.dart';
import 'features/customer/presentation/customer_bloc.dart';
import 'features/customer/presentation/customer_home_screen.dart';
// Delivery Imports
import 'features/delivery/data/delivery_repository_impl.dart';
import 'features/delivery/domain/get_pending_orders_usecase.dart';
import 'features/delivery/domain/mark_order_delivered_usecase.dart';
import 'features/delivery/presentation/delivery_bloc.dart';
import 'features/delivery/presentation/delivery_home_screen.dart';
// Admin Imports
import 'features/admin/data/admin_repository_impl.dart';
import 'features/admin/domain/add_product_usecase.dart';
import 'features/admin/domain/update_product_usecase.dart';
import 'features/admin/domain/delete_product_usecase.dart';
import 'features/admin/presentation/admin_bloc.dart';
import 'features/admin/presentation/admin_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WaterDeliveryApp());
}

class WaterDeliveryApp extends StatelessWidget {
  const WaterDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // रिपॉजिटरीज़ का इंस्टेंस बनाना
    final authRepository = AuthRepositoryImpl();
    final customerRepository = CustomerRepositoryImpl();
    final deliveryRepository = DeliveryRepositoryImpl();
    final adminRepository = AdminRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            sendOTPUseCase: SendOTPUseCase(repository: authRepository),
            roleBasedVerifyOTPUseCase: VerifyOTPUseCase(repository: authRepository),
          ),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => CustomerBloc(
            getProductsUseCase: GetProductsUseCase(repository: customerRepository),
          ),
        ),
        BlocProvider<DeliveryBloc>(
          create: (context) => DeliveryBloc(
            getPendingOrdersUseCase: GetPendingOrdersUseCase(repository: deliveryRepository),
            markOrderDeliveredUseCase: MarkOrderDeliveredUseCase(repository: deliveryRepository),
          ),
        ),
        BlocProvider<AdminBloc>(
          create: (context) => AdminBloc(
            addProductUseCase: AddProductUseCase(repository: adminRepository),
            updateProductUseCase: UpdateProductUseCase(repository: adminRepository),
            deleteProductUseCase: DeleteProductUseCase(repository: adminRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Water Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        // अभी के लिए सीधे AdminHomeScreen() पर रख रहे हैं ताकि आप इसकी टेस्टिंग कर सकें
        home: const AdminHomeScreen(), 
      ),
    );
  }
}

