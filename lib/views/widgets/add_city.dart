import 'dart:io';
import 'package:dars_52_home/controllers/citys_controller.dart';
import 'package:dars_52_home/models/city.dart';
import 'package:dars_52_home/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddCity extends StatefulWidget {
  bool isAdd;
  City? city;
  AddCity({super.key,required this.isAdd,this.city});

  @override
  State<AddCity> createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  final _formKey = GlobalKey<FormState>();
  final _cityName = TextEditingController();
  final _description = TextEditingController();
  final _imgForCity = TextEditingController();
  String? error;
  bool isLoading = false;
  List<File> imgs = [];

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imgs.add(File(pickedImage.path));
        // imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final citysController = Provider.of<CitysController>(context);
    return AlertDialog(
      title: widget.isAdd ? const Text("Yangi shahar qo'shish") : const Text("Shaharni tahrirlash"),
      content: Form(
        key: _formKey,
        child: isLoading ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: CircularProgressIndicator(color: Colors.red,),),
          ],
        ) : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            error == null ? SizedBox() : Text("${error}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.red),),
            SizedBox(height: 10,),
            TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Shahar nomi bosh bolmasligi kerak";
                }
                return null;
              },
              controller: _cityName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                label: widget.isAdd ? Text("Yangi shahar nomi") : Text("${widget.city!.cityName}"),
              ),
            ),
            SizedBox(height: 20,),

            TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Shahar tarifi bosh bolmasligi kerak";
                }
                return null;
              },
              controller: _description,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                label: widget.isAdd ? const Text("Yangi shahar uchun sharh") : Text("Shahar uchun yangi tavsif"),
              ),
            ),

            SizedBox(height: 20,),

            widget.isAdd ? Row(
              children: [
                IconButton(onPressed: openCamera, icon: Icon(Icons.camera),),
                Text("Suratlar uzunligi : ${imgs.length}"),
              ],
            ) : SizedBox(),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Bekor qilish"),),
        ElevatedButton(onPressed: () async{
          if(_formKey.currentState!.validate()){
            if(imgs.length > 0 || !widget.isAdd){
              if(widget.isAdd){
                setState(() {
                  isLoading = true;
                });
                await LocationServices.getCurrentLocation();
                final location = LocationServices.currentLocation;
                await citysController.addProduct(City(globalId: '', cityName: _cityName.text, description: _description.text, imgs: [], long: location!.latitude.toString(), tong: location.longitude.toString()), imgs);
                Navigator.pop(context);
                setState(() {
                  isLoading = false;
                });
              }else{
                print("Bajarilyapti ");
                setState(() {
                  isLoading = true;
                });
                await LocationServices.getCurrentLocation();
                final location = LocationServices.currentLocation;
                widget.city!.cityName = _cityName.text;
                widget.city!.description = _description.text;
                await citysController.editCity(widget.city!);
                // await citysController.addProduct(City(globalId: '', cityName: _cityName.text, description: _description.text, imgs: [], long: location!.latitude.toString(), tong: location.longitude.toString()), imgs);
                Navigator.pop(context);
                setState(() {
                  isLoading = false;
                });
              }
            }else{
              setState(() {
                if(widget.isAdd){
                  error = 'Iltimos bu joyni suratga oling';
                }else{
                  error = null;
                }
              });
            }
          }
        }, child: Text("Saqlash"),),

      ],
    );
  }
}
