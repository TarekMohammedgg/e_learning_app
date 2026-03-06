import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class CustomLessonCard extends StatelessWidget {
  final String lessonTitle;
  final int orderIndex;
  final int durationMinutes;
  final bool isCompleted;
  final bool isSelected;
  final VoidCallback? onTap;

  const CustomLessonCard({
    super.key,
    required this.lessonTitle,
    required this.orderIndex,
    required this.durationMinutes,
    this.isCompleted = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.05)
              : AppColors.btnForground,
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : null,
        ),
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.btnBackground
                    : AppColors.progressIndicatorBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 22)
                    : Text(
                        '$orderIndex',
                        style: AppStyle.bold16,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lessonTitle,
                    style: AppStyle.bold16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$durationMinutes min',
                        style: AppStyle.regular12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.play_circle_outline,
              color: isCompleted ? AppColors.btnBackground : Colors.grey[400],
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
