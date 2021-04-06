import 'package:Unio/src/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

checkLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String apiToken = prefs.getString('apiToken');
  if (apiToken == null) {
    return MaterialPageRoute(builder: (_) => SignInWidget());
  } else {
    return apiToken;
  }
}
