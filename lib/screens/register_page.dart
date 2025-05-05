import 'package:chat_application/cubits/register_cubit/register_cubit.dart';
import 'package:chat_application/helpers/constants.dart';
import 'package:chat_application/helpers/show_snackbar.dart';
import 'package:chat_application/screens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
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
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return CustomTextField(
                          obsecureText: BlocProvider.of<RegisterCubit>(context)
                              .obSecureText,
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
                              BlocProvider.of<RegisterCubit>(context)
                                  .toggleObSecureText();
                            },
                            child: BlocProvider.of<RegisterCubit>(context)
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
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<RegisterCubit, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterLoading) {
                          BlocProvider.of<RegisterCubit>(context).isLoading =
                              true;
                        }
                        if (state is RegisterSuccess) {
                          showSnackBar(context, "Registered Successfully");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginPage()));
                        }
                        if (state is RegisterFailure) {
                          showSnackBar(context, state.errorMessage);
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return CircularProgressIndicator(
                            backgroundColor: Color(0xFF0096c7),
                          );
                        } else {
                          return CustomButton(
                            onTap: () async {
                              if (_key.currentState!.validate()) {
                                BlocProvider.of<RegisterCubit>(context)
                                    .registerUser(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                              } else {
                                showSnackBar(context, "Something wrong!");
                              }
                            },
                            text: "Register",
                          );
                        }
                      },
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
      ),
    );
  }

  Future<void> registerUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
  }
}
