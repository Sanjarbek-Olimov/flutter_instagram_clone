import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
}
