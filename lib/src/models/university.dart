import 'package:flutter/material.dart';

class University {
  String id = UniqueKey().toString();
  int universityId;
  String name;
  String description;
  String website;
  String logo;
  String header;

  University(this.universityId, this.name, this.description, this.website,
      this.logo, this.header);
}

class UniversityList {
  List<University> _universitiesList;
  List<University> get universitiesList => _universitiesList;

  UniversityList() {
    _universitiesList = [
      new University(
          77, 'Surabaya Kampus', 'Business & Finance', '-', '-', '-'),
    ];
  }
}
