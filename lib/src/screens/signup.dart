import 'dart:convert';
import 'package:Unio/src/providers/authentication.dart';
import 'package:Unio/src/service/http_service.dart';
import 'package:Unio/src/utilities/regex.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/SocialMediaWidget.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  bool _showPassword = false;
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  // final myPasswordConfirmationController = TextEditingController();
  final myNameController = TextEditingController();
  final myPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> _countries = [];
  Country _selectedCountry;

  int _ratio;

  @override
  void initState() {
    super.initState();

    _selectedCountry = CountryPickerUtils.getCountryByIsoCode('ID');
    _ratio = _selectedCountry.phoneCode.length;

    _getCountryCode();
  }

  Future<void> _getCountryCode() async {
    return getService(SERVER_DOMAIN + 'countries', onSuccess: (response) {
      List countries = json.decode(response.body)['data'];
      if (countries.isNotEmpty && countries != null) {
        for (int i = 0; i < countries.length; i++) {
          String c = countries[i]['code_3166'];
          _countries.add(c);
        }
      }
    });
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

  Widget build(BuildContext context) {
    final _authProvider = context.read<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  margin: EdgeInsets.fromLTRB(20, 70, 20, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 20)
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Text('Sign Up',
                            style: Theme.of(context).textTheme.display2),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            String pattern = FULLNAME_REGEX;
                            RegExp regExp = new RegExp(pattern);
                            if (value.isEmpty) {
                              return 'Name is required';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Invalid Name';
                            } else {
                              return null;
                            }
                          },
                          controller: myNameController,
                          style: TextStyle(color: Theme.of(context).focusColor),
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: Theme.of(context).textTheme.body1.merge(
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
                            prefixIcon: Icon(
                              UiIcons.user_1,
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            String pattern = EMAIL_REGEX;
                            RegExp regExp = new RegExp(pattern);
                            if (value.isEmpty) {
                              return 'Email is required';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Invalid Email';
                            } else {
                              return null;
                            }
                          },
                          controller: myEmailController,
                          style: TextStyle(color: Theme.of(context).focusColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: Theme.of(context).textTheme.body1.merge(
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
                            prefixIcon: Icon(
                              UiIcons.envelope,
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password is required';
                            } else {
                              return null;
                            }
                          },
                          controller: myPasswordController,
                          style: TextStyle(color: Theme.of(context).focusColor),
                          keyboardType: TextInputType.text,
                          obscureText: !_showPassword,
                          decoration: new InputDecoration(
                            hintText: 'Password',
                            hintStyle: Theme.of(context).textTheme.body1.merge(
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
                            prefixIcon: Icon(
                              UiIcons.padlock_1,
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.4),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              color:
                                  Theme.of(context).focusColor.withOpacity(0.4),
                              icon: Icon(_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 4 + _ratio - 2,
                                child: Container(
                                  // width: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                style: TextStyle(
                                    color: Theme.of(context).focusColor),
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
                                  // prefixIcon: Icon(
                                  //   UiIcons.phone_call,
                                  //   color: Theme.of(context)
                                  //       .focusColor
                                  //       .withOpacity(0.4),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 70),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _authProvider.register(
                                email: myEmailController.text,
                                password: myPasswordController.text,
                                name: myNameController.text,
                                phone: _selectedCountry.phoneCode
                                        .replaceAll('-', '') +
                                    myPhoneController.text,
                                context: context,
                              );
                            }
                          },
                          child: Text(
                            'Sign Up',
                            style: Theme.of(context).textTheme.title.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(height: 50),
                        Text(
                          'Or using social media',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        SizedBox(height: 20),
                        new SocialMediaWidget()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/SignIn');
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(color: Theme.of(context).primaryColor),
                      ),
                  children: [
                    TextSpan(text: 'Already have an account ?'),
                    TextSpan(
                        text: ' Sign In',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
