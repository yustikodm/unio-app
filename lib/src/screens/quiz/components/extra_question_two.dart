import 'dart:io';

import 'package:Unio/config/ui_icons.dart';
// import 'package:Unio/src/controllers/question_controller.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/screens/quiz/components/option.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Unio/src/models/category.dart';

import '../../../../constants.dart';
// import 'package:get/get.dart';

class ExtraQuestionTwoScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  dynamic oldHc;
  dynamic extraHc;
  dynamic extraQuestions;

  ExtraQuestionTwoScreen({Key key, this.routeArgument}) {
    oldHc = this.routeArgument.argumentsList[0];
    extraHc = this.routeArgument.argumentsList[1];
    extraQuestions = this.routeArgument.argumentsList[2];
  }

  @override
  _ExtraQuestionTwoScreenState createState() => _ExtraQuestionTwoScreenState();
}

class _ExtraQuestionTwoScreenState extends State<ExtraQuestionTwoScreen> {
  dynamic options;
  int order;
  bool isAnswered;
  dynamic answer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order = 1;
    isAnswered = false;
    options = [];
    normalizeData();
    // extraHc = _questionController.extraHc;
    // extraQuestions = _questionController.extraQuestions;
  }

  void normalizeData() {
    for (var i = 0; i < widget.extraHc.length; i++) {
      var type = widget.extraHc[i];
      for (var j = 0; j < widget.extraQuestions.length; j++) {
        if (widget.extraQuestions[j]['type'] == type) {
          widget.extraQuestions[j]['order'] = 0;
          options.add(widget.extraQuestions[j]);
        }
      }
    }
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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Please choose your preference',
                      style: Theme.of(context).textTheme.display1,
                    )),
                ..._extras(),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //     onPressed: () {
                      //       resetOrder();
                      //     },
                      //     child: Text('Reset')),
                      ElevatedButton(
                          onPressed: () {
                            if (isAnswered)
                              // print(order);
                              answerExtra();
                          },
                          child: Text('Done'))
                    ],
                  ),
                )
              ],
            ),
          ))),
    ));
  }

  Color getTheRightColor(option) {
    if (option['order'] == 1) {
      return kGreenColor;
    }
    return kGrayColor;
  }

  IconData getTheRightIcon(option) {
    return getTheRightColor(option) == kRedColor ? Icons.close : Icons.done;
  }

  List<Widget> _extras() {
    List<Widget> _w = [];

    for (var i = 0; i < options.length; i++) {
      _w.add(GestureDetector(
          onTap: () {
            setState(() {
              isAnswered = true;
              if (options[i]['order'] == 0) {
                options[i]['order'] = 1;
                options[(i + 1) % 2]['order'] = 0;
              }
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: kDefaultPadding),
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border.all(color: getTheRightColor(options[i]), width: 1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: getTheRightColor(options[i]).withOpacity(0.30),
                    offset: Offset(0, 4),
                    blurRadius: 15)
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(options[i]['name']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      options[i]['img'],
                      height: 100,
                      width: 200,
                    ),
                    //Image.asset("assets/" + text),
                    /*Text(
                        "${index + 1}. $text",
                        style: TextStyle(color: getTheRightColor(), fontSize: 16),
                      ),*/
                    Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: getTheRightColor(options[i]) == kGrayColor
                            ? Colors.transparent
                            : getTheRightColor(options[i]),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: getTheRightColor(options[i])),
                      ),
                      child: getTheRightColor(options[i]) == kGrayColor
                          ? null
                          : Icon(getTheRightIcon(options[i]), size: 16),
                    )
                  ],
                ),
              ],
            ),
          )));
    }

    return _w;
  }

  void resetOrder() {
    setState(() {
      for (var i = 0; i < options.length; i++) {
        options[i]['order'] = 0;
      }
      isAnswered = false;
    });
  }

  void answerExtra() async {
    var tempIndex;
    var hc = '';

    var answer = {};

    for (int i = 0; i < options.length; i++) {
      answer[options[i]['order']] = options[i]['type'];
    }

    print(answer);

    for (int i = 0; i < widget.oldHc.length; i++) {
      if (!widget.extraHc.contains(widget.oldHc[i])) {
        print(widget.oldHc[i]);
        tempIndex = i;
      }
    }

    if (tempIndex != null) {
      // ANSWER RETURN 2 HC
      if (tempIndex == 0) hc = hc + widget.oldHc[tempIndex];

      hc = hc + answer[1] + answer[0];

      if (tempIndex == 2) hc = hc + widget.oldHc[tempIndex];
    }

    print(hc);

    try {
      final url =
          Uri.parse('${SERVER_DOMAIN}user/set-hc/${Global.instance.authId}');
      final token = await storage.read(key: 'apiToken');
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'hc': hc,
      });

      print(response);

      // save to local storage
      Global.instance.authHc = hc;
      await storage.write(key: 'authHc', value: hc);

      print('${hc} added to user profile');

      Navigator.of(context).pushReplacementNamed('/Advice',
          arguments: new RouteArgument(argumentsList: [
            Category('Advice', UiIcons.compass, true, Colors.redAccent, []),
            ''
          ]));
    } on SocketException {
      throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
    }
  }
}
