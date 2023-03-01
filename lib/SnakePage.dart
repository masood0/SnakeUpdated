import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lod/LoadData.dart';
import 'package:url_launcher/url_launcher.dart';

String wikUrl='https://en.wikipedia.org/wiki/Cerastes_cerastes';
final Uri _url = Uri.parse(wikUrl);
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }}


class SnakePage extends StatefulWidget {
  const SnakePage({Key? key}) : super(key: key);

  @override
  State<SnakePage> createState() => _SnakePageState();
}


class _SnakePageState extends State<SnakePage> {


  late FixedExtentScrollController controller;
  Future<List<LoadSnakeData>> snakeFuture = getSnake();
  static Future<List<LoadSnakeData>> getSnake() async {
    const url = 'https://drive.google.com/uc?export.json=download&id=1qbT27NwRydpK-882snAWzuR-vspvAA0t';
    final response = await http.get(Uri.parse(url));

    final body = json.decode(response.body);
    return body.map<LoadSnakeData>(LoadSnakeData.fromJson).toList();
  }



  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: Center(
          child: FutureBuilder<List<LoadSnakeData>>(
            future: snakeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                    CircularProgressIndicator(),
                      Text('\nLoading Data '),
                      Text('Note: this page need internet connectivity ',
                          style: TextStyle(color: Colors.deepOrange)
                      ),

              ]
              );
              }
              else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }
              else if (snapshot.hasData) {
                final snake = snapshot.data!;
                return buildSnake(snake);
              }
              else {
                return const Text('No Data');
              }
            },
          ),
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(wikUrl=='') {
                controller.initialItem;
              } else {
                _launchUrl();
              }
            },

            child: Image.asset('assets/images/icon/WikipediaIcon.png')
          ),
      );

  Widget buildSnake(List<LoadSnakeData> snakes) =>
      ListWheelScrollView.useDelegate(
        itemExtent: 420,
        physics: const FixedExtentScrollPhysics(),
onSelectedItemChanged: (a){
  final snake = snakes[a];
  wikUrl=snake.wikUrl;
},
        childDelegate: ListWheelChildBuilderDelegate(
            childCount: snakes.length,
            builder: (context, index) {
              final snake = snakes[index];
              return Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal[500],
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 100),
                  ],
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.transparent, width: 2.0),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    SizedBox(
                      width: 320,
                      height: 200,
                      child: Image.network(snake.imageUrl),
                    ),
                    Container(
                      padding:const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.teal[900],
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: Colors.transparent, width: 2.0),
                      ),
                      height: 35,
                      width: 320,
                      child: Text(
                          'Name: ${snake.snakeName}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white)
                      ),
                    ), //Name
                   // const SizedBox(width: 280, height: 10,),
                    Container(
                      padding:const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.teal[900],
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                            color: Colors.transparent, width: 2.0),
                      ),
                      height: 35,
                      width: 320,
                      child: Text(
                          'Venomous: ${snake.snakeVenom}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white)
                      ),
                    ), //Venomous
                  //  const SizedBox(width: 280, height: 10,),
                Container(
                  padding:const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.teal[900],
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: Colors.transparent, width: 2.0),
                  ),
                  height: 50,
                  width: 320,
                  child: Text(
                      'Venom ranking: ${snake.ranking}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white)
                  ),
                ),


                  ],

                )
                ,);
            }
        ),
      );

}