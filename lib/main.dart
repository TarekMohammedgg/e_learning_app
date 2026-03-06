import 'package:e_learning_app/core/networking/supabase_service.dart';
import 'package:e_learning_app/core/routing/app_router.dart';
import 'package:e_learning_app/core/routing/routes.dart';
import 'package:e_learning_app/core/widgets/simple_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  Bloc.observer = SimpleObserver();
  runApp(const ELearningScreen());
}

class ELearningScreen extends StatelessWidget {
  const ELearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter().generateRoute,
      initialRoute: Routes.login,
    );
  }
}
