import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/constants/colors.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // डिफ़ॉल्ट रूप से हम रोल 'customer' रख रहे हैं
  String _selectedRole = 'customer'; 

  @override
  void dispose() {
    _otpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('लॉगिन और रजिस्ट्रेशन सफल रहा!')),
            );
            // यहाँ से आगे हम होम स्क्रीन या डैशबोर्ड पर रिडायरेक्ट करेंगे
          } else if (state is AuthErrorState) {
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
                    Text(
                      'वेरिफिकेशन कोड',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'हमने आपके नंबर ${widget.phoneNumber} पर एक 6-अंकों का ओटीपी भेजा है।',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // नाम इनपुट फ़ील्ड (नया यूज़र रजिस्टर करने के लिए)
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                        labelText: 'आपका पूरा नाम',
                        hintText: 'अमित कुमार',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया अपना नाम दर्ज करें';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // रोल चुनने के लिए ड्रॉपडाउन मेनू
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.assignment_ind_outlined),
                        labelText: 'अपना रोल चुनें',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'customer', child: Text('Customer (ग्राहक)')),
                        DropdownMenuItem(value: 'delivery', child: Text('Delivery Boy (वितरक)')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRole = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // ओटीपी इनपुट फ़ील्ड
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 8),
                      decoration: InputDecoration(
                        labelText: '6-डिजिट ओटीपी कोड',
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'कृपया ओटीपी दर्ज करें';
                        }
                        if (value.length != 6) {
                          return 'ओटीपी बिल्कुल 6 अंकों का होना चाहिए';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // सबमिट बटन
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: state is AuthLoading ? null : AppColors.primaryGradient,
                          color: state is AuthLoading ? AppColors.textSecondaryLight.withOpacity(0.2) : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          VerifyOTPEvent(
                                            smsCode: _otpController.text.trim(),
                                            name: _nameController.text.trim(),
                                            phoneNumber: widget.phoneNumber,
                                            role: _selectedRole,
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primaryLight),
                                )
                              : const Text(
                                  'वेरिफाई और लॉगिन करें',
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
