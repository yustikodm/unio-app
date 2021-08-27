import 'package:Unio/config/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Unio/src/controllers/question_controller.dart';

import 'components/body.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(UiIcons.return_icon,
              color: Theme.of(context).hintColor.withOpacity(0.5)),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Stop Questionaire?'),
                  content: Text(
                      'You will have to restart all the questions. Are you sure?'),
                  actions: [
                    TextButton(
                        child: Text('Quit'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              }),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // actions: [
        //   FlatButton(onPressed: _controller.nextQuestion, child: Text("Skip")),
        // ],
      ),
      body: Body(),
    );
  }
}
