import 'dart:convert';
import 'package:http/http.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "fcm.googleapis.com";
  static String SERVER_PRODUCTION = "fcm.googleapis.com";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAjA7w4dM:APA91bHblqKdE2Mc0UP792AMP3O4-9fbAG9iI8qevIhgT5Pts-VvCLNEa5LJspW2RilewT7e5gp34Pe68N6B-DdXZOXgxmQR2p04bnK6MKtxODCYyn-yG5yAI17yRWzF5ZBt6DOE8uop'
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> POST(String api, Map<String, dynamic> body) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
        await post(uri, headers: getHeaders(), body: jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /* Http Apis */
  static String API_PUSH = "/fcm/send";

  /* Http Bodies */
  static Map<String, dynamic> bodyCreate(String token) {
    Map<String, dynamic> body = {};
    body.addAll({
      "notification": {
        "title":"Instagram Clone",
        "body":"Someone followed you"
      },
      "registration_ids":[token],
      "click_action":"FLUTTER_NOTIFICATION_CLICK"
    });
    return body;
  }
}
