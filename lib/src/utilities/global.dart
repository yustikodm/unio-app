import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SERVER_DOMAIN = "https://primavisiglobalindo.net/unio/public/api/";
const SERVER_LOCAL_DOMAIN = "http://10.0.2.2:8000/api/";
const ML_DOMAIN = "http://3.137.120.216:6565/api/";
const WA_NUMBER = "6281260000980";

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
  var authHc = '';
  var authCountryId;
  var authLevelId;
}

convertType(type) {
  switch (type) {
    case 'vendors':
      return 'Vendor';
    case 'universities':
      return 'University';
    case 'majors':
      return 'Field of Study';
    case 'services':
      return 'Service';
    case 'place_lives':
      return 'Place to Live';
    default:
      return '-';
  }
}
