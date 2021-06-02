class QuestionaireScore {
  Map _hollandCode;
  String _score;
  String get score => _score;

  Map _answers = new Map();
  Map get answers => _answers;

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
    // print(type);
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

  String calculateFinalScore() {
    countScore();
    
    var sortedKeys = _hollandCode.keys.toList(growable: false)
      ..sort((k1, k2) => _hollandCode[k2].compareTo(_hollandCode[k1]));
    print(sortedKeys);

    Map sortedMap = new Map.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => _hollandCode[k]);

    String str = "";

    sortedMap.keys.forEach((char) {
      str += char;
    });

    _score = str.substring(0, 3);
    print(sortedMap);
    return _score;
  }
}
