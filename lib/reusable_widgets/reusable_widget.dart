import 'package:flutter/material.dart';


//reusable text field for login and register page
TextField reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller){
  return TextField(controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(prefixIcon: Icon(icon,color: Colors.amber[600],),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 17,letterSpacing: 1.5,fontWeight: FontWeight.bold,/*fontFamily: 'RobotoCondensed'*/),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

