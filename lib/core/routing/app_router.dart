import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/features/auth/presentation/screens/login_screen.dart';
import 'package:e_learning_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:e_learning_app/features/course_details/presentation/screens/course_overview_screen.dart';
import 'package:e_learning_app/features/course_details/presentation/screens/widgets/course_overview_args.dart';
import 'package:e_learning_app/features/home/presentation/screens/home_screen.dart';
import 'package:e_learning_app/features/layout_nav_bottom_bar/presentation/screens/layout_bottom_nav_bar_screen.dart';
import 'package:e_learning_app/features/my_courses/presentation/screens/my_courses_screen.dart';
import 'package:e_learning_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.layoutBottomNavBar:
        return MaterialPageRoute(
          builder: (context) => const LayoutBottomNavBarScreen(),
        );
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case Routes.courseOverview:
        final args = settings.arguments as CourseOverviewArguments;
        return MaterialPageRoute(
          builder: (context) => CourseOverviewScreen(
            price: args.price,
            image: args.image,
            title: args.title,
            desc: args.desc,
            courseId: args.courseId,
          ),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case Routes.signup:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case Routes.myCourses:
        return MaterialPageRoute(builder: (context) => const MyCoursesScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
