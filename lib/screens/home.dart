import '../screens/save_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../func_perm_widgets/function_and_var_global.dart';
import 'pag2.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gif Find and Share",
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xBE95E3A4),
        ),
        scaffoldBackgroundColor: const Color(0xca5c8486),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    checkPermission(context);
    return Scaffold(
      appBar: AppBar(
        title:const Center(child:  Text("Gif Find and Share", style: TextStyle(fontSize: 21, color: Colors.blueGrey, fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Add Key Giphy',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const Keyadd()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(fondo1), fit: BoxFit.cover),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 200,
                child: GestureDetector(
                    onTap: () => urlCall("https://giphy.com"),
                    child: Image.asset(powered, fit: BoxFit.fill),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 320,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white60),
                          color: Colors.black54,
                        ),
                        child: const Center(
                          child: Text("Datos de la busqueda",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, bottom: 10),
                        child: TextField(
                          controller: hintController,
                          decoration: const InputDecoration(
                            hintText: "Frase o nombre para Busqueda",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 10),
                        child: TextField(
                          controller: cantController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Catidad de resultados a mostrar",
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      CupertinoButton(
                        onPressed: () {
                          hints = hintController.text;
                          cants = cantController.text;
                          listadoGifs = [];
                          getGifs(context).then((value) {
                            listadoGifs.addAll(value);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Pag2()),
                            );
                          });
                        },
                        color: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        borderRadius: BorderRadius.circular(25),
                        child: const Text(
                          "Buscar",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomDevName(),
    );
  }
}
