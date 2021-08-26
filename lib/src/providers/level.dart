import 'package:Unio/src/service/http_service.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class LevelProvider with ChangeNotifier {
  String _defaultLevel;
  String get defaultLevel => _defaultLevel;
  set defaultLevel(String level) {
    this._defaultLevel = level;
    print(this._defaultLevel);
    notifyListeners();
  }

  String _selectedLevel;
  String get selectedLevel => _selectedLevel;
  set selectedLevel(String level) {
    this._selectedLevel = level;
    print(this._selectedLevel);
    notifyListeners();
  }

  int _selectedLevelId;
  int get selectedLevelId => _selectedLevelId;
  set selectedLevelId(int id) {
    this._selectedLevelId = id;
    notifyListeners();
  }

  List<String> _levels = [];
  List<String> get levels => _levels;
  set levels(List<String> levels) {
    this._levels = levels;
    notifyListeners();
  }

  dynamic _levelResult;
  dynamic get levelResult => _levelResult;

  bool _checkBoxValue = false;
  bool get checkBoxValue => _checkBoxValue;
  set checkBoxValue(bool value) {
    this._checkBoxValue = value;
    notifyListeners();
  }

  bool _showCheckBox = false;
  bool get showCheckBox => _showCheckBox;
  set showCheckBox(bool value) {
    this._showCheckBox = value;
    notifyListeners();
  }

  Future<dynamic> initLevel() async {
    String url = SERVER_DOMAIN + "level_major";

    getService(url,
        onSuccess: (response) {
          print(response.body);
          _levelResult = json.decode(response.body)['data'];
          _levels.clear();
          for (var i = 0; i < _levelResult.length; i++) {
            _levels.add(_levelResult[i]['name'].toString());
          }

          if (Global.instance.authLevelId != null) {
            var selected = _levelResult.firstWhere(
                (element) => element['id'] == Global.instance.authLevelId);
            _selectedLevel = selected['name'];
            _defaultLevel = selected['name'];
            _checkBoxValue = true;
            _showCheckBox = true;
          }

          print("level=" + _selectedLevel.toString());
          notifyListeners();
        },
        onError: (err) => throw (err));
  }

  Future<dynamic> addDefault() async {
    var selected =
        _levelResult.firstWhere((element) => element['name'] == _selectedLevel);
    int _selectedLevelId = selected['id'];

    String userId = Global.instance.authId.toString();
    String token = Global.instance.apiToken.toString();
    String url = SERVER_DOMAIN + 'users/' + userId;

    putService(url, token: token, body: {
      'level_id': _selectedLevelId.toString(),
    }, onSuccess: (response) {
      print(response.body);
      dynamic result = json.decode(response.body);
      if (result["success"]) {
        _defaultLevel = _selectedLevel;
        Global.instance.authLevelId = result["data"]["biodata"]["level_id"];
        storage.write(key: 'authLevelId', value: _selectedLevelId.toString());
      } else {
        Global.instance.authLevelId = null;
        storage.write(key: 'authLevelId', value: null);
        print("UPDATE NOT SUCCESSFUL");
      }

      notifyListeners();
    });
  }

  Future<dynamic> removeDefault() async {
    _defaultLevel = null;

    String userId = Global.instance.authId.toString();
    String token = Global.instance.apiToken.toString();
    String url = SERVER_DOMAIN + 'users/' + userId;

    putService(url, token: token, body: {
      'level_id': null,
    }, onSuccess: (response) {
      print(response.body);
      dynamic result = json.decode(response.body);
      if (result["success"]) {
        Global.instance.authLevelId = null;
        storage.write(key: 'authLevelId', value: null);
      } else {
        Global.instance.authLevelId = null;
        storage.write(key: 'authLevelId', value: null);
        print("UPDATE NOT SUCCESSFUL");
      }

      notifyListeners();
    });
  }
}
