import '../data/auth_repository_impl.dart';

class SendOTPUseCase {
  final AuthRepositoryImpl repository;

  SendOTPUseCase({required this.repository});

  // यह फ़ंक्शन ओटीपी भेजने के लॉजिक को ट्रिगर करेगा
  Future<void> call({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    return await repository.sendOTP(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
    );
  }
}
