import 'package:flutter/material.dart';

class Carts {
  String id = UniqueKey().toString();
  int userId;
  int entityId;
  String entityType;
  String name;
  String description;
  String level;
  String image;
  int qty;
  int price;
  int totalPrice;
  String vendorName;

  Carts(
      this.userId,
      this.entityId,
      this.entityType,
      this.name,
      this.description,
      this.level,
      this.image,
      this.qty,
      this.price,
      this.totalPrice,
      this.vendorName);
}

class CartsList {
  List<Carts> _cartList;

  List<Carts> get cartList => _cartList;

  CartsList() {
    _cartList = [
      /*new Carts(
          1,
          1,
          'services',
          'Jasa sertifikasi toefl',
          'Jasa sertifikasi toefl profesional',
          'SMA',
          'img/hilton.webp',
          1,
          1000,
          1000,
          'IPIEMS'),*/
    ];
  }
}
