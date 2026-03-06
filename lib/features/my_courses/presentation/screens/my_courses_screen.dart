import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/core/widgets/custom_course_card.dart';
import 'package:e_learning_app/features/my_courses/presentation/cubit/my_courses_cubit.dart';
import 'package:e_learning_app/features/my_courses/presentation/cubit/my_courses_states.dart';
import 'package:e_learning_app/features/my_courses/presentation/screens/lessons_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyCoursesCubit()..getMyCourses(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.myCourses)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: BlocBuilder<MyCoursesCubit, MyCoursesStates>(
            builder: (context, state) {
              return Column(
                children: [
                  if (state is LoadingMyCoursesState)
                    const Center(child: CircularProgressIndicator())
                  else if (state is ErrorMyCoursesState)
                    Center(child: Text(state.error))
                  else if (state is SuccessMyCoursesState)
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.courses.length,
                        itemBuilder: (context, index) {
                          final course = state.courses[index];
                          final progress = state.progressMap[course.id] ??
                              {'completed': 0, 'total': 0};
                          final completed = progress['completed']!;
                          final total = progress['total']!;
                          final percentage = total > 0
                              ? (completed / total * 100).toInt()
                              : 0;
                          final progressValue = total > 0
                              ? completed / total
                              : 0.0;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LessonsScreen(
                                      courseId: course.id,
                                      courseTitle: course.title,
                                    ),
                                  ),
                                );
                                // Refresh progress when coming back
                                if (context.mounted) {
                                  context.read<MyCoursesCubit>().getMyCourses();
                                }
                              },
                              child: CustomCourseCard(
                                imageUrl: course.image,
                                courseName: course.title,
                                progressText: '$completed/$total Lessons',
                                progressPercentageText: '$percentage%',
                                progressValue: progressValue,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
