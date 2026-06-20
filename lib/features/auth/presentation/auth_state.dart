abstract class AuthState {}

// 1. शुरुआती स्थिति (जब लॉगिन स्क्रीन बिल्कुल नई खुलेगी)
class AuthInitial extends AuthState {}

// 2. लोडिंग स्थिति (जब ओटीपी जा रहा हो या वेरिफाई हो रहा हो - स्क्रीन पर Spinner दिखेगा)
class AuthLoading extends AuthState {}

// 3. ओटीपी सेंड स्थिति (जब ओटीपी चला जाएगा और यूज़र को ओटीपी डालने का बॉक्स दिखाना है)
class OTPSentState extends AuthState {
  final String verificationId;
  OTPSentState({required this.verificationId});
}

// 4. लॉगिन सक्सेस स्थिति (जब लॉगिन पूरी तरह सफल हो जाएगा)
class AuthSuccessState extends AuthState {}

// 5. एरर स्थिति (अगर कोई गड़बड़ होती है, जैसे गलत ओटीपी या नेटवर्क एरर)
class AuthErrorState extends AuthState {
  final String errorMessage;
  AuthErrorState({required this.errorMessage});
}
