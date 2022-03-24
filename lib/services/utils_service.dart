import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'hive_service.dart';

class Utils {
  static void snackBar(String text, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+-]).{8,30}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool validateEmail(String value) {
    return EmailValidator.validate(value);
  }

  static Future<bool> dialogCommon(
      BuildContext context, String title, String message, bool isSingle) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              !isSingle
                  ? MaterialButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    )
                  : const SizedBox.shrink(),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  static Future<Map<String, String>> deviceParams()async{
    Map<String, String> params = {};
    var deviceInfo = DeviceInfoPlugin();
    String fcm_token = await HiveDB.loadFCM();
    if(Platform.isIOS){
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id':iosDeviceInfo.identifierForVendor!,
        'device_type':"I",
        'device_token':fcm_token
      });
    } else{
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id':androidDeviceInfo.androidId!,
        'device_type':"A",
        'device_token':fcm_token
      });
    }
    return params;
  }
}
