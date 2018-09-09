import 'package:flutter/material.dart';

class StudyHall {
  final String id;
  final String name;
  final String location;
  final double price;
  final String image;
  final bool isFavorite;
  final String userEmail;
  final String userId;

  StudyHall(
      {
       @required this.id,
       @required this.name,
       @required this.location,
       @required this.price,
       @required this.image,
       @required this.userEmail,
       @required this.userId,
       this.isFavorite = false});
}
