import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state declaration OTPSentState) {
            // जब OTP चला जाएगा, तो हम यहाँ से OTP वेरिफिकेशन वाली स्क्रीन पर नेविगेट करेंगे
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP सफलतापूर्वक भेजा गया!')),
            );
          } else if (state declaration AuthErrorState) {
            // अगर कोई एरर आता है तो उसे स्क्रीन पर दिखाना
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    // प्रीमियम वॉटर ड्रॉपलेट आइकॉन या लोगो के लिए जगह
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          size: 72,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome to\nWater Delivery',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 32,
                            height: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'अपना फ़ोन नंबर दर्ज करें ताकि हम आगे बढ़ सकें',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),
                    // फ़ोन नंबर इनपुट फ़ील्ड
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Text('+91 ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        hintText: '00000 00000',
                        hintStyle: TextStyle(color: AppColors.textSecondaryLight.withOpacity(0.5), letterSpacing: 1),
                        labelText: 'फ़ोन नंबर',
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया फ़ोन नंबर दर्ज करें';
                        }
                        if (value.length != 10) {
                          return 'फ़ोन नंबर बिल्कुल 10 अंकों का होना चाहिए';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    // प्रीमियम ग्रेडिएंट बटन
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: state declaration AuthLoading ? null : AppColors.primaryGradient,
                          color: state declaration AuthLoading ? AppColors.textSecondaryLight.withOpacity(0.2) : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: state declaration AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    // +91 के साथ नंबर भेजना आवश्यक है Firebase Auth के लिए
                                    final fullNumber = '+91${_phoneController.text.trim()}';
                                    context.read<AuthBloc>().add(SendOTPEvent(phoneNumber: fullNumber));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: state declaration AuthLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primaryLight),
                                )
                              : const Text(
                                  'ओटीपी भेजें',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
