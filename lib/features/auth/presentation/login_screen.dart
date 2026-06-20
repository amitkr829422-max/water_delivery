import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import '../../customer/presentation/customer_home_screen.dart';
import '../../delivery/presentation/delivery_home_screen.dart';
import '../../admin/presentation/admin_home_screen.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OTPSentSuccessState) {
            setState(() {
              _isOtpSent = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 OTP सफलतापूर्वक भेज दिया गया है!'), backgroundColor: Colors.green),
            );
          } else if (state is AuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('👋 स्वागत है! आपका रोल: ${state.role.toUpperCase()}'), backgroundColor: Colors.green),
            );

            // 🌟 रोल के हिसाब से सही स्क्रीन पर नेविगेट करना
            Widget targetScreen;
            if (state.role == 'admin') {
              targetScreen = const AdminHomeScreen();
            } else if (state.role == 'delivery') {
              targetScreen = const DeliveryHomeScreen();
            } else {
              targetScreen = const CustomerHomeScreen(); // डिफ़ॉल्ट कस्टमर
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.water_drop_rounded, size: 80, color: AppColors.primaryLight),
                const SizedBox(height: 16),
                const Text(
                  'Water Delivery App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
                ),
                const SizedBox(height: 32),
                
                // फोन नंबर इनपुट फ़ील्ड
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !_isOtpSent && state is! AuthLoadingState,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixText: '+91 ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                  ),
                ),
                const SizedBox(height: 16),

                // ओटीपी इनपुट फ़ील्ड (सिर्फ तब दिखेगा जब ओटीपी चला जाएगा)
                if (_isOtpSent) ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    enabled: state is! AuthLoadingState,
                    decoration: InputDecoration(
                      labelText: 'Enter 6-Digit OTP',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // एक्शन बटन
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: state is AuthLoadingState
                        ? null
                        : () {
                            if (!_isOtpSent) {
                              if (_phoneController.text.length == 10) {
                                context.read<AuthBloc>().add(SendOTPEvent(phoneNumber: '+91${_phoneController.text}'));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('कृपया सही 10-अंकीय फोन नंबर डालें।'), backgroundColor: AppColors.error),
                                );
                              }
                            } else {
                              if (_otpController.text.length == 6) {
                                context.read<AuthBloc>().add(VerifyOTPEvent(
                                  phoneNumber: '+91${_phoneController.text}',
                                  otp: _otpController.text,
                                ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('कृपया 6-अंकीय OTP डालें।'), backgroundColor: AppColors.error),
                                );
                              }
                            }
                          },
                    child: state is AuthLoadingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isOtpSent ? 'Verify & Login' : 'Send OTP',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

