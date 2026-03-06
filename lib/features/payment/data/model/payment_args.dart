class PaymentArgs {
  final String courseTitle;
  final num coursePrice;
  final String courseId;
  final String courseImage;

  const PaymentArgs({
    required this.courseTitle,
    required this.coursePrice,
    required this.courseId,
    required this.courseImage,
  });
}
