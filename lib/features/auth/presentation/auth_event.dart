abstract class AuthEvent {}

// 1. जब यूज़र फ़ोन नंबर डालकर "Send OTP" बटन दबाएगा
class SendOTPEvent extends AuthEvent {
  final String phoneNumber;
  SendOTPEvent({required this.phoneNumber});
}

// 2. जब यूज़र OTP कोड और अपनी डिटेल्स डालकर "Verify" बटन दबाएगा
class VerifyOTPEvent extends AuthEvent {
  final String smsCode;
  final String name;
  final String phoneNumber;
  final String role; // customer, delivery, admin

  VerifyOTPEvent({
    required this.smsCode,
    required this.name,
    required this.phoneNumber,
    required this.role,
  });
}
