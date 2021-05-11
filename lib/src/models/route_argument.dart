class RouteArgument {
  dynamic id;
  List<dynamic> argumentsList;
  dynamic param1;
  dynamic param2;

  RouteArgument({this.id, this.argumentsList, this.param1, this.param2});

  @override
  String toString() {
    return '{id: $id, heroTag:${argumentsList.toString()}}';
  }
}

/*
class RouteArgument {
  String id;
  String heroTag;
  dynamic param;
  // dynamic param2;

  RouteArgument({this.id, this.heroTag, this.param}); //, , this.param2

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
*/
