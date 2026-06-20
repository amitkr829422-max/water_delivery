import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../domain/send_otp_usecase.dart';
import '../domain/verify_otp_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOTPUseCase sendOTPUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;

  AuthBloc({
    required this.sendOTPUseCase,
    required this.roleBasedVerifyOTPUseCase, // ध्यान रखें, इसे हम शॉर्ट में verifyOTPUseCase ही कहेंगे
  }) : verifyOTPUseCase = roleBasedVerifyOTPUseCase, 
       super(AuthInitial()) {
    
    // 1. जब SendOTPEvent ट्रिगर होगा
    on<SendOTPEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await sendOTPUseCase.call(
          phoneNumber: event.phoneNumber,
          onCodeSent: (verificationId) {
            emit(OTPSentState(verificationId: verificationId));
          },
          onVerificationFailed: (errorMessage) {
            emit(AuthErrorState(errorMessage: errorMessage));
          },
        );
      } catch (e) {
        emit(AuthErrorState(errorMessage: e.toString()));
      }
    });

    // 2. 当 VerifyOTPEvent ट्रिगर होगा
    on<VerifyOTPEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await verifyOTPUseCase.call(
          smsCode: event.smsCode,
          name: event.name,
          phoneNumber: event.phoneNumber,
          role: event.role,
        );
        
        if (user != null) {
          emit(AuthSuccessState());
        } else {
          emit(AuthErrorState(errorMessage: "लॉगिन विफल रहा। कृपया दोबारा प्रयास करें।"));
        }
      } catch (e) {
        emit(AuthErrorState(errorMessage: e.toString()));
      }
    });
  }
}
