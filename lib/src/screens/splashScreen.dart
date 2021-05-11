import 'package:Unio/main.dart';
import 'package:flutter/material.dart';
import '../screens/on_boarding.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:Unio/src/utilities/global.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    //storage.deleteAll();
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
    //Global.instance.authBirthDate = DateTime.parse(date);
    Global.instance.authIdentity = await storage.read(key: 'authIdentity');
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 8,
      navigateAfterSeconds: new OnBoardingWidget(),
      title: new Text(
        ' UNIO ',
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.7),
      loaderColor: Colors.white,
    );
  }
}
