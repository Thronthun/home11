import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Map<String,dynamic> foodMap = {};
  List<dynamic> data=[];
  List<String> name = [];
  List<int> price = [];
  List<String> img = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('FLUTTER FOOD')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _handleClickButton, //onPress ต้องใส่เป็นฟังก์ชัน ไม่ใช่ result จากฟังก์ชัน
                  child: const Text('LOAD FOODS DATA'),
                ),
              ],
            ),
          ),
          if(data.isNotEmpty)

          /*for(var i in  data)
              foodMap.addAll(data[i]);
              buildFoodList(),*/
            Flexible(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    var i = index;
                    return buildFoodList(i);
                  }
              ),
            )

        ],
      ),
    );
  }

  Card buildFoodList(int i) {
    return Card(
      elevation: 5.0,
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(img.elementAt(i),width: 100,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(name.elementAt(i),style: TextStyle(fontSize: 20,color: Colors.green.shade500),),
                      Text(price.elementAt(i).toString(),style: TextStyle(fontSize: 15,color: Colors.green.shade200,),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> _handleClickButton() async {
    final url = Uri.parse('https://cpsu-test-api.herokuapp.com/foods');
    var result = await http.get(url);  //await คือ การแปลงเป็น result.then()ให้
    print(result.body);
    var jj = jsonDecode(result.body); // decode เพื่อแปลงออกมาเป็นโครงสร้างในภาษา dart จะได้ List ของ Map
    String status = jj['status']; //jj['ชื่อ key']
    String? msg = jj['message'];

    setState((){
      data = jj['data'];
      print('Status : $status , Message : $msg, Number of food : ${data.length}');//
      Map<String,dynamic> ts={};
      for(var i in data){
        ts = i;
        print('menu ${ts['name']} price ${ts['price']} img ${ts['image']}');
        name.add(ts['name']);
        price.add(ts['price']);
        img.add(ts['image']);
      }
    });
  }
}