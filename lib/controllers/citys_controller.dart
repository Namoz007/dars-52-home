import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_52_home/models/city.dart';
import 'package:dars_52_home/services/citys_services.dart';
import 'package:flutter/cupertino.dart';

class CitysController extends ChangeNotifier{
  final _services = CitysServices();
  List<City> _citys = [];

  Stream<QuerySnapshot> getAllCitys() async*{
    yield* _services.getAllCitys();
  }

  Future<void> addProduct(City city,List<File> imgs) async{
    await _services.addCity(city, imgs);
  }

  Future<void> deleteCity(String globalId) async{
    await _services.deleteCity(globalId);
  }

  Future<void> editCity(City city) async{
    await _services.editCity(city);
  }
}