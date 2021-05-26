import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Unio/src/controllers/question_controller.dart';
import 'package:Unio/src/models/Questions.dart';

import '../../../../constants.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key key,
    // it means we have to pass this
    @required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            'If you like doing activities? click on the image.',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: kBlackColor),
          ),
          SizedBox(height: kDefaultPadding / 2),
          Option(
            index: 1,
            text: question.imgOne,
            press: () => _controller.checkAns(question.typeOne, 1),
          ),
          Option(
            index: 2,
            text: question.imgTwo,
            press: () => _controller.checkAns(question.typeTwo, 2),
          ),
          FlatButton(onPressed: _controller.prevQuestion, child: Text("Back")),
          FlatButton(onPressed: _controller.nextQuestion, child: Text("Next")),
        ],
      ),
    );
  }
}
