import 'package:flutter/material.dart';

TextField textfield({String? hintText , TextEditingController? controller , bool? obsecure}) {
  return TextField(
    controller: controller ,
    obscureText: obsecure ?? false,
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey[100], // light background
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none, // no border line
      ),
    ),
  );
}
