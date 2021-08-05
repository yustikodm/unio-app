import 'package:Unio/config/ui_icons.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterWAScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  dynamic phoneNumber;

  RegisterWAScreen({Key key, this.routeArgument}) {
    phoneNumber = routeArgument.param1;
  }

  @override
  _RegisterWAScreenState createState() => _RegisterWAScreenState();
}

class _RegisterWAScreenState extends State<RegisterWAScreen> {
  bool isSent;

  @override
  void initState() {
    super.initState();
    isSent = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: new Icon(UiIcons.return_icon,
                    color: Theme.of(context).hintColor.withOpacity(0.5)),
                onPressed: () => _showMyDialog(
                    message: "Are you sure you want to cancel registration?",
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          // TODO: clear registration data
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]),
              ),
              title: Text('Verify Phone Number'),
            ),
            body: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Please make sure the registered number is the same with your Whatsapp Number',
                        style: TextStyle(fontSize: 14),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        widget.phoneNumber,
                        style: Theme.of(context).textTheme.display2,
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                        onPressed: () async {
                          await launch(
                              "https://wa.me/${WA_NUMBER}?text=!verifikasi%20UNIO%0Aphone:%20${widget.phoneNumber}");
                          setState(() {
                            isSent = true;
                          });
                        },
                        child: isSent ? Text('Resend') : Text('Verify')),
                  )
                ],
              ),
            ))),
      ),
    );
  }

  Future<void> _showMyDialog({String message, List<Widget> actions}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: actions,
        );
      },
    );
  }
}
