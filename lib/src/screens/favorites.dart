import 'dart:io';
import 'package:Unio/src/models/route_argument.dart';
import 'package:Unio/src/widgets/FavoriteSearchWidget.dart';

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
  String layout = 'list';
  FavoriteList _favoriteList = new FavoriteList();

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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FavoriteSearchWidget(),
          ),
          SizedBox(height: 10),
          Offstage(
            offstage: _favoriteList.favoritesList.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                leading: Icon(
                  UiIcons.heart,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Wish List',
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
                    setState(() {
                      _favoriteList.favoritesList.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          /*Offstage(
            offstage:
                this.layout != 'grid' || _favoriteList.favoritesList.isEmpty,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: new StaggeredGridView.countBuilder(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: _favoriteList.favoritesList.length,
                itemBuilder: (BuildContext context, int index) {
                  Favorite favorite =
                      _favoriteList.favoritesList.elementAt(index);
                  return FavoriteGridItemWidget(
                    favorite: favorite,
                    heroTag: 'favorites_grid',
                  );
                },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
            ),
          ),*/
          Offstage(
            offstage: _favoriteList.favoritesList.isNotEmpty,
            child: EmptyFavoritesWidget(),
          )
        ],
      ),
    );
  }

  getData(type, name) async {
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
        print('========= noted: get response body ' + response.body.toString());
        if (response.body.isNotEmpty) {
          List jsonMap = json.decode(response.body)['data'];
          if (jsonMap != null) {
            for (var i = 0; i < jsonMap.length; i++) {
              print(i);
              setState(() {
                _favoriteList.favoritesList.add(new Favorite(
                  jsonMap[i]['name'].toString() ?? '-',
                  jsonMap[i]['picture'].toString() ?? '-',
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
}
