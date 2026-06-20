import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class AuthRepositoryImpl {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  // 1. फ़ोन नंबर पर OTP भेजना
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ऑटोमैटिक वेरिफिकेशन (अगर फ़ोन खुद कोड रीड कर ले)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message ?? 'Verification Failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // 2. OTP को वेरिफाई करके लॉगिन करना
  Future<UserCredential> verifyOTP({required String smsCode}) async {
    if (_verificationId == null) {
      throw Exception('Verification ID not found. Send OTP first.');
    }
    
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );
    
    return await _auth.signInWithCredential(credential);
  }

  // 3. नए यूज़र का डेटा Firestore में सेव करना (रोल के साथ)
  Future<void> saveUserData({
    required String uid,
    required String name,
    required String phoneNumber,
    required String role,
  }) async {
    UserModel user = UserModel(
      uid: uid,
      phoneNumber: phoneNumber,
      name: name,
      role: role,
    );

    await _firestore.collection('users').doc(uid).set(user.toMap());
  }
}
