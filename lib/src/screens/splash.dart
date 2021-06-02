import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  SplashPage(
      {Key key,
      this.navigateAfterSeconds,
      this.seconds,
      this.backgroundColor,
      this.loaderColor,
      this.logo})
      : super(key: key);

  _SplashPageState createState() => _SplashPageState();

  final dynamic navigateAfterSeconds;
  final int seconds;
  final Color backgroundColor;
  final Color loaderColor;
  final Widget logo;
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  afterSplash() {
    // after seconds navigate to homepage
    Future.delayed(Duration(seconds: widget.seconds)).then((value) {
      gotoHomePage();
    });
  }

  gotoHomePage() {
    if (widget.navigateAfterSeconds is String) {
      Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
    } else if (widget.navigateAfterSeconds is Widget) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => widget.navigateAfterSeconds));
    } else {
      throw new ArgumentError(
          'widget.navigateAfterSeconds must either be a String or Widget');
    }
  }

  @override
  void initState() {
    super.initState();
    afterSplash();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.backgroundColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: widget.logo,
              ),
              CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(widget.loaderColor),
              )
            ]),
      ),
    );
  }
}
