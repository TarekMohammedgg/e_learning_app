import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';

class AuthRepo {
  Future<Either<String, void>> signInWithGoogle() async {
    return await SupabaseService.signInWithGoogle();
  }

  Future<Either<String, void>> signIn(String email, String password) async {
    return await SupabaseService.signin(email, password);
  }

  Future<Either<String, void>> signUp(
    String email,
    String password,
    String name,
  ) async {
    return await SupabaseService.signup(email, password, name);
  }

  Future<Either<String, void>> saveUserData({
    required String name,
    required String email,
  }) async {
    try {
      await SupabaseService.saveUserData(name: name, email: email);
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> signOut() async {
    await SupabaseService.signOut();
  }
}
