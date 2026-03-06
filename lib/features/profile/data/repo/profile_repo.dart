import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/features/profile/data/model/user_model.dart';

class ProfileRepo {
  Future<Either<String, userModel>> getUserData() async {
    try {
      final userData = await SupabaseService.getUserData();
      return right(userModel.fromJson(userData));
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> logout() async {
    return await SupabaseService.logout();
  }
}
