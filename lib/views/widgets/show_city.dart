import 'package:dars_52_home/models/city.dart';
import 'package:flutter/material.dart';

class ShowCity extends StatefulWidget {
  City city;
  ShowCity({super.key, required this.city});

  @override
  State<ShowCity> createState() => _ShowCityState();
}

class _ShowCityState extends State<ShowCity> {
  int _imgIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      "${widget.city.imgs[_imgIndex]}",
                    ),
                    fit: BoxFit.fitHeight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "${widget.city.cityName.toUpperCase()}",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox()
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.city.imgs.length; i++)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _imgIndex = i;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  "${widget.city.cityName.toUpperCase()} - ${widget.city.description}"),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kordinatalar"),
                  Text("Lat:  ${widget.city.long}"),
                  Text("Long:  ${widget.city.tong}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
