import 'package:chat_application/cubits/login_cubit/login_cubit.dart';
import 'package:chat_application/helpers/constants.dart';
import 'package:chat_application/helpers/show_snackbar.dart';
import 'package:chat_application/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'chat_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

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
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return CustomTextField(
                          obsecureText:
                              BlocProvider.of<LoginCubit>(context).obSecureText,
                          controller: _passwordController,
                          hintText: "Password",
                          hintTextColor: Colors.white,
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              BlocProvider.of<LoginCubit>(context)
                                  .toggleObSecureText();
                            },
                            child: BlocProvider.of<LoginCubit>(context)
                                    .obSecureText
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
                          });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocListener<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginLoading) {
                        BlocProvider.of<LoginCubit>(context).isLoading = true;
                      }
                      if (state is LoginSuccess) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(email: _emailController.text)));
                      }
                      if (state is LoginFailure) {
                        showSnackBar(context, state.error);
                      }
                    },
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: primaryColor,
                            ),
                          );
                        } else {
                          return CustomButton(
                            onTap: () async {
                              if (_key.currentState!.validate()) {
                                BlocProvider.of<LoginCubit>(context).loginUser(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                              }
                            },
                            text: "Login",
                          );
                        }
                      },
                    ),
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
