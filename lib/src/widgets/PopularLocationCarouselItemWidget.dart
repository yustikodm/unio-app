import 'package:Unio/src/models/university.dart';

import '../models/utilities.dart';
import '../models/route_argument.dart';
//import '../widgets/AvailableProgressBarWidget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PopularLocationCarouselItemWidget extends StatelessWidget {
  String heroTag;
  double marginLeft;
  University university;

  PopularLocationCarouselItemWidget({
    Key key,
    this.heroTag,
    this.marginLeft,
    this.university,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(university.universityId is int);
        Navigator.of(context).pushNamed('/Detail',
            arguments: RouteArgument(
                param1: university.universityId, param2: 'universities'));
      },
      child: Container(
        margin: EdgeInsets.only(left: this.marginLeft, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Hero(
              tag: heroTag + university.id,
              child: Container(
                width: 180,
                height: 185,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    // image: AssetImage(utilitie.image),
                    image: (this.heroTag == "home_flash_sales")
                        ? AssetImage(university.logo)
                        : NetworkImage(
                            "https://i.ibb.co/RgwbsQy/icon-campus.jpg"),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 160),
              width: 140,
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ]),
              child: Center(
                child: Text(
                  university.name,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
                //SizedBox(height: 7),
                //Text(
                //'${utilitie.available} Available',
                //style: Theme.of(context).textTheme.body1,
                //overflow: TextOverflow.ellipsis,
                //),
              ),
            )
          ],
        ),
      ),
    );
  }
}
