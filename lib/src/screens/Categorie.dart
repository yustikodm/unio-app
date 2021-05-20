import 'package:Unio/src/utilities/global.dart';

import '../../config/ui_icons.dart';
import '../models/category.dart';
import '../models/route_argument.dart';
import '../widgets/BrandHomeTabWidget.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/ProductsByBrandWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/utilities.dart';
import 'package:Unio/main.dart';
import '../models/university.dart';

class CategorieWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  CategorieWidget({Key key, this.routeArgument}) {
    _category = this.routeArgument.argumentsList[0] as Category;
  }

  @override
  _CategorieWidgetState createState() => _CategorieWidgetState();
}

class _CategorieWidgetState extends State<CategorieWidget>
    with SingleTickerProviderStateMixin {
  UniversityList _universityList = new UniversityList();
  TabController _tabController;
  UtilitiesList utilitiesList = new UtilitiesList();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  int halaman;
  var hasilquery = List();
  String description;
  String accreditation;
  String address;

  @override
  void initState() {
    print("hallooooooo");
    print(widget._category.name);
    if ((widget._category.name == "University") &&
        (widget.routeArgument.id != 101)) {
      //getUniversities();
      getuniversity2();
    }
    if ((widget._category.name == "Field of study") &&
        (widget.routeArgument.id != 101)) {
      getMajors2();
    }
    if ((widget._category.name == "Vendor") &&
        (widget.routeArgument.id != 101)) {
      getVendors2();
    }
    if ((widget._category.name == "Places to Live") &&
        (widget.routeArgument.id != 101)) {
      getPlacestoLive2();
    }
    if ((widget._category.name == "Scholarship") &&
        (widget.routeArgument.id != 101)) {
      getScholarship2();
    }
    if ((widget._category.name == "Article") &&
        (widget.routeArgument.id != 101)) {
      getArticle2();
    }
    if (widget.routeArgument.id == 101) {
      _tabIndex = 1;
      halaman = 2;
    }
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    // ambildata(widget._category.name);
    super.initState();
  }

  void getuniversity2() async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/universities'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      hasilquery = jsonDecode(response.body)['data']['data'];
    });
    print(hasilquery.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];

    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        utilitiesList.popularList.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###University',
            '-',
            25,
            130,
            4.3,
            12.1));
        widget._category.utilities.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###University',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }
  }

  void getMajors2() async {
    final response = await http.get(
      Uri.parse(
          'https://primavisiglobalindo.net/unio/public/api/university-majors'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      hasilquery = jsonDecode(response.body)['data']['data'];
    });
    print(hasilquery.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        utilitiesList.popularList.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###Field of study',
            '-',
            25,
            130,
            4.3,
            12.1));
        widget._category.utilities.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###Field of study',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }
  }

  void getVendors2() async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/vendors'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      hasilquery = jsonDecode(response.body)['data']['data'];
    });
    print(hasilquery.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        utilitiesList.popularList.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###Vendor',
            '-',
            25,
            130,
            4.3,
            12.1));
        widget._category.utilities.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###Vendor',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }
  }

  void getPlacestoLive2() async {
    final response = await http.get(
      Uri.parse(
          'https://primavisiglobalindo.net/unio/public/api/place-to-lives'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      hasilquery = jsonDecode(response.body)['data']['data'];
    });
    print(hasilquery.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        utilitiesList.popularList.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###Places to Live',
            '-',
            25,
            130,
            4.3,
            12.1));
        widget._category.utilities.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###Places to Live',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }
  }

  void getScholarship2() async {
    final response = await http.get(
      Uri.parse(
          'https://primavisiglobalindo.net/unio/public/api/university-scholarships'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      hasilquery = jsonDecode(response.body)['data']['data'];
    });
    print(hasilquery.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        utilitiesList.popularList.add(new Utilitie(
            "Scholarship " + hasilquery[i]['university']['name'],
            hasilquery[i]['picture'],
            hasilquery[i]['year'].toString(),
            '-###Scholarship',
            '-',
            25,
            130,
            4.3,
            12.1));
        widget._category.utilities.add(new Utilitie(
            "Scholarship " + hasilquery[i]['university']['name'],
            hasilquery[i]['picture'],
            hasilquery[i]['year'].toString(),
            '-###Scholarship',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }
  }

  // getArticle2();
  void getArticle2() async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/articles'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      hasilquery = jsonDecode(response.body)['data']['data'];
    });
    print(hasilquery.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        utilitiesList.popularList.add(new Utilitie(
            hasilquery[i]['title'],
            hasilquery[i]['picture'],
            hasilquery[i]['slug'].toString(),
            '-###Article',
            '-',
            25,
            130,
            4.3,
            12.1));
        widget._category.utilities.add(new Utilitie(
            hasilquery[i]['title'],
            hasilquery[i]['picture'],
            hasilquery[i]['slug'].toString(),
            '-###Article',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }
  }

  getUniversities() async {
    String url = SERVER_DOMAIN + "universities";
    Map<String, dynamic> request = Map();

    try {
      final client = new http.Client();
      final response = await client
          .get(
        Uri.parse(url),
        /*headers: headers,*/
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
          dynamic jsonMap = json.decode(response.body)['data']['data'];
          if (jsonMap != null) {
            for (var i = 0; i < jsonMap.length; i++) {
              print(i);
              setState(() {
                widget._category.universities.add(new University(
                  jsonMap[i]['id'],
                  jsonMap[i]['name'].toString(),
                  jsonMap[i]['description'].toString(),
                  jsonMap[i]['website'].toString(),
                  jsonMap[i]['logo_src'].toString(),
                  jsonMap[i]['header_src'].toString(),
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

  void getuniversity() async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/universities'
          /*'https://primavisiglobalindo.net/unio/public/api/search/?keyword=universities' +
              cari_query +
              '&page=' +
              halaman.toString()*/
          ),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    halaman = halaman + 1;
    print(response.body);
    hasilquery = jsonDecode(response.body)['data'];

    for (var i = 0; i < hasilquery.length; i++) {
      setState(() {
        String desc = (hasilquery[i]['description'] == null)
            ? ""
            : hasilquery[i]['description'];
        String type =
            (hasilquery[i]['type'] == null) ? "" : hasilquery[i]['type'];
        String accreditation = (hasilquery[i]['accreditation'] == null)
            ? ""
            : hasilquery[i]['accreditation'];
        String address =
            (hasilquery[i]['address'] == null) ? "" : hasilquery[i]['address'];
        setState(() {});
        // utilitiesList.popularList.add(new Utilitie(
        //     hasilquery[i]['name'],
        //     hasilquery[i]['logo_src'],
        //     hasilquery[i]['type'],
        //     '-###',
        //     25,
        //     130,
        //     4.3,
        //     12.1));
        widget._category.utilities.add(new Utilitie(
            hasilquery[i]['name'],
            hasilquery[i]['logo_src'],
            hasilquery[i]['type'],
            '-###University',
            '-',
            25,
            130,
            4.3,
            12.1));
      });
    }

    // print(universities.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
  }

  void getmajors() async {
    print(cari_query);
    final response = await http.get(
      Uri.parse(
          // 'https://primavisiglobalindo.net/unio/public/api/university-majors?page=' +
          'https://primavisiglobalindo.net/unio/public/api/search/?keyword=universities' +
              cari_query +
              'page=' +
              halaman.toString()),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );

    var hasilquery = jsonDecode(response.body)['data'];
    print(hasilquery.toString());
    // print(hasilsearch.length);

    for (var i = 0; i < hasilquery.length; i++) {
      print(hasilquery[i]['name']);
      setState(() {
        widget._category.utilities.add(
          new Utilitie(
              hasilquery[i]['major']['name'] + '-' + hasilquery[i]['name'],
              hasilquery[i]['logo_src'],
              '-',
              '-###Field of study',
              '-',
              25,
              130,
              4.3,
              12.1),
        );
      });
//      widget._category.

    }
    // print(CategoriesList().list.elementAt(1).name);
  }

  void getvendor() async {
    print(
        'https://primavisiglobalindo.net/unio/public/api/search/?keyword=vendors' +
            cari_query +
            '&page=' +
            halaman.toString());
    final response = await http.get(
      Uri.parse(
          // 'https://primavisiglobalindo.net/unio/public/api/university-majors?page=' +
          'https://primavisiglobalindo.net/unio/public/api/search/?keyword=vendors' +
              cari_query +
              '&page=' +
              halaman.toString()),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );

    var hasilquery = jsonDecode(response.body)['data'];
    print(hasilquery.toString());
    // print(hasilsearch.length);

    for (var i = 0; i < hasilquery.length; i++) {
      print(hasilquery[i]['name']);
      setState(() {
        widget._category.utilities.add(
          new Utilitie(hasilquery[i]['name'], '-', '-', '-###Vendor', '-', 25,
              130, 4.3, 12.1),
        );
      });
//      widget._category.

    }
    // print(CategoriesList().list.elementAt(1).name);
  }

  void getplacetolive() async {
    print('https://primavisiglobalindo.net/unio/public/api/place-to-lives/' +
        cari_query +
        '?page=' +
        halaman.toString());
    final response = await http.get(
      Uri.parse(
          // 'https://primavisiglobalindo.net/unio/public/api/university-majors?page=' +
          //   'https://primavisiglobalindo.net/unio/public/api/search/?keyword=vendors'+cari_query+'&page='+
          'https://primavisiglobalindo.net/unio/public/api/place-to-lives/' +
              cari_query +
              '?page=' +
              halaman.toString()),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body.toString());
    var hasilquery = jsonDecode(response.body)['data']['data'];
    print(hasilquery.toString());
    // print(hasilsearch.length);

    for (var i = 0; i < hasilquery.length; i++) {
      print(hasilquery[i]['name']);
      setState(() {
        widget._category.utilities.add(
          new Utilitie(hasilquery[i]['name'], '-', '-', '-###Place to Live',
              '-', 25, 130, 4.3, 12.1),
        );
      });
//      widget._category.

    }
    // print(CategoriesList().list.elementAt(1).name);
  }

  void getscholarship() async {
    print(
        'https://primavisiglobalindo.net/unio/public/api/search/?keyword=scholarship' +
            cari_query +
            '&page=' +
            halaman.toString());
    final response = await http.get(
      Uri.parse(
          // 'https://primavisiglobalindo.net/unio/public/api/university-majors?page=' +
          'https://primavisiglobalindo.net/unio/public/api/search/?keyword=scholarship' +
              cari_query +
              '&page=' +
              halaman.toString()),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );

    var hasilquery = jsonDecode(response.body)['data'];
    print(hasilquery.toString());
    // print(hasilsearch.length);

    for (var i = 0; i < hasilquery.length; i++) {
      // print(hasilquery[i]['name']);
      setState(() {
        widget._category.utilities.add(
          new Utilitie("Scholarship " + hasilquery[i]['university']['name'],
              '-', '-', '-###Scholarship', '-', 25, 130, 4.3, 12.1),
        );
      });
//      widget._category.

    }
    // print(CategoriesList().list.elementAt(1).name);
  }

  void getarticle() async {
    print('https://primavisiglobalindo.net/unio/public/api/articles/' +
        cari_query +
        '?page=' +
        halaman.toString());
    final response = await http.get(
      Uri.parse(
          // 'https://primavisiglobalindo.net/unio/public/api/university-majors?page=' +
          //   'https://primavisiglobalindo.net/unio/public/api/search/?keyword=vendors'+cari_query+'&page='+
          'https://primavisiglobalindo.net/unio/public/api/articles/' +
              cari_query +
              '?page=' +
              halaman.toString()),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body.toString());
    var hasilquery = jsonDecode(response.body)['data']['data'];
    print(hasilquery.toString());
    // print(hasilsearch.length);

    for (var i = 0; i < hasilquery.length; i++) {
      print(hasilquery[i]['name']);
      setState(() {
        widget._category.utilities.add(
          new Utilitie(hasilquery[i]['title'], hasilquery[i]['picture'], '-',
              '-###Article', '-', 25, 130, 4.3, 12.1),
        );
      });
//      widget._category.

    }
    // print(CategoriesList().list.elementAt(1).name);
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: <Widget>[
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
            //new ShoppingCartButtonWidget(
            //  iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor),
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
          expandedHeight: 250,
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
                      )
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
          bottom: TabBar(
            controller: _tabController,
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor:
                Theme.of(context).primaryColor.withOpacity(0.8),
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Items'),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Offstage(
              offstage: 0 != _tabIndex,
              child: Column(
                children: <Widget>[
                  BrandHomeTabWidget(
                    category: widget._category,
                    utilitiesList: utilitiesList,
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: 1 != _tabIndex,
              child: Column(
                children: <Widget>[
                  UtilitiesByBrandWidget(category: widget._category),
                  InkWell(
                    onTap: () {
                      setState(() {
                        // widget._category.utilities.add(new Utilitie("its", "-",
                        //     '-', 25, 130, 4.3, 12.1),);
                        if (widget._category.name == "University") {
                          //getUniversities();
                          getuniversity();
                        }
                        if (widget._category.name == "Field of study") {
                          getmajors();
                        }

                        if (widget._category.name == "Vendor") {
                          getvendor();
                        }
                        if (widget._category.name == "Places to Live") {
                          getplacetolive();
                        }
                        if (widget._category.name == "Scholarship") {
                          getscholarship();
                        }

                        if (widget._category.name == "Article") {
                          getarticle();
                        }
                        // halaman=halaman+1;
                      });
                    },
                    child: Container(
                      child: Image.asset("img/more.png"),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
