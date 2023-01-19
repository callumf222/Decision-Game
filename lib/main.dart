
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:animated_background/animated_background.dart';

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
  await Hive.initFlutter(); //HIVE SETUP
  Hive.registerAdapter(DecisionMapAdapter());
  box = await Hive.openBox<DecisionMap>('decisionMap');



  runApp (  const MaterialApp(
    home: MyFlutterApp(),
  ),
  );
}



class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreen();
  }
}


class HomeScreen extends State<MyFlutterApp> with TickerProviderStateMixin {

  late int ID;
  late int noID;
  late int yesID;
  String description = "Pick a Map!";

  bool buttonPressed = false;

  bool visableProgramID = true;
  bool visableGameID = true;

  bool visableStartID = false;
  bool visableRestartID = false;
  bool visableYesID = false;
  bool visableNoID = false;

  @override
  void initState()  {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
       setState(() {
         DecisionMap? current = box.get(1);
         if(current != null) {
           ID = current.ID;
           yesID = current.yesID;
           noID = current.noID;
           description = "Pick a Map!";
         }
       });
    });
  }

  Future<void> program() async {


    String csv = "artProgrammingLanguage_map.csv"; //path to csv file asset
    String fileData = await rootBundle.loadString(csv);
    List <String> rows = fileData.split("\n");

    for (int i = 0; i < rows.length; i++) {
      //selects an item from row and places
      String row = rows[i];
      List <String> itemInRow = row.split(",");

      DecisionMap decMap = DecisionMap()
        ..ID = int.parse(itemInRow[0])
        ..yesID = int.parse(itemInRow[1])
        ..noID = int.parse(itemInRow[2])
        ..description = itemInRow[3];
      int key = int.parse(itemInRow[0]);
      box.put(key, decMap);
    }

      setState(() {
        DecisionMap? current = box.get(1);
        if(current != null) {
          ID = current.ID;
          yesID = current.yesID;
          noID = current.noID;
          description = current.description;
        }

        visableGameID = false;
        visableProgramID = false;
        visableYesID = true;
        visableNoID = true;
        buttonPressed = true;
      });

  }

  Future<void> game() async {


    String csv = "artGameBuying_map.csv"; //path to csv file asset
    String fileData = await rootBundle.loadString(csv);
    List <String> rows = fileData.split("\n");

    for (int i = 0; i < rows.length; i++) {
      //selects an item from row and places
      String row = rows[i];
      List <String> itemInRow = row.split(",");

      DecisionMap decMap = DecisionMap()
        ..ID = int.parse(itemInRow[0])
        ..yesID = int.parse(itemInRow[1])
        ..noID = int.parse(itemInRow[2])
        ..description = itemInRow[3];
      int key = int.parse(itemInRow[0]);
      box.put(key, decMap);
    }

    setState(() {
      DecisionMap? current = box.get(1);
      if(current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }

      visableGameID = false;
      visableProgramID = false;
      visableYesID = true;
      visableNoID = true;
      buttonPressed = true;
    });

  }

  void noClickHandler() {
    setState(() {
      DecisionMap? current = box.get(noID);
      if(current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }

      if(noID == 100){
        visableRestartID = true;
        visableNoID = false;
        visableYesID = false;
      }
      buttonPressed = true;
    });
  }

  void yesClickHandler() {
    setState(() {
      DecisionMap? current = box.get(yesID);
      if(current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
      }

      if(yesID == 100){
        visableRestartID = true;
        visableNoID = false;
        visableYesID = false;
      }
      buttonPressed = true;
    });
  }

  void startOnClickHandler(){
    setState(() {
      DecisionMap? current = box.get(1);
      if(current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;

        visableStartID = false;
        visableYesID = true;
        visableNoID = true;
      }
      buttonPressed = true;
    });
  }

  void restartOnClickHandler(){
    setState(() {
      DecisionMap? current = box.get(1);
      if(current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = "Pick a Map!";

        visableRestartID = false;
        visableProgramID = true;
        visableGameID = true;
      }
      buttonPressed = true;
      R = 16;
      B = 32;
    });
  }

  int R = 16;
  int B = 32;

  Color getColor(){

    if(R != 2) {
      if (buttonPressed == true) {
        R -= 2;
        B += 2;
        buttonPressed = false;
        return Color.fromRGBO(R, 24, B, 1);
      } else {
        return const Color.fromRGBO(16, 24, 32, 1);
      }
    }else{
      return Color.fromRGBO(R, 24, B, 1);
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        backgroundColor: getColor(),
        body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
        options: const ParticleOptions(
          spawnMaxRadius: 50,
          spawnMinSpeed: 10.00,
          particleCount: 30,
          spawnMaxSpeed: 40,
          minOpacity: 0.3,
          spawnOpacity: 0.4,
          baseColor: Colors.blue,
      ),
    ),
    vsync: this,

      child: Align(
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

              Visibility(
                visible: visableProgramID,
                child: Align(
                  alignment: const Alignment(-0.5, 0.0),
                  child: MaterialButton(
                    onPressed: () {program();},
                    color: const Color(0xfffee715),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textColor: const Color(0xff000000),
                    height: 50,
                    minWidth: 140,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: const Text(
                      "Art of Learning a Programming Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: visableGameID,
                child: Align(
                  alignment: const Alignment(0.5, 0.0),
                  child: MaterialButton(
                    onPressed: () {game();},
                    color: const Color(0xfffee715),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textColor: const Color(0xff000000),
                    height: 50,
                    minWidth: 140,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: const Text(
                      "Art of Buying a Game",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),


              Visibility(
                visible: visableStartID,
                child: Align(
                  alignment: const Alignment(0.0, 0.0),
                  child: MaterialButton(
                    onPressed: () {startOnClickHandler();},
                    color: const Color(0xfffee715),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textColor: const Color(0xff000000),
                    height: 50,
                    minWidth: 140,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: const Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: visableNoID,
                child: Align(
                alignment: const Alignment(0.5, 0.0),
                child: MaterialButton(
                  onPressed: () {noClickHandler();},
                  color: const Color(0xfffee715),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xff000000),
                  height: 50,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: const Text(
                    "No",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                ),
              ),

              Visibility(
                visible: visableYesID,
                child: Align(
                alignment: const Alignment(-0.5, 0.0),
                child: MaterialButton(
                  onPressed: () {yesClickHandler();},
                  color: const Color(0xfffee715 /*eea47f*/),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xff000000),
                  height: 50,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                ),
              ),

              Visibility(
                  visible: visableRestartID,
                    child:Align(
                      alignment: const Alignment(0.0, 0.4),
                      child: MaterialButton(
                      onPressed: () {restartOnClickHandler();},
                      color: const Color(0xfffee715),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      textColor: const Color(0xff000000),
                      height: 50,
                      minWidth: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Text(
                        "Press to restart",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(70),
                child: Align(
                alignment: const Alignment(0.0, -0.7),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 45,
                    color: Color(0xfffee715),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        ),
    );

  }
}