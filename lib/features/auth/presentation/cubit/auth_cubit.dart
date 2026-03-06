import 'package:dartz/dartz.dart';
import 'package:e_learning_app/features/auth/data/repo/auth_repo.dart';
import 'package:e_learning_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(InitialAuthState());

  Future signin({required String email, required String password}) async {
    emit(LoginLoadingAuthState());
    final Either<String, void> res = await authRepo.signIn(email, password);
    res.fold(
      (error) {
        if (!isClosed) emit(LoginFailureAuthState(errMsg: error.toString()));
      },
      (success) {
        if (!isClosed) emit(LoginSuccessAuthState());
      },
    );
  }

  Future signInWithGoogle() async {
    emit(GoogleLoadingAuthState());
    final Either<String, void> res = await authRepo.signInWithGoogle();
    res.fold(
      (error) {
        if (!isClosed) emit(GoogleFailureAuthState(errMsg: error.toString()));
      },
      (success) {
        if (!isClosed) emit(GoogleSuccessAuthState());
      },
    );
  }

  Future signup({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignUPLoadingAuthState());
    final Either<String, void> res = await authRepo.signUp(
      email,
      password,
      name,
    );
    res.fold(
      (error) {
        if (!isClosed) emit(SignUPFailureAuthState(errMsg: error.toString()));
      },
      (success) {
        if (!isClosed) emit(SignUPSuccessAuthState());
      },
    );
  }
}
