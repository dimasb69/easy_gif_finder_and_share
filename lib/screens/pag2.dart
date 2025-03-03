import 'dart:io';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import '../func_perm_widgets/function_and_var_global.dart';
import '../main.dart';

class Pag2 extends StatelessWidget {
  const Pag2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Resultados",
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xBE95E3A4),
        ),
        scaffoldBackgroundColor: const Color(0xca5c8486),
      ),
      home: const PageGif(),
    );
  }
}

class PageGif extends StatefulWidget {
  const PageGif({Key? key}) : super(key: key);

  @override
  _PageGifState createState() => _PageGifState();
}

class _PageGifState extends State<PageGif> {
  @override
  void dispose() {
    Navigator.pop(context);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    print(platform);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Resultados',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Return Home',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MaingPage()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: listadoGifs.isNotEmpty ? ListaGif() : Mensaje()
          ),
        ],
      ),
      bottomNavigationBar: bottomDevName(),
    );
  }


  Widget ListaGif (){
    return ListView.builder(
      itemCount: listadoGifs.length,
      itemBuilder: (BuildContext context, int index) {
        var len = 0;
        len = listadoGifs[index].name.toString().length;
        if (len >= 40) {
          len = 40;
        }
        return DelayedDisplay(
          delay: const Duration(milliseconds: 450),
          child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black45, width: 5))),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          listadoGifs[index]
                              .name
                              .toString()
                              .substring(0, len)
                              .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                            onTap: () async {
                              http.Response gif = await http.get(Uri.parse(
                                  listadoGifs[index].url.toString()));
                              permissionReady =
                              await checkPermission(context);
                              if (permissionReady) {
                                var dir =  await findLocalPath();
                                //print("Downloading $dir");
                                var gifTo = '${dir.toString()}gifto.gif';
                                if (gif.body.isNotEmpty) {
                                  final file = File(gifTo);
                                  await file.writeAsBytes(gif.bodyBytes);
                                  try {
                                    List<String> share = [gifTo];
                                    await Share.shareXFiles([XFile(share.first)]);
                                  } catch (e, s) {
                                    print(s);
                                    print("Error al Compartir");
                                  }
                                } else {
                                  print("File not Downloaded");
                                  alertDialog2(context);
                                }
                              }
                            }, // Image tapped
                            child: const Icon(
                              // <-- Icon
                              Icons.share,
                              size: 24.0,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                        onLongPress: () async {
                          http.Response gif = await http.get(
                              Uri.parse(listadoGifs[index].url.toString()));
                          permissionReady = await checkPermission(context);
                          if (permissionReady) {
                            var dir = await findLocalPath();
                            //print("Downloading $dir");
                            var gifTo = '${dir.toString()}gifto.gif';
                            if (gif.body.isNotEmpty) {
                              final file = File(gifTo);
                              await file.writeAsBytes(gif.bodyBytes);
                              try {
                                List<String> share = [gifTo];
                                await Share.shareXFiles([XFile(share.first)]);
                              } catch (e, s) {
                                print(s);
                                print("Error al Compartir");
                              }
                            } else {
                              print("File not Downloaded");
                              alertDialog2(context);
                            }
                          }
                        }, // Image tapped
                        child: Image.network(
                          listadoGifs[index].url.toString(),
                          fit: BoxFit.fill,
                        )),
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget Mensaje () {
    return const SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            textAlign : TextAlign.center,
              "Ningún resultado o KEY se encuentra desactivado o bloqueado.",
            style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold),),
        )
      ),
    );
  }

}
