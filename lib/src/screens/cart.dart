import '../../config/ui_icons.dart';
import '../models/utilities.dart';
import '../widgets/EmptyCartWidget.dart';
import '../widgets/CartListItemWidget.dart';
import '../widgets/UtilitiesGridItemWidget.dart';
import '../widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  String layout = 'list';
  UtilitiesList _utilitiesList = new UtilitiesList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBarWidget(),
          ),
          SizedBox(height: 10),
          Offstage(
            offstage: _utilitiesList.cartList.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                leading: Icon(
                  UiIcons.shopping_cart,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Cart',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.display1,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'list';
                        });
                      },
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: this.layout == 'list'
                            ? Theme.of(context).focusColor
                            : Theme.of(context).focusColor.withOpacity(0.4),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'grid';
                        });
                      },
                      icon: Icon(
                        Icons.apps,
                        color: this.layout == 'grid'
                            ? Theme.of(context).focusColor
                            : Theme.of(context).focusColor.withOpacity(0.4),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: this.layout != 'list' || _utilitiesList.cartList.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _utilitiesList.cartList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return CartListItemWidget(
                  heroTag: 'cart_list',
                  utilitie: _utilitiesList.cartList.elementAt(index),
                  onDismissed: () {
                    setState(() {
                      _utilitiesList.cartList.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          Offstage(
            offstage: this.layout != 'grid' || _utilitiesList.cartList.isEmpty,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: new StaggeredGridView.countBuilder(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: _utilitiesList.cartList.length,
                itemBuilder: (BuildContext context, int index) {
                  Utilitie utilitie = _utilitiesList.cartList.elementAt(index);
                  return UtilitietGridItemWidget(
                    utilitie: utilitie,
                    heroTag: 'cart_grid',
                  );
                },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
            ),
          ),
          Offstage(
            offstage: _utilitiesList.cartList.isNotEmpty,
            child: EmptyCartWidget(),
          )
        ],
      ),
    );
  }
}
