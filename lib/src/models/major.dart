import 'package:Unio/src/models/faculty.dart';
import 'package:Unio/src/models/university.dart';
import 'package:flutter/material.dart';

class Major {
  String id = UniqueKey().toString();
  String name;
  String level;
  String description;
  String accreditation;
  University university;
  Faculty faculty;

  Major({this.name, this.description, this.level, this.accreditation,
    this.university, this.faculty});
}
