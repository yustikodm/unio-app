import 'package:Unio/src/utilities/global.dart';
import 'package:Unio/src/widgets/SearchBarWidget.dart';
import 'package:Unio/src/widgets/UtilitiesGridItemWidget.dart';
import 'package:Unio/src/widgets/UniversitiesGridItemWidget.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../config/ui_icons.dart';
import '../models/category.dart';
import '../models/route_argument.dart';
import '../widgets/BrandHomeTabWidget.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/ProductsByBrandWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/utilities.dart';
import 'package:Unio/main.dart';
import '../models/university.dart';

class DirectoryWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  DirectoryWidget({Key key, this.routeArgument}) {
    _category = this.routeArgument.argumentsList[0] as Category;
  }

  @override
  _DirectoryWidgetState createState() => _DirectoryWidgetState();
}

class _DirectoryWidgetState extends State<DirectoryWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  bool hasMore = true;
  int page = 1;
  String subUrl = '';
  String entity = '';

  @override
  void initState() {
    setParam();
    getData();
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print('============ _scrollListener end end ' + hasMore.toString() + '======' + page.toString());
        if(hasMore) {
          getData();
        }
      }
    });
  }

  void setParam() {
    switch (widget._category.name) {
      case 'University':
        subUrl = 'universities/';
        entity = 'universities';
        break;
      case 'Field of study':
        subUrl = 'university-majors/';
        entity = 'majors';
        break;
      case 'Vendor':
        subUrl = 'vendors/';
        entity = 'vendors';
        break;
      case 'Places to Live':
        subUrl = 'place-to-lives/';
        entity = 'place_lives';
        break;
      case 'Scholarship':
        subUrl = 'university-scholarships/';
        entity = '';
        break;
      case 'Article':
        subUrl = 'articles/';
        entity = '';
        break;
      default:
        subUrl = 'universities/';
        entity = '';
        break;
    }
  }

  void getData() async {
    String url = SERVER_DOMAIN + subUrl + '?page=$page';
    print('========= noted: get requestMap ' + "===== url " + url);
    try {
      final client = new http.Client();
      final response = await client.get(Uri.parse(url),).timeout(Duration(seconds: 60), onTimeout: () {
        throw 'Koneksi terputus. Silahkan coba lagi.';
      });

      if (response.statusCode == 200) {
        print('========= noted: get response body ' + response.body.toString());
        if (response.body.isNotEmpty) {
          dynamic jsonMap = json.decode(response.body)['data']['data'];
          if (jsonMap != null) {
            for (var i = 0; i < jsonMap.length; i++) {
              dynamic jsonUniv;
              if(widget._category.name == 'Field of study' || widget._category.name == 'Scholarship') { //university, name
                jsonUniv = jsonMap[i]['university'];
              }

              widget._category.utilities.add(new Utilitie(
                jsonMap[i][(widget._category.name == 'Article')? 'title':'name'].toString(),
                jsonMap[i]['header_src'].toString(),
                (jsonUniv != null)? jsonUniv['logo_src'].toString():
                  jsonMap[i][(widget._category.name == 'Vendor')? 'logo':
                  ((widget._category.name == 'Article' ||
                      widget._category.name == 'Places to Live')? 'picture':'logo_src')].toString(), //seharusnya type
                (jsonUniv != null)? jsonUniv['name'].toString():jsonMap[i]['description'].toString(),
                jsonMap[i]['website'].toString(),
                jsonMap[i]['id'], //seharusnya available gak ada response param ini, jadi value default
                (jsonUniv != null)? 1:0, //seharusnya price, tapi buat ngcek, ada univ name ato gak
                0, //rate
                0 //discount
              ));
            }
          }

          int currentPage = json.decode(response.body)['data']['current_page'];
          int lastPage = json.decode(response.body)['data']['last_page'];
          if(currentPage < lastPage) {
            page++;
            hasMore = true;
          } else {
            hasMore = false;
          }
          setState(() { });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
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
                    child: CircleAvatar(
                      backgroundImage: AssetImage('img/user2.jpg'),
                    ),
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
                        SizedBox(height: 15,),
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
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: SearchBarWidget(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: new StaggeredGridView.countBuilder(
                  primary: false,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  itemCount: widget._category.utilities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
                      onTap: () {
                        if (Global.instance.apiToken != null) {
                          if(entity != '') {
                            Navigator.of(context).pushNamed('/Detail',
                                arguments: RouteArgument(
                                    param1: widget._category.utilities[index].available,
                                    param2: entity));
                          } else {
                            showOkAlertDialog(
                              context: context,
                              title: 'This feature is under development.',
                            );
                          }
                        } else {
                          _showNeedLoginAlert(context);
                        }

                        // Navigator.of(context).pushNamed('/Utilities',
                        //     arguments: new RouteArgument(argumentsList: [this.utilitie, this.heroTag], id: this.utilitie.id));
                      },
                      child: Container(
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
                            (widget._category.utilities[index].type == 'null')?
                              Image.asset('img/icon_campus.jpg'):
                              Image.network(widget._category.utilities[index].type),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget._category.utilities[index].name,
                                    style: Theme.of(context).textTheme.body2,
                                  ),
                                  (widget._category.utilities[index].price == 1)? Text(
                                    widget._category.utilities[index].description,
                                    style: Theme.of(context).textTheme.body1,
                                  ):Container(),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                ),
              ),
              (hasMore)? Center( // optional
                child: CircularProgressIndicator(),
              ):Container(),
            ]),
          )
      ]),
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
