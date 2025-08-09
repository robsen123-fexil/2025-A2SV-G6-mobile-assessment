import 'package:flutter/material.dart';

Container Textbutton(
  String text,
  VoidCallback onPressed, {
  bool isLoading = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    width: double.infinity,
    child: TextButton(
      onPressed: isLoading ? null : onPressed, // disable when loading
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF3F51FF),
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      
      child:
          isLoading
              ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
    ),
  );
}
