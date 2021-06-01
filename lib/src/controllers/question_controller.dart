import 'dart:convert';

import 'package:Unio/src/models/questionaire_score.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:Unio/src/models/Questions.dart';
import 'package:Unio/src/screens/score/score_screen.dart';
import 'package:http/http.dart' as http;

// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar

  AnimationController _animationController;
  Animation _animation;
  // so that we can access our animation outside
  Animation get animation => this._animation;

  PageController _pageController;
  PageController get pageController => this._pageController;

  // List<Question> _questions = sample_data
  //     .map(
  //       (question) => Question(
  //           id: question['id'],
  //           question: question['question'],
  //           options: question['options'],
  //           answer: question['answer_index']),
  //     )
  //     .toList();
  List<Question> _questions;
  List<Question> get questions => this._questions;

  QuestionaireScore _score;
  QuestionaireScore get score => this._score;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  int _correctAns;
  int get correctAns => this._correctAns;

  int _selectedAns;
  int get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  // called immediately after the widget is allocated memory
  @override
  void onInit() {
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    // _animationController =
    //     AnimationController(duration: Duration(seconds: 60), vsync: this);
    // _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
    //   ..addListener(() {
    //     // update like setState
    //     update();
    //   });

    // start our animation
    // Once 60s is completed go to the next qn
    // _animationController.forward().whenComplete(nextQuestion);
    _pageController = new PageController();
    _score = new QuestionaireScore();
    fetchQuestion();
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    // _animationController.dispose();
    _pageController.dispose();
  }

  // get data from api
  Future<List<Question>> fetchQuestion() async {
    final url = Uri.parse('${SERVER_DOMAIN}questionnaire_image');
    final token = await storage.read(key: 'apiToken');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(response.body);
      var res = json.decode(response.body);
      var data = res['data'];

      // print(data);

      _questions =
          List<Question>.from(data.map((model) => Question.fromJson(model)));
      print(_questions);

      return _questions;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load questions');
    }
  }

  void checkAns(String answer, int selectedIndex) {
    // because once user press any option then it will run
    if (!_isAnswered) {}
    _isAnswered = true;
    // _correctAns = 2;
    _selectedAns = selectedIndex;

    // add score by answer
    _score.addScore(answer);

    // _score.calculateFinalScore();

    // if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // It will stop the counter
    // _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
  }

  void prevQuestion() {
    if (_questionNumber.value != 1) {
      _isAnswered = true;
      _pageController.previousPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      // _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      // _animationController.forward().whenComplete(nextQuestion);
      // update();
    } else {
      /*updateTheQnNum(0);

      resetDefault();

      // Get package provide us simple way to naviigate another page
      Get.to(() => ScoreScreen());*/
    }
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      if (!_isAnswered) {
        AlertDialog(title: Text('Please choose the answer first'));
      } else {
        _isAnswered = false;
        _pageController.nextPage(
            duration: Duration(milliseconds: 250), curve: Curves.ease);
      }

      // Reset the counter
      // _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      // _animationController.forward().whenComplete(nextQuestion);
      // update();
    } else {
      updateTheQnNum(0);

      resetDefault();

      // Get package provide us simple way to naviigate another page
      Get.to(() => ScoreScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }

  void resetDefault() {
    _isAnswered = false;
    _questionNumber = 1.obs;
    _correctAns = null;
    _selectedAns = null;
    _pageController.dispose();
    _pageController = new PageController();
    update();
  }

  void resetScore() {
    _score = new QuestionaireScore();
    update();
  }

  void adviceStudent() async {
    String finalScore = _score.calculateFinalScore();
    // update hc of student profile
    final url =
        Uri.parse('${SERVER_DOMAIN}user/set-hc/${Global.instance.authId}');
    final token = await storage.read(key: 'apiToken');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'hc': '$finalScore',
    });

    print(_score.score);
    print(response);

    // save to local storage
    storage.write(key: 'hc', value: _score.score);
    print('${_score.score} added to user profile');
    resetScore();
  }
}
