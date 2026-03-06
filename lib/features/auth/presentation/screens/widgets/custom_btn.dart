import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.forgroundColor,
    this.onPressed,
    required this.enableImage,
    this.image,
  });
  final void Function()? onPressed;
  final bool enableImage;
  final String? image;
  final String title;
  final Color backgroundColor;
  final Color forgroundColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,

      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: backgroundColor,
        foregroundColor: forgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          enableImage
              ? Row(
                  children: [
                    if (image != null && image!.isNotEmpty)
                      Image.asset(image!, height: 30, width: 30),
                    SizedBox(width: 5),
                  ],
                )
              : SizedBox.shrink(),
          Text(title),
        ],
      ),
    );
  }
}
