import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/config/theme.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/domain/send_otp_usecase.dart';
import 'features/auth/domain/verify_otp_usecase.dart';
import 'features/auth/presentation/auth_bloc.dart';
import 'features/auth/presentation/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WaterDeliveryApp());
}

class WaterDeliveryApp extends StatelessWidget {
  const WaterDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // पूरे ऐप को रिपॉजिटरी और ब्लॉक का एक्सेस देना
    final authRepository = AuthRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            sendOTPUseCase: SendOTPUseCase(repository: authRepository),
            roleBasedVerifyOTPUseCase: VerifyOTPUseCase(repository: authRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Water Delivery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(), // ऐप अब सीधे लॉगिन स्क्रीन से शुरू होगा
      ),
    );
  }
}

