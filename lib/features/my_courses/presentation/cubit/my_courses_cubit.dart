import 'package:bloc/bloc.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/features/my_courses/data/repo/my_courses_repo.dart';
import 'package:e_learning_app/features/my_courses/presentation/cubit/my_courses_states.dart';

class MyCoursesCubit extends Cubit<MyCoursesStates> {
  MyCoursesCubit() : super(InitialMyCoursesState());

  final MyCoursesRepo _repo = MyCoursesRepo();

  Future<void> getMyCourses() async {
    emit(LoadingMyCoursesState());
    final result = await _repo.getMyCoursesList();

    // Handle result WITHOUT async inside fold
    if (result.isLeft()) {
      final error = result.fold((l) => l, (r) => '');
      if (isClosed) return;
      emit(ErrorMyCoursesState(error: error));
      return;
    }

    final courses = result.fold((l) => null, (r) => r)!;

    // Fetch progress for each course
    final Map<String, Map<String, int>> progressMap = {};
    for (final course in courses) {
      try {
        final progress = await SupabaseService.getCourseProgress(
          courseId: course.id,
        );
        progressMap[course.id] = progress;
      } catch (_) {
        progressMap[course.id] = {'completed': 0, 'total': 0};
      }
    }

    if (isClosed) return;
    emit(SuccessMyCoursesState(
      courses: courses,
      progressMap: progressMap,
    ));
  }
}
