import 'package:Unio/config/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompareScreen extends StatefulWidget {
  CompareScreen({Key key, this.onClose, this.comparedItems}) : super(key: key);

  Function onClose;
  Map comparedItems;

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  ScrollController scrollController = ScrollController();
  List keys;

  @override
  void initState() {
    super.initState();
    keys = widget.comparedItems.keys.toList();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('============ _scrollListener end end ======');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  leading: new IconButton(
                    icon: new Icon(UiIcons.return_icon,
                        color: Theme.of(context).hintColor),
                    onPressed:
                        widget.onClose ?? () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'Compare',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ..._compareItems(),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _compareItemsFields(keys[0]),
                            _compareItemsFields(keys[1]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _compareItems() {
    List<Widget> _w = [];
    List keys = widget.comparedItems.keys.toList();

    for (var i = 0; i < keys.length; i++) {
      var item = widget.comparedItems[keys[i]];

      // _w.add(CompareItems(id: keys[i], item: item));
      _w.add(Container(
        width: MediaQuery.of(context).size.width * 0.35,
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
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                (!item['isCompared'])
                    ? Container(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.plusCircle),
                              color: Theme.of(context).hintColor.withOpacity(0.10),
                              onPressed: widget.onClose,
                            ),
                            Text('Add'),
                          ],
                        ),
                      )
                    : SizedBox(),
                (item['isCompared'])
                    ? Positioned(
                        top: 0,
                        right: 5.0,
                        child: GestureDetector(
                            onTap: () {
                              // TODO DI SINI COI
                              setState(() {
                                widget.comparedItems[keys[i]]['isCompared'] =
                                    !widget.comparedItems[keys[i]]
                                        ['isCompared'];
                              });
                            },
                            child: Icon(
                              FontAwesomeIcons.times,
                              size: 14.0,
                            )))
                    : SizedBox(),
                (item['isCompared'])
                    ? Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Column(
                          children: [
                            Hero(
                              tag: 'logo item',
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  image: DecorationImage(
                                      image: NetworkImage(item['logo_src']),
                                      fit: BoxFit.contain),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              item['name'],
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            )),
      ));
    }

    return _w;
  }

  Widget _compareItemsFields(key) {
    var item = widget.comparedItems[key];

    String type = item['type'] != '' ? item['type'] : '-';
    String campuses = item['campus_locations'].length.toString();
    String website = item['website'] != null ? 'Yes' : 'No';

    return Container(
        child: Column(
      children: [
        SizedBox(height: 25),
        Text(
          'Country',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        (item['isCompared']) ? Text(item['country']['name'] ?? '-') : Text('-'),
        SizedBox(
          height: 10,
        ),
        Text(
          'Type',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        (item['isCompared']) ? Text(type) : Text('-'),
        SizedBox(
          height: 10,
        ),
        Text(
          '# Of Campuses',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        (item['isCompared']) ? Text(campuses) : Text('-'),
        SizedBox(
          height: 10,
        ),
        Text(
          'Website',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        (item['isCompared']) ? Text(website) : Text('-'),
      ],
    ));
  }
}

class CompareItems extends StatefulWidget {
  CompareItems({Key key, this.id, this.item, this.onClear, this.onAdd})
      : super(key: key);
  final dynamic id;
  final dynamic item;
  final Function onClear;
  final Function onAdd;

  @override
  _CompareItemsState createState() => _CompareItemsState();
}

class _CompareItemsState extends State<CompareItems> {
  bool isCleared;

  dynamic item;

  String type;
  String campuses;
  String website;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCleared = false;
    item = widget.item;
    type = item['type'] != '' ? item['type'] : '-';
    campuses = item['campus_locations'].length.toString();
    website = item['website'] != null ? 'Yes' : 'No';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
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
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    (isCleared)
                        ? Container(
                            height: 100,
                            child: SizedBox(),
                          )
                        : SizedBox(),
                    (!isCleared)
                        ? Positioned(
                            top: 0,
                            right: 5.0,
                            child: GestureDetector(
                                onTap: () {
                                  // TODO DI SINI COI
                                  setState(() {
                                    isCleared = true;
                                  });
                                },
                                child: Icon(
                                  FontAwesomeIcons.times,
                                  size: 14.0,
                                )))
                        : SizedBox(),
                    (!isCleared)
                        ? Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Column(
                              children: [
                                Hero(
                                  tag: 'logo item',
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      image: DecorationImage(
                                          image: NetworkImage(item['logo_src']),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  item['name'],
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                )),
          ),
          // SizedBox(height: 20),
          // Text(
          //   'Country',
          //   style: TextStyle(
          //     fontSize: 14.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Text(item['country']['name'] ?? '-'),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   'Type',
          //   style: TextStyle(
          //     fontSize: 14.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Text(type),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   '# Of Campuses',
          //   style: TextStyle(
          //     fontSize: 14.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Text(campuses),
          // SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   'Website',
          //   style: TextStyle(
          //     fontSize: 14.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // Text(website),
        ],
      ),
    );
  }
}
