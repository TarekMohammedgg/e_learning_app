import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/course_details/data/repo/course_details_repo.dart';
import 'package:e_learning_app/features/course_details/presentation/cubit/course_details_cubit.dart';
import 'package:e_learning_app/features/course_details/presentation/cubit/course_details_states.dart';
import 'package:e_learning_app/features/payment/data/model/payment_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseOverviewScreen extends StatelessWidget {
  const CourseOverviewScreen({
    super.key,
    required this.price,
    required this.image,
    required this.title,
    required this.desc,
    required this.courseId,
  });
  final num price;
  final String image;
  final String title;
  final String desc;
  final String courseId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocProvider(
        create: (context) =>
            CourseDetailsCubit(CourseDetailsRepo())
              ..checkEnrollment(courseId: courseId),
        child: BlocConsumer<CourseDetailsCubit, CourseDetailsStates>(
          listener: (context, state) {
            if (state is CourseDetailsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.enrolledSuccessfully),
                  backgroundColor: AppColors.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is CourseDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.errorColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ElevatedButton(
                  onPressed:
                      state is AlreadyEnrolled ||
                          state is CourseDetailsSuccess ||
                          state is CourseDetailsLoading
                      ? null
                      : () {
                          // Navigate to payment screen
                          Navigator.pushNamed(
                            context,
                            Routes.payment,
                            arguments: PaymentArgs(
                              courseTitle: title,
                              coursePrice: price,
                              courseId: courseId,
                              courseImage: image,
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        state is AlreadyEnrolled ||
                            state is CourseDetailsSuccess
                        ? AppColors.disabledColor
                        : AppColors.primaryColor,
                    foregroundColor: AppColors.btnForground,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state is CourseDetailsLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.btnForground,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state is AlreadyEnrolled ||
                                      state is CourseDetailsSuccess
                                  ? AppStrings.alreadyEnrolled
                                  : '${price.toString()} ${AppStrings.currency} - ${AppStrings.enrollNow}',
                              style: AppStyle.bold16.copyWith(
                                color: AppColors.btnForground,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(image),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: AppStyle.bold24.copyWith(color: AppColors.primaryColor),
            ),
            SizedBox(height: 10),
            Text(
              "${price.toString()} ${AppStrings.currency}",
              style: AppStyle.medium14.copyWith(color: AppColors.textDark),
            ),
            SizedBox(height: 10),
            Text(
              AppStrings.description,
              style: AppStyle.bold18.copyWith(color: AppColors.primaryColor),
            ),
            SizedBox(height: 10),
            Text(
              desc,
              style: AppStyle.medium14.copyWith(color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }
}
