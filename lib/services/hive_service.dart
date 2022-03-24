import 'package:hive/hive.dart';

class HiveDB {
  static String DB_NAME = "firebase";
  static var box = Hive.box(DB_NAME);

  static void storeUid(String uid) async {
    box.put("uid", uid);
  }

  static String loadUid() {
    return box.get("uid", defaultValue: "");
  }

  static Future<void> removeUid() {
    return box.delete("uid");
  }

  // Firebase Token
  static void saveFCM(String fcm_token) async {
    box.put('fcm_token', fcm_token);
  }

  static String loadFCM() {
    return box.get("fcm_token", defaultValue: "");
  }
}
