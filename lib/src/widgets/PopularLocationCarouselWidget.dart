import 'package:Unio/src/models/university.dart';

import '../models/utilities.dart';
import '../widgets/PopularLocationCarouselItemWidget.dart';
import 'package:flutter/material.dart';

class PopularLocationCarouselWidget extends StatelessWidget {
  List<University> universityList;
  String heroTag;

  PopularLocationCarouselWidget({
    Key key,
    this.universityList,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 230,
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: universityList.length,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            return PopularLocationCarouselItemWidget(
              heroTag: this.heroTag,
              marginLeft: _marginLeft,
              university: universityList.elementAt(index),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }
}
