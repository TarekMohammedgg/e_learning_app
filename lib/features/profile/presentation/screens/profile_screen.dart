import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/home/data/models/course_model.dart';
import 'package:e_learning_app/features/profile/data/model/user_model.dart';
import 'package:e_learning_app/features/profile/data/repo/profile_repo.dart';
import 'package:e_learning_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:e_learning_app/features/profile/presentation/cubit/profile_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepo())..getUserData(),
      child: const _ProfileScreenBody(),
    );
  }
}

class _ProfileScreenBody extends StatelessWidget {
  const _ProfileScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile), centerTitle: true),
      body: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          } else if (state is LogoutFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMsg),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileErrorState) {
            return Center(child: Text(state.message));
          } else if (state is ProfileSuccessState) {
            return _buildProfileContent(
              context,
              state.userData,
              state.enrolledCourses,
            );
          } else if (state is LogoutLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    userModel userData,
    List<CourseModel> enrolledCourses,
  ) {
    final name = userData.name;
    final email = userData.email;
    final role = userData.role;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppStyle.bold32.copyWith(color: AppColors.btnForground),
            ),
          ),
          const SizedBox(height: 16),
          Text(name, style: AppStyle.bold24),
          const SizedBox(height: 4),
          Text(email, style: AppStyle.regular14),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(role.toUpperCase(), style: AppStyle.bold10),
          ),

          // Enrolled Courses Section
          const SizedBox(height: 32),
          Row(
            children: [
              Text(AppStrings.enrolledCourses, style: AppStyle.bold18),
              const Spacer(),
              Text('${enrolledCourses.length}', style: AppStyle.medium14),
            ],
          ),
          const SizedBox(height: 12),
          if (enrolledCourses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(AppStrings.noCourses, style: AppStyle.regular14),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: enrolledCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final course = enrolledCourses[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            course.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.progressIndicatorBackground,
                              child: const Icon(
                                Icons.school,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: AppStyle.bold14,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(course.tag, style: AppStyle.regular12),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: AppColors.successColor,
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<ProfileCubit>().logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorColor,
                foregroundColor: AppColors.btnForground,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppStrings.logout,
                style: AppStyle.bold16.copyWith(color: AppColors.btnForground),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
