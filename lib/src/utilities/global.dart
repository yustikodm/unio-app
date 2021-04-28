class Global {
  static final Global _singleton = new Global._internal();
  Global._internal();
  static Global get instance => _singleton;

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
