import 'package:flutter/material.dart';

class Advice {
  String id = UniqueKey().toString();
  int universityId;
  String universityName;
  String universityLogo;
  int majorId;
  String majorName;
  String fos;
  bool isChecked;

  Advice(
    {@required this.universityId,
     @required this.universityName,
     @required this.universityLogo,
     @required this.majorId,
     @required this.majorName,
     @required this.fos,
     @required this.isChecked});
}

class AdviceList {
  List<Advice> _list;
  List<Advice> get list => _list;

  AdviceList() {
    _list = [];
  }
}
