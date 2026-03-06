class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String videoUrl;
  final int orderIndex;
  final int durationMinutes;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.videoUrl,
    required this.orderIndex,
    required this.durationMinutes,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json['id']?.toString() ?? '',
    courseId: json['course_id']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    videoUrl: json['video_url']?.toString() ?? '',
    orderIndex: json['order_index'] is int
        ? json['order_index'] as int
        : int.tryParse(json['order_index']?.toString() ?? '0') ?? 0,
    durationMinutes: json['duration_minutes'] is int
        ? json['duration_minutes'] as int
        : int.tryParse(json['duration_minutes']?.toString() ?? '0') ?? 0,
  );
}
