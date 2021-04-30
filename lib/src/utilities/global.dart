import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SERVER_DOMAIN = "https://primavisiglobalindo.net/unio/public/api/";
final storage = FlutterSecureStorage();

class Global {
  static final Global _singleton = new Global._internal();
  Global._internal();
  static Global get instance => _singleton;

  var authId;
  var apiToken;
  var authName;
  var authEmail;
  var authGender;
  DateTime authBirthDate;
  var authBirthPlace = '';
  var authPicture = '';
  var authAddress = '-';
  var authPhone = "-";
  var authSchool = '-';
  var authGraduate;
  var authIdentity = '';
  var authReligion = '';
}
