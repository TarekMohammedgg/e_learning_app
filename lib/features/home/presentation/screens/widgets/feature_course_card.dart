import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class FeatureCardItem extends StatelessWidget {
  final String imageUrl;
  final String tagText;
  final String title;
  final String description;
  final num price;

  const FeatureCardItem({
    super.key,
    required this.imageUrl,
    required this.tagText,
    required this.title,
    required this.description,
    required this.price,
  });

  String get fallbackImage {
    if (imageUrl.contains('maxresdefault')) {
      return imageUrl.replaceAll('maxresdefault', 'hqdefault');
    }
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: SizedBox(
            width: double.infinity,
            height: 140,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  imageUrl.replaceAll('maxresdefault', 'hqdefault'),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    );
                  },
                );
              },
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [TagContainer(tagText: tagText)]),
              const SizedBox(height: 10),
              Text(
                title,
                style: AppStyle.bold18,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: AppStyle.regular14,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${price.toString()} EGP',
                    style: AppStyle.bold18.copyWith(color: AppColors.tagColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TagContainer extends StatelessWidget {
  final String tagText;
  const TagContainer({super.key, required this.tagText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.tagColor.withValues(alpha: 0.1),
      ),
      child: Text(tagText, style: AppStyle.bold10),
    );
  }
}
