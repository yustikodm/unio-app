import '../../config/ui_icons.dart';
import '../models/category.dart';
import '../models/utilities.dart';
import '../widgets/PopularLocationCarouselWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/utilities.dart';

// ignore: must_be_immutable
class BrandHomeTabWidget extends StatefulWidget {
  Category category;
  UtilitiesList utilitiesList = new UtilitiesList();

  BrandHomeTabWidget({this.category, this.utilitiesList});

  @override
  _BrandHomeTabWidgetState createState() => _BrandHomeTabWidgetState();
}

class _BrandHomeTabWidgetState extends State<BrandHomeTabWidget> {
  var universities = List();

  @override
  void initState() {
    // getuniversity();
  }

  // void getuniversity() async {
  //   final response = await http.get(
  //     Uri.parse('https://primavisiglobalindo.net/unio/public/api/universities'),
  //     // Send authorization headers to the backend.
  //     headers: {HttpHeaders.authorizationHeader: "VsNYL8JE4Cstf8gb9LYCobuxYWzIo71bvUkIVYXXVUO4RtvuRxGYxa3TFzsaOeHxxf4PRY7MIhBPJBly4H9bckY5Qr44msAxc0l4"},
  //   );
  //   print(response.body);
  //   setState(() {
  //     universities= jsonDecode(response.body)['data']['data'];
  //
  //   });
  //   // district = [{"id":1,"name":"Surabaya"},{"id":2,"name":"Jakarta"},{"id":3,"name":"Malang"},{"id":4,"name":"Medan"},];
  //   print("panjang "+ universities.length.toString());
  //   for (var i=0;i<universities.length;i++)
  //   {
  //
  //     print(universities[i]['name']);
  //     setState(() {
  //       widget.utilitiesList.popularList.add(
  //           new Utilitie(
  //               universities[i]['name'], universities[i]['logo_src'], universities[i]['type'], '-###',25, 130, 4.3, 12.1));
  //       // utilitiesList: widget._utilitiesList.popularList
  //     });
  //
  //   }
  //
  // }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        /*Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),

          child: Center(
            child: Text(
              '${widget.category.name}',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),*/
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.favorites,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Description',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
              'We’re all going somewhere. And whether it’s the podcast blaring from your headphones as you walk down the street or the essay that encourages you to take on that big project, there’s a real joy in getting lost in the kind of story that feels like a destination unto itself.'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.trophy,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Popular',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        /*PopularLocationCarouselWidget(heroTag: 'brand_featured_products', utilitiesList: widget.utilitiesList.popularList),*/
      ],
    );
  }
}
