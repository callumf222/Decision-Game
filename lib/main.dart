import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'decisionmap.dart';

import 'package:hive/hive.dart';
part 'main.g.dart';

@HiveType(typeId: 0)
class DecisionMap{

  @HiveField(0)
  late int ID;

  @HiveField(1)
  late int yesID;

  @HiveField(2)
  late int noID;

  @HiveField(3)
  late String description;
}

late Box<DecisionMap> box;

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();   //HIVE SETUP
  Hive.registerAdapter(DecisionMapAdapter());
  box = await Hive.openBox<DecisionMap>('decisionMap');


  String csv = "decision_map.csv"; //path to csv file asset
  String fileData = await rootBundle.loadString(csv);
  List <String> rows = fileData.split("\n");

  for (int i = 0; i < rows.length; i++)  {
    //selects an item from row and places
    String row = rows[i];
    List <String> itemInRow = row.split(",");

    DecisionMap decMap = DecisionMap()
      ..ID = int.parse(itemInRow[0])
      ..yesID =  int.parse(itemInRow[1])
      ..noID = int.parse(itemInRow[2])
      ..description = itemInRow[3];
    int key = int.parse(itemInRow[0]);
    box.put(key,decMap);
  }




  runApp (
    const MaterialApp(
      home: MyFlutterApp(),
    ),
  );
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}

class MyFlutterState extends State<MyFlutterApp> {

  late int ID = 1;
  late int noID;
  late int yesID;
  String description = "";

  @override
  void initState()  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
       setState(() {
         DecisionMap? current = box.get(ID);
         if(current != null) {
           ID = current.ID;
           yesID = current.yesID;
           noID = current.noID;
           description = current.description;
         }
      });
    });
  }

  void noclickHandler() {
    setState(() {
      DecisionMap? current = box.get(ID);
      if(current != null) {
        ID = current.noID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }
    });
  }

  void yesclickHandler() {
    setState(() {
      DecisionMap? current = box.get(ID);
      if(current != null) {
        ID = current.yesID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF5DF),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [

              Align(
                alignment: const Alignment(0.5, 0.0),
                child: MaterialButton(
                  onPressed: () {noclickHandler();},
                  color: const Color(0xff5EBEC4),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xff000000),
                  height: 40,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: const Alignment(-0.5, 0.0),
                child: MaterialButton(
                  onPressed: () {yesclickHandler();},
                  color: const Color(0xff5EBEC4),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xff000000),
                  height: 40,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),

              ),

              Align(
                alignment: Alignment(0.0, -0.7),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 34,
                    color: Color(0xff5EBEC4),
                  ),
                ),
              ),

              /*Align(
                alignment: Alignment(0.0, -0.4),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 34,
                    color: Color(0xff5EBEC4),
                  ),
                ),
              )*/

            ],

          ),
        ),
      ),
    );
  }
}




