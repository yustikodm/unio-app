import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:Unio/src/controllers/question_controller.dart';
import 'package:get/get.dart';

import '../../../../constants.dart';

class Option extends StatelessWidget {
  const Option({
    Key key,
    this.image,
    this.id,
    this.index,
    this.press,
    this.type,
    this.title,
  }) : super(key: key);
  final String image;
  final int id;
  final int index;
  final VoidCallback press;
  final String type;
  final String title;

  @override
  Widget build(BuildContext context) {
    // QuestionController _questionController = Get.put(QuestionController());
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (qnController) {
          // print(qnController.score.answers);

          Color getTheRightColor() {
            if (qnController.isAnswered ||
                qnController.score.answers.containsKey(index)) {
              qnController.isAnswered = true;
              if (type == qnController.score.answers[index]) {
                return kGreenColor;
              } else {
                return kRedColor;
              }
            }
            return kGrayColor;
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
          }

          return InkWell(
            onTap: press,
            child: Container(
              margin: EdgeInsets.only(top: kDefaultPadding),
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                border: Border.all(color: getTheRightColor()),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: <Widget>[
                  Text(title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        image,
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
                          color: getTheRightColor() == kGrayColor
                              ? Colors.transparent
                              : getTheRightColor(),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: getTheRightColor()),
                        ),
                        child: getTheRightColor() == kGrayColor
                            ? null
                            : Icon(getTheRightIcon(), size: 16),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
