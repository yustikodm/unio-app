import 'dart:io';

import 'package:Unio/src/utilities/global.dart';

import '../../config/ui_icons.dart';
import '../models/carts.dart';
import '../widgets/EmptyCartWidget.dart';
import '../widgets/CartListItemWidget.dart';
import '../widgets/CartsGridItemWidget.dart';
import '../widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  String layout = 'list';
  var queryResult = [];
  CartsList _cartsList = new CartsList();

  @override
  void initState() {
    getData();
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
            child: SearchBarWidget(),
          ),
          SizedBox(height: 10),
          Offstage(
            offstage: _cartsList.cartList.isEmpty,
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
            offstage: this.layout != 'list' || _cartsList.cartList.isEmpty,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _cartsList.cartList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return CartListItemWidget(
                  heroTag: 'cart_list',
                  carts: _cartsList.cartList.elementAt(index),
                  onDismissed: () {
                    setState(() {
                      _cartsList.cartList.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
          Offstage(
            offstage: this.layout != 'grid' || _cartsList.cartList.isEmpty,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: new StaggeredGridView.countBuilder(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: _cartsList.cartList.length,
                itemBuilder: (BuildContext context, int index) {
                  Carts carts = _cartsList.cartList.elementAt(index);
                  return CartsGridItemWidget(
                    carts: carts,
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
            offstage: _cartsList.cartList.isNotEmpty,
            child: EmptyCartWidget(),
          )
        ],
      ),
    );
  }

  getData() async {
    String url = SERVER_DOMAIN + "carts";

    Map<String, dynamic> request = Map();
    request['user_id'] = Global.instance.authId;

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
          Map<String, dynamic> jsonMap = json.decode(response.body)['data'];
          if (jsonMap != null) {
            print('lala');
            print(jsonMap['data']);
            print('lala');
            print('============ noted: jsonMap response ' + jsonMap.toString());

            for (var i = 0; i < jsonMap['data'].length; i++) {
              setState(() {
                _cartsList.cartList.add(new Carts(
                    int.parse(Global.instance.authId),
                    jsonMap['data'][i]['entity_id'],
                    jsonMap['data'][i]['entity_type'].toString(),
                    jsonMap['data'][i]['service']['name'].toString(),
                    jsonMap['data'][i]['service']['description'].toString(),
                    jsonMap['data'][i]['service']['level'].toString(),
                    jsonMap['data'][i]['service']['picture'].toString(),
                    jsonMap['data'][i]['qty'],
                    jsonMap['data'][i]['price'],
                    jsonMap['data'][i]['total_price'],
                    jsonMap['data'][i]['service']['vendor']['name']
                        .toString()));
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
