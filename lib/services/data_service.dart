import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram/model/post_model.dart';
import 'package:flutter_instagram/model/user_model.dart';
import 'package:flutter_instagram/services/hive_service.dart';

class DataService {
  static final _fireStore = FirebaseFirestore.instance;

  static String folder_user = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";

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
    for (var result in querySnapshot.docs) {
      UserModel newUser = UserModel.fromJson(result.data());
      if (newUser.uid != uid) {
        users.add(newUser);
      }
    }
    return users;
  }

  // Post Related

  static Future<Post> storePost(Post post) async {
    UserModel me = await loadUser();
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.img_user = me.img_url;
    post.date = DateTime.now().toString().substring(0, 16);

    String postId = _fireStore
        .collection(folder_user)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;

    await _fireStore
        .collection(folder_user)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = HiveDB.loadUid();
    await _fireStore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = HiveDB.loadUid();
    var querySnapshot = await _fireStore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_feeds)
        .get();
    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      posts.add(post);
    }
    return posts;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = HiveDB.loadUid();
    var querySnapshot = await _fireStore
        .collection(folder_user)
        .doc(uid)
        .collection(folder_posts)
        .get();
    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      posts.add(post);
    }
    return posts;
  }

}
