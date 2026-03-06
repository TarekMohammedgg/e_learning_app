import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/features/my_courses/data/repo/lessons_repo.dart';
import 'package:e_learning_app/features/my_courses/presentation/cubit/lessons_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsCubit extends Cubit<LessonsStates> {
  LessonsCubit() : super(LessonsInitial());
  final LessonsRepo _lessonsRepo = LessonsRepo();

  String _courseId = '';

  Future<void> getCourseLessons({required String courseId}) async {
    _courseId = courseId;
    emit(LessonsLoading());
    final result = await _lessonsRepo.getCourseLessons(courseId: courseId);

    // Handle result WITHOUT async inside fold
    if (result.isLeft()) {
      final error = result.fold((l) => l, (r) => '');
      if (isClosed) return;
      emit(LessonsError(error));
      return;
    }

    final lessons = result.fold((l) => null, (r) => r)!;

    // Fetch completed lesson IDs
    List<String> completedIds = [];
    try {
      completedIds = await SupabaseService.getCompletedLessonIds(
        courseId: courseId,
      );
    } catch (_) {}

    if (isClosed) return;
    emit(LessonsSuccess(
      lessons,
      selectedIndex: 0,
      completedLessonIds: completedIds,
    ));
  }

  void selectLesson(int index) {
    final currentState = state;
    if (currentState is LessonsSuccess) {
      emit(LessonsSuccess(
        currentState.lessons,
        selectedIndex: index,
        completedLessonIds: currentState.completedLessonIds,
      ));
    }
  }

  Future<void> markLessonComplete({required String lessonId}) async {
    final currentState = state;
    if (currentState is LessonsSuccess) {
      try {
        await SupabaseService.markLessonComplete(lessonId: lessonId);

        // Add to completed list if not already there
        final updatedIds = List<String>.from(currentState.completedLessonIds);
        if (!updatedIds.contains(lessonId)) {
          updatedIds.add(lessonId);
        }

        if (isClosed) return;
        emit(LessonsSuccess(
          currentState.lessons,
          selectedIndex: currentState.selectedIndex,
          completedLessonIds: updatedIds,
        ));
      } catch (e) {
        // Keep current state, don't break UI
      }
    }
  }
}
