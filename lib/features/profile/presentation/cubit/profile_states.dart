import 'package:e_learning_app/features/profile/data/model/user_model.dart';

abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

// Get user data states
class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final userModel userData;
  ProfileSuccessState({required this.userData});
}

class ProfileErrorState extends ProfileStates {
  final String message;
  ProfileErrorState({required this.message});
}

// Logout states
class LogoutLoadingState extends ProfileStates {}

class LogoutSuccessState extends ProfileStates {}

class LogoutFailureState extends ProfileStates {
  final String errMsg;
  LogoutFailureState({required this.errMsg});
}
