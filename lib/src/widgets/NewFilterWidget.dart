import 'package:Unio/config/ui_icons.dart';
import 'package:Unio/src/models/category.dart';

import '../models/product_color.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewFilterWidget extends StatefulWidget {
  @override
  _NewFilterWidgetState createState() => _NewFilterWidgetState();
}

class _NewFilterWidgetState extends State<NewFilterWidget> {
  final myController = TextEditingController();
  int categoryId = 1;

  CategoriesList _categoriesList = new CategoriesList();
  FilterList _filterList = new FilterList();
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
                        categoryId = 1;
                        clearSelection();
                      });
                    },
                    /*child: Text(
                      'Clear',
                      style: Theme.of(context).textTheme.body2,
                    ),*/
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
                    children: List.generate(_filterList.list.length, (index) {
                      var _category = _filterList.list.elementAt(index);
                      return CheckboxListTile(
                        value: _category.selected,
                        onChanged: (value) {
                          setState(() {
                            _category.selected = value;
                            categoryId = index;
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
                /*Navigator.of(context).pushNamed('/Favorites',
                    arguments: RouteArgument(
                        param1: searchType ?? '', param2: myController.text));*/
                Navigator.of(context).pushNamed('/Directory',
                    arguments: new RouteArgument(argumentsList: [
                      /*Category('University', UiIcons.bar_chart, true,
                          Colors.cyan, [])*/
                      _filterList.list[categoryId] ??
                          Category('Field of study', UiIcons.laptop, false,
                              Colors.orange, []),
                      myController.text
                    ]));
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
