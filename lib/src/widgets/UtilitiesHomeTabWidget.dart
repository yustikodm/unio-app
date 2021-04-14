import '../../config/ui_icons.dart';
import '../models/product_color.dart';
import '../widgets/PopularLocationCarouselWidget.dart';
import 'package:flutter/material.dart';
import '../models/utilities.dart';
// ignore: must_be_immutable
class UtilitieHomeTabWidget extends StatefulWidget {
  Utilitie utilitie;
  UtilitiesList _productsList = new UtilitiesList();

  UtilitieHomeTabWidget({this.utilitie});

  @override
  UtilitieHomeTabWidgetState createState() => UtilitieHomeTabWidgetState();
}

class UtilitieHomeTabWidgetState extends State<UtilitieHomeTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 22, left: 20, right: 20),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.utilitie.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              Chip(
                padding: EdgeInsets.all(0),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.utilitie.rate.toString(),
                        style:
                            Theme.of(context).textTheme.body2.merge(TextStyle(color: Theme.of(context).primaryColor))),
                    SizedBox(width: 4),
                    Icon(
                      Icons.star_border,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
Row(
  children: [
        Text(

                        "Accredition : "+widget.utilitie.description.split("#")[1],

                        overflow: TextOverflow.ellipsis,

                        maxLines: 1,

                        style: Theme.of(context).textTheme.body2

                  ),
    Text(
        ", Type : Negri",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.body2
    ),
  ],
),
              Text(
                    "Indonesia, DIY Djokjakarta",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.body2
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  UiIcons.file_2,
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
              child: Text(widget.utilitie.description.split("#")[0]),
            ),
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //       child: ListTile(
        //         dense: true,
        //         contentPadding: EdgeInsets.symmetric(vertical: 0),
        //         leading: Icon(
        //           UiIcons.file_2,
        //           color: Theme.of(context).hintColor,
        //         ),
        //         title: Text(
        //           'Accredition',
        //           style: Theme.of(context).textTheme.display1,
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //       child: Text(widget.utilitie.description.split("#")[1]),
        //     ),
        //   ],
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  UiIcons.file_2,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Address',
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(widget.utilitie.description.split("#")[2]),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  UiIcons.file_2,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Facility',
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            //   child: Text("-"),
            // ),
            new Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height* 0.15,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                          ),
                          Text("Accept Credit Card"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.local_parking,
                          ),
                          Text("Parking"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                          ),
                          Text("Pet Friendly"),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.wifi,
                          ),
                          Text("Wireless Internet"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.laptop_chromebook_sharp,
                          ),
                          Text("Offering a deal"),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.payment,
                          ),
                          Text("Apple Pay"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //       child: ListTile(
        //         dense: true,
        //         contentPadding: EdgeInsets.symmetric(vertical: 0),
        //         leading: Icon(
        //           UiIcons.file_2,
        //           color: Theme.of(context).hintColor,
        //         ),
        //         title: Text(
        //           'Country',
        //           style: Theme.of(context).textTheme.display1,
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //       child: Text("-"),
        //     ),
        //   ],
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //       child: ListTile(
        //         dense: true,
        //         contentPadding: EdgeInsets.symmetric(vertical: 0),
        //         leading: Icon(
        //           UiIcons.file_2,
        //           color: Theme.of(context).hintColor,
        //         ),
        //         title: Text(
        //           'State',
        //           style: Theme.of(context).textTheme.display1,
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //       child: Text("-"),
        //     ),
        //   ],
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //       child: ListTile(
        //         dense: true,
        //         contentPadding: EdgeInsets.symmetric(vertical: 0),
        //         leading: Icon(
        //           UiIcons.file_2,
        //           color: Theme.of(context).hintColor,
        //         ),
        //         title: Text(
        //           'District',
        //           style: Theme.of(context).textTheme.display1,
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //       child: Text("-"),
        //     ),
        //   ],
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SizedBox(
            height: 180,
            width: double.maxFinite,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                image:DecorationImage(
                  image:AssetImage('img/gps.png'),
                  fit: BoxFit.cover,
                )
              ),
             ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.box,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Related',
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        PopularLocationCarouselWidget(
            heroTag: 'product_related_products', utilitiesList: widget._productsList.popularList),
      ],
    );
  }
}

class SelectColorWidget extends StatefulWidget {
  SelectColorWidget({
    Key key,
  }) : super(key: key);

  @override
  _SelectColorWidgetState createState() => _SelectColorWidgetState();
}

class _SelectColorWidgetState extends State<SelectColorWidget> {
  ProductColorsList _productColorsList = new ProductColorsList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(_productColorsList.list.length, (index) {
        var _color = _productColorsList.list.elementAt(index);
        return buildColor(_color);
      }),
    );
  }

  SizedBox buildColor(ProductColor color) {
    return SizedBox(
      width: 38,
      height: 38,
      child: FilterChip(
        label: Text(''),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: color.color,
        selectedColor: color.color,
        selected: color.selected,
        shape: StadiumBorder(),
        avatar: Text(''),
        onSelected: (bool value) {
          setState(() {
            color.selected = value;
          });
        },
      ),
    );
  }
}



