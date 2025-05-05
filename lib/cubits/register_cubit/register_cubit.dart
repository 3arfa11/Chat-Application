import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  bool isLoading = false;
  bool obSecureText = false;

  void toggleObSecureText() {
    obSecureText = !obSecureText;
    emit(RegisterInitial());
  }

  void registerUser({required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure("The password provided is too weak."));

        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure('The account already exists for that email.'));

        // print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure("Invalid email!"));
      }
    } on Exception catch (e) {
      emit(RegisterFailure("Something went wrong!"));
    }
  }
}
