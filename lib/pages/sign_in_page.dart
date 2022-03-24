import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/pages/sign_up_page.dart';
import 'package:flutter_instagram/services/auth_service.dart';
import 'package:flutter_instagram/services/hive_service.dart';
import 'package:flutter_instagram/services/utils_service.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static const String id = "sign_in_page";

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _callSignUpPage() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  void _doSignIn() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      // error msg
      Utils.snackBar('Fields cannot be null or empty', context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    await AuthService.signInUser(context, email, password)
        .then((value) => _getFirebaseUser(value));
  }

  void _getFirebaseUser(User? user) {
    if (user != null) {
      HiveDB.storeUid(user.uid);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
                        textInputAction: TextInputAction.done,
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

                    // #sign_in
                    GestureDetector(
                      onTap: _doSignIn,
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
                            "Sign In",
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
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: _callSignUpPage,
                      child: const Text(
                        "Sign Up",
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
