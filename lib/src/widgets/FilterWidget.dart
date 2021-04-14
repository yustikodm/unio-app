import '../models/category.dart';
import '../models/product_color.dart';
import '../models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/utilities.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  CategoriesList _categoriesList = new CategoriesList();
  ProductColorsList _productColorsList = new ProductColorsList();
  //List<int> selections = [];
  String _categoryGroup = "";
  String _valCountry;
  String _valState;
  String _valDistrict;
  String _valCategory;
  String _valUniversity;
  var propinsi = List();
  var state = List();
  var district = List();
  var category = List();
  var universities = List();
  @override
  void initState() {
    ambildata();
  }

  void ambildata() async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/countries'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      propinsi = jsonDecode(response.body)['data'];
    });
    // propinsi = [{"id":1,"name":"Indonesia"},{"id":2,"name":"United States"},{"id":3,"name":"Belanda"},{"id":4,"name":"Malaysia"}];

    print(propinsi.toString());
    getCategory();
    getuniversity();
    // getstate("1");
    // getdistrict("1");
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
    print(response.body);
    setState(() {
      state = jsonDecode(response.body)['data'];
    });
    print(state.toString());
    // state = [{"id":1,"name":"Jawa Barat"},{"id":2,"name":"Jawa Tengah"},{"id":3,"name":"Jawa Timur"},{"id":4,"name":"DKI Jakarta"}];
  }

  void getdistrict(String stateid) async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/district'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      district = jsonDecode(response.body)['data'];
    });
    print(district.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
  }

  void getuniversity() async {
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
      universities = jsonDecode(response.body)['data']['data'];
    });
    print(universities.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
  }

  void getCategory() async {
    final response = await http.get(
      Uri.parse(
          'https://primavisiglobalindo.net/unio/public/api/vendor-categories'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      category = jsonDecode(response.body)['data'];
    });
    print(category.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
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
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.4),
                                width: 1),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            TextField(
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
                            // Padding(
                            //   padding: const EdgeInsets.only(right:30.0),
                            //   child: IconButton(
                            //     onPressed: () {
                            //       // Scaffold.of(context).openEndDrawer();
                            //     },
                            //     icon: Icon(UiIcons.checked,
                            //         size: 20,
                            //         color: Theme.of(context).hintColor.withOpacity(0.5)),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        'Categories',
                      ),
                      children: List.generate(8, (index) {
                        var _category = _categoriesList.list.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: new Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _category.icon,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10, height: 10),
                                  Text(
                                    _category.name,
                                    style: new TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              new Radio(
                                value: _category.name,
                                groupValue: _categoryGroup,
                                onChanged: (value) {
                                  setState(() {
                                    _categoryGroup = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    (_categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("Category :"),
                          )
                        : Container(),
                    (_categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new DropdownButton(
                              items: category.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                      (item['name'].toString().length > 30)
                                          ? item['name']
                                              .toString()
                                              .substring(0, 30)
                                          : item['name'].toString()),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  _valCategory = newVal;
                                });
                              },
                              value: _valCategory,
                            ))
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Majors" ||
                            _categoryGroup == "Places to Live" ||
                            _categoryGroup == "Vendor" ||
                            _categoryGroup == "Scholarship")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("Country :"),
                          )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Majors" ||
                            _categoryGroup == "Places to Live" ||
                            _categoryGroup == "Vendor" ||
                            _categoryGroup == "Scholarship")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new DropdownButton(
                              items: propinsi.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                      (item['name'].toString().length > 30)
                                          ? item['name']
                                              .toString()
                                              .substring(0, 30)
                                          : item['name'].toString()),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  _valCountry = newVal;
                                });
                              },
                              value: _valCountry,
                            ))
                        : Container(),
                    (_categoryGroup == "Scholarship")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("University :"),
                          )
                        : Container(),
                    (_categoryGroup == "Scholarship")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new DropdownButton(
                              items: universities.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                      (item['name'].toString().length > 30)
                                          ? item['name']
                                              .toString()
                                              .substring(0, 30)
                                          : item['name'].toString()),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  _valUniversity = newVal;
                                });
                              },
                              value: _valUniversity,
                            ))
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Majors" ||
                            _categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("State :"),
                          )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Majors" ||
                            _categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new DropdownButton(
                              items: state.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                      (item['name'].toString().length > 30)
                                          ? item['name']
                                              .toString()
                                              .substring(0, 30)
                                          : item['name'].toString()),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  _valState = newVal;
                                });
                              },
                              value: _valState,
                            ))
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Majors" ||
                            _categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("District :"),
                          )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Majors" ||
                            _categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new DropdownButton(
                              items: district.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                      (item['name'].toString().length > 30)
                                          ? item['name']
                                              .toString()
                                              .substring(0, 30)
                                          : item['name'].toString()),
                                  value: item['id'].toString(),
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                setState(() {
                                  _valDistrict = newVal;
                                });
                              },
                              value: _valDistrict,
                            ))
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 15),
              FlatButton(
                onPressed: () async {
                  if (_categoryGroup == "University") {
                    final response = await http.get(
                      Uri.parse(
                          'https://primavisiglobalindo.net/unio/public/api/universities?country_id=1'),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data']['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);
                      String desc = (hasilsearch[i]['description'] == null)
                          ? ""
                          : hasilsearch[i]['description'];
                      String type = (hasilsearch[i]['type'] == null)
                          ? ""
                          : hasilsearch[i]['type'];
                      String accreditation =
                          (hasilsearch[i]['accreditation'] == null)
                              ? ""
                              : hasilsearch[i]['accreditation'];
                      String address = (hasilsearch[i]['address'] == null)
                          ? ""
                          : hasilsearch[i]['address'];
                      _categoriesList.list.elementAt(0).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['name'],
                                hasilsearch[i]['logo_src'],
                                type,
                                desc + "#" + accreditation + "#" + address,
                                25,
                                130,
                                4.3,
                                12.1),
                          );
                    }
                    // print(CategoriesList().list.elementAt(0).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(0)
                        ]));
                  }

                  if (_categoryGroup == "Major") {
                    final response = await http.get(
                      Uri.parse(
                          'https://primavisiglobalindo.net/unio/public/api/university-majors'),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data']['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(1).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['name'],
                                hasilsearch[i]['logo_src'],
                                '-',
                                '-',
                                25,
                                130,
                                4.3,
                                12.1),
                          );
                    }
                    // print(CategoriesList().list.elementAt(1).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(1)
                        ]));
                  }

                  if (_categoryGroup == "Vendor") {
                    final response = await http.get(
                      Uri.parse(
                          'https://primavisiglobalindo.net/unio/public/api/vendors'),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(2).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['name'],
                                hasilsearch[i]['picture'],
                                '-',
                                '-',
                                25,
                                130,
                                4.3,
                                12.1),
                          );
                    }
                    // print(CategoriesList().list.elementAt(2).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(2)
                        ]));
                  }

                  if (_categoryGroup == "Places to Live") {
                    final response = await http.get(
                      Uri.parse(
                          'https://primavisiglobalindo.net/unio/public/api/vendors'),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(2).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['name'],
                                hasilsearch[i]['picture'],
                                '-',
                                '-',
                                25,
                                130,
                                4.3,
                                12.1),
                          );
                    }
                    // print(CategoriesList().list.elementAt(2).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(2)
                        ]));
                  }

                  if (_categoryGroup == "Scholarship") {}

                  if (_categoryGroup == "Article") {
                    final response = await http.get(
                      Uri.parse(
                          'https://primavisiglobalindo.net/unio/public/api/articles'),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    for (var i = 0; i < hasilsearch.length; i++) {
                      // print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(5).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['title'],
                                hasilsearch[i]['picture'],
                                '-',
                                '-',
                                25,
                                130,
                                4.3,
                                12.1),
                          );
                    }
                    // print(CategoriesList().list.elementAt(2).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(5)
                        ]));
                  }

                  if (_categoryGroup == "Article") {}
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
      ),
    );
  }

  void clearSelection() {
    this._categoriesList.clearSelection();
  }
}
