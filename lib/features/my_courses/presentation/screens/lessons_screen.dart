import 'package:e_learning_app/core/constants/app_colors.dart';
import 'package:e_learning_app/core/constants/app_style.dart';
import 'package:e_learning_app/features/my_courses/data/model/lesson_model.dart';
import 'package:e_learning_app/features/my_courses/presentation/cubit/lessons_cubit.dart';
import 'package:e_learning_app/features/my_courses/presentation/cubit/lessons_states.dart';
import 'package:e_learning_app/features/my_courses/presentation/screens/widgets/custom_lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonsScreen extends StatefulWidget {
  final String courseId;
  final String courseTitle;
  const LessonsScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  // 1. Make the controller nullable instead of late
  YoutubePlayerController? _youtubeController;
  int _currentSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // 2. Remove the empty initialization from here.
    // We will initialize it when the data arrives.
  }

  @override
  void dispose() {
    // 3. Safely dispose if it was initialized
    _youtubeController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _handleVideoSwitch(LessonsSuccess state) {
    if (state.lessons.isEmpty) return;

    final newIndex = state.selectedIndex;
    if (newIndex == _currentSelectedIndex) return;

    _currentSelectedIndex = newIndex;
    final lesson = state.lessons[newIndex];
    final videoId = YoutubePlayer.convertUrlToId(lesson.videoUrl);

    if (videoId != null && videoId.isNotEmpty) {
      // 4. If the controller doesn't exist yet, initialize it with the first valid ID
      if (_youtubeController == null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
            forceHD: false,
          ),
        );
        // Rebuild the UI so the YoutubePlayerBuilder can use the new controller
        setState(() {});
      } else {
        // 5. If it already exists, just load the new video normally
        _youtubeController!.load(videoId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LessonsCubit()..getCourseLessons(courseId: widget.courseId),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.courseTitle)),
        body: BlocConsumer<LessonsCubit, LessonsStates>(
          listener: (context, state) {
            if (state is LessonsSuccess) {
              _handleVideoSwitch(state);
            }
          },
          builder: (context, state) {
            if (state is LessonsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LessonsError) {
              return Center(child: Text(state.error));
            } else if (state is LessonsSuccess) {
              // 6. If the controller is still null, show a loader while it initializes
              if (_youtubeController == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final selectedLesson = state.lessons.isNotEmpty
                  ? state.lessons[state.selectedIndex]
                  : null;
              final isSelectedCompleted =
                  selectedLesson != null &&
                  state.completedLessonIds.contains(selectedLesson.id);

              return YoutubePlayerBuilder(
                player: YoutubePlayer(
                  // 7. Safely pass the non-null controller
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors.primaryColor,
                  progressColors: ProgressBarColors(
                    playedColor: AppColors.primaryColor,
                    handleColor: AppColors.btnBackground,
                  ),
                  bottomActions: [
                    const CurrentPosition(),
                    const SizedBox(width: 8),
                    ProgressBar(
                      isExpanded: true,
                      colors: ProgressBarColors(
                        playedColor: AppColors.primaryColor,
                        handleColor: AppColors.btnBackground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const RemainingDuration(),
                    const SizedBox(width: 8),
                    const PlaybackSpeedButton(),
                    const FullScreenButton(),
                  ],
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      // YouTube Player
                      player,

                      // Lesson Info Card
                      if (selectedLesson != null)
                        _buildLessonInfoCard(
                          selectedLesson,
                          isSelectedCompleted,
                          context,
                        ),

                      // Lessons count header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${state.lessons.length} Lessons',
                            style: AppStyle.bold18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Lesson list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = state.lessons[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CustomLessonCard(
                                lessonTitle: lesson.title,
                                orderIndex: lesson.orderIndex,
                                durationMinutes: lesson.durationMinutes,
                                isCompleted: state.completedLessonIds.contains(
                                  lesson.id,
                                ),
                                isSelected: index == state.selectedIndex,
                                onTap: () {
                                  context.read<LessonsCubit>().selectLesson(
                                    index,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLessonInfoCard(
    LessonModel selectedLesson,
    bool isSelectedCompleted,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Lesson info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Lesson ${selectedLesson.orderIndex}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedLesson.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${selectedLesson.durationMinutes} min',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Mark Complete or Completed badge
          isSelectedCompleted
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.greenAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Completed',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    context.read<LessonsCubit>().markLessonComplete(
                      lessonId: selectedLesson.id,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Mark as Complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
