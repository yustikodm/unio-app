import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import '../models/carts.dart';

class CartsGridItemWidget extends StatelessWidget {
  const CartsGridItemWidget({
    Key key,
    @required this.carts,
    @required this.heroTag,
  }) : super(key: key);

  final Carts carts;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Utilities',
            arguments: new RouteArgument(
                argumentsList: [this.carts, this.heroTag], id: this.carts.id));
      },
      child: Container(
        //margin: EdgeInsets.all(20),
        //alignment: AlignmentDirectional.topCenter,
        //padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.10),
                offset: Offset(0, 4),
                blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: this.heroTag + carts.id,
              child: Image.asset('img/icon_campus.jpg'),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                carts.name,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${carts.totalPrice} Point',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // The title of the product
                  Expanded(
                    child: Text(
                      'Qty: ' + carts.qty.toString(),
                      style: Theme.of(context).textTheme.body1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  Text(
                    '',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Icon(
                    Icons.attach_money,
                    color: Colors.amber,
                    size: 18,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    carts.price.toString(),
                    style: Theme.of(context).textTheme.body2,
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
