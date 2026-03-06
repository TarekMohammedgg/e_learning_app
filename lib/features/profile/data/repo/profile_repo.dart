import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';

class ProfileRepo {
  Future<Either<String, Map<String, dynamic>>> getUserData() async {
    try {
      final userData = await SupabaseService.getUserData();
      return right(userData);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> logout() async {
    return await SupabaseService.logout();
  }
}
