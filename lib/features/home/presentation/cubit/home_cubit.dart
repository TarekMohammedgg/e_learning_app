import 'package:e_learning_app/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_app/features/home/presentation/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo homeRepo;
  HomeCubit(this.homeRepo) : super(InitialHomeState());
  Future<void> getCourses() async {
    emit(HomeLoadingState());
    final courses = await homeRepo.getCourses();
    courses.fold(
      (l) => emit(HomeErrorState(message: l)),
      (r) => emit(HomeSuccessState(courses: r)),
    );
  }
}
