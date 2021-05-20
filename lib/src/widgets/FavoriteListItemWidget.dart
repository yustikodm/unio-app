import 'package:Unio/src/models/favorites.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import '../../config/ui_icons.dart';
import '../models/favorites.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:Unio/src/utilities/global.dart';

// ignore: must_be_immutable
class FavoriteListItemWidget extends StatefulWidget {
  String heroTag;
  Favorite favorite;
  VoidCallback onDismissed;

  FavoriteListItemWidget(
      {Key key, this.heroTag, this.favorite, this.onDismissed})
      : super(key: key);

  @override
  _FavoriteListItemWidgetState createState() => _FavoriteListItemWidgetState();
}

class _FavoriteListItemWidgetState extends State<FavoriteListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.favorite.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed();
        });

        // Then show a snackbar.
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                "The ${widget.favorite.name} favorite is removed from wish list")));
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          if (widget.favorite.entityType == 'universities' ||
              widget.favorite.entityType == 'majors') {
            Navigator.of(context).pushNamed('/Detail',
                arguments: RouteArgument(
                    param1: widget.favorite.entityId,
                    param2: widget.favorite.entityType));
          } else {
            showOkAlertDialog(
              context: context,
              title: 'This feature is under development.',
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: widget.heroTag + widget.favorite.id,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: NetworkImage(widget.favorite.image),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.favorite.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Row(
                            children: <Widget>[
                              // The title of the utilitie
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size:
                                    widget.favorite.parentName == '-' ? 1 : 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                widget.favorite.parentName.toString(),
                                style: Theme.of(context).textTheme.body1,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(convertType(widget.favorite.entityType.toString()),
                        style: Theme.of(context).textTheme.body2),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
