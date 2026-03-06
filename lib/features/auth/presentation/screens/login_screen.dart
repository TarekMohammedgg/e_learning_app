import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_images.dart';
import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/auth/data/repo/auth_repo.dart';
import 'package:e_learning_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_learning_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:e_learning_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:e_learning_app/features/auth/presentation/screens/widgets/custom_btn.dart';
import 'package:e_learning_app/features/auth/presentation/screens/widgets/custom_text_field.dart';
import 'package:e_learning_app/features/auth/presentation/screens/widgets/welcome_section.dart';
import 'package:e_learning_app/features/layout_nav_bottom_bar/presentation/screens/layout_bottom_nav_bar_screen.dart'
    show LayoutBottomNavBarScreen;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepo()),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleEmailSignIn() {
    if (!loginFormKey.currentState!.validate()) return;

    context.read<AuthCubit>().signin(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessAuthState) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Welcome back!')),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.layoutBottomNavBar,
            (route) => false,
          );
        } else if (state is LoginFailureAuthState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMsg), backgroundColor: Colors.red),
          );
        } else if (state is GoogleSuccessAuthState) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Welcome back!')),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.layoutBottomNavBar,
            (route) => false,
          );
        } else if (state is GoogleFailureAuthState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMsg), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isEmailLoading = state is LoginLoadingAuthState;
        final isGoogleLoading = state is GoogleLoadingAuthState;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.signInString, style: AppStyle.bold18),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(AppImages.welcomeImage, fit: BoxFit.contain),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WelcomeSection(),
                          const SizedBox(height: 10),
                          CustomTextFieldSection(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              final emailRegex = RegExp(
                                r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            labelMsg: AppStrings.emailString,
                            controller: emailController,
                            hintText: AppStrings.emailHintMsg,
                            iconprefix: Icons.email,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFieldSection(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password is required';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            labelMsg: AppStrings.passString,
                            controller: passwordController,
                            hintText: AppStrings.passString,
                            iconprefix: Icons.lock_outline,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.forgetpassMsg,
                                style: AppStyle.medium14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: isEmailLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CustomBtn(
                                    onPressed: isGoogleLoading
                                        ? null
                                        : _handleEmailSignIn,
                                    enableImage: false,
                                    title: AppStrings.loginBtnMsg,
                                    forgroundColor: AppColors.btnForground,
                                    backgroundColor: AppColors.btnBackground,
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.continuewith,
                                style: AppStyle.regular14,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: isGoogleLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CustomBtn(
                                    enableImage: true,
                                    image: AppImages.googleImage,
                                    title: "Google",
                                    backgroundColor: Colors.white,
                                    forgroundColor: Colors.black,
                                    onPressed: isEmailLoading
                                        ? null
                                        : () => context
                                              .read<AuthCubit>()
                                              .signInWithGoogle(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.dontHaveAccount),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.signup);
                          },
                          child: const Text(
                            " Sign Up",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
