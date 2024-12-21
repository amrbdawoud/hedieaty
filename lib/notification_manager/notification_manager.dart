import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hedieaty/notification_manager/fcm_token_manager.dart';
import 'package:hedieaty/onboarding/managers/user_session_manager.dart';

class NotificationManager {
// Private constructor to prevent external instantiation
  NotificationManager._();

  // Static instance of the singleton class
  static final NotificationManager _instance = NotificationManager._();

  // Getter to access the singleton instance
  static NotificationManager get instance => _instance;

  static String? accessToken = null;
  final FcmTokenManager _tokenManager = FcmTokenManager();

  Future<void> configure() async {
    User? user = await UserSessionManager.instance.getCurrentUser();

    if (user != null) {
      _tokenManager.registerToken(user.uid);
    }
  }

  Future<void> dispose() async {
    User? user = await UserSessionManager.instance.getCurrentUser();

    if (user != null) {
      _tokenManager.delete(user.uid);
    }
  }

  Future<void> sendNotification(
      String userId, String title, String body) async {
    // Create a Dio instance
    Dio dio = Dio();

    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    // Define the API endpoint
    String apiUrl = 'http://192.168.1.6:3000/send-notification';

    // Prepare the data
    Map<String, dynamic> data = {
      'userId': userId,
      'title': title,
      'body': body,
    };

    try {
      // Send the POST request
      Response response = await dio.post(apiUrl, data: data);

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print('Failed to send notification. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  // Future<void> sendNotification(
  //     String userId, String title, String body) async {
  //   final url = Uri.parse(
  //       'https://fcm.googleapis.com/v1/projects/hedieaty-flutter-app/messages:send');

  //   String? deviceToken =
  //       (await _tokenManager.retrieveTokens(userId)).firstOrNull;
  //   final payload = {
  //     "message": {
  //       "token": deviceToken,
  //       "notification": {"title": title, "body": body}
  //     }
  //   };

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode(payload),
  //   );

  //   if (response.statusCode == 200) {
  //     print("Notification sent successfully: ${response.body}");
  //   } else {
  //     print(
  //         "Failed to send notification: ${response.statusCode} ${response.body}");
  //   }
  // }
}
