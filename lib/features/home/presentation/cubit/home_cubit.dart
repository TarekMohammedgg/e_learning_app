import 'package:e_learning_app/features/home/data/models/course_model.dart';
import 'package:e_learning_app/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/features/home/presentation/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo homeRepo;
  HomeCubit(this.homeRepo) : super(InitialHomeState());

  List<CourseModel> _allCourses = [];

  Future<void> getCourses() async {
    emit(HomeLoadingState());
    final courses = await homeRepo.getCourses();
    courses.fold((l) => emit(HomeErrorState(message: l)), (r) {
      _allCourses = r;
      emit(HomeSuccessState(courses: r));
    });
  }

  void searchCourses(String query) {
    if (query.isEmpty) {
      emit(HomeSuccessState(courses: _allCourses));
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filteredCourses = _allCourses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.desc.toLowerCase().contains(lowerQuery) ||
          course.tag.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(HomeSuccessState(courses: filteredCourses));
  }
}
