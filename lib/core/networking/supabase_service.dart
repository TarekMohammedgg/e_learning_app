import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_learning_app/core/constants/api_constants.dart';
import 'package:e_learning_app/features/home/data/models/course_model.dart';
import 'package:e_learning_app/features/my_courses/data/model/lesson_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static init() async {
    await Supabase.initialize(
      url: ApiConstants.supbaProjectURL,
      anonKey: ApiConstants.supbaPublishURL,
    );
    await _googleSignIn.initialize(serverClientId: ApiConstants.clientId);
  }

  static final SupabaseClient client = Supabase.instance.client;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<Either<String, void>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) {
        return left('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw 'No ID Token found.';

      // accessToken is optional for Supabase — don't let its failure block login
      String? accessToken;
      try {
        const scopes = ['email', 'profile'];
        var authorization = await googleUser.authorizationClient
            .authorizationForScopes(scopes);
        authorization ??= await googleUser.authorizationClient.authorizeScopes(
          scopes,
        );
        accessToken = authorization.accessToken;
      } catch (_) {
        // Proceed with idToken alone if authorization step fails
      }

      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Save user data after successful Google sign-in
      await saveUserData(
        name: googleUser.displayName ?? '',
        email: googleUser.email,
      );

      return right(null);
    } catch (e) {
      log('Error signing in with Google: $e');
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> signin(
    String email,
    String password,
  ) async {
    try {
      await client.auth.signInWithPassword(password: password, email: email);
      return right(null);
    } on AuthException catch (e) {
      return left(e.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Either<String, void>> signup(
    String email,
    String password,
    String name,
  ) async {
    try {
      await client.auth.signUp(
        data: {"name": name},
        password: password,
        email: email,
      );

      // Save user data to users table after successful signup
      await saveUserData(name: name, email: email);

      return right(null);
    } on AuthException catch (e) {
      return left(e.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await client.auth.signOut();
  }

  static Future<void> saveUserData({
    required String name,
    required String email,
    String role = 'student',
  }) async {
    try {
      final res = await client.from(ApiConstants.usersTable).upsert({
        'id': client.auth.currentUser!.id,
        'name': name,
        'email': email,
        'role': role,
      }, onConflict: 'id');
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<CourseModel>> getCourseList() async {
    try {
      final res = await client.from(ApiConstants.coursesTable).select("*");
      return res.map((e) => CourseModel.fromJson(e)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  static User? get user => client.auth.currentUser;

  static Future<Either<String, void>> logout() async {
    try {
      await _googleSignIn.signOut();
      await client.auth.signOut();
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getUserData() async {
    try {
      final userId = client.auth.currentUser!.id;
      final res = await client
          .from(ApiConstants.usersTable)
          .select('*')
          .eq('id', userId)
          .single();
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> enrollInCourse({
    required String courseId,
    required String userId,
  }) async {
    try {
      await client.from(ApiConstants.enrollmentsTable).upsert({
        'course_id': courseId,
        'user_id': userId,
      }, onConflict: 'user_id,course_id');
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<bool> checkEnrollment({
    required String courseId,
    required String userId,
  }) async {
    try {
      final res = await client
          .from(ApiConstants.enrollmentsTable)
          .select("*")
          .eq('course_id', courseId)
          .eq('user_id', userId)
          .maybeSingle();
      return res != null;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<CourseModel>> getMyCourses() async {
    try {
      final userId = client.auth.currentUser!.id;
      final res = await client
          .from(ApiConstants.enrollmentsTable)
          .select('course_id, courses(*)')
          .eq('user_id', userId);

      return res
          .map(
            (e) => CourseModel.fromJson(e['courses'] as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<LessonModel>> getCourseLessons({
    required String courseId,
  }) async {
    try {
      final res = await client
          .from(ApiConstants.lessonsTable)
          .select('*')
          .eq('course_id', courseId)
          .order('order_index', ascending: true);
      return res.map((e) => LessonModel.fromJson(e)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<int> getCourseLessonsCount({required String courseId}) async {
    try {
      final res = await client
          .from(ApiConstants.lessonsTable)
          .select('id')
          .eq('course_id', courseId)
          .count(CountOption.exact);
      return res.count;
    } catch (e) {
      throw e.toString();
    }
  }

  // Mark a lesson as completed
  static Future<void> markLessonComplete({
    required String lessonId,
  }) async {
    try {
      await client.from(ApiConstants.lessonProgressTable).upsert({
        'user_id': client.auth.currentUser!.id,
        'lesson_id': lessonId,
        'completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,lesson_id');
    } catch (e) {
      throw e.toString();
    }
  }

  // Get list of completed lesson IDs for a course
  static Future<List<String>> getCompletedLessonIds({
    required String courseId,
  }) async {
    try {
      final res = await client
          .from(ApiConstants.lessonProgressTable)
          .select('lesson_id, lessons!inner(course_id)')
          .eq('user_id', client.auth.currentUser!.id)
          .eq('lessons.course_id', courseId)
          .eq('completed', true);

      return res.map((e) => e['lesson_id'].toString()).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  // Get progress: {completed: 2, total: 10}
  static Future<Map<String, int>> getCourseProgress({
    required String courseId,
  }) async {
    try {
      final total = await getCourseLessonsCount(courseId: courseId);
      final completedIds = await getCompletedLessonIds(courseId: courseId);
      return {
        'completed': completedIds.length,
        'total': total,
      };
    } catch (e) {
      throw e.toString();
    }
  }
}
