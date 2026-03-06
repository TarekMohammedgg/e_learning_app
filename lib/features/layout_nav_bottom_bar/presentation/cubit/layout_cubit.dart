import 'package:e_learning_app/features/home/presentation/screens/home_screen.dart';
import 'package:e_learning_app/features/layout_nav_bottom_bar/presentation/cubit/layout_states.dart'
    show
        InitialLayoutBottomNavBarState,
        LayoutBottomNavBarStates,
        ChangeLayoutBottomNavBarState;
import 'package:e_learning_app/features/my_courses/presentation/screens/my_courses_screen.dart';
import 'package:e_learning_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutCubit extends Cubit<LayoutBottomNavBarStates> {
  LayoutCubit() : super(InitialLayoutBottomNavBarState());
  int currentIndex = 0;
  List<Widget> screens = [HomeScreen(), MyCoursesScreen(), ProfileScreen()];
  changeIndex(int index) {
    currentIndex = index;
    emit(ChangeLayoutBottomNavBarState());
  }
}
