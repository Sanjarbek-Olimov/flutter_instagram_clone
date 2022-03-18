import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/model/user_model.dart';
import 'package:flutter_instagram/services/hive_service.dart';

class DataService {
  static final _fireStore = FirebaseFirestore.instance;

  static String folder_user = "users";

  // User Related

  static Future storeUser(UserModel user) async {
    user.uid = HiveDB.loadUid();
    return _fireStore.collection(folder_user).doc(user.uid).set(user.toJson());
  }

  static Future<UserModel> loadUser() async {
    String uid = HiveDB.loadUid();
    var value = await _fireStore.collection("users").doc(uid).get();
    UserModel user = UserModel.fromJson(value.data()!);
    return user;
  }

  static Future updateUser(UserModel user) async {
    String uid = HiveDB.loadUid();
    return _fireStore.collection(folder_user).doc(uid).update(user.toJson());
  }

  static Future<List<UserModel>> searchUser(String keyword) async {
    List<UserModel> users = [];
    String uid = HiveDB.loadUid();
    var querySnapshot = await _fireStore
        .collection(folder_user)
        .orderBy("email")
        .startAt([keyword]).get();
    querySnapshot.docs.forEach((result) {
      UserModel newUser = UserModel.fromJson(result.data());
      if (newUser.uid != uid) {
        users.add(newUser);
      }
    });
    return users;
  }
}
