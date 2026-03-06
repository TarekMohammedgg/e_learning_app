import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/course_details/presentation/screens/widgets/course_overview_args.dart';
import 'package:e_learning_app/features/home/data/repo/home_repo.dart';
import 'package:e_learning_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:e_learning_app/features/home/presentation/cubit/home_states.dart';
import 'package:e_learning_app/features/home/presentation/screens/widgets/feature_course_card.dart';
import 'package:e_learning_app/features/home/presentation/screens/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeRepo())..getCourses(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is HomeErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.scaffoldBackground,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.goodMorning,
                    style: AppStyle.medium14.copyWith(
                      color: const Color(0xff0F172A),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    SupabaseService.user!.userMetadata!['name'] ?? '',
                    style: AppStyle.bold24,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    const SearchTextField(
                      hintText: AppStrings.whatDoYouWantToLearn,
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          AppStrings.featuredCourses,
                          style: AppStyle.bold18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (state is HomeLoadingState)
                      const Center(child: CircularProgressIndicator()),
                    if (state is HomeSuccessState)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.courses.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.53,
                            ),
                        itemBuilder: (context, index) {
                          final course = state.courses[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.courseOverview,
                                arguments: CourseOverviewArguments(
                                  image: course.image,
                                  title: course.title,
                                  desc: course.desc,
                                  price: course.price,
                                  courseId: course.id.toString(),
                                ),
                              );
                            },
                            child: FeatureCardItem(
                              imageUrl: course.image,
                              tagText: course.tag,
                              title: course.title,
                              description: course.desc,
                              price: course.price,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
