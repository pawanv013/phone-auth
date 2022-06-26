import 'package:firebase_auth/firebase_auth.dart';

import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitialState()) {
    late User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthLoggedInState(currentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }
  late String _verificationId;

  void sendOtp(String phoneNumber) async {
    emit(AuthLoaddingState());
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        emit(AuthCodeSendState());
      },
      verificationCompleted: (PhoneAuthCredential) {
        signInWithOtp(PhoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(AuthErrorState(error.message.toString()));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOtp(String otp) async {
    emit(AuthLoaddingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    signInWithOtp(credential);
  }

  void signInWithOtp(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      emit(
        AuthErrorState(e.message.toString()),
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
