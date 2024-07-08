import 'package:dars_52_home/controllers/citys_controller.dart';
import 'package:dars_52_home/models/city.dart';
import 'package:dars_52_home/views/widgets/add_city.dart';
import 'package:dars_52_home/views/widgets/show_city.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final citysController = Provider.of<CitysController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Travel Citys"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => AddCity(isAdd: true));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(color: Colors.red,),) : StreamBuilder(
        stream: citysController.getAllCitys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Kechirasiz, ma'lumot olishda xatolik yuz berdi!"),
            );
          }

          List<City> citys = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++)
            citys.add(City.fromJson(snapshot.data!.docs[i]));

          return citys.length == 0
              ? Center(
            child: Text(
                "Kechirasiz, hozirda hech qanday shaharlar mavjud emas"),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                mainAxisExtent: 200,
                mainAxisSpacing: 10,
              ),
              itemCount: citys.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ShowCity(city: citys[index])));
                  },
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                          "${citys[index].imgs[0]}",
                        ),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            IconButton(onPressed: () async{
                              setState(() {
                                isLoading = true;
                              });
                              await citysController.deleteCity(citys[index].globalId);
                              setState(() {
                                isLoading = false;
                              });
                            }, icon: Icon(Icons.delete,color: Colors.red,),),
                            IconButton(onPressed: (){
                              showDialog(context: context, builder: (context) => AddCity(isAdd: false,city: citys[index],));
                            }, icon: Icon(Icons.edit,color: Colors.green,),),
                          ],
                        ),
                        Text(
                          "${citys[index].cityName.toUpperCase()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
