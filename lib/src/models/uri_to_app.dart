import 'package:Unio/src/screens/signin.dart';
import 'package:Unio/src/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Unio/src/utilities/global.dart';

class UriToApp {
  static void navigate(Uri uri, BuildContext context) {
    print(uri.path);

    if (uri.path.contains('login')) {
      print('\login');
      Navigator.of(context).pushReplacementNamed('/SignIn');
      // NavigationService.instance.navigateToReplacement('/SignIn');

    }
  }
}
