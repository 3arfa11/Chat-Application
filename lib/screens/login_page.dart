import 'dart:developer';

import 'package:chat_application/helpers/constants.dart';
import 'package:chat_application/helpers/show_snackbar.dart';
import 'package:chat_application/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool obSecureText = false;
  void _toggle() {
    setState(() {
      obSecureText = !obSecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(
                    height: getDeviceHeight(context) / 5,
                  ),
                  Image.asset(appLogo),
                  Text(
                    "Scholar Chat",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: "Pacifico"),
                  ),
                  SizedBox(
                    height: getDeviceHeight(context) / 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email",
                    hintTextColor: Colors.white,
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                    validator: (data) {
                      if (data.isEmpty) {
                        return "Empty Fields";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      obsecureText: obSecureText,
                      controller: _passwordController,
                      hintText: "Password",
                      hintTextColor: Colors.white,
                      icon: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _toggle();
                        },
                        child: obSecureText
                            ? Icon(
                                CupertinoIcons.eye_fill,
                                color: Colors.grey,
                              )
                            : Icon(
                                CupertinoIcons.eye_slash_fill,
                                color: Colors.white,
                              ),
                      ),
                      validator: (data) {
                        if (data.isEmpty) {
                          return "Empty Fields";
                        } else {
                          return null;
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  !isLoading
                      ? CustomButton(
                          onTap: () async {
                            if (_key.currentState!.validate()) {
                              isLoading = true;
                              setState(() {});
                              try {
                                await signInUser();
                                if (context.mounted) {
                                  showSnackBar(
                                      context, "User Login Successfully");
                                }
                                if (context.mounted) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                            email: _emailController.text,
                                          )));
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-credential') {
                                  if (context.mounted) {
                                    showSnackBar(context,
                                        'No user found for that email.');
                                  }
                                } else if (e.code == 'wrong-password') {
                                  if (context.mounted) {
                                    showSnackBar(context,
                                        'Wrong password provided for that user.');
                                  }
                                  // print('Wrong password provided for that user.');
                                }
                              }
                              isLoading = false;
                              setState(() {});
                            } else {
                              showSnackBar(context, "Something went wrong!");
                            }
                          },
                          text: "Login",
                        )
                      : CircularProgressIndicator(
                          color: Color(0xFF0096c7),
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Color(0xFF0096c7),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }
}
