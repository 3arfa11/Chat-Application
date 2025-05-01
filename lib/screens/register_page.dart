import 'package:chat_application/helpers/constants.dart';
import 'package:chat_application/helpers/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextField(
                      controller: _emailController,
                      hintTextColor: Colors.white,
                      validator: (data) {
                        if (data.isEmpty) {
                          return "Empty Fields!";
                        } else {
                          return null;
                        }
                      },
                      hintText: "Email",
                      icon: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintTextColor: Colors.white,
                    controller: _passwordController,
                    validator: (data) {
                      if (data.isEmpty) {
                        return "Empty Fields!";
                      } else {
                        return null;
                      }
                    },
                    hintText: "Password",
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
                  ),
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
                                await registerUser();
                                if (context.mounted) {
                                  showSnackBar(
                                      context, "Registered Successfully");
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  if (context.mounted) {
                                    showSnackBar(context,
                                        'The password provided is too weak.');
                                  }
                                  // print('The password provided is too weak.');
                                } else if (e.code == 'email-already-in-use') {
                                  if (context.mounted) {
                                    showSnackBar(context,
                                        'The account already exists for that email.');
                                  }
                                  // print('The account already exists for that email.');
                                }
                              } catch (e) {
                                // print(e);
                                if (context.mounted) {
                                  showSnackBar(context, e.toString());
                                }
                              }
                              isLoading = false;
                              setState(() {});
                            } else {
                              showSnackBar(context, "Something wrong!");
                            }
                          },
                          text: "Register",
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
                        "Already have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Color(0xFF0096c7),
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }
}
