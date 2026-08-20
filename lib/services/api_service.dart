import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
class ApiService {
  // =========================================================
  // BASE URL
  // =========================================================
  static Future<Map<String, dynamic>> verifySign(
      String token,
      XFile video,
      ) async {
    final request = http.MultipartRequest(
      'POST',
        Uri.parse('$baseUrl/ml/verify'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        video.path,
      ),
    );

    final streamedResponse = await request.send();

    final response =
    await http.Response.fromStream(streamedResponse);

    debugPrint(
      'ML HTTP STATUS: ${response.statusCode}',
    );

    debugPrint(
      'ML RESPONSE: ${response.body}',
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'ML backend returned ${response.statusCode}',
      );
    }

    return jsonDecode(response.body)
    as Map<String, dynamic>;
  }
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    const host = String.fromEnvironment(
      'API_HOST',
      defaultValue: '10.92.161.197',
    );

    return 'http://$host:8080/api';
  }

  // =========================================================
  // LOGIN
  // =========================================================

  static Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  // =========================================================
  // REGISTER
  // =========================================================

  static Future<Map<String, dynamic>> register(
      String name,
      String email,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  // =========================================================
  // VERIFY OTP
  // =========================================================

  static Future<Map<String, dynamic>> verifyOtp(
      String email,
      String otp,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );

    return _handleResponse(response);
  }

  // =========================================================
  // PROFILE
  // =========================================================

  static Future<Map<String, dynamic>> getProfile(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/me'),
      headers: _authHeaders(token),
    );

    return _handleResponse(response);
  }

  // =========================================================
  // LESSONS
  // =========================================================

  static Future<List<dynamic>> getLessons(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lessons'),
      headers: _authHeaders(token),
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // =========================================================
  // PRACTICE QUESTIONS
  // =========================================================

  static Future<List<dynamic>> getPracticeQuestions(
      String token,
      int lessonId,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/practice/lesson/$lessonId'),
      headers: _authHeaders(token),
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // =========================================================
  // SUBMIT PRACTICE
  // =========================================================

  static Future<Map<String, dynamic>> submitPractice(
      String token,
      int lessonId,
      Map<int, String> answers,
      ) async {
    final formattedAnswers = <String, String>{};

    answers.forEach((questionId, answer) {
      formattedAnswers[questionId.toString()] = answer;
    });

    final response = await http.post(
      Uri.parse('$baseUrl/practice/submit'),
      headers: _authHeaders(token),
      body: jsonEncode({
        'lessonId': lessonId,
        'answers': formattedAnswers,
      }),
    );

    return _handleResponse(response);
  }

  // =========================================================
  // PROGRESS
  // =========================================================

  static Future<List<dynamic>> getProgress(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/progress'),
      headers: _authHeaders(token),
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // =========================================================
  // COMPLETE LESSON
  // =========================================================

  static Future<Map<String, dynamic>> completeLesson(
      String token,
      int lessonId, {
        double? score,
      }) async {
    String url =
        '$baseUrl/progress/lesson/$lessonId/complete';

    if (score != null) {
      url += '?score=$score';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: _authHeaders(token),
    );

    return _handleResponse(response);
  }

  // =========================================================
  // ACHIEVEMENTS
  // =========================================================

  static Future<List<dynamic>> getAchievements(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/achievements'),
      headers: _authHeaders(token),
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

  // =========================================================
  // STATISTICS
  // =========================================================

  static Future<Map<String, dynamic>> getStatistics(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/progress/statistics'),
      headers: _authHeaders(token),
    );

    return _handleResponse(response);
  }
  // =========================================================
// NOTIFICATIONS
// =========================================================

  static Future<List<dynamic>> getNotifications(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: _authHeaders(token),
    );

    final data = _handleResponse(response);

    if (data is List) {
      return data;
    }

    return [];
  }

// =========================================================
// UNREAD NOTIFICATION COUNT
// =========================================================

  static Future<int> getUnreadNotificationCount(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/unread-count'),
      headers: _authHeaders(token),
    );

    final data = _handleResponse(response);

    if (data is int) {
      return data;
    }

    return int.tryParse(data.toString()) ?? 0;
  }

// =========================================================
// MARK ONE NOTIFICATION AS READ
// =========================================================

  static Future<Map<String, dynamic>> markNotificationAsRead(
      String token,
      int notificationId,
      ) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/notifications/$notificationId/read',
      ),
      headers: _authHeaders(token),
    );

    return Map<String, dynamic>.from(
      _handleResponse(response),
    );
  }

// =========================================================
// MARK ALL NOTIFICATIONS AS READ
// =========================================================

  static Future<void> markAllNotificationsAsRead(
      String token,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notifications/read-all'),
      headers: _authHeaders(token),
    );

    _handleResponse(response);
  }
  // =========================================================
  // AUTH HEADERS
  // =========================================================

  static Map<String, String> _authHeaders(
      String token,
      ) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // =========================================================
  // RESPONSE HANDLER
  // =========================================================

  static dynamic _handleResponse(
      http.Response response,
      ) {
    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = {
        'message': response.body,
      };
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    String message = 'Something went wrong';

    if (data is Map<String, dynamic>) {
      message =
          data['message']?.toString() ??
              data['error']?.toString() ??
              message;
    }

    throw Exception(
      'API Error ${response.statusCode}: $message',
    );
  }
}