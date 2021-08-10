import 'dart:convert';

import 'package:Unio/src/providers/authentication.dart';
import 'package:Unio/src/service/http_service.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SocialMediaWidget extends StatelessWidget {
  const SocialMediaWidget({
    Key key,
  }) : super(key: key);

  Future<void> _facebookLogin(
      BuildContext context, AuthenticationProvider authProvider) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        dynamic graphResponse;

        await getService(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token',
            onSuccess: (response) => graphResponse = response);

        final profile = json.decode(graphResponse.body);

        print(profile);
        var email = profile.containsKey('email') ? profile['email'] : 'test';

        // showOkAlertDialog(context: context, message: profile['name']);
        authProvider.loginWithSocialAccounts(
            context, 'facebook', profile['id'], email, profile['name']);
        break;
      case FacebookLoginStatus.cancelledByUser:
        // showOkAlertDialog(context: context, message: "Login canceled");
        break;
      case FacebookLoginStatus.error:
        showOkAlertDialog(context: context, message: result.errorMessage);
        break;
    }
  }

  Future<void> _googleSignIn(
      BuildContext context, AuthenticationProvider authProvider) async {
    GoogleSignInAccount _currentUser;

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );

    try {
      await _googleSignIn.signIn();
      _currentUser = _googleSignIn.currentUser;

      if (_currentUser == null) {
        showOkAlertDialog(
          context: context,
          title: 'User not found',
        );
      }

      print(_currentUser);

      authProvider.loginWithSocialAccounts(context, 'google', _currentUser.id,
          _currentUser.email, _currentUser.displayName);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = context.read<AuthenticationProvider>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () {
              _facebookLogin(context, _authProvider);
            },
            child: Image.asset('img/facebook.png'),
          ),
        ),
        SizedBox(width: 10),
        // SizedBox(
        //   width: 45,
        //   height: 45,
        //   child: InkWell(
        //     onTap: () {},
        //     child: Image.asset('img/twitter.png'),
        //   ),
        // ),
        // SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () {
              _googleSignIn(context, _authProvider);
            },
            child: Image.asset('img/google-plus.png'),
          ),
        ),
        // SizedBox(width: 10),
        // SizedBox(
        //   width: 45,
        //   height: 45,
        //   child: InkWell(
        //     onTap: () {},
        //     child: Image.asset('img/linkedin.png'),
        //   ),
        // )
      ],
    );
  }
}
