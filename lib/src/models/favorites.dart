import 'package:flutter/material.dart';

class Favorite {
  String id = UniqueKey().toString();
  String name;
  String image;
  String description;
  int entityId;
  String entityType;
  int parentId;
  String parentName;

  Favorite(this.name, this.image, this.description, this.entityId,
      this.entityType, this.parentId, this.parentName);
}

class FavoriteList {
  List<Favorite> _favoritesList;
  List<Favorite> get favoritesList => _favoritesList;

  FavoriteList() {
    _favoritesList = [
      /*new Favorite('Elu Shopping', 'img/elu.png', 'Business & Finance', 1,
          'services', 1, 'Vendor Jaya Kusuma'),*/
    ];
  }
}
