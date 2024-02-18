import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../main.dart';
import '../models/key_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/gif_data.dart';

var fondo1 = 'assets/images/fondo.gif';
var powered = 'assets/images/640.gif';
var hints = "";
var cants = "";
String mKey = '';
TextEditingController hintController = TextEditingController();
TextEditingController cantController = TextEditingController();
TextEditingController keyController = TextEditingController();
List<Gif> listadoGifs = [];
late String localPath;
late bool permissionReady;
late TargetPlatform? platform;
late String csv;
const csvName = "key.csv";
const miUrl = 'https://momdontgo.dev';

Future<List<Gif>> getGifs(context) async {
  List<Gif> gifs = [];
  if (mKey == '') {
    aletKey(context);
  } else {
    var url = Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=$mKey&q=$hints&limit=$cants&offset=0&rating=g&lang=es");
    final response = await http.get(url);
    final temValidate = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var datos = jsonDecode(response.body);
      var count = 0;
      for (var item in datos["data"]) {
        var n = datos["data"][count]["title"];
        var u = datos["data"][count]["images"]["downsized_medium"]["url"];
        gifs.add(Gif(n, u));
        count++;
      }
    } else {
      print('Boddy:   ${temValidate['meta']['msg']}');
      if (temValidate['meta']['msg'] == 'Unauthorized') {
        aletKey(context);
        mKey = '';
        keyController.text = '';
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MaingPage()));

      }
      throw Exception("Fallo la conexión");
    }
    return gifs;
  }
  return gifs;
}

Future<bool> checkPermission(BuildContext context) async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  var sdk = androidInfo.version.sdkInt;
  //print(sdk);
  late final Map<Permission, PermissionStatus> statusess;

  if (sdk >= 33) {
    statusess =
        await [Permission.manageExternalStorage, Permission.photos].request();
  } else {
    statusess = await [
      Permission.manageExternalStorage,
      Permission.storage,
      Permission.mediaLibrary
    ].request();
  }

  var stat = false;
  statusess.forEach((permission, status) {
    if (status != PermissionStatus.granted) {
      stat = false;
    } else {
      stat = true;
    }
  });
  return stat;
}

var perm10 = 0;

Future<void> checkWritePermission() async {
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      var permissionStatus = await Permission.storage.status;

      //print('permission status: $permissionStatus');

      switch (permissionStatus) {
        case PermissionStatus.denied:
          await Permission.storage.request();
          if (await Permission.storage.status == PermissionStatus.granted) {
            perm10 = 1;
          }
          break;
        case PermissionStatus.permanentlyDenied:
          await Permission.storage.request();
          if (await Permission.storage.status == PermissionStatus.granted) {
            perm10 = 1;
          }
          break;
        default:
      }
    }
  }
}

Future<void> prepareSaveDir() async {
  localPath = (await findLocalPath())!;
  final savedDir = Directory(localPath);
  // print("Thissssss$savedDir");
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
}

Future<String?> findLocalPath() async {
  if (platform == TargetPlatform.android) {
    return "/sdcard/download/";
  } else {
    var directory = await getApplicationDocumentsDirectory();
    return '${directory.path}${Platform.pathSeparator}Download';
  }
}

Future<void> alertDialog(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Limited Access to Files'),
      content: const Text(
          textAlign: TextAlign.center,
          'You must have  permission for all files in order to can share it to others applications!!, On App setting select Permissions -> Files and Media -> Allow management of all files. Then return to the App'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(context, 'Si');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> aletKey(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Giphy Key error'),
      content: const Text(
          textAlign: TextAlign.center,
          'Para poder usar la App necesitas un Api Key Valida,  en Giphy de forma gratuita y personal'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            mykey = [KeySaved('')];
            await listToCSV(mykey)
                .then((value) {
              Navigator.pop(context, 'Si');
              hintController.clear();
              cantController.clear();
                });
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> alertDialog2(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('ERROR on Download'),
      content: const Text(textAlign: TextAlign.center, 'File not Downloaded'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Si');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> alertKeyVacio(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('El key esta vacio'),
      content: const Text(
        textAlign: TextAlign.center,
        'El campo Key no debe estar Vacio \nSi se coloca cualquier frase o palabra que no sea un Key de Giphy la App no funcionara correctamente',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Si');
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> keyStoredS(BuildContext context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Key Saved'),
      content: const Text(
          textAlign: TextAlign.center,
          'La clave se guardo correctamente, si limpias data o desintalas debes colocarla de nuevo!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Si');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MaingPage()));
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> listToCSV(List<KeySaved> lista) async {
  List<List<dynamic>> csvData = [
    <String>['keyS'],
    ...lista.map((item) => [
          item.keyS,
        ])
  ];
  csv = const ListToCsvConverter().convert(csvData);
  //print('valor del CSV leid: $csv');

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/$csvName';
  final File file = File(path);

  var dataSaved = await file.writeAsString(csv);
  print(dataSaved);
}

Future<void> csvRead() async {
  mykey = [];
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/$csvName';
  final input = File(path).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();
  //print('Tamaño:  ${fields.length}');
  final String keyS = fields[1][0].toString();
  mykey.add(KeySaved(keyS));
  timporEspera(250);
}

Future<void> timporEspera(dur) async {
  await Future.delayed(Duration(milliseconds: dur));
}

Widget bottomDevName() {
  return SizedBox(
    height: 20,
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 0,
            child: GestureDetector(
              onTap: () async {
                urlCall(miUrl);
              },
              child: const Text('Developed',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xA6111111),
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 0,
            child: GestureDetector(
              onTap: () async {
                urlCall(miUrl);
              },
              child: const Text(' By {MomDontGo.Dev}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xA6111111),
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> urlCall(String surl) async {
  final Uri url = Uri.parse(surl);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
