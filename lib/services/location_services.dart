import 'package:location/location.dart';

class LocationServices{
  static final _location = Location();

  static bool isServicesEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> init() async{
    await _checkServices();
    await _checkPermission();
  }

  //joylashuvni olish ximati yoqilganmi tekshiramiz
  static Future<void> _checkServices() async{
    isServicesEnabled = await _location.serviceEnabled();
    if(!isServicesEnabled){
      isServicesEnabled = await _location.requestService();
      if(!isServicesEnabled){
        return;  //Redirect to Settings - Sozlamardan to'g'rilash kerak endi
      }
    }
  }

  //Joylashuv olish uchun ruxsat olinganmi shuni tekshiramiz
  static Future<void> _checkPermission() async{
    _permissionStatus == await _location.hasPermission();

    if(_permissionStatus == PermissionStatus.denied){
      _permissionStatus = await _location.requestPermission();
      if(_permissionStatus != PermissionStatus.granted){
        return; //Sozlamalar to'g'irlash kerak(ruxsat berish kerak)
      }
    }
  }

  static Future<void> getCurrentLocation() async{
    if(isServicesEnabled && _permissionStatus == PermissionStatus.granted){
      currentLocation = await _location.getLocation();
    }
  }

// static Stream<LocationData> getLiveLocation() async*{
//   yield* currentLocation;
// }
}