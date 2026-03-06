import 'package:e_learning_app/features/home/data/models/course_model.dart';

abstract class HomeStates {}

class InitialHomeState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<CourseModel> courses;
  HomeSuccessState({required this.courses});
}

class HomeErrorState extends HomeStates {
  final String message;
  HomeErrorState({required this.message});
}
