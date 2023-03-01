import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
// import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  MaterialStatePropertyAll<Color> colBtn1 =const MaterialStatePropertyAll<Color>(Colors.black26) ;
  MaterialStatePropertyAll<Color> colBtn2 =const MaterialStatePropertyAll<Color>(Colors.black26) ;
  late File _image;
  late List _results;
  bool imageSelect=false;
  int srcSelect=0;
  @override
  void initState()
  {
    super.initState();
    loadModel();
  }
  Future loadModel()
  async {
    Tflite.close();
    await Tflite.loadModel(model: "assets/model.tflite",labels: "assets/labels.txt");
    //log("Models loading status: $res");
  }

  Future imageClassification(File image)
  async {
    final List ?recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      const List noRes=[{"confidence": 0.5, "index": 11, "label": "No Result"}];

      if(recognitions?.isEmpty ?? true)
      {_results= noRes;}
      else
      {_results= recognitions!;}
      _image=image;
      imageSelect=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(0),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius:100),],
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.transparent, width: 2.0)),
            child:  SizedBox(
                width:270 ,
                height:300 ,
                child:FittedBox(
                  fit: BoxFit.fill,
                  child:  (imageSelect)? Image.file(_image):Image.asset('assets/SelectImage.gif'),
                )

            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)?_results.map((result) {
                return Card(
                  child: Container(
                    margin:const EdgeInsets.all(10),
                    child: Text(
                      "${result['label'].toString().substring(1)} "
                          "with confidence "
                          "${(result['confidence']*100).toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.red,
                          fontSize: 20),
                    ),
                  ),
                );
              }).toList():[],

            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton.icon(

                    onPressed:()=>
                        pickImage(true)
                    , icon:const Icon(LineIcons.camera),
                    label: const Text('Take Photo'),

                    style: ButtonStyle(
                      backgroundColor:colBtn2,
                    ),
                  )
              ),
              Container(

                margin: const EdgeInsets.all(10.0),
                width: 150,
                height: 60,
                child:
                ElevatedButton.icon(
                  onPressed:()=>pickImage(false),
                  icon:const Icon(LineIcons.photoVideo),
                  label: const Text('Pick Photo'),
                  style: ButtonStyle(
                    backgroundColor:colBtn1,
                  ),
                ),
              ),
            ],
          ),

        ],

      ),

    );


  }


  Future pickImage(bool sel)
  async {
    HapticFeedback.mediumImpact();
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    if(sel)
    {pickedFile = await picker.pickImage(source: ImageSource.camera,);
    colBtn2 =const MaterialStatePropertyAll<Color>(Colors.lightGreen);
    colBtn1 =const MaterialStatePropertyAll<Color>(Colors.black26);
    }
    else
    {
      pickedFile = await picker.pickImage(source: ImageSource.gallery,);
      colBtn1 =const MaterialStatePropertyAll<Color>(Colors.lightGreen);
      colBtn2 =const MaterialStatePropertyAll<Color>(Colors.black26);
    }
    File image=File(pickedFile!.path);
    imageClassification(image);


  }
}
