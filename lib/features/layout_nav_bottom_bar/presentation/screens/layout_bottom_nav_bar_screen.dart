import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/features/layout_nav_bottom_bar/presentation/cubit/layout_cubit.dart';
import 'package:e_learning_app/features/layout_nav_bottom_bar/presentation/cubit/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutBottomNavBarScreen extends StatefulWidget {
  const LayoutBottomNavBarScreen({super.key});

  @override
  State<LayoutBottomNavBarScreen> createState() =>
      _LayoutBottomNavBarScreenState();
}

class _LayoutBottomNavBarScreenState extends State<LayoutBottomNavBarScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutBottomNavBarStates>(
        builder: (context, state) {
          return Scaffold(
            body: context
                .read<LayoutCubit>()
                .screens[context.read<LayoutCubit>().currentIndex],
            bottomNavigationBar: ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                decoration: BoxDecoration(color: AppColors.scaffoldBackground),
              child: BottomNavigationBar(
                  currentIndex: context.read<LayoutCubit>().currentIndex,
                  onTap: (index) {
                    context.read<LayoutCubit>().changeIndex(index);
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black54,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark),
                      label: "Courses",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Profile",
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

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(0, 0, 30, 0);
    path.lineTo(size.width - 30, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
