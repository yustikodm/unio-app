import 'package:Unio/main.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/screens/quiz/quiz_screen.dart';
import 'package:Unio/src/widgets/FavoriteFilterWidget.dart';
import 'package:Unio/src/widgets/FilterWidget.dart';
import 'package:Unio/src/widgets/NewFilterWidget.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  int currentTab = 0;
  int selectedTab = 0;
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
        // case 0:
        //   widget.currentTitle = 'Home';
        //   widget.currentPage = HomeWidget();
        //   break;
        // case 1:
        //   if (Global.instance.apiToken != null) {
        //     widget.currentTitle = 'Favorites';
        //     if (widget.routeArgument == null) {
        //       widget.currentPage = FavoritesWidget();
        //     } else {
        //       widget.currentPage = FavoritesWidget(
        //         routeArgument: widget.routeArgument,
        //       );
        //     }
        //   } else {
        //     _showNeedLoginAlert(context);
        //   }
        //   break;
        // case 2:
        //   if (Global.instance.apiToken != null) {
        //     widget.currentTitle = 'Cart';
        //     widget.currentPage = CartWidget();
        //   } else {
        //     _showNeedLoginAlert(context);
        //   }
        //   break;
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
          IconButton(
            icon: Icon(
              FontAwesomeIcons.fileAlt,
              color: Theme.of(context).hintColor,
              size: 18,
            ),
            tooltip: 'Feedback Form',
            onPressed: () {
              (Global.instance.apiToken != null)
                  ? Navigator.of(context).pushNamed('/WebView',
                      arguments: new RouteArgument(argumentsList: [
                        'https://forms.gle/vd15DFBGPDKvRCyP7'
                      ]))
                  : _showNeedLoginAlert(context);
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.solidHeart,
              color: Theme.of(context).hintColor,
              size: 18,
            ),
            tooltip: 'My Bookmark',
            onPressed: () {
              (Global.instance.apiToken != null)
                  ? Navigator.of(context).pushNamed('/Bookmark')
                  : _showNeedLoginAlert(context);
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.shoppingCart,
              color: Theme.of(context).hintColor,
              size: 18,
            ),
            tooltip: 'My Cart',
            onPressed: () {
              showOkAlertDialog(
                context: context,
                title: 'This feature is under development.',
              );
            },
          ),
        ],
      ),
      body: HomeWidget(),
    );
  }
}
