import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      this.icon,
      this.suffixIcon,
      this.validator,
      this.controller,
      this.hintTextColor,
      this.enabledBorderColor,
      this.obsecureText = false});
  final bool? obsecureText;
  final String hintText;
  final Color? hintTextColor;
  final Color? enabledBorderColor;
  final Icon? icon;
  final GestureDetector? suffixIcon;
  final FormFieldValidator? validator;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText!,
      controller: controller,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: icon,
          hintStyle: TextStyle(
              color: hintTextColor,
              // fontWeight: FontWeight.bold,
              fontSize: 18),
          hintText: hintText,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(width: 2, color: Colors.red.withValues(alpha: 1))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  width: 1, color: Colors.red.withValues(alpha: .8))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  width: 1, color: Colors.blue.withValues(alpha: .8))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  width: 1,
                  color: enabledBorderColor == null
                      ? Colors.white
                      : enabledBorderColor!))),
    );
  }
}
