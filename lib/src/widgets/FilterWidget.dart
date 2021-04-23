import '../models/category.dart';
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

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final myController = TextEditingController();
  CategoriesList _categoriesList = new CategoriesList();
  final List<DropdownMenuItem> countryitem = [];
  final List<DropdownMenuItem> categoriitem = [];
  final List<DropdownMenuItem> universityitem = [];
  final List<DropdownMenuItem> stateitem = [];
  final List<DropdownMenuItem> districtitem = [];

  ProductColorsList _productColorsList = new ProductColorsList();
  //List<int> selections = [];
  String _categoryGroup = "";
  String _valCountry;
  String _valState;
  String _valDistrict;
  String _valCategory;
  String _valUniversity;
  String selectedValue;
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

    myController.text = cari_keyword;
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
      propinsi = jsonDecode(response.body)['data']['data'];
    });
    // propinsi = [{"id":1,"name":"Indonesia"},{"id":2,"name":"United States"},{"id":3,"name":"Belanda"},{"id":4,"name":"Malaysia"}];
    for (var i = 0; i < propinsi.length; i++) {
      setState(() {
        countryitem.add(DropdownMenuItem(
          child: Text(propinsi[i]['name']),
          value: propinsi[i]['name'],
        ));

      });

    }




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
      state = jsonDecode(response.body)['data']['data'];
    });
    print(state.toString());
    // state = [{"id":1,"name":"Jawa Barat"},{"id":2,"name":"Jawa Tengah"},{"id":3,"name":"Jawa Timur"},{"id":4,"name":"DKI Jakarta"}];
    for (var i = 0; i < state.length; i++) {
      setState(() {
        stateitem.add(DropdownMenuItem(
          child: Text(state[i]['name']),
          value: state[i]['name'],
        ));

      });

    }
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getdistrict(String stateid) async {
    final response = await http.get(
      Uri.parse('https://primavisiglobalindo.net/unio/public/api/districts'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
      },
    );
    print(response.body);
    setState(() {
      district = jsonDecode(response.body)['data']['data'];
    });
    print(district.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
    for (var i = 0; i < district.length; i++) {
      setState(() {
        districtitem.add(DropdownMenuItem(
          child: Text(district[i]['name']),
          value: district[i]['name'],
        ));

      });

    }


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
    for (var i = 0; i < universities.length; i++) {
      setState(() {
        universityitem.add(DropdownMenuItem(
          child: Text(universities[i]['name']),
          value: universities[i]['name'],
        ));

      });

    }
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
      category = jsonDecode(response.body)['data']['data'];
    });
    print(category.toString());
    // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];

    for (var i = 0; i < category.length; i++) {
      setState(() {
        categoriitem.add(DropdownMenuItem(
          child: Text(category[i]['name']),
          value: category[i]['name'],
        ));

      });

    }

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
                        ?
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: SearchableDropdown.single(
                        items: categoriitem,
                        value: selectedValue,
                        hint: "Category",
                        searchHint: "Category",
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            print(value);
                          });
                        },
                        isExpanded: true,
                      ),
                    )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Field of study" ||
                            _categoryGroup == "Places to Live" ||
                            _categoryGroup == "Vendor" ||
                            _categoryGroup == "Scholarship")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("Country :"),
                          )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Field of study" ||
                            _categoryGroup == "Places to Live" ||
                            _categoryGroup == "Vendor" ||
                            _categoryGroup == "Scholarship")
                        ?
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: SearchableDropdown.single(
                        items: countryitem,
                        value: _valCountry,
                        hint: "Country",
                        searchHint: "Country",
                        onChanged: (value) {
                          setState(() {
                            _valCountry = value;
                            getstate(_valCountry);
                            print(value);
                          });
                        },
                        isExpanded: true,
                      ),
                    )
                    // Padding(
                    //         padding: const EdgeInsets.only(left: 20.0),
                    //         child: new DropdownButton(
                    //           items: propinsi.map((item) {
                    //             return new DropdownMenuItem(
                    //               child: new Text(
                    //                   (item['name'].toString().length > 30)
                    //                       ? item['name']
                    //                           .toString()
                    //                           .substring(0, 30)
                    //                       : item['name'].toString()),
                    //               value: item['id'].toString(),
                    //             );
                    //           }).toList(),
                    //           onChanged: (newVal) {
                    //             setState(() {
                    //               _valCountry = newVal;
                    //               _valState = null;
                    //               state  = jsonDecode('[{"id":"0","country_id":"0","name":""}]');
                    //               getstate(_valCountry);
                    //             });
                    //           },
                    //           value: _valCountry,
                    //         ))
                        : Container(),
                    (_categoryGroup == "Scholarship")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("University :"),
                          )
                        : Container(),
                    (_categoryGroup == "Scholarship")
                        ?
                    // Padding(
                    //         padding: const EdgeInsets.only(left: 20.0),
                    //         child: new DropdownButton(
                    //           items: universities.map((item) {
                    //             return new DropdownMenuItem(
                    //               child: new Text(
                    //                   (item['name'].toString().length > 30)
                    //                       ? item['name']
                    //                           .toString()
                    //                           .substring(0, 30)
                    //                       : item['name'].toString()),
                    //               value: item['id'].toString(),
                    //             );
                    //           }).toList(),
                    //           onChanged: (newVal) {
                    //             setState(() {
                    //               _valUniversity = newVal;
                    //             });
                    //           },
                    //           value: _valUniversity,
                    //         ))
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: SearchableDropdown.single(
                        items: universityitem,
                        value: _valUniversity,
                        hint: "University",
                        searchHint: "University",
                        onChanged: (value) {
                          setState(() {
                            _valUniversity = value;
                            print(value);
                          });
                        },
                        isExpanded: true,
                      ),
                    )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Field of study" ||
                            _categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("State :"),
                          )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Field of study" ||
                            _categoryGroup == "Vendor")
                        ?
                    // Padding(
                    //         padding: const EdgeInsets.only(left: 20.0),
                    //         child: new DropdownButton(
                    //           items: state.map((item) {
                    //             return new DropdownMenuItem(
                    //               child: new Text(
                    //                   (item['name'].toString().length > 30)
                    //                       ? item['name']
                    //                           .toString()
                    //                           .substring(0, 30)
                    //                       : item['name'].toString()),
                    //               value: item['id'].toString(),
                    //             );
                    //           }).toList(),
                    //           onChanged: (newVal) {
                    //             setState(() {
                    //               _valState = newVal;
                    //               _valDistrict = null;
                    //               district  = jsonDecode('[{"id":"0","state_id":"0","name":""}]');
                    //               getdistrict(_valState);
                    //             });
                    //           },
                    //           value: _valState,
                    //         ))
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: SearchableDropdown.single(
                        items: stateitem,
                        value: _valState,
                        hint: "State",
                        searchHint: "State",
                        onChanged: (value) {
                          setState(() {
                            _valState = value;
                            getdistrict(_valState);
                            print(value);
                          });
                        },
                        isExpanded: true,
                      ),
                    )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Field of study" ||
                            _categoryGroup == "Vendor")
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("District :"),
                          )
                        : Container(),
                    (_categoryGroup == "University" ||
                            _categoryGroup == "Field of study" ||
                            _categoryGroup == "Vendor")
                        ?
                    // Padding(
                    //         padding: const EdgeInsets.only(left: 20.0),
                    //         child: new DropdownButton(
                    //           items: district.map((item) {
                    //             return new DropdownMenuItem(
                    //               child: new Text(
                    //                   (item['name'].toString().length > 30)
                    //                       ? item['name']
                    //                           .toString()
                    //                           .substring(0, 30)
                    //                       : item['name'].toString()),
                    //               value: item['id'].toString(),
                    //             );
                    //           }).toList(),
                    //           onChanged: (newVal) {
                    //             setState(() {
                    //               _valDistrict = newVal;
                    //             });
                    //           },
                    //           value: _valDistrict,
                    //         ))
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: SearchableDropdown.single(
                        items: districtitem,
                        value: selectedValue,
                        hint: "District",
                        searchHint: "District",
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            print(value);
                          });
                        },
                        isExpanded: true,
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 15),
              FlatButton(
                onPressed: () async {
                  if (_categoryGroup == "University") {
                    cari_query = "&name="+myController.text.replaceAll(" ", "%20");
                    if (_valCountry!=null)
                    {
                      cari_query=cari_query+"&country="+_valCountry;
                      if (_valState!=null)
                      {
                        cari_query=cari_query+"&state="+_valState;
                        if (_valDistrict!=null)
                        {
                            cari_query = cari_query+"&district="+_valDistrict;
                        }
                      }
                    }

                    final response = await http.get(
                      // Uri.parse('http://18.136.203.155/api/universities?country_id=1'),
                      Uri.parse(
                          'https://primavisiglobalindo.net/unio/public/api/search/?keyword=universities'+cari_query),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );
                    print(response.body);
                    print("------------");
                    var hasilsearch = jsonDecode(response.body)['data'];
                    print("------------");
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
                                desc + "#" + accreditation + "#" + address +"#University",
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
                  if (_categoryGroup == "Field of study") {
                    if (cari_keyword=="")
                      {
                        _showMyDialog("Must fill search first");
                        return;
                      }
                    cari_query = "&major="+myController.text.replaceAll(" ", "%20");
                    if (_valCountry!=null)
                    {
                      cari_query=cari_query+"&country="+_valCountry;
                      if (_valState!=null)
                      {
                        cari_query=cari_query+"&state="+_valState;
                        if (_valDistrict!=null)
                        {
                          cari_query = cari_query+"&district="+_valDistrict;
                        }
                      }
                    }
                    final response = await http.get(
                      Uri.parse(
                          // 'https://primavisiglobalindo.net/unio/public/api/university-majors'),
                        'https://primavisiglobalindo.net/unio/public/api/search/?keyword=universities'+cari_query),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);
                    _categoriesList.list.elementAt(1).utilities.clear();
                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);

                      _categoriesList.list.elementAt(1).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['major']['name']+"-"+hasilsearch[i]['name'],
                                hasilsearch[i]['logo_src'],
                                '-',
                                '-###Field of study',
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
                    cari_query = "&name="+myController.text.replaceAll(" ", "%20");
                    if (_valCategory!=null)
                    {
                      cari_query = cari_query+"&vendor_category="+_valCategory;
                    }
                    if (_valCountry!=null)
                    {
                      cari_query=cari_query+"&country="+_valCountry;
                      if (_valState!=null)
                      {
                        cari_query=cari_query+"&state="+_valState;
                        if (_valDistrict!=null)
                        {
                          cari_query = cari_query+"&district="+_valDistrict;
                        }
                      }
                    }
                    print('https://primavisiglobalindo.net/unio/public/api/search/?keyword=vendors'+cari_query);
                    final response = await http.get(
                      Uri.parse(
                        'https://primavisiglobalindo.net/unio/public/api/search/?keyword=vendors'+cari_query),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    _categoriesList.list.elementAt(2).utilities.clear();
                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(2).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['name'],
                                hasilsearch[i]['picture'],
                                '-',
                                '-###Vendor',
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
                    cari_query="";
                    if (_valCountry!=null) {
                      cari_query = "?country_id=" + _valCountry;
                    }
                    print('https://primavisiglobalindo.net/unio/public/api/place-to-lives/'+cari_query);
                    final response = await http.get(
                      Uri.parse('https://primavisiglobalindo.net/unio/public/api/place-to-lives/'+cari_query),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );
                    print(response.body.toString());
                    var hasilsearch = jsonDecode(response.body)['data']['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);
                    _categoriesList.list.elementAt(3).utilities.clear();
                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(3).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['name'],
                                hasilsearch[i]['picture'],
                                '-',
                                '-###Place to Live',
                                25,
                                130,
                                4.3,
                                12.1),
                          );
                    }
                    // print(CategoriesList().list.elementAt(2).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(3)
                        ]));
                  }

                  if (_categoryGroup == "Scholarship") {
                    cari_query="";
                    if (_valCountry!=null) {
                      cari_query = "&country_id=" + _valCountry;
                    }
                    // print('https://primavisiglobalindo.net/unio/public/api/place-to-lives/'+cari_query);
                    final response = await http.get(
                      Uri.parse(
                        'https://primavisiglobalindo.net/unio/public/api/search/?keyword=scholarship'+cari_query),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                        "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );
                    print(response.body.toString());
                    var hasilsearch = jsonDecode(response.body)['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);
                    _categoriesList.list.elementAt(4).utilities.clear();
                    for (var i = 0; i < hasilsearch.length; i++) {
                      print(hasilsearch[i]['university']['name']);
                      _categoriesList.list.elementAt(4).utilities.add(
                        new Utilitie(
                            "Scholarship "+hasilsearch[i]['university']['name'],
                            hasilsearch[i]['picture'],
                            '-',
                            '-###Scholarship',
                            25,
                            130,
                            4.3,
                            12.1),
                      );
                    }
                    // print(CategoriesList().list.elementAt(2).name);
                    Navigator.of(context).pushNamed('/Categorie',
                        arguments: RouteArgument(id: 101, argumentsList: [
                          _categoriesList.list.elementAt(4)
                        ]));


                  }

                  if (_categoryGroup == "Article") {
                    final response = await http.get(
                      Uri.parse('https://primavisiglobalindo.net/unio/public/api/articles'),
                      // Send authorization headers to the backend.
                      headers: {
                        HttpHeaders.authorizationHeader:
                            "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"
                      },
                    );

                    var hasilsearch = jsonDecode(response.body)['data']['data'];
                    print(hasilsearch.toString());
                    // print(hasilsearch.length);

                    _categoriesList.list.elementAt(5).utilities.clear();
                    for (var i = 0; i < hasilsearch.length; i++) {
                      // print(hasilsearch[i]['name']);
                      _categoriesList.list.elementAt(5).utilities.add(
                            new Utilitie(
                                hasilsearch[i]['title'],
                                hasilsearch[i]['picture'],
                                '-',
                                '-###Article',
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
