import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/features/home/data/models/course_model.dart';

class HomeRepo {
  List<CourseModel> courses = [];
  Future<Either<String, List<CourseModel>>> getCourses() async {
    try {
      courses = await SupabaseService.getCourseList();
      return right(courses);
    } catch (e) {
      return left(e.toString());
    }
  }
}
