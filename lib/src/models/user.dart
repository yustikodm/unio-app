import 'package:Unio/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:Unio/src/utilities/global.dart';

enum UserState { available, away, busy }

class User {
  String id = UniqueKey().toString();
  String name;
  String email;
  String gender;
  DateTime dateOfBirth;
  String birthPlace;
  String avatar;
  String address;
  String phone;
  String school;
  String graduate;
  String identity;
  String religion;

  UserState userState;

  User.init();

  User.basic(this.name, this.avatar, this.userState);

  User.advanced(
      this.name,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.birthPlace,
      this.avatar,
      this.address,
      this.phone,
      this.school,
      this.graduate,
      this.identity,
      this.religion,
      this.userState);

  User getCurrentUser() {
    if (Global.instance.apiToken == null) {
      return User.advanced(
          'Guest User',
          'guest@mail.com',
          'Male',
          DateTime(2000, 01, 01),
          'Surabaya',
          'img/user2.jpg',
          '4600 Isaacs Creek Road Golden, IL 62339',
          '08781223334',
          'SMA Negeri 1 Surabaya',
          '2018',
          '992991992991',
          'Islam',
          UserState.available);
    } else {
      return User.advanced(
          Global.instance.authName ?? '-',
          Global.instance.authEmail ?? '-',
          Global.instance.authGender ?? '-',
          Global.instance.authBirthDate ?? '-',
          Global.instance.authBirthPlace ?? '-',
          Global.instance.authPicture ?? '-',
          Global.instance.authAddress ?? '-',
          Global.instance.authPhone ?? '-',
          Global.instance.authSchool ?? '-',
          Global.instance.authGraduate ?? '-',
          Global.instance.authIdentity ?? '-',
          Global.instance.authReligion ?? '-',
          UserState.available);
    }
  }

  getDateOfBirth() {
    return DateFormat('dd-MM-yyyy').format(this.dateOfBirth);
  }

  String initials() {
    List<String> name = this.name.split(' ');

    return ((name[0] != null ? name[0][0] : "") +
            (name.length > 1 ? (name[1] != null ? name[1][0] : "") : ""))
        .toUpperCase();
  }

  bool hasPicture() {
    final url_avatar = 'https://ui-avatars.com/api/';
    final uri = Uri.parse(url_avatar);
    if (uri.host == 'ui-avatars.com') {
      return false;
    } else {
      return true;
    }
  }
}
