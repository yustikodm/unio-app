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
  List<University> _popularListHome;

  List<University> get universitiesList => _universitiesList;
  List<University> get popularListHome => _popularListHome;

  UniversityList() {
    _universitiesList = [
      new University(
          77, 'Surabaya Kampus', 'Business & Finance', '-', '-', '-'),
    ];

    _popularListHome = [
      new University(
          1,
          'Harvard University',
          'Harvard is at the frontier of academic and intellectual discovery. Those who venture hereâ€”to learn, research, teach, work, and growâ€”join nearly four centuries of students and scholars in the pursuit of truth, knowledge, and a better world.',
          'https://www.harvard.edu/',
          'img/harvard.jpg',
          'https://aseanop.com/wp-content/uploads/2019/08/Harvard-Online-Course.jpg'),
      new University(
          261,
          'Stanford University',
          'there is no description',
          'https://www.stanford.edu/',
          'img/stanford.jpg',
          'http://dev.unio.id/dashboard/images/stanford-university_573_large.jpg'),
      new University(
          3,
          'University of Oxford',
          'Universitas Oxford adalah perguruan tinggi tertua berbahasa Inggris yang berlokasi di kota Oxford, Inggris.[5] Sejarah universitas ini dapat ditelusuri paling tidak mulai akhir abad ke-11, walaupun tanggal tepat pendiriannya tetap tak jelas. Menurut legenda, setelah pecahnya kerusuhan antara mahasiswa dan penduduk kota pada tahun 1209, beberapa akademisi Oxford melarikan diri ke timur laut, ke kota Cambridge, dan mendirikan Universitas Cambridge..[6] Kedua universitas "kuno" ini sejak itu telah saling bersaing satu sama lain, dan merupakan dua perguruan tinggi paling selektif di Britania Raya, yang sering dirujuk sebagai Oxbridge.',
          'https://www.ox.ac.uk/',
          'img/oxford.jpg',
          '-'),
      new University(239, 'University of Cambridge,', 'there is no description',
          'https://www.cambridge.org/', 'img/cambridge.jpg', '-')
    ];
  }
}
