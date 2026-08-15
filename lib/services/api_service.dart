import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // =========================================================
  // BASE URL
  // =========================================================

  // Android Emulator → use 10.0.2.2 to access your PC's localhost
  // static const String baseUrl = 'http://10.0.2.2:8080/api';
  //static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String baseUrl = 'http://localhost:8080/api';

  // ===========import 'dart:convert';
  // import 'package:http/http.dart' as http;
  //
  // class ApiService {
  //   // =========================================================
  //   // BASE URL
  //   // =========================================================
  //
  //   // Android Emulator → use 10.0.2.2 to access your PC's localhost
  //   // static const String baseUrl = 'http://10.0.2.2:8080/api';
  //   //static const String baseUrl = 'http://10.0.2.2:8080/api';
  //   static const String baseUrl = 'http://localhost:8080/api';
  //
  //   // =========================================================
  //   // LOGIN
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> login(
  //       String email,
  //       String password,
  //       ) async {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/auth/login'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'email': email,
  //         'password': password,
  //       }),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // REGISTER
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> register(
  //       String name,
  //       String email,
  //       String password,
  //       ) async {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/auth/register'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'name': name,
  //         'email': email,
  //         'password': password,
  //       }),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // VERIFY OTP
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> verifyOtp(
  //       String email,
  //       String otp,
  //       ) async {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/auth/verify-otp'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'email': email,
  //         'otp': otp,
  //       }),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // PROFILE
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> getProfile(
  //       String token,
  //       ) async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/profile/me'),
  //       headers: _authHeaders(token),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // LESSONS
  //   // =========================================================
  //
  //   static Future<List<dynamic>> getLessons(
  //       String token,
  //       ) async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/lessons'),
  //       headers: _authHeaders(token),
  //     );
  //
  //     final data = _handleResponse(response);
  //
  //     if (data is List) {
  //       return data;
  //     }
  //
  //     return [];
  //   }
  //
  //   // =========================================================
  //   // PRACTICE QUESTIONS
  //   // =========================================================
  //
  //   static Future<List<dynamic>> getPracticeQuestions(
  //       String token,
  //       int lessonId,
  //       ) async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/practice/lesson/$lessonId'),
  //       headers: _authHeaders(token),
  //     );
  //
  //     final data = _handleResponse(response);
  //
  //     if (data is List) {
  //       return data;
  //     }
  //
  //     return [];
  //   }
  //
  //   // =========================================================
  //   // SUBMIT PRACTICE
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> submitPractice(
  //       String token,
  //       int lessonId,
  //       Map<int, String> answers,
  //       ) async {
  //     final formattedAnswers = <String, String>{};
  //
  //     answers.forEach((questionId, answer) {
  //       formattedAnswers[questionId.toString()] = answer;
  //     });
  //
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/practice/submit'),
  //       headers: _authHeaders(token),
  //       body: jsonEncode({
  //         'lessonId': lessonId,
  //         'answers': formattedAnswers,
  //       }),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // PROGRESS
  //   // =========================================================
  //
  //   static Future<List<dynamic>> getProgress(
  //       String token,
  //       ) async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/progress'),
  //       headers: _authHeaders(token),
  //     );
  //
  //     final data = _handleResponse(response);
  //
  //     if (data is List) {
  //       return data;
  //     }
  //
  //     return [];
  //   }
  //
  //   // =========================================================
  //   // COMPLETE LESSON
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> completeLesson(
  //       String token,
  //       int lessonId, {
  //         double? score,
  //       }) async {
  //     String url =
  //         '$baseUrl/progress/lesson/$lessonId/complete';
  //
  //     if (score != null) {
  //       url += '?score=$score';
  //     }
  //
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: _authHeaders(token),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // ACHIEVEMENTS
  //   // =========================================================
  //
  //   static Future<List<dynamic>> getAchievements(
  //       String token,
  //       ) async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/achievements'),
  //       headers: _authHeaders(token),
  //     );
  //
  //     final data = _handleResponse(response);
  //
  //     if (data is List) {
  //       return data;
  //     }
  //
  //     return [];
  //   }
  //
  //   // =========================================================
  //   // STATISTICS
  //   // =========================================================
  //
  //   static Future<Map<String, dynamic>> getStatistics(
  //       String token,
  //       ) async {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/progress/statistics'),
  //       headers: _authHeaders(token),
  //     );
  //
  //     return _handleResponse(response);
  //   }
  //
  //   // =========================================================
  //   // AUTH HEADERS
  //   // =========================================================
  //
  //   static Map<String, String> _authHeaders(
  //       String token,
  //       ) {
  //     return {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     };
  //   }
  //
  //   // =========================================================
  //   // RESPONSE HANDLER
  //   // =========================================================
  //
  //   static dynamic _handleResponse(
  //       http.Response response,
  //       ) {
  //     dynamic data;
  //
  //     try {
  //       data = jsonDecode(response.body);
  //     } catch (_) {
  //       data = {
  //         'message': response.body,
  //       };
  //     }
  //
  //     if (response.statusCode >= 200 &&
  //         response.statusCode < 300) {
  //       return data;
  //     }
  //
  //     String message = 'Something went wrong';
  //
  //     if (data is Map<String, dynamic>) {
  //       message =
  //           data['message']?.toString() ??
  //               data['error']?.toString() ??
  //               message;
  //     }
  //
  //     throw Exception(
  //       'API Error ${response.statusCode}: $message',
  //     );
  //   }
  // }==============================================
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