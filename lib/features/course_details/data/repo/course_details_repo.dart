import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';

class CourseDetailsRepo {
  Future<Either<String, void>> enrollInCourse({
    required String courseId,
  }) async {
    try {
      await SupabaseService.enrollInCourse(
        courseId: courseId,
        userId: SupabaseService.user!.id,
      );
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, bool>> checkEnrollment({
    required String courseId,
  }) async {
    try {
      final res = await SupabaseService.checkEnrollment(
        courseId: courseId,
        userId: SupabaseService.user!.id,
      );
      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }
}
