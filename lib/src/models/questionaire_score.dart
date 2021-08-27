import 'package:flutter/cupertino.dart';

class QuestionaireScore {
  Map _hollandCode;
  dynamic _score;
  dynamic get score => _score;

  Map _answers = new Map();
  Map get answers => _answers;

  bool _hasExtra = false;
  bool get hasExtra => _hasExtra;

  List<dynamic> _extraQuestions;
  List<dynamic> get extraQuestions => _extraQuestions;

  QuestionaireScore() {
    this._hollandCode = {
      'R': 0,
      'I': 0,
      'A': 0,
      'S': 0,
      'E': 0,
      'C': 0,
    };
  }

  void addScore(String type, int index) {
    print(type);
    switch (type) {
      case 'R':
        _answers[index] = 'R';
        break;
      case 'I':
        _answers[index] = 'I';
        break;
      case 'A':
        _answers[index] = 'A';
        break;
      case 'S':
        _answers[index] = 'S';
        break;
      case 'E':
        _answers[index] = 'E';
        break;
      case 'C':
        _answers[index] = 'C';
        break;
    }
  }

  void countScore() {
    _answers.forEach((key, value) {
      switch (value) {
        case 'R':
          _hollandCode['R'] += 1;
          break;
        case 'I':
          _hollandCode['I'] += 1;
          break;
        case 'A':
          _hollandCode['A'] += 1;
          break;
        case 'S':
          _hollandCode['S'] += 1;
          break;
        case 'E':
          _hollandCode['E'] += 1;
          break;
        case 'C':
          _hollandCode['C'] += 1;
          break;
      }
    });
  }

  dynamic calculateFinalScore() {
    countScore();

    var sortedKeys = _hollandCode.keys.toList(growable: false)
      ..sort((k1, k2) => _hollandCode[k2].compareTo(_hollandCode[k1]));
    print(sortedKeys);

    Map sortedMap = new Map.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => _hollandCode[k]);
    print(sortedMap);

    // ONLY WORKS IF DATA IS SORTED FROM HIGH TO LOW
    // List code = sortedMap.keys.toList();
    List hcTemp = [];
    String scoreTemp = "";
    // var hcMap = {};

    int pointer = 0;
    // int len = 0;

    while (pointer < 3) {
      var val = sortedMap[sortedKeys[pointer]];
      var n1 = sortedMap[sortedKeys[pointer + 1]];
      var n2 = sortedMap[sortedKeys[pointer + 2]];

      if (val == n1 && val == n2) {
        hcTemp.add(sortedKeys[pointer]);
        hcTemp.add(sortedKeys[pointer + 1]);
        hcTemp.add(sortedKeys[pointer + 2]);
        scoreTemp = scoreTemp + '_';
        pointer = pointer + 3;
        continue;
      }

      if (val == n1) {
        hcTemp.add(sortedKeys[pointer]);
        hcTemp.add(sortedKeys[pointer + 1]);
        scoreTemp = scoreTemp + '_';
        pointer = pointer + 2;
        continue;
      }

      scoreTemp = scoreTemp + sortedKeys[pointer];
      pointer = pointer + 1;
    }

    print(hcTemp);
    print(scoreTemp);

    // for (var i = 0; i < 3; i++) {
    //   var _v = sortedMap[sortedKeys[i]];

    //   if (scoreTemp == null) {
    //     scoreTemp = _v;
    //   }

    //   if (scoreTemp == _v) {
    //     hcTemp.add(sortedKeys[i]);
    //   }

    //   if (scoreTemp != _v && hcTemp.length < 2) {
    //     hcTemp.clear();
    //     hcTemp.add(sortedKeys[i]);
    //     scoreTemp = _v;
    //   }
    // }

    if (hcTemp.length > 1) {
      _score = {
        'has_extra': true,
        'score': scoreTemp,
        // 'old_hc': [sortedKeys[0], sortedKeys[1], sortedKeys[2]],
        'extra_hc': hcTemp,
      };
    } else {
      _score = {
        'has_extra': false,
        'score': scoreTemp,
      };
    }

    return _score;
  }
}
