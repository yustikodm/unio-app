import '../models/favoriteCategory.dart';
import '../models/product_color.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/utilities.dart';
import 'package:Unio/main.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class FavoriteFilterWidget extends StatefulWidget {
  @override
  _FavoriteFilterWidgetState createState() => _FavoriteFilterWidgetState();
}

class _FavoriteFilterWidgetState extends State<FavoriteFilterWidget> {
  final myController = TextEditingController();
  String searchType = '';

  CategoriesList _categoriesList = new CategoriesList();
  ProductColorsList _productColorsList = new ProductColorsList();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Refine Results'),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        clearSelection();
                      });
                    },
                    child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.4),
                              width: 1),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          TextField(
                            controller: myController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'Search',
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      'Categories',
                    ),
                    children: List.generate(5, (index) {
                      var _category = _categoriesList.list.elementAt(index);
                      return CheckboxListTile(
                        value: _category.selected,
                        onChanged: (value) {
                          setState(() {
                            _category.selected = value;
                            searchType = _category.type;
                          });
                        },
                        secondary: Container(
                          width: 35,
                          height: 35,
                          child: Icon(
                            _category.icon,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          _category.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Favorites',
                    arguments: RouteArgument(
                        param1: searchType ?? '', param2: myController.text));
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Text(
                'Apply Filters',
                textAlign: TextAlign.start,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  void clearSelection() {
    this._categoriesList.clearSelection();
  }
}
