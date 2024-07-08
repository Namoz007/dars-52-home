import 'package:cloud_firestore/cloud_firestore.dart';

class City {
  String globalId;
  String cityName;
  List<String> imgs;
  String description;
  String long;
  String tong;

  City(
      {required this.globalId,
      required this.cityName,
      required this.description,
      required this.imgs,
      required this.long,
      required this.tong,});

  factory City.fromJson(QueryDocumentSnapshot query) {
    return City(
      globalId: query.id,
      cityName: query['cityName'],
      imgs: List<String>.from(query['imgs']),
      description: query['description'],
      long: query['long'].toString(),
      tong: query['tong'].toString(),
    );
  }

  Map<String, dynamic> toJson(City city) {
    return {
      "globalId": city.globalId,
      "cityName": city.cityName,
      "imgs": city.imgs,
      "description": city.description,
      "long": city.long,
      "tong": city.tong,
    };
  }

}
