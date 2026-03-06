import 'package:e_learning_app/features/course_details/data/repo/course_details_repo.dart';
import 'package:e_learning_app/features/course_details/presentation/cubit/course_details_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsStates> {
  CourseDetailsCubit(this.repo) : super(CourseDetailsInitial());
  final CourseDetailsRepo repo;

  Future enrollInCourse({required String courseId}) async {
    emit(CourseDetailsLoading());
    final result = await repo.enrollInCourse(courseId: courseId);
    result.fold(
      (error) => emit(CourseDetailsError(error)),
      (r) => emit(CourseDetailsSuccess()),
    );
  }

  Future checkEnrollment({
    required String courseId,
  }) async {
    emit(CourseDetailsLoading());
    final result = await repo.checkEnrollment(
      courseId: courseId,
    );
    result.fold(
      (error) => emit(CourseDetailsError(error)),
      (r) => emit(r ? AlreadyEnrolled() : NotEnrolled()),
    );
  }
} 
