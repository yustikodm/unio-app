import 'package:Unio/config/ui_icons.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

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
          print(Global.instance.apiToken);
          if (widget.category.name != 'Ranking' &&
              widget.category.name != 'Advice') {
            // widget.category.name == 'University' || widget.category.name == 'Field of study'
            widget.onPressed(widget.category.id);
          } else if (widget.category.name == 'Advice') {
            if (Global.instance.apiToken == null) {
              _showNeedLoginAlert();
            } else {
              Navigator.of(context).pushNamed('/Advice',
                  arguments: new RouteArgument(argumentsList: [
                    Category(
                        'Advice', UiIcons.compass, true, Colors.redAccent, []),
                    ''
                  ]));
            }
          } else {
            showOkAlertDialog(
              context: context,
              title: 'This feature is under development.',
            );
          }
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            widget.category.icon,
            size: 25,
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
