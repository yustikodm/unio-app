import 'dart:convert';

import 'package:Unio/src/models/university.dart';
import 'package:Unio/src/utilities/global.dart';
import 'package:Unio/src/widgets/CircularLoadingWidget.dart';

import '../../config/ui_icons.dart';
import '../models/category.dart';
import '../models/utilities.dart';
import '../widgets/CategoriesIconsContainerWidget.dart';
import '../widgets/CategorizedUtilitiesWidget.dart';
import '../widgets/HomeSliderWidget.dart';
import 'package:flutter/material.dart';
import '../widgets/PopularLocationCarouselWidget.dart';
import '../widgets/SearchBarHomeWidget.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin {
  List<Utilitie> _utilitiesOfCategoryList;
  List<Utilitie> _utilitiesfBrandList;
  CategoriesList _categoriesList = new CategoriesList();
  // UniversityList _universityList = new UniversityList();

  List<University> _universityList;

  Animation animationOpacity;
  AnimationController animationController;

  @override
  void initState() {
    _universityList = [];

    fetchData();

    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();

    _utilitiesOfCategoryList = _categoriesList.list.firstWhere((category) {
      return category.selected;
    }).utilities;

    // _utilitiesList.popularList.add(
    //   new Utilitie(
    //       'MIT', 'img/mit.jpg', 'Arts & Humanities', '-',25, 130, 4.3, 12.1));
    //
    // _utilitiesList.popularList.add(
    //   new Utilitie('Harvard University', 'img/harvard.jpg',
    //       'Business & Finance', '-',80, 2554, 3.1, 10.5),
    // );
    //
    // _utilitiesList.popularList.add(
    //     new Utilitie('Stanford University', 'img/stanford.jpg',
    //         'Business & Finance', '-',60, 63, 5.0, 20.2),
    // );
    //
    // _utilitiesList.popularList.add(
    //   new Utilitie('Cambridge University', 'img/cambridge.jpg',
    //       'Arts & Humanities', '-',80, 2554, 3.1, 10.5),
    // );
    //
    // _utilitiesList.popularList.add(
    //   new Utilitie('Oxford University', 'img/oxford.jpg', 'Arts & Humanities',
    //       '-',10, 415, 4.9, 15.3),
    // );

    //_utilitiesfBrandList = _brandsList.list.firstWhere((brand) {
    //return brand.selected;
    //}).utilities;
    super.initState();
  }

  void fetchData() async {
    // var type = "majors";
    String url = SERVER_DOMAIN + "frontend-home";

    print('========= noted: query all item ' + url);

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('========= noted: get response body ' + response.body.toString());
      if (response.body.isNotEmpty) {
        List universities =
            await json.decode(response.body)['data']['university'];
        if (universities != null && universities.isNotEmpty) {
          for (var i = 0; i < universities.length; i++) {
            print('university $i');
            setState(() {
              _universityList.add(new University(
                  universities[i]['id'],
                  universities[i]['name'],
                  universities[i]['description'],
                  universities[i]['website'],
                  universities[i]['logo_src'],
                  universities[i]['header_src'] != null
                      ? universities[i]['header_src']
                      : "http://dev.unio.id/frontend/placeholder_university_header.jpg"));
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            HomeSliderWidget(),
            Container(
              margin: const EdgeInsets.only(top: 150, bottom: 20),
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: SearchBarHomeWidget(),
            ),
          ],
        ),
        Container(
            padding: const EdgeInsets.only(right: 2, left: 2),
            child: CategoriesIconsContainerWidget(
              categoriesList: _categoriesList,
            )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    UiIcons.favorites,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    'Popular',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ],
            )),
        (_universityList.isNotEmpty)
            ? PopularLocationCarouselWidget(
                heroTag: 'home_flash_sales', universityList: _universityList)
            : CircularProgressIndicator(),
        /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    UiIcons.box,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    'Recent',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ],
            )),*/
        /*CategorizedUtilitiesWidget(
          animationOpacity: animationOpacity,
          utilitiesList: _utilitiesList.recentList,
        )*/
      ],
    ));
  }
}
