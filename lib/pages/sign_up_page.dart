import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model/user_model.dart';
import 'package:flutter_instagram/pages/sign_in_page.dart';
import 'package:flutter_instagram/services/auth_service.dart';
import 'package:flutter_instagram/services/data_service.dart';
import 'package:flutter_instagram/services/hive_service.dart';
import 'package:flutter_instagram/services/utils_service.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "sign_up_page";

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  void _callSignInPage() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  void _doSignUp() async {
    String name = fullNameController.text.trim().toString();
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();
    String cpassword = cpasswordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      // error msg
      Utils.snackBar('Fields cannot be null or empty', context);
      return;
    }
    if (password != cpassword) {
      Utils.snackBar('Password and Confirm password do not match', context);
      return;
    }
    if (!Utils.validateEmail(email)) {
      Utils.snackBar('Enter a valid email address', context);
      return;
    }
    if (!Utils.validatePassword(password)) {
      Utils.snackBar(
          'Password must contain at least one upper case, one lower case, one digit, one Special character & be at least 8 characters in length',
          context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    UserModel userModel =
        UserModel(fullName: name, email: email, password: password);
    await AuthService.signUpUser(context, name, email, password)
        .then((value) => _getFirebaseUser(userModel, value));
  }

  void _getFirebaseUser(UserModel userModel, User? user) {
    if (user != null) {
      HiveDB.storeUid(user.uid);
      DataService.storeUser(userModel).then(
          (value) => Navigator.pushReplacementNamed(context, SignInPage.id));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(193, 53, 132, 1),
              Color.fromRGBO(131, 58, 180, 1),
            ])),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Instagram",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontFamily: "Bluevinyl"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // #fullname
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white54.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7)),
                      child: TextField(
                        controller: fullNameController,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            hintText: "Full name",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // #email
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white54.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7)),
                      child: TextField(
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: "Email",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // #password
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white54.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7)),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // #confirm_password
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white54.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7)),
                      child: TextField(
                        obscureText: true,
                        controller: cpasswordController,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: "Confirm Password",
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // #sign_up
                    GestureDetector(
                      onTap: _doSignUp,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white54.withOpacity(0.2),
                                width: 2),
                            borderRadius: BorderRadius.circular(7)),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: _callSignInPage,
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    ));
  }
}
