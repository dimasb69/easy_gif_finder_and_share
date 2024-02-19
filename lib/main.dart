import '../models/key_model.dart';
import '../screens/save_key.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'func_perm_widgets/function_and_var_global.dart';

List<KeySaved> mykey = [];

void main() => runApp(const Main());

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  
  @override


  @override
  void dispose() {
    listToCSV(mykey).then((value) {
      print (csv);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Easy Gif Finder",
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xBE95E3A4),
        ),
        scaffoldBackgroundColor: const Color(0xca5c8486),
      ),


      home: const MaingPage(),
    );
  }
}

class MaingPage extends StatefulWidget {
  const MaingPage({Key? key}) : super(key: key);

  @override
  _MaingPageState createState() => _MaingPageState();
}

class _MaingPageState extends State<MaingPage> {
  @override
  Widget build(BuildContext context) {
    csvRead().then((value) => {
      mKey = mykey[0].keyS.toString(),
    }).then((value) =>  setState(() {}));
    checkPermission(context);
    if (mKey == ''){
      return const Keyadd();
    }else{
      return const Home();
    }
  }
}
