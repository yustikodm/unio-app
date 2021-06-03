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
    @required this.index,
  }) : super(key: key);

  final Question question;
  final int index;

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
      child: ListView(
        shrinkWrap: true,
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
            id: 1,
            index: index,
            type: question.typeOne,
            text: question.imgOne,
            press: () => _controller.checkAns(question.typeOne, 1, index),
          ),
          Option(
            id: 2,
            index: index,
            type: question.typeTwo,
            text: question.imgTwo,
            press: () => _controller.checkAns(question.typeTwo, 2, index),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                index != 0
                    ? ElevatedButton(
                        onPressed: _controller.prevQuestion,
                        child: Text("Back"))
                    : SizedBox(),
                ElevatedButton(
                  onPressed: _controller.nextQuestion, child: Text(
                    index == 14 ? "Finish" : "Next"
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
