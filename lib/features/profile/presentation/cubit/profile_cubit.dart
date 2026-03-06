import 'package:e_learning_app/features/profile/data/repo/profile_repo.dart';
import 'package:e_learning_app/features/profile/presentation/cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getUserData() async {
    emit(ProfileLoadingState());

    final userResult = await profileRepo.getUserData();
    final coursesResult = await profileRepo.getEnrolledCourses();

    userResult.fold(
      (error) {
        if (!isClosed) emit(ProfileErrorState(message: error));
      },
      (userData) {
        final courses = coursesResult.fold(
          (error) => <dynamic>[],
          (courses) => courses,
        );
        if (!isClosed) {
          emit(
            ProfileSuccessState(
              userData: userData,
              enrolledCourses: List.from(courses),
            ),
          );
        }
      },
    );
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await profileRepo.logout();
    result.fold(
      (error) {
        if (!isClosed) emit(LogoutFailureState(errMsg: error));
      },
      (_) {
        if (!isClosed) emit(LogoutSuccessState());
      },
    );
  }
}
