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
          if (widget.category.name == 'University' ||
              widget.category.name == 'Field of study') {
            widget.onPressed(widget.category.id);
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
