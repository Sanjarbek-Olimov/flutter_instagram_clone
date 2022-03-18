import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'hive_service.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static final folder_post = "post_images";
  static final folder_user = "user_images";

  static Future<String?> uploadUserImage(File _image) async {
    String uid = HiveDB.loadUid();
    String img_name = uid;
    Reference firebaseStorageRef = _storage.child(folder_user).child(img_name);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String?> uploadPostImage(File? _image) async {
    if (_image == null) return null;
    String uid = HiveDB.loadUid();
    String imgName = "file_" + DateTime.now().toString();
    Reference firebaseStorageRef = _storage.child(folder_post).child(imgName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
