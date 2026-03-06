import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchTextField({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: AppColors.textFieldIconColor,
        filled: true,
        hintText: hintText,
        fillColor: AppColors.btnForground,
        enabledBorder: _searchOutlineBorder(),
        focusedBorder: _searchOutlineBorder(),
        border: _searchOutlineBorder(),
      ),
    );
  }

  OutlineInputBorder _searchOutlineBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.btnForground),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
