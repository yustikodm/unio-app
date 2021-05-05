import '../../config/ui_icons.dart';
import '../models/carts.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Unio/src/utilities/global.dart';

// ignore: must_be_immutable
class CartListItemWidget extends StatefulWidget {
  String heroTag;
  Carts carts;
  VoidCallback onDismissed;

  CartListItemWidget({Key key, this.heroTag, this.carts, this.onDismissed})
      : super(key: key);

  @override
  _CartListItemWidgetState createState() => _CartListItemWidgetState();
}

class _CartListItemWidgetState extends State<CartListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.carts.hashCode.toString()),
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
                "The ${widget.carts.name} utilitie is removed from wish list")));
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Utilities',
              arguments: new RouteArgument(
                  argumentsList: [this.widget.carts, this.widget.heroTag],
                  id: this.widget.carts.id));
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
                tag: widget.heroTag + widget.carts.id,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: NetworkImage(widget.carts.image),
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
                            widget.carts.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 3),
                              Text(
                                'Qty: ' + widget.carts.qty.toString(),
                                style: Theme.of(context).textTheme.body1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              // The title of the utilitie
                              Icon(
                                Icons.attach_money,
                                color: Colors.amber,
                                size: 12,
                              ),
                              Text(
                                widget.carts.price.toString(),
                                style: Theme.of(context).textTheme.body1,
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('${widget.carts.totalPrice} Point',
                        style: Theme.of(context).textTheme.display1),
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
