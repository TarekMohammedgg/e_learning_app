import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class CustomCourseCard extends StatelessWidget {
  final String imageUrl;
  final String courseName;
  final String progressText;
  final String progressPercentageText;
  final double progressValue;

  const CustomCourseCard({
    super.key,
    required this.imageUrl,
    required this.courseName,
    required this.progressText,
    required this.progressPercentageText,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.btnForground,
      ),
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                final fallback = imageUrl.replaceAll(
                  'maxresdefault',
                  'hqdefault',
                );

                return Image.network(
                  fallback,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                );
              },
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: AppStyle.bold16,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(progressText, style: AppStyle.regular12),
                    Text(progressPercentageText, style: AppStyle.regular12),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                  value: progressValue,
                  color: AppColors.btnBackground,
                  backgroundColor: AppColors.progressIndicatorBackground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
