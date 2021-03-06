import 'package:Unio/src/models/favorites.dart';

import '../models/route_argument.dart';
import 'package:flutter/material.dart';

// Not Used it an optional grid
// ignore: must_be_immutable
class FavoriteGridItemWidget extends StatelessWidget {
  Favorite favorite;
  String heroTag;

  FavoriteGridItemWidget({Key key, this.heroTag, this.favorite})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Utilitie',
            arguments: new RouteArgument(
                argumentsList: [this.favorite, this.heroTag],
                id: this.favorite.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(50),
            alignment: AlignmentDirectional.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: heroTag + favorite.id,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(this.favorite.image),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  favorite.name,
                  style: Theme.of(context).textTheme.body2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  favorite.parentId.toString(),
                  style: Theme.of(context).textTheme.display1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {},
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
