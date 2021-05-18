import 'package:Unio/src/models/major.dart';
import 'package:Unio/src/models/university.dart';
import 'package:flutter/material.dart';

class Faculty {
  String id = UniqueKey().toString();
  String name;
  String description;
  University university;
  List<Major> majorList;

  Faculty({this.name, this.description, this.university, this.majorList});
}
