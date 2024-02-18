import '../models/key_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../func_perm_widgets/function_and_var_global.dart';
import '../main.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Key Add',
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xBE95E3A4),
        ),
        scaffoldBackgroundColor: const Color(0xca5c8486),
      ),
      home: Keyadd()));
}

class Keyadd extends StatefulWidget {
  @override
  State<Keyadd> createState() => _KeyaddState();
}

class _KeyaddState extends State<Keyadd> {
  @override
  Widget build(BuildContext context) {
    if (mKey == '') {
      keyController.text = '';
    } else {
      keyController.text = mKey;
    }

    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text('Giphy KEY',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold))),
          actions: [
            mKey != ''
                ? const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: SizedBox(width: 25),
                  )
                : const SizedBox(),
          ]),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    width: 290,
                    child: TextField(
                      controller: keyController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Key de Giphy",
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () async {
                      mykey = [];
                      if (keyController.text == '') {
                        alertKeyVacio(context);
                      } else {
                        mKey = keyController.text;
                        mykey.add(KeySaved(keyController.text));
                        await listToCSV(mykey).then((value) {
                          keyStoredS(context);
                          setState(() {});
                        });
                      }
                    },
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 90),
                  Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      margin: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              """Para poder usar la Aplicacion debes tener una Key de Giphy valido, esta es gratis y personal. Una vez la tengas solo ingresala. Recuerda que esta clave es personal y si sobrepasas los limites de uso, puede generar cargos en tu cuenta ó no generara mas busquedas hasta que se reinicie el mes""",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: TextButton(
                                child: const Text("DEVELOPERS.GIPHY.COM",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent)),
                                onPressed: () async {
                                  urlCall("https://developers.giphy.com");
                                },
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomDevName(),
    );
  }
}