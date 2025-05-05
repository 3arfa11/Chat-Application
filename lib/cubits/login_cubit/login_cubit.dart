import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  bool isLoading = false;
  bool obSecureText = false;

  void toggleObSecureText() {
    obSecureText = !obSecureText;
    emit(LoginInitial());
  }

  void loginUser({required String email, required String password}) async {
    emit(LoginLoading());

    // Simulate a network call
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        emit(LoginFailure("Invalid Credential"));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure("Wrong Password"));
        // print('Wrong password provided for that user.');
      }
    } catch (e) {
      emit(LoginFailure("Something went wrong"));
    }
  }
}
