import 'package:Unio/src/utilities/global.dart';
import 'package:Unio/src/widgets/AdviceListItemWidget.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import '../../config/ui_icons.dart';
import '../models/category.dart';
import '../models/route_argument.dart';
import '../widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/advice.dart';

// ignore: must_be_immutable
class AdviceWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;
  String _keyword;

  AdviceWidget({Key key, this.routeArgument}) {
    _category = this.routeArgument.argumentsList[0] as Category;
    _keyword = this.routeArgument.argumentsList[1] as String;
  }

  @override
  _AdviceWidgetState createState() => _AdviceWidgetState();
}

class _AdviceWidgetState extends State<AdviceWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  bool hasMore = true;
  int page = 1;
  String subUrl = 'match-with-me';
  String entity = 'match-with-me';
  AdviceList _adviceList = new AdviceList();
  bool shouldPop = true;

  @override
  void initState() {
    //setParam();
    getData();
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('============ _scrollListener end end ' +
            hasMore.toString() +
            '======' +
            page.toString());
        if (hasMore) {
          getData();
        }
      }
    });
  }

  void setParam() {
    switch (widget._category.name) {
      case 'University':
        subUrl = 'universities';
        entity = 'universities';
        break;
      case 'Field of study':
        subUrl = 'university-majors';
        entity = 'majors';
        break;
      case 'Vendor':
        subUrl = 'vendors';
        entity = '';
        break;
      case 'Places to Live':
        subUrl = 'place-to-lives';
        entity = '';
        break;
      case 'Scholarship':
        subUrl = 'university-scholarships';
        entity = '';
        break;
      case 'Article':
        subUrl = 'articles';
        entity = '';
        break;
      default:
        subUrl = 'universities';
        entity = '';
        break;
    }
  }

  void getData() async {
    String url = SERVER_DOMAIN + subUrl;
    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var token = Global.instance.apiToken;
    headers.addAll(
        <String, String>{HttpHeaders.authorizationHeader: 'Bearer $token'});

    print('========= noted: get requestMap ' + "===== url " + url);
    try {
      final client = new http.Client();
      final response = await client
          .get(
        Uri.parse(url),
        headers: headers,
      )
          .timeout(Duration(seconds: 60), onTimeout: () {
        throw 'Koneksi terputus. Silahkan coba lagi.';
      });

      if (response.statusCode == 200) {
        print('========= noted: get response body ' + response.body.toString());
        if (response.body.isNotEmpty) {
          List jsonMap = json.decode(response.body)['data'];
          if (jsonMap != null) {
            for (var i = 0; i < jsonMap.length; i++) {
              print(i);
              setState(() {
                _adviceList.adviceList.add(new Advice(
                  jsonMap[i]['university_id'],
                  jsonMap[i]['university_name'],
                  jsonMap[i]['major_id'],
                  jsonMap[i]['major_name'],
                  jsonMap[i]['fos'],
                ));
              });
            }
          }

          String error = json.decode(response.body)['error'];
          if (error != null) {
            throw error;
          }
        } else {
          showOkAlertDialog(
            context: context,
            title: 'You need to do Questionnaire first!',
          );
        }
      } else {
        String error = json.decode(response.body)['error'];
        throw (error == '') ? 'Gagal memproses data' : error;
      }
    } on SocketException {
      throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed('/Tabs', arguments: 2);
        return shouldPop;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerWidget(),
        body: CustomScrollView(controller: scrollController, slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                    },
                  )),
            ],
            backgroundColor: widget._category.color,
            expandedHeight: 200,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                          widget._category.color,
                          Theme.of(context).primaryColor.withOpacity(0.5),
                        ])),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: widget._category.id,
                          child: new Icon(
                            widget._category.icon,
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${widget._category.name}',
                          style: Theme.of(context).textTheme.display3,
                        ),
                      ],
                    )),
                  ),
                  Positioned(
                    right: -60,
                    bottom: -100,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(300),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    top: -80,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    UiIcons.box,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    '${widget._category.name} Items',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              Container(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _adviceList.adviceList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return AdviceListItemWidget(
                      heroTag: 'advice_list',
                      advice: _adviceList.adviceList.elementAt(index),
                      onDismissed: () {
                        setState(() {
                          _adviceList.adviceList.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              ),
            ]),
          )
        ]),
      ),
    );
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
}
