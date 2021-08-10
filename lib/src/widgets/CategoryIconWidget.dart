import 'package:Unio/config/ui_icons.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/screens/quiz/quiz_screen.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:get/get.dart';

import '../models/category.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryIconWidget extends StatefulWidget {
  Category category;
  ValueChanged<String> onPressed;

  CategoryIconWidget({Key key, this.category, this.onPressed})
      : super(key: key);

  @override
  _CategoryIconWidgetState createState() => _CategoryIconWidgetState();
}

class _CategoryIconWidgetState extends State<CategoryIconWidget>
    with SingleTickerProviderStateMixin {
  Future<void> _showNeedLoginAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You are not logged in!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you wanna login first?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pushNamed('/SignIn');
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildCategory(context),
    );
  }

  FlatButton buildCategory(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: () {
        setState(() {
          // print(Global.instance.apiToken);

          switch (widget.category.name) {
            case 'Ranking':
              // widget.onPressed(widget.category.id);
              showOkAlertDialog(
                context: context,
                title: 'This feature is under development.',
              );
              break;

            case 'Match With Me':
              if (Global.instance.apiToken == null) {
                _showNeedLoginAlert();
              } else {
                if (Global.instance.authHc == '') {
                  print("quetionary");
                  Get.to(() => QuizScreen());
                } else {
                  print("Match With Me");
                  Navigator.of(context).pushNamed('/Advice',
                      arguments: new RouteArgument(argumentsList: [
                        Category('Match With Me', UiIcons.compass, true,
                            Colors.redAccent, []),
                        ''
                      ]));
                }
              }
              break;

            case 'Questionnaire':
              if (Global.instance.apiToken != null) {
                Get.to(() => QuizScreen());
              } else {
                _showNeedLoginAlert();
              }
              break;

            case 'Bookmark':
              Navigator.pushNamed(context, '/Bookmark');
              break;

            case 'Cart':
              showOkAlertDialog(
                context: context,
                title: 'This feature is under development.',
              );
              break;

            default:
              widget.onPressed(widget.category.id);
              break;
          }
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            widget.category.icon,
            size: 25,
            color: Color(0xFF007BFF),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            widget.category.name,
            style: Theme.of(context).textTheme.body1,
          ),
        ],
      ),
    );
  }
}
