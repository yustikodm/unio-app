import 'package:Unio/main.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/screens/quiz/quiz_screen.dart';
import 'package:Unio/src/widgets/FavoriteFilterWidget.dart';
import 'package:Unio/src/widgets/FilterWidget.dart';
import 'package:Unio/src/widgets/NewFilterWidget.dart';
import 'package:get/get.dart';

import '../../config/ui_icons.dart';
import '../screens/account.dart';
import '../screens/cart.dart';
import '../screens/chat.dart';
import '../screens/favorites.dart';
import '../screens/home.dart';
import '../screens/messages.dart';
import '../screens/notifications.dart';
import '../widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:Unio/src/utilities/global.dart';

// ignore: must_be_immutable
class TabsWidget extends StatefulWidget {
  RouteArgument routeArgument;
  int currentTab = 2;
  int selectedTab = 2;
  String currentTitle = 'Home';
  Widget currentPage = HomeWidget();

  TabsWidget({
    Key key,
    this.currentTab,
    this.routeArgument,
  }) : super(key: key);

  @override
  _TabsWidgetState createState() {
    return _TabsWidgetState();
  }
}

class _TabsWidgetState extends State<TabsWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    _selectTab(widget.currentTab);
    super.initState();
  }

  @override
  void didUpdateWidget(TabsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _showNeedLoginAlert(BuildContext context) async {
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

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      widget.selectedTab = tabItem;
      switch (tabItem) {
        // case 0:
        //   if (Global.instance.apiToken != null) {
        //     widget.currentTitle = 'Notifications';
        //     widget.currentPage = NotificationsWidget();
        //   } else {
        //     _showNeedLoginAlert(context);
        //   }
        //   break;
        case 0:
          widget.currentTitle = 'Home';
          widget.currentPage = HomeWidget();
          break;
        case 1:
          if (Global.instance.apiToken != null) {
            widget.currentTitle = 'Favorites';
            if (widget.routeArgument == null) {
              widget.currentPage = FavoritesWidget();
            } else {
              widget.currentPage = FavoritesWidget(
                routeArgument: widget.routeArgument,
              );
            }
          } else {
            _showNeedLoginAlert(context);
          }
          break;
        case 2:
          if (Global.instance.apiToken != null) {
            widget.currentTitle = 'Cart';
            widget.currentPage = CartWidget();
          } else {
            _showNeedLoginAlert(context);
          }
          break;
        // case 1:
        //   if (Global.instance.apiToken != null) {
        //     widget.currentTitle = 'Messages';
        //     widget.currentPage = MessagesWidget();
        //   } else {
        //     _showNeedLoginAlert(context);
        //   }
        //   break;
        // case 5:
        //   if (Global.instance.apiToken != null) {
        //     widget.selectedTab = 3;
        //     widget.currentTitle = 'Chat';
        //     widget.currentPage = ChatWidget();
        //   } else {
        //     _showNeedLoginAlert(context);
        //   }
        //   break;
        // case 6:
        //   widget.currentTitle = 'Profile';
        //   widget.currentPage = AccountWidget();
        //   break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      //endDrawer: FavoriteFilterWidget(),
      //endDrawer: FilterWidget(),
      endDrawer: NewFilterWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.currentTitle,
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          SizedBox()
        ],
      ),
      body: widget.currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).accentColor,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIconTheme: IconThemeData(size: 25),
        unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
        currentIndex: widget.selectedTab,
        onTap: (int i) {
          this._selectTab(i);
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
              title: new Container(height: 5.0),
              icon: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(0.8),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 40,
                        offset: Offset(0, 15)),
                    BoxShadow(
                        color: Theme.of(context).accentColor.withOpacity(0.4),
                        blurRadius: 13,
                        offset: Offset(0, 3))
                  ],
                ),
                child: new Icon(UiIcons.home,
                    color: Theme.of(context).primaryColor),
              )),
          BottomNavigationBarItem(
            icon: new Icon(UiIcons.heart),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(UiIcons.shopping_cart),
            title: new Container(height: 0.0),
          ),
        ],
      ),
    );
  }
}
