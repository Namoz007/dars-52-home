import 'package:dars_52_home/controllers/citys_controller.dart';
import 'package:dars_52_home/services/location_services.dart';
import 'package:dars_52_home/views/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Map<Permission,PermissionStatus> statutes = await [
      Permission.location,
      Permission.camera,
  ].request();

  await LocationServices.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx){
            return CitysController();
          },
        )
      ],
      builder: (context,child){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomeScreen()
        );
      },
    );
  }
}
