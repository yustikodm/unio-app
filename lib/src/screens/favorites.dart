import 'dart:io';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/widgets/LoadingFavoritesWidget.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/ui_icons.dart';
import '../models/favorites.dart';
import '../widgets/EmptyFavoritesWidget.dart';
import '../widgets/FavoriteListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Unio/src/utilities/global.dart';

// ignore: must_be_immutable
class FavoritesWidget extends StatefulWidget {
  RouteArgument routeArgument;

  FavoritesWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  final searchController = TextEditingController();
  String searchType = '';
  String layout = 'list';
  FavoriteList _favoriteList = new FavoriteList();
  Item selectedFilter;
  bool isLoading = true;
  List<Item> filters = <Item>[
    const Item(name: 'All', type: ''),
    const Item(
        name: 'University',
        type: 'universities',
        icon: Icon(
          FontAwesomeIcons.university,
          color: const Color(0xFF46A0AE),
        )),
    const Item(
        name: 'Field of study',
        type: 'majors',
        icon: Icon(
          FontAwesomeIcons.puzzlePiece,
          color: const Color(0xFF46A0AE),
        )),
    const Item(
        name: 'Vendor',
        type: 'vendors',
        icon: Icon(
          FontAwesomeIcons.store,
          color: const Color(0xFF46A0AE),
        )),
    const Item(
        name: 'Places to Live',
        type: 'place_lives',
        icon: Icon(
          FontAwesomeIcons.building,
          color: const Color(0xFF46A0AE),
        )),
  ];

  String filterTitle = 'All';

  @override
  void initState() {
    String type = '';
    String name = '';

    if (widget.routeArgument != null) {
      type = widget.routeArgument.param1;
      name = widget.routeArgument.param2;
    }

    getData(type, name);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      // drawer: DrawerWidget(),
      //endDrawer: FavoriteFilterWidget(),
      //endDrawer: FilterWidget(),
      // endDrawer: NewFilterWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon:
              new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Bookmark',
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[SizedBox()],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //child: FavoriteSearchWidget(),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.10),
                        offset: Offset(0, 4),
                        blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.8)),
                            /*prefixIcon: Icon(UiIcons.loupe,
                      size: 20, color: Theme.of(context).hintColor),*/
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              getData(searchType, searchController.text);
                            });

                            // Navigator.of(context).pushNamed('/Bookmark');
                            //Scaffold.of(context).openEndDrawer();
                          },
                          icon: Icon(UiIcons.loupe,
                              size: 20,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    leading: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        DropdownButton(
                          hint: Text(
                            "All",
                            style: Theme.of(context).textTheme.display1,
                          ),
                          value: selectedFilter,
                          onChanged: (Item value) {
                            setState(() {
                              selectedFilter = value;
                              searchType = value.type;

                              getData(value.type, searchController.text);

                              // Navigator.of(context).pushNamed('/Bookmark',
                              //     arguments: RouteArgument(
                              //         param1: value.type ?? '',
                              //         param2: searchController.text ?? ''));
                            });
                          },
                          items: filters.map((Item filter) {
                            return DropdownMenuItem<Item>(
                              value: filter,
                              child: Row(
                                children: <Widget>[
                                  filter.icon ?? SizedBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    filter.name,
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Offstage(
                offstage: this.layout != 'list' ||
                    _favoriteList.favoritesList.isEmpty,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Slide items to remove from list')],
                  ),
                )),
            Offstage(
              offstage:
                  this.layout != 'list' || _favoriteList.favoritesList.isEmpty,
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _favoriteList.favoritesList.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return FavoriteListItemWidget(
                    heroTag: 'favorites_list',
                    favorite: _favoriteList.favoritesList.elementAt(index),
                    onDismissed: () {
                      Favorite item =
                          _favoriteList.favoritesList.elementAt(index);
                      setState(() {
                        addBookmark(item.entityId, item.entityType, item);
                        _favoriteList.favoritesList.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            Offstage(
              offstage: _favoriteList.favoritesList.isNotEmpty,
              child: EmptyFavoritesWidget(),
            ),

            // Offstage(
            //   offstage: isLoading == false,
            //   child: LoadingFavoritesWidget(),
            // ),
          ],
        ),
      ),
    );
  }

  getData(type, name) async {
    print(type);
    print(name);
    _favoriteList.favoritesList.clear();

    String url = SERVER_DOMAIN + "wishlists";

    Map<String, dynamic> request = Map();
    request['user_id'] = Global.instance.authId;
    request['entity_type'] = type;
    request['name'] = name;

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
    var token = Global.instance.apiToken;
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
        isLoading = false;
        print('========= noted: get response body ' + response.body.toString());
        if (response.body.isNotEmpty) {
          List jsonMap = json.decode(response.body)['data'];
          if (jsonMap != null) {
            for (var i = 0; i < jsonMap.length; i++) {
              print(i);
              setState(() {
                _favoriteList.favoritesList.add(new Favorite(
                  jsonMap[i]['name'].toString() ?? '-',
                  jsonMap[i]['picture'],
                  jsonMap[i]['description'].toString() ?? '-',
                  jsonMap[i]['entity_id'] ?? null,
                  jsonMap[i]['entity_type'].toString() ?? '-',
                  jsonMap[i]['detail_id'] == ''
                      ? null
                      : int.parse(jsonMap[i]['detail_id']),
                  jsonMap[i]['detail_name'].toString() ?? '-',
                ));
              });
            }

            // return jsonMap;
          }

          String error = json.decode(response.body)['error'];
          if (error != null) {
            throw error;
          }
        }
      } else {
        String error = json.decode(response.body)['error'];
        throw (error == '') ? 'Gagal memproses data' : error;
      }
    } on SocketException {
      throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
    }
  }

  Future<void> addBookmark(_id, _type, _item) async {
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
          'entity_id': _id,
          'entity_type': _type,
        }));
    print(response.body);

    var data = json.decode(response.body);

    if (!data['success'])
      return Future(() {
        // var data = json.decode(response.body);
        showOkAlertDialog(
          context: context,
          title: 'Error: ' + data['message'],
        );
        setState(() {
          _favoriteList.favoritesList.add(_item);
        });
      });

    if (response.statusCode != 200)
      return Future(() {
        // var data = json.decode(response.body);
        showOkAlertDialog(
          context: context,
          title: "There is an error, please refresh the page",
        );
        setState(() {
          _favoriteList.favoritesList.add(_item);
        });
      });
  }
}

class Item {
  const Item({this.name, this.type, this.icon});
  final String name;
  final String type;
  final Icon icon;
}
