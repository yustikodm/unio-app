import 'package:Unio/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

enum UserState { available, away, busy }

class User {
  String id = UniqueKey().toString();
  String name;
  String email;
  String gender;
  DateTime dateOfBirth;
  String avatar;
  String address;
  UserState userState;

  User.init();

  User.basic(this.name, this.avatar, this.userState);

  User.advanced(this.name, this.email, this.gender, this.dateOfBirth,
      this.avatar, this.address, this.userState);

  User getCurrentUser() {
    if (apiToken == null) {
      return User.advanced(
          'Guest',
          'guest@mail.com',
          'Male',
          DateTime(1993, 12, 31),
          'img/user2.jpg',
          '4600 Isaacs Creek Road Golden, IL 62339',
          UserState.available);
    } else {
      return User.advanced(
          authName,
          authEmail,
          'male',
          DateTime(1993, 12, 31),
          'img/user1.jpg',
          '4600 Isaacs Creek Road Golden, IL 62339',
          UserState.available);
    }
  }

  getDateOfBirth() {
    return DateFormat('yyyy-MM-dd').format(this.dateOfBirth);
  }
}
