import 'package:e_learning_app/features/profile/data/repo/profile_repo.dart';
import 'package:e_learning_app/features/profile/presentation/cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getUserData() async {
    emit(ProfileLoadingState());
    final result = await profileRepo.getUserData();
    result.fold(
      (error) {
        if (!isClosed) emit(ProfileErrorState(message: error));
      },
      (userData) {
        if (!isClosed) emit(ProfileSuccessState(userData: userData));
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
