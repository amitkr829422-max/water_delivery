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
      ],
      child: MaterialApp(
        title: 'Water Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        // अभी के लिए हम सीधे CustomerHomeScreen() पर रख रहे हैं ताकि आप यूआई देख सकें
        // बाद में इसे लॉगिन स्क्रीन से कंडीशनल नेविगेट करेंगे
        home: const CustomerHomeScreen(), 
      ),
    );
  }
}
}

