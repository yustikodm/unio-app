import 'package:flutter/material.dart';

class Advice {
  String id = UniqueKey().toString();
  int universityId;
  String universityName;
  int majorId;
  String majorName;
  String fos;

  Advice(this.universityId, this.universityName, this.majorId, this.majorName,
      this.fos);
}

class AdviceList {
  List<Advice> _adviceList;
  List<Advice> get adviceList => _adviceList;

  AdviceList() {
    _adviceList = [];
  }
}
