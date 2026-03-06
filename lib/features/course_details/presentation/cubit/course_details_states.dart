abstract class CourseDetailsStates {}

class CourseDetailsInitial extends CourseDetailsStates {}

class CourseDetailsLoading extends CourseDetailsStates {}

class CourseDetailsSuccess extends CourseDetailsStates {}

class CourseDetailsError extends CourseDetailsStates {
  final String error;
  CourseDetailsError(this.error);
}

class AlreadyEnrolled extends CourseDetailsStates {}

class NotEnrolled extends CourseDetailsStates {}
