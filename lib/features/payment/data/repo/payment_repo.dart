import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';

class PaymentRepo {
  /// Dummy payment processing - simulates a 2-second network call
  /// On success, enrolls the user in the course
  Future<Either<String, void>> processPayment({
    required String courseId,
  }) async {
    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // After successful payment, enroll the user in the course
      await SupabaseService.enrollInCourse(
        courseId: courseId,
        userId: SupabaseService.user!.id,
      );

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }
}
