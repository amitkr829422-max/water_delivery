import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_repository_impl.dart';

class VerifyOTPUseCase {
  final AuthRepositoryImpl repository;

  VerifyOTPUseCase({required this.repository});

  // यह फ़ंक्शन OTP वेरिफाई करेगा और यूज़र मिलने पर उसका डेटाबेस रिकॉर्ड बनाएगा
  Future<User?> call({
    required String smsCode,
    required String name,
    required String phoneNumber,
    required String role, // customer, delivery, admin
  }) async {
    // 1. सबसे पहले Firebase Auth के ज़रिए OTP वेरिफाई करके लॉगिन करें
    UserCredential credential = await repository.verifyOTP(smsCode: smsCode);
    User? user = credential.user;

    // 2. अगर लॉगिन सफल रहा, तो यूज़र का डेटा प्रोफाइल के साथ Firestore में सेव करें
    if (user != null) {
      await repository.saveUserData(
        uid: user.uid,
        name: name,
        phoneNumber: phoneNumber,
        role: role,
      );
    }
    
    return user;
  }
}
