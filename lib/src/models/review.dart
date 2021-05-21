import 'dart:math';

import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class Review {
  String id = UniqueKey().toString();
  User user;
  String review;
  double rate;
  DateTime dateTime =
      DateTime.now().subtract(Duration(days: Random().nextInt(20)));

  Review(this.user, this.review, this.rate);

  getDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').format(this.dateTime);
  }
}

class ReviewsList {
  List<Review> _reviewsList;

  List<Review> get reviewsList => _reviewsList;

  ReviewsList() {
    this._reviewsList = [
      new Review(
          new User.basic('Anam Saputra', 'img/user0.jpg', UserState.available),
          'Best University in the world',
          5.0),
    ];
  }
}
