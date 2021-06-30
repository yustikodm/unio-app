import 'package:Unio/src/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Unio/constants.dart';
import 'package:Unio/src/controllers/question_controller.dart';

import 'question_card.dart';

class Body extends StatelessWidget {
  Body({
    Key key,
  }) : super(key: key);

  // So that we have acccess our controller
  QuestionController _questionController = Get.put(QuestionController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // new SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        (!_questionController.hasExtra)
            ? SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      // child: ProgressBar(),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Obx(
                        () => Text.rich(
                          TextSpan(
                            text:
                                "Activity ${_questionController.questionNumber.value}",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: kSecondaryColor),
                            children: [
                              TextSpan(
                                text: "/15",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: kSecondaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(thickness: 1.5),
                    SizedBox(height: kDefaultPadding),
                    Expanded(
                      child: FutureBuilder<List<Question>>(
                        future: _questionController.fetchQuestion(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return new PageView.builder(
                              // Block swipe to next qn
                              physics: NeverScrollableScrollPhysics(),
                              controller: _questionController.pageController,
                              onPageChanged: _questionController.updateTheQnNum,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) => QuestionCard(
                                  question: snapshot.data[index], index: index),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          // By default, show a loading spinner.
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text('Test'),
      ],
    );
  }

}
