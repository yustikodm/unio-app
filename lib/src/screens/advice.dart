import 'package:Unio/src/models/fos.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:Unio/src/widgets/AdviceListItemWidget.dart';
import 'package:Unio/src/widgets/CustomDropdownSearchWidget.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../config/ui_icons.dart';
import '../models/category.dart';
import '../models/route_argument.dart';
import '../widgets/DrawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/advice.dart';
import 'package:Unio/src/utilities/global.dart';

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
  final myController = TextEditingController();
  final univeristyNameSearchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController scrollController = ScrollController();
  bool hasMore;
  bool loadingData;
  bool _initialFosData;
  int page;
  int limit;

  String subUrl = 'match-with-me-mobile';
  String entity = 'match-with-me-mobile';

  AdviceList _adviceList;
  bool shouldPop;

  List<Fos> _fosList;
  final List<String> level = [
    "Bachelor",
    "Master",
    "Doctor",
  ];

  // Main Search
  String majorName;

  // filters
  Map selectedCip; // CHECKBOX FILTER VALUE
  List<String> levels;
  int countryId;
  int stateId;
  String universityName;
  String levelDegree;

  // RIGHT DRAWER
  bool isRightDrawerOpen;
  double xOffset;
  double yOffset;

  // DROPDOWN SEARCH
  DropdownSearch<String> stateDropDown;
  DropdownSearch<String> countryDropDown;

  List<DropdownMenuItem> countries;
  List<DropdownMenuItem> states;

  List<String> countryList;
  List<String> stateList;

  var countryRes;
  var stateRes;

  String _valCountry;
  String _valCountryId;

  String _valState;

  @override
  void initState() {
    setParam();

    getData();

    getCountry();

    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('============ _scrollListener end end ' +
            hasMore.toString() +
            '======' +
            page.toString());
        if (hasMore && !loadingData) {
          page += 1;
          getData();
        }
      }
    });

    myController.addListener(handleSearchController);
    univeristyNameSearchController
        .addListener(handleUniversityNameSearchController);
  }

  @override
  void dispose() {
    myController.dispose();
    univeristyNameSearchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void handleSearchController() {
    widget._keyword = myController.text;
  }

  void handleUniversityNameSearchController() {
    universityName = univeristyNameSearchController.text;
  }

  void openRightDrawer() {
    setState(() {
      isRightDrawerOpen = true;
      xOffset = MediaQuery.of(context).size.width * 1 / 4;
    });
  }

  void closeRightDrawer() {
    setState(() {
      isRightDrawerOpen = false;
      xOffset = MediaQuery.of(context).size.width;
    });
  }

  void setParam() {
    xOffset = 500;
    yOffset = 0;
    isRightDrawerOpen = false;

    page = 1;
    limit = 10;

    hasMore = true;
    loadingData = false;
    _initialFosData = true;

    _adviceList = new AdviceList();
    shouldPop = true;

    _fosList = [];
    selectedCip = new Map();

    countries = [];
    countryList = [];
    countryRes = [];

    states = [];
    stateList = [];
    stateRes = [];
  }

  void getData() async {
    var userId = await Global.instance.authId;

    // TODOS: perbaiki ini kampret
    // var userHc = await Global.instance.authHc;
    var userHc = await storage.read(key: 'authHc');
    var token = await Global.instance.apiToken;

    String url = SERVER_DOMAIN + subUrl + "/" + userId + "/" + userHc;
    // String url =
    //     "http://10.0.2.2:8000/api/" + subUrl + "/" + userId + "/" + userHc;

    String urlArgs = "?" +
        (page == null ? "" : "page=" + page.toString()) +
        (limit == null ? "" : "&limit=" + limit.toString()) +
        (countryId == null ? "" : "&country_id=" + countryId.toString()) +
        (stateId == null ? "" : "&state_id=" + stateId.toString()) +
        (universityName == null ? "" : "&university_name=" + universityName) +
        (levelDegree == null ? "" : "&level[]=" + levelDegree);

    // insert cip if not empty
    String selectedCipParams = "";
    if (selectedCip.isNotEmpty) {
      for (var i = 0; i < selectedCip.length; i++) {
        if (selectedCip[i] != null)
          selectedCipParams =
              selectedCipParams + "&cip[]=" + selectedCip[i].toString();
      }
      urlArgs = urlArgs + selectedCipParams;
    }

    print(urlArgs);

    Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    headers.addAll(
        <String, String>{HttpHeaders.authorizationHeader: 'Bearer $token'});

    print('========= noted: get requestMap ' + "===== url " + url + urlArgs);

    try {
      loadingData = true;

      final client = new http.Client();
      final response = await client
          .get(
        Uri.parse(url + urlArgs),
        headers: headers,
      )
          .timeout(Duration(seconds: 60), onTimeout: () {
        throw 'Koneksi terputus. Silahkan coba lagi.';
      });

      if (response.statusCode == 200) {
        print('========= noted: get response body ' + response.body.toString());
        if (response.body.isNotEmpty) {
          // parse majors
          List jsonMajors = await json.decode(response.body)['data']['majors'];
          if (jsonMajors != null && jsonMajors.isNotEmpty) {
            for (var i = 0; i < jsonMajors.length; i++) {
              print('majors: $i');
              setState(() {
                _adviceList.adviceList.add(new Advice(
                  jsonMajors[i]['university_id'],
                  jsonMajors[i]['university_name'],
                  jsonMajors[i]['major_id'],
                  jsonMajors[i]['major_name'],
                  jsonMajors[i]['fos'],
                ));
              });
            }
          } else {
            _adviceList.adviceList.clear();
          }

          // matchedFos and initial cip
          if (_initialFosData) {
            _initialFosData = false;
            List jsonFos =
                await json.decode(response.body)['data']['matchedFos'];
            if (jsonFos != null && jsonFos.isNotEmpty) {
              for (var i = 0; i < jsonFos.length; i++) {
                print('fos: $i');
                setState(() {
                  _fosList.add(new Fos(
                    cip: jsonFos[i]['cip'],
                    name: jsonFos[i]['name'],
                    hc: jsonFos[i]['hc'],
                  ));

                  selectedCip[i] = jsonFos[i]['cip'];
                });
              }
            } else {
              _fosList.clear();
              selectedCip.clear();
            }
          }

          if (jsonMajors.length < limit) {
            hasMore = false;
          } else {
            hasMore = true;
          }
          // setState(() {});

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
      loadingData = false;
      setState(() {});
    } on SocketException {
      throw 'Tidak ada koneksi internet. Silahkan coba lagi.';
    }
  }

  void getCountry() async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/countries'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    // print(response.body);
    setState(() {
      // _valCountry = null;
      countries.clear();
      countryList.clear();
      countryRes = jsonDecode(response.body)['data'];
    });
    // print(countryRes.toString());
    // state = [{"id":1,"name":"Jawa Barat"},{"id":2,"name":"Jawa Tengah"},{"id":3,"name":"Jawa Timur"},{"id":4,"name":"DKI Jakarta"}];
    countries.clear();
    for (var i = 0; i < countryRes.length; i++) {
      setState(() {
        countries.add(DropdownMenuItem(
          child: Text(countryRes[i]['name']),
          value: countryRes[i]['name'],
        ));
        countryList.add(countryRes[i]['name'].toString());
      });
    }
  }

  void getstate(String countryid) async {
    final response = await http.get(
      Uri.parse(
          'https://primavisiglobalindo.net/unio/public/api/states?country_id=' +
              countryid),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    // print(response.body);
    setState(() {
      _valState = null;
      states.clear();
      stateList.clear();
      stateRes = jsonDecode(response.body)['data']['data'];
    });
    // print(stateRes.toString());
    // state = [{"id":1,"name":"Jawa Barat"},{"id":2,"name":"Jawa Tengah"},{"id":3,"name":"Jawa Timur"},{"id":4,"name":"DKI Jakarta"}];
    for (var i = 0; i < stateRes.length; i++) {
      setState(() {
        states.add(DropdownMenuItem(
          child: Text(stateRes[i]['name']),
          value: stateRes[i]['name'],
        ));
        stateList.add(stateRes[i]['name'].toString());
      });
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
        body: Stack(children: [
          CustomScrollView(controller: scrollController, slivers: <Widget>[
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.05),
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.09),
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
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.10),
                            offset: Offset(0, 4),
                            blurRadius: 10)
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            TextFormField(
                              // initialValue: widget._keyword,
                              keyboardType: TextInputType.text,
                              controller: myController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'Search Major Name',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.8)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            Positioned(
                              right: 30.0,
                              child: IconButton(
                                onPressed: () {
                                  openRightDrawer();
                                },
                                icon: Icon(UiIcons.filter,
                                    size: 20,
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.5)),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _adviceList.adviceList.clear();
                                hasMore = true;
                                page = 1;
                                setState(() {});
                                getData();
                              },
                              icon: Icon(UiIcons.loupe,
                                  size: 20,
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                      if (_adviceList.adviceList.isNotEmpty) {
                        return AdviceListItemWidget(
                          heroTag: 'advice_list',
                          advice: _adviceList.adviceList.elementAt(index),
                          onDismissed: () {
                            setState(() {
                              _adviceList.adviceList.removeAt(index);
                            });
                          },
                        );
                      } else {
                        return Text("There is no item found");
                      }
                    },
                  ),
                ),
                (hasMore)
                    ? Center(
                        // optional
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ]),
            )
          ]),
          isRightDrawerOpen
              ? GestureDetector(
                  onTap: () {
                    closeRightDrawer();
                  },
                  child: Container(color: Colors.black45),
                )
              : SizedBox(),
          _rightDrawer(),
        ]),
      ),
    );
  }

  Widget _rightDrawer() {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0),
      duration: Duration(milliseconds: 250),
      child: Container(
        width: xOffset * 3,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.only(top: 50, left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Filters',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onTap: () {
                          closeRightDrawer();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).hintColor,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text('Major Details'),
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 100,
                      maxHeight: 200,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: searchUniversityName(),
                        ),
                        CustomDropdownWidget(
                            context: context,
                            hint: 'Country',
                            selectedItem: _valCountry,
                            items: countryList,
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  print("nilai=" + value.toString());
                                  var selected = countryRes.firstWhere(
                                      (element) => element['name'] == value);
                                  _valCountryId = selected['id'].toString();
                                  _valState = '';
                                  getstate(selected['id'].toString());
                                  countryId = selected['id'];
                                } else {
                                  countryId = null;
                                  stateId = null;
                                }
                              });
                            }),
                        CustomDropdownWidget(
                          context: context,
                          hint: 'State',
                          selectedItem: _valState,
                          items: stateList,
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                var selected = stateRes.firstWhere(
                                    (element) => element['name'] == value);

                                stateId = selected['id'];
                              } else {
                                stateId = null;
                              }
                            });
                          },
                        ),
                        CustomDropdownWidget(
                          context: context,
                          hint: 'Level',
                          selectedItem: levelDegree,
                          items: level,
                          onChanged: (value) {
                            setState(() {
                              levelDegree = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  (_fosList.isNotEmpty) ? _checkBoxes() : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // close window
                      closeRightDrawer();

                      // search with filter
                      _adviceList.adviceList.clear();
                      page = 1;
                      hasMore = true;
                      setState(() {});
                      getData();
                    },
                    child: Text('Apply'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchUniversityName() {
    return Container(
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
              TextFormField(
                // initialValue: widget._keyword,
                keyboardType: TextInputType.text,
                controller: univeristyNameSearchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'University Name',
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.8)),
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkBoxes() {
    List<Widget> checkBoxes = [];
    for (var i = 0; i < _fosList.length; i++) {
      checkBoxes.add(CheckboxListTile(
          title: Text(_fosList[i].name),
          value: _fosList[i].isChecked,
          onChanged: (value) {
            setState(() {
              // rebuild checkbox
              _fosList[i].isChecked = value;

              if (value) {
                selectedCip[i] = _fosList[i].cip;
              } else {
                selectedCip[i] = null;
              }
            });
          }));
    }

    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories'),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 120,
              minHeight: 100,
            ),
            child: ListView(shrinkWrap: true, children: <Widget>[
              ...checkBoxes,
            ]),
          ),
        ],
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
