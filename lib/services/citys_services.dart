import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_52_home/models/city.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CitysServices{
  final _cityDatabase = FirebaseFirestore.instance.collection("travels");
  final _fireStorega = FirebaseStorage.instance.ref();

  Stream<QuerySnapshot> getAllCitys() async*{
    yield* _cityDatabase.snapshots();
  }

  Future<void> addCity(City city, List<File> imgs) async{
    for(int i = 0;i < imgs.length;i++){
      final response = await _fireStorega.child("${city.cityName[Random().nextInt(city.cityName.length)]}${city.cityName[Random().nextInt(city.cityName.length)]}${city.cityName[Random().nextInt(city.cityName.length)]}${Random().nextInt(100000)}").putFile(imgs[i]);
      final taskSnapshot = await response;
      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      String url = downloadURL.toString();
      city.imgs.add(url);
    }

    final response = await _cityDatabase.add(city.toJson(city));
    await _cityDatabase.doc(response.id).update({
      "globalId":response.id
    });
  }

  Future<void> deleteCity(String globalId) async{
    await _cityDatabase.doc(globalId).delete();
  }

  Future<void> editCity(City city) async{
    await _cityDatabase.doc(city.globalId).update({
      "cityName":city.cityName,
      "description": city.description,
    });
  }
}