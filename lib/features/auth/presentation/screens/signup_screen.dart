import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_images.dart';
import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/auth/data/repo/auth_repo.dart';
import 'package:e_learning_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:e_learning_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:e_learning_app/features/auth/presentation/screens/login_screen.dart';
import 'package:e_learning_app/features/auth/presentation/screens/widgets/custom_btn.dart';
import 'package:e_learning_app/features/auth/presentation/screens/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthRepo()),
      child: const _SignupScreenBody(),
    );
  }
}

class _SignupScreenBody extends StatefulWidget {
  const _SignupScreenBody();

  @override
  State<_SignupScreenBody> createState() => _SignupScreenBodyState();
}

class _SignupScreenBodyState extends State<_SignupScreenBody> {
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (!signupFormKey.currentState!.validate()) return;

    context.read<AuthCubit>().signup(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: fullNameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SignUPSuccessAuthState) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else if (state is SignUPFailureAuthState) {
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
        final isSignupLoading = state is SignUPLoadingAuthState;
        final isGoogleLoading = state is GoogleLoadingAuthState;

        return Scaffold(
          appBar: AppBar(title: Text("Creat Account", style: AppStyle.bold18)),
          body: SingleChildScrollView(
            child: Form(
              key: signupFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.createAccountMsg),
                    const SizedBox(height: 10),
                    CustomTextFieldSection(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                      labelMsg: AppStrings.fullName,
                      controller: fullNameController,
                      hintText: AppStrings.hintFullName,
                      iconprefix: Icons.person,
                    ),
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
                    SizedBox(height: height * 0.3),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: isSignupLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomBtn(
                              onPressed: isGoogleLoading ? null : _handleSignUp,
                              enableImage: false,
                              title: AppStrings.signUp,
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
                          ? const Center(child: CircularProgressIndicator())
                          : CustomBtn(
                              enableImage: true,
                              image: AppImages.googleImage,
                              title: "Google",
                              backgroundColor: Colors.white,
                              forgroundColor: Colors.black,
                              onPressed: isSignupLoading
                                  ? null
                                  : () => context
                                        .read<AuthCubit>()
                                        .signInWithGoogle(),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.alreadyHaveMsg),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            AppStrings.loginBtnMsg,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
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
