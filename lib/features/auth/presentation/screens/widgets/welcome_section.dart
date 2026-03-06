import 'package:e_learning_app/core/constants/app_strings.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:flutter/cupertino.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.welcomeString, style: AppStyle.bold32),
        Text(
          AppStrings.pleaseMessageString,
          maxLines: 2,
          softWrap: true,
          style: AppStyle.regular16,
        ),
      ],
    );
  }
}
