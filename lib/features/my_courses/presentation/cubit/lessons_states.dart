import 'package:e_learning_app/features/my_courses/data/model/lesson_model.dart';

abstract class LessonsStates {}

class LessonsInitial extends LessonsStates {}

class LessonsLoading extends LessonsStates {}

class LessonsSuccess extends LessonsStates {
  final List<LessonModel> lessons;
  final int selectedIndex;
  final List<String> completedLessonIds;
  LessonsSuccess(
    this.lessons, {
    this.selectedIndex = 0,
    this.completedLessonIds = const [],
  });
}

class LessonsError extends LessonsStates {
  final String error;
  LessonsError(this.error);
}
