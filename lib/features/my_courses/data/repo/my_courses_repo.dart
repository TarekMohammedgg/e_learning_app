import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/features/home/data/models/course_model.dart';

class MyCoursesRepo {
  Future<Either<String, List<CourseModel>>> getMyCoursesList() async {
    try {
      final courses = await SupabaseService.getMyCourses();
      return right(courses);
    } catch (e) {
      return left(e.toString());
    }
  }
}
