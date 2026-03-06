class CourseModel {
  final String title;
  final String desc;
  final String image;
  final num price;
  final String id;
  final String tag;

  CourseModel({
    required this.title,
    required this.desc,
    required this.image,
    required this.price,
    required this.id,
    required this.tag,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    title: json["title"]?.toString() ?? '',
    desc: json["desc"]?.toString() ?? '',
    image: json["image"]?.toString() ?? '',
    price: json["price"] is num
        ? json["price"] as num
        : num.tryParse(json["price"]?.toString() ?? '0') ?? 0,
    id: json["id"]?.toString() ?? '',
    tag: json["tag"]?.toString() ?? '',
  );
}
