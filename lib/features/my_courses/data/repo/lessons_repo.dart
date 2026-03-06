import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/features/my_courses/data/model/lesson_model.dart';

class LessonsRepo {
  Future<Either<String, List<LessonModel>>> getCourseLessons({
    required String courseId,
  }) async {
    try {
      final res = await SupabaseService.getCourseLessons(courseId: courseId);
      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }
}
