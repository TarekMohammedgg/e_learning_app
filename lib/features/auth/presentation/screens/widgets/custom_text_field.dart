import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class CustomTextFieldSection extends StatelessWidget {
  const CustomTextFieldSection({
    super.key,
    required this.hintText,
    required this.iconprefix,
    required this.controller,
    required this.labelMsg,
    required this.validator,
  });
  final String hintText;
  final IconData iconprefix;
  final TextEditingController controller;
  final String labelMsg;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(labelMsg, style: AppStyle.medium16)]),
        TextFormField(
          validator: validator,
          controller: controller,
          cursorColor: AppColors.textFieldIconColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(iconprefix, color: AppColors.textFieldIconColor),
            hint: Text(
              hintText,
              style: TextStyle(color: AppColors.textFieldIconColor),
            ),

            border: customoutlinedborder(),

            enabledBorder: customoutlinedborder(),
            focusedBorder: customoutlinedborder(),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder customoutlinedborder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xffE2E8F0)),
    );
  }
}
