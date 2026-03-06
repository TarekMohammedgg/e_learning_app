abstract class AuthStates {}

class InitialAuthState extends AuthStates {}

// Login
class LoginSuccessAuthState extends AuthStates {}

class LoginFailureAuthState extends AuthStates {
  final String errMsg;

  LoginFailureAuthState({required this.errMsg});
}

class LoginLoadingAuthState extends AuthStates {}

// sign up

class SignUPSuccessAuthState extends AuthStates {}

class SignUPFailureAuthState extends AuthStates {
  final String errMsg;

  SignUPFailureAuthState({required this.errMsg});
}

class SignUPLoadingAuthState extends AuthStates {}

// Google
class GoogleLoadingAuthState extends AuthStates {}

class GoogleSuccessAuthState extends AuthStates {}

class GoogleFailureAuthState extends AuthStates {
  final String errMsg;
  GoogleFailureAuthState({required this.errMsg});
}
