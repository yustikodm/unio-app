import 'dart:async';

import 'package:Unio/config/ui_icons.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/service/http_service.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:Unio/src/utilities/regex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'dart:convert';

class RegisterWAScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  String phoneNumber;
  String email;
  dynamic data;

  RegisterWAScreen({Key key, this.routeArgument}) {
    phoneNumber = routeArgument.param1[0];
    email = routeArgument.param1[1];
    data = routeArgument.param2['data'];
  }

  @override
  _RegisterWAScreenState createState() => _RegisterWAScreenState();
}

class _RegisterWAScreenState extends State<RegisterWAScreen> {
  final myPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isSent;
  List<String> _countries = [];
  Country _selectedCountry;
  int _ratio;

  int _start = 5;
  Timer _timer;

  @override
  void initState() {
    // myPhoneController.text = widget.phoneNumber;

    _selectedCountry = CountryPickerUtils.getCountryByIsoCode('ID');
    _ratio = _selectedCountry.phoneCode.length;

    isSent = false;

    _sanitizePhoneNumber();

    _getCountryCode();

    super.initState();
  }

  // TODO GET DEFAULT PHONE CODE FROM COUNTRY CODE IN DB
  void _sanitizePhoneNumber() {
    String _code = _selectedCountry.phoneCode;
    String _phoneCode = _code.replaceAll('-', '');
    int _range = _phoneCode.length;

    print(_phoneCode);
    print(_range);

    myPhoneController.text = widget.phoneNumber.substring(_range);

    print(myPhoneController.text);
  }

  Future<void> _getCountryCode() async {
    return getService(
        SERVER_DOMAIN + 'countries',
        onSuccess: (response) {
          List countries = json.decode(response.body)['data'];
          if (countries.isNotEmpty && countries != null) {
            for (int i = 0; i < countries.length; i++) {
              String c = countries[i]['code_3166'];
              _countries.add(c);
            }
          }
        });
  }

  Future<void> _updateUser() async {
    String phoneNumber =
        _selectedCountry.phoneCode.replaceAll('-', '') + myPhoneController.text;
    int _id = widget.data['id'];
    return putService(
        SERVER_DOMAIN + 'users/' + _id.toString(),
        token: widget.data['api_token'],
        body: {'phone': phoneNumber},
        onSuccess: (response) {
          print(response.body);
        });
  }

  void _startTimer() {
    const onSec = Duration(seconds: 1);
    _timer = new Timer.periodic(onSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
          isSent = false;
          _start = 5;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
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

  Widget _countryPicker(Country country) => Row(
        children: <Widget>[
          // CountryPickerUtils.getDefaultFlagImage(country),
          Icon(
            FontAwesomeIcons.chevronDown,
            size: 12,
            color: Theme.of(context).focusColor.withOpacity(0.4),
          ),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          // SizedBox(width: 8.0),
          // Flexible(child: Text(country.name))
        ],
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) => setState(() {
              _selectedCountry = country;
              _ratio = country.phoneCode.length;
            }),
            itemFilter: (c) => _countries.contains(c.isoCode),
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

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
                    child: Row(
                      children: [
                        Expanded(
                            flex: 4 + _ratio - 2,
                            child: Container(
                              // width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    onTap: _openCountryPickerDialog,
                                    title: _countryPicker(_selectedCountry),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 9,
                          child: TextFormField(
                            validator: (value) {
                              String pattern = PHONE_NUMBER_REGEX;
                              RegExp regExp = new RegExp(pattern);

                              if (value.trim().isEmpty) {
                                return 'Phone is required';
                              } else if (!regExp.hasMatch(value)) {
                                return "Invalid Phone";
                              } else {
                                return null;
                              }
                            },
                            controller: myPhoneController,
                            style:
                                TextStyle(color: Theme.of(context).focusColor),
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle:
                                  Theme.of(context).textTheme.body1.merge(
                                        TextStyle(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.4)),
                                      ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).focusColor)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 30),
                  //     child: Text(
                  //       "$_start",
                  //       style: Theme.of(context).textTheme.display2,
                  //     )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (isSent == false) {
                            _startTimer();

                            await _updateUser();

                            String phoneNumber =
                                _selectedCountry.phoneCode.replaceAll('-', '') +
                                    myPhoneController.text;
                            await launch(
                                "https://wa.me/${WA_NUMBER}?text=!verifikasi%20UNIO%0Aphone:%20${phoneNumber}");
                            setState(() {
                              isSent = true;
                            });
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(!isSent
                                ? Color(0xFF2196F3)
                                : Color(0xffEBE8E7))),
                        child: isSent
                            ? Text('Resend in $_start')
                            : Text('Verify')),
                  )
                ],
              ),
            ))),
      ),
    );
  }
}
