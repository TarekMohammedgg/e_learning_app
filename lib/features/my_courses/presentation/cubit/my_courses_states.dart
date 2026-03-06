import 'package:e_learning_app/features/home/data/models/course_model.dart';

abstract class MyCoursesStates {}

class InitialMyCoursesState extends MyCoursesStates {}

class LoadingMyCoursesState extends MyCoursesStates {}

class SuccessMyCoursesState extends MyCoursesStates {
  final List<CourseModel> courses;
  final Map<String, Map<String, int>> progressMap;
  SuccessMyCoursesState({required this.courses, required this.progressMap});
}

class ErrorMyCoursesState extends MyCoursesStates {
  final String error;
  ErrorMyCoursesState({required this.error});
}
