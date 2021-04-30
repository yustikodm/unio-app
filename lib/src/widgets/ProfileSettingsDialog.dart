import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../../config/ui_icons.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:Unio/src/utilities/global.dart';
import 'package:http/http.dart' as http;

class ProfileSettingsDialog extends StatefulWidget {
  User user;
  VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  Future<String> updateProfile() async {
    var res = await http.post(
        Uri.parse(SERVER_DOMAIN + 'users/' + Global.instance.authId),
        body: {
          'name': Global.instance.authName,
          'address': Global.instance.authAddress,
          'phone': Global.instance.authPhone,
          'email': Global.instance.authEmail,
          'gender': Global.instance.authGender,
          'school_origin': Global.instance.authSchool,
          'graduation_year': Global.instance.authGraduate,
          'birth_place': Global.instance.authBirthPlace,
          'birth_date': Global.instance.authBirthDate,
          'identity_number': Global.instance.authIdentity,
          'religion': Global.instance.authReligion
        });
    if (res.statusCode == 200) return res.body;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(UiIcons.user_1),
                    SizedBox(width: 10),
                    Text(
                      'Profile Settings',
                      style: Theme.of(context).textTheme.body2,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                            keyboardType: TextInputType.text,
                            decoration: getInputDecoration(
                                hintText: 'John Doe', labelText: 'Full Name'),
                            initialValue: widget.user.name,
                            validator: (input) => input.trim().length < 3
                                ? 'Not a valid full name'
                                : null,
                            onSaved: (input) => widget.user.name = input),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              hintText: 'johndo@gmail.com',
                              labelText: 'Email Address'),
                          initialValue: widget.user.email,
                          validator: (input) =>
                              !input.contains('@') ? 'Not a valid email' : null,
                          onSaved: (input) => widget.user.email = input,
                        ),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonFormField<String>(
                              decoration: getInputDecoration(
                                  hintText: 'Female', labelText: 'Gender'),
                              hint: Text("Select Gender"),
                              value: widget.user.gender,
                              onChanged: (input) {
                                setState(() {
                                  widget.user.gender = input;
                                  widget.onChanged();
                                });
                              },
                              onSaved: (input) => widget.user.gender = input,
                              items: [
                                new DropdownMenuItem(
                                    value: 'Male', child: Text('Male')),
                                new DropdownMenuItem(
                                    value: 'Female', child: Text('Female')),
                              ],
                            );
                          },
                        ),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DateTimeField(
                              decoration: getInputDecoration(
                                  hintText: '1996-12-31',
                                  labelText: 'Birth Date'),
                              format: new DateFormat('dd-MM-yyyy'),
                              //initialValue: DateTime(1996, 12, 31),
                              initialValue: widget.user.dateOfBirth,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              onSaved: (input) => setState(() {
                                widget.user.dateOfBirth = input;
                                widget.onChanged();
                              }),
                            );
                          },
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: 'Surabaya', labelText: 'Birth Place'),
                          initialValue: widget.user.birthPlace,
                          validator: (input) => input.trim().length < 3
                              ? 'Not a valid Birth Place'
                              : null,
                          onSaved: (input) => widget.user.birthPlace = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: 'Jakarta Street 19, Indonesia',
                              labelText: 'Address'),
                          initialValue: widget.user.address,
                          validator: (input) => input.trim().length < 3
                              ? 'Not a valid address'
                              : null,
                          onSaved: (input) => widget.user.address = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '08781122333', labelText: 'Phone'),
                          initialValue: widget.user.phone,
                          validator: (input) => input.trim().length < 8
                              ? 'Not a valid Phone Number'
                              : null,
                          onSaved: (input) => widget.user.phone = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: 'SMA Negeri 1 Surabaya',
                              labelText: 'School Origin'),
                          initialValue: widget.user.school,
                          validator: (input) => input.trim().length < 3
                              ? 'Not a valid school origin'
                              : null,
                          onSaved: (input) => widget.user.school = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration(
                              hintText: '2018', labelText: 'Graduation Year'),
                          initialValue: widget.user.graduate,
                          validator: (input) => input.trim().length < 3
                              ? 'Not a valid graduation year'
                              : null,
                          onSaved: (input) => widget.user.graduate = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: '999199929993',
                              labelText: 'Identity Number'),
                          initialValue: widget.user.identity,
                          validator: (input) => input.trim().length < 8
                              ? 'Not a valid identity number'
                              : null,
                          onSaved: (input) => widget.user.identity = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: 'Islam', labelText: 'Religion'),
                          initialValue: widget.user.religion,
                          validator: (input) => input.trim().length < 3
                              ? 'Not a valid religion'
                              : null,
                          onSaved: (input) => widget.user.religion = input,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          'Save',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        "Edit",
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.body1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  Future<void> _submit() async {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();

      setState(() {
        Global.instance.authName = widget.user.name;
        Global.instance.authEmail = widget.user.email;
        Global.instance.authGender = widget.user.gender;
        //Global.instance.authBirthDate = widget.user.getDateOfBirth();
        /*Global.instance.authBirthDate = DateTime.parse(
          DateFormat('dd-MM-yyyy').format(widget.user.getDateOfBirth()));*/
        Global.instance.authBirthPlace = widget.user.birthPlace;
        Global.instance.authAddress = widget.user.address;
        Global.instance.authPhone = widget.user.phone;
        Global.instance.authSchool = widget.user.school;
        Global.instance.authGraduate = widget.user.graduate;
        Global.instance.authIdentity = widget.user.identity;
        Global.instance.authReligion = widget.user.religion;

        storage.delete(key: 'authEmail');
        storage.write(key: 'authEmail', value: widget.user.email);
        storage.delete(key: 'authName');
        storage.write(key: 'authName', value: widget.user.name);
        storage.delete(key: 'authPhone');
        storage.write(key: 'authPhone', value: widget.user.phone);
        storage.delete(key: 'authGender');
        storage.write(key: 'authGender', value: widget.user.gender);
        storage.delete(key: 'authAddress');
        storage.write(key: 'authAddress', value: widget.user.address);
        storage.delete(key: 'authGraduate');
        storage.write(key: 'authGraduate', value: widget.user.graduate);
        storage.delete(key: 'authSchool');
        storage.write(key: 'authSchool', value: widget.user.school);
        //storage.delete(key: 'authBirthDate');
        /*storage.write(
          key: 'authBirthDate', value: widget.user.getDateOfBirth().toString());*/
        storage.delete(key: 'authBirthPlace');
        storage.write(key: 'authBirthPlace', value: widget.user.birthPlace);
        storage.delete(key: 'authIdentity');
        storage.write(key: 'authIdentity', value: widget.user.identity);
        storage.delete(key: 'authReligion');
        storage.write(key: 'authReligion', value: widget.user.religion);
      });

      //var jwt = await updateProfile();

      Navigator.pop(context);
    }
  }
}
