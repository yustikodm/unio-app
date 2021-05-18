import 'package:Unio/src/models/faculty.dart';
import 'package:flutter/material.dart';

class University {
  String id = UniqueKey().toString();
  String name;
  String description;
  String logoSrc;
  String headerSrc;
  String type;
  String website;
  String email;
  String accreditation;
  String address;
  List<Faculty> faculty;
  

  University(
      {this.name,
      this.description,
      this.logoSrc,
      this.headerSrc,
      this.type,
      this.website,
      this.email,
      this.accreditation,
      this.address,
      this.faculty});
}
