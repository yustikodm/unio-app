import 'dart:convert';

import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/service/http_service.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class AuthenticationProvider with ChangeNotifier {
  Future<void> login(
      {String email, String password, BuildContext context}) async {
    EasyLoading.show(status: 'loading...');
    storage.deleteAll();

    dynamic data;
    bool error = false;

    await postService(SERVER_DOMAIN + 'login',
        body: {'email': email, 'password': password},
        onSuccess: (res) => data = json.decode(res.body),
        onError: (err) => error = true);

    if (!error) {
      if (data['success'] == false) {
        EasyLoading.dismiss();
        if (data['data'] == null) {
          showOkAlertDialog(
            context: context,
            title: 'Incorrect username or password!',
          );
        }
        if (data['data']['email_verified_at'] == null) {
          Navigator.of(context).pushNamed('/RegisterWA',
              arguments: new RouteArgument(
                  param1: [data['data']['phone'], data['data']['email']],
                  param2: data));
        }
      } else {
        storeAuth(data['data']);

        EasyLoading.dismiss();

        Navigator.of(context).popUntil((route) => !route.navigator.canPop());
        Navigator.of(context).pushReplacementNamed('/Tabs');
      }
    } else {
      EasyLoading.dismiss();
      showOkAlertDialog(
        context: context,
        title: 'Incorrect username or password!',
      );
    }
  }

  Future<void> register(
      {String email,
      String password,
      String name,
      String phone,
      BuildContext context}) async {
    print(phone);

    EasyLoading.show(status: 'Loading...');

    return postService(SERVER_DOMAIN + 'register', body: {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone
    }, onSuccess: (response) {
      dynamic data = json.decode(response.body);
      print(data);

      EasyLoading.dismiss();

      Navigator.of(context).popAndPushNamed('/RegisterWA',
          arguments: new RouteArgument(param1: [phone, email], param2: data));
    }, onError: (response) {
      EasyLoading.dismiss();
      showOkAlertDialog(
        context: context,
        title: "Error: " + json.decode(response.body)['message'],
      );
    });
  }

  Future<void> loginWithSocialAccounts(context, _provider, _providerId,
      _providerEmail, _providerFullName) async {
    EasyLoading.show(status: 'loading...');
    storage.deleteAll();
    var res;

    await postService(SERVER_DOMAIN + 'login-with-provider/$_provider',
        body: {
          'provider_id': _providerId,
          'provider_email': _providerEmail == '' ? null : _providerEmail,
          'provider_full_name': _providerFullName,
        },
        onSuccess: (response) => res = response.body,
        onError: (err) {
          EasyLoading.dismiss();
          showOkAlertDialog(
            context: context,
            title:
                'Login using Social Accounts encounters an error for the moment. Try again later',
          );
        });

    print(res);

    if (res == null) {
      EasyLoading.dismiss();
      showOkAlertDialog(
        context: context,
        title:
            'Login using Social Accounts encounters an error for the moment. Try again later',
      );
    }

    var data = json.decode(res);

    if (data != null) {
      if (data['success'] == false) {
        EasyLoading.dismiss();
        showOkAlertDialog(
          context: context,
          title: 'Invalid username or password!',
        );
      } else {
        storeAuth(data);

        EasyLoading.dismiss();
        Navigator.of(context).popUntil((route) => !route.navigator.canPop());
        Navigator.of(context).pushReplacementNamed('/Tabs');
      }
    } else {
      EasyLoading.dismiss();
      showOkAlertDialog(
        context: context,
        title: 'Invalid Login',
      );
    }
  }

  void storeAuth(data) {
    print(data);
    dynamic date = data['biodata']['birth_date'];

    DateTime formattedDate;

    if (date != null) {
      DateTime date2 = DateTime.parse(date);
      formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date2));
    } else {
      formattedDate = DateTime(2000, 01, 01);
    }

    var authId = data['id'].toString();

    Global.instance.authId = authId;
    Global.instance.apiToken = data['api_token'] == null
        ? data['token']['api_token']
        : data['api_token'];
    Global.instance.authName = data['biodata']['fullname'];
    Global.instance.authEmail = data['email'];
    Global.instance.authPhone = data['phone'];
    Global.instance.authGender = data['biodata']['gender'];
    Global.instance.authPicture = data['image_path'];
    Global.instance.authAddress = data['biodata']['address'];
    Global.instance.authSchool = data['biodata']['school_origin'];
    Global.instance.authGraduate = data['biodata']['graduation_year'];
    Global.instance.authAddress = data['biodata']['address'];
    Global.instance.authBirthDate = formattedDate;
    Global.instance.authBirthPlace = data['biodata']['birth_place'];
    Global.instance.authIdentity =
        data['biodata']['identity_number'].toString();
    Global.instance.authReligion = data['biodata']['religion'];

    Global.instance.authCountryId = data['biodata']['country_id'];

    Global.instance.authLevelId = data['biodata']['level_id'];

    // add hc to global
    Global.instance.authHc = data['biodata']['hc'];

    storage.write(key: 'authId', value: authId ?? '1');
    storage.write(
        key: 'apiToken',
        value: data['api_token'] == null
            ? data['token']['api_token']
            : data['api_token']);
    storage.write(key: 'authEmail', value: data['email'] ?? '-');
    storage.write(key: 'authName', value: data['biodata']['fullname'] ?? '-');
    storage.write(key: 'authPicture', value: data['image_path'] ?? '-');
    storage.write(key: 'authPhone', value: data['phone'] ?? '-');
    storage.write(key: 'authGender', value: data['biodata']['gender'] ?? '-');
    storage.write(key: 'authAddress', value: data['biodata']['address'] ?? '-');
    storage.write(
        key: 'authGraduate', value: data['biodata']['graduation_year'] ?? '-');
    storage.write(
        key: 'authSchool', value: data['biodata']['school_origin'] ?? '-');
    storage.write(key: 'authBirthDate', value: formattedDate.toString());
    storage.write(
        key: 'authBirthPlace', value: data['biodata']['birth_place'] ?? '-');
    storage.write(
        key: 'authIdentity',
        value: data['biodata']['identity_number'].toString() ?? '-');
    storage.write(
        key: 'authReligion', value: data['biodata']['religion'] ?? '-');

    storage.write(
        key: 'authCountryId',
        value: data['biodata']['country_id'] != null
            ? data['biodata']['country_id'].toString()
            : null);

    storage.write(
        key: 'authLevelId',
        value: data['biodata']['level_id'] != null
            ? data['biodata']['level_id'].toString()
            : null);

    // add hc to storage
    storage.write(key: 'authHc', value: data['biodata']['hc'] ?? '-');
  }
}

enum AuthenticationStatus {
  loading,
  notFound,
  notVerified,
  success,
  error,
}
