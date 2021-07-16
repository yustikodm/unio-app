import 'package:Unio/main.dart';
import 'package:Unio/src/screens/signin.dart';
import 'package:Unio/src/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/on_boarding.dart';
import 'package:Unio/src/utilities/global.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // storage.deleteAll();
    getAuthData();
    // TODO: implement initState
    super.initState();
  }

  getAuthData() async {
    var date = await storage.read(key: 'authBirthDate');
    print(date);
    print('lala');
    Global.instance.authId = await storage.read(key: 'authId');
    Global.instance.apiToken = await storage.read(key: 'apiToken');
    Global.instance.authName = await storage.read(key: 'authName');
    Global.instance.authEmail = await storage.read(key: 'authEmail');
    Global.instance.authGender = await storage.read(key: 'authGender');
    Global.instance.authPicture = await storage.read(key: 'authPicture');
    Global.instance.authPhone = await storage.read(key: 'authPhone');
    Global.instance.authAddress = await storage.read(key: 'authAddress');
    Global.instance.authSchool = await storage.read(key: 'authSchool');
    Global.instance.authGraduate = await storage.read(key: 'authGraduate');
    Global.instance.authBirthPlace = await storage.read(key: 'authBirthPlace');
    Global.instance.authBirthDate = date != 'null' ? DateTime.parse(date) : null;
    Global.instance.authIdentity = await storage.read(key: 'authIdentity');
    Global.instance.authHc = await storage.read(key: 'authHc');
    Global.instance.authCountryId = int.parse(await storage.read(key: 'authCountryId'));
    Global.instance.authLevelId = int.parse(await storage.read(key: 'authLevelId'));
  }

  @override
  Widget build(BuildContext context) {
    return new SplashPage(
      seconds: 8,
      navigateAfterSeconds: new OnBoardingWidget(),
      logo: SvgPicture.asset(
        'assets/icons/uniologoputih.svg',
        color: Colors.white,
        width: 40.0,
        height: 40.0,
      ),
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
      loaderColor: Colors.white,
    );
  }
}
