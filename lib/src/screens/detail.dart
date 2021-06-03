import 'dart:convert';
import 'dart:io';

import 'package:Unio/src/models/product_color.dart';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/widgets/CircularLoadingWidget.dart';
import 'package:Unio/src/widgets/ReviewsListWidget.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import '../../config/ui_icons.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/DrawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Color bookmarkColor = Color(0xFFFFFFFF);

  DetailWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget>
    with SingleTickerProviderStateMixin {
  dynamic data;
  String detailType;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  int _tabIndex = 0;

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

  @override
  void initState() {
    detailType = widget.routeArgument.param2;
    getData(widget.routeArgument.param1, detailType);
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);

    print('lala');
    super.initState();
  }

  Future<String> addBookmark() async {
    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var url = SERVER_DOMAIN + 'wishlists';
    var token = Global.instance.apiToken;
    headers.addAll(
        <String, String>{HttpHeaders.authorizationHeader: 'Bearer $token'});
    print(url);
    print(headers);

    final client = new http.Client();
    final response = await client.post(Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'user_id': Global.instance.authId,
          'entity_id': widget.routeArgument.param1,
          'entity_type': widget.routeArgument.param2,
        }));
    print(response.body);

    if (response.statusCode == 200) return response.body;
    return null;
  }

  void _launchURL(url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch url';
  }

  void _launchMap(uri) async {
    await canLaunch('http://maps.google.com/?q=' + uri)
        ? await launch('http://maps.google.com/?q=' + uri)
        : throw 'Could not launch http://maps.google.com/?q=' + uri;
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? CircularLoadingWidget(
            height: double.infinity,
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: DrawerWidget(),
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: Container(
                height: 20,
              ),
            ),
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(UiIcons.return_icon,
                      color: Theme.of(context).hintColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  //new ShoppingCartButtonWidget(
                  //iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
                  Container(
                      width: 30,
                      height: 30,
                      margin:
                          EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(300),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/Tabs', arguments: 1);
                        },
                        /*child: CircleAvatar(
                          backgroundImage: AssetImage('img/user2.jpg'),
                        ),*/
                      )),
                ],
                backgroundColor: Theme.of(context).primaryColor,
                expandedHeight: 350,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: 'lala tag',
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                          width: double.infinity,
                          // decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //         image: new NetworkImage(data['header_src']))),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Theme.of(context).primaryColor,
                                Colors.white.withOpacity(0),
                                Colors.white.withOpacity(0),
                                Theme.of(context).scaffoldBackgroundColor
                              ],
                                  stops: [
                                0,
                                0.4,
                                0.6,
                                1
                              ])),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                    unselectedLabelColor:
                        Theme.of(context).focusColor.withOpacity(1),
                    labelColor: Theme.of(context).primaryColor,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).focusColor.withOpacity(0.6)),
                    tabs: [
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            //border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.6), width: 1)
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Detail"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            //border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.2), width: 1)
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Review"),
                          ),
                        ),
                      ),
                    ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Offstage(
                    offstage: 0 != _tabIndex,
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 22, left: 20, right: 20),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      data['name'] != null ? data['name'] : '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.display2,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (Global.instance.apiToken != null) {
                                        var jwt = await addBookmark();
                                        if (jwt != null) {
                                          var data = json.decode(jwt);
                                          showOkAlertDialog(
                                            context: context,
                                            title: data['message'],
                                          );
                                          setState(() {
                                            widget.bookmarkColor = (data[
                                                        'message'] ==
                                                    'Unbookmarked successfully')
                                                ? Color(0xFFFFFFFF)
                                                : Color(0xFFC1C1C1);
                                          });
                                        }
                                      } else {
                                        _showNeedLoginAlert(context);
                                      }
                                    },
                                    child: Chip(
                                      padding: EdgeInsets.all(0),
                                      label: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.bookmark,
                                            color: widget.bookmarkColor,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Chip(
                                    padding: EdgeInsets.all(0),
                                    label: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('5.0',
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2
                                                .merge(TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor))),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.star_border,
                                          color: Theme.of(context).primaryColor,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.9),
                                    shape: StadiumBorder(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          detailType != 'universities'
                                              ? Text(
                                                  data['level'] != null
                                                      ? 'Level : ' +
                                                          data['level']
                                                      : '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .body2)
                                              : SizedBox(),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (detailType ==
                                                    'universities') {
                                                  _launchURL(data['website']);
                                                } else {
                                                  _launchURL(data['university']
                                                      ['website']);
                                                }
                                              });
                                            },
                                            child: Text(
                                                detailType == 'universities'
                                                    ? data['website']
                                                    : data['university']
                                                        ['website'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body2),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  /*Text("Indonesia, Jakarta",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.body2),*/
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      UiIcons.file_2,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      'Description',
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                //   child: Text(widget.utilitie.description.split("#")[0]),
                                // ),
                                new Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  // height: MediaQuery.of(context).size.height * 0.15,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Text(widget.utilitie.description.split("#")[0],maxLines: 5,),
                                      Text(
                                        data['description'] ??
                                            'There is no description',
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  child: Text(detailType == 'universities'
                                      ? data['address']
                                      : data['university']['address']),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      UiIcons.file_2,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      'Facility',
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                //   child: Text("-"),
                                // ),
                                new Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.credit_card,
                                              ),
                                              Text("Accept Credit Card"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_parking,
                                              ),
                                              Text("Parking"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.pets,
                                              ),
                                              Text("Pet Friendly"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.wifi,
                                              ),
                                              Text("Wireless Internet"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.laptop_chromebook_sharp,
                                              ),
                                              Text("Offering a deal"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.payment,
                                              ),
                                              Text("Apple Pay"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: SizedBox(
                                height: 180,
                                width: double.maxFinite,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (detailType != 'universities') {
                                        _launchMap(data['university']['name']);
                                      } else {
                                        _launchMap(data['name']);
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        image: DecorationImage(
                                          image: AssetImage('img/gps.png'),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  UiIcons.box,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  'Related',
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),*/
                            /*PopularLocationCarouselWidget(
                                heroTag: 'product_related_products',
                                utilitiesList: widget._productsList.popularList),*/
                          ],
                        )
                        /*UtilitieHomeTabWidget(utilitie: widget._utilitie),*/
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: 1 != _tabIndex,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              UiIcons.chat_1,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              'Reviews',
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                        ),
                        ReviewsListWidget()
                      ],
                    ),
                  )
                ]),
              )
            ]),
          );
  }

  getData(int relationId, String type) async {
    String subUrl;
    switch (type) {
      case 'universities':
        subUrl = 'universities/';
        break;
      case 'majors':
        subUrl = 'university-majors/';
        break;
      case 'place_lives':
        subUrl = 'place-to-lives/';
        break;
      case 'services':
        subUrl = 'vendor-services/';
        break;
      case 'vendors':
        subUrl = 'vendors/';
        break;
      default:
        subUrl = 'universities/';
        break;
    }

    String url = SERVER_DOMAIN + subUrl + relationId.toString();

    Map<String, dynamic> request = Map();
    request['user_id'] = Global.instance.authId ?? '';
    /*request['user_id'] = Global.instance.authId;
    request['entity_type'] = '';
    request['name'] = '';*/

    String requestMap = '';
    int index = 0;
    request.forEach((key, value) {
      requestMap += '$key=$value';
      if (index != request.length - 1) requestMap += '&';
      index++;
    });
    url += '?$requestMap';

    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var token = Global.instance.apiToken ??
        'RzEnFml7Pms7H7uL3djU8GeeGWC6FA3sdwMwsmBpZMtlgnxXlxEK3SNKxXqODS3o6XAo815HG8lmJdCZ8Wik9MHYFcD785KrgMQN';
    headers.addAll(
        <String, String>{HttpHeaders.authorizationHeader: 'Bearer $token'});
    print('============ noted: token ' + token);

    try {
      final client = new http.Client();
      final response = await client
          .get(
        Uri.parse(url),
        headers: headers,
        // body: json.encode(request),
      )
          .timeout(Duration(seconds: 60), onTimeout: () {
        throw 'Koneksi terputus. Silahkan coba lagi.';
      });
      print('========= noted: get requestMap ' +
          request.toString() +
          "===== url " +
          url);

      // var result = Map<String, dynamic>();
      if (response.statusCode == 200) {
        print('========= noted: get response body ' + response.body.toString());
        if (response.body.isNotEmpty) {
          dynamic jsonMap = json.decode(response.body)['data'];
          if (jsonMap != null) {
            setState(() {
              data = jsonMap;
              widget.bookmarkColor = data['is_checked'] != '0'
                  ? Color(0xFFC1C1C1)
                  : Color(0xFFFFFFFF);
            });
          }

          String error = json.decode(response.body)['error'];
          if (error != null) {
            throw error;
          }
        }

        print('lala2');
        print(data['university']['website']);
      } else {
        String error = json.decode(response.body)['error'];
        throw (error == '') ? 'Gagal memproses data' : error;
      }
    } on SocketException {
      throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
    }
  }
}

class SelectColorWidget extends StatefulWidget {
  SelectColorWidget({
    Key key,
  }) : super(key: key);

  @override
  _SelectColorWidgetState createState() => _SelectColorWidgetState();
}

class _SelectColorWidgetState extends State<SelectColorWidget> {
  ProductColorsList _productColorsList = new ProductColorsList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_productColorsList.list.length, (index) {
        var _color = _productColorsList.list.elementAt(index);
        return buildColor(_color);
      }),
    );
  }

  SizedBox buildColor(ProductColor color) {
    return SizedBox(
      width: 38,
      height: 38,
      child: FilterChip(
        label: Text(''),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: color.color,
        selectedColor: color.color,
        selected: color.selected,
        shape: StadiumBorder(),
        avatar: Text(''),
        onSelected: (bool value) {
          setState(() {
            color.selected = value;
          });
        },
      ),
    );
  }
}
