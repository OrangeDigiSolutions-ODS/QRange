import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "dart:ui" as ui;
import "package:universal_html/html.dart" as html;
import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:path_provider/path_provider.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:screenshot/screenshot.dart";
import "package:share_plus/share_plus.dart";
import "/home/menu.dart";

class DesktopQRView extends StatefulWidget {
  const DesktopQRView({required this.url, Key? key}) : super(key: key);
  final String url;

  @override
  _DesktopQRViewState createState() => _DesktopQRViewState();
}

class _DesktopQRViewState extends State<DesktopQRView> {
  final DateTime dateToday = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().hour,
      DateTime.now().minute,
      DateTime.now().second);

  double matrix4 = ui.window.devicePixelRatio;

  final GlobalKey _globalKey = GlobalKey();
  Future<dynamic> saveImage(Uint8List bytes) async {
    Directory? directory = await getExternalStorageDirectory();
    String newPath = "";
    final List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      final String folder = paths[x];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }
    newPath = "$newPath/QRange";
    directory = Directory(newPath);
    // ignore: avoid_slow_async_io
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    // ignore: avoid_slow_async_io
    if (await directory.exists()) {
      final File file = File("${directory.path}${"/QRange $dateToday.png"}");
      debugPrint("$dateToday");
      file.writeAsBytesSync(bytes);
      return file;
    }
  }

  Future<dynamic> saveAndShare(Uint8List bytes) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File image = File("${directory.path}/flutter.png");
    final String text = widget.url;
    image.writeAsBytesSync(bytes);
    await Share.shareFiles(<String>[image.path], text: text);
  }

  final ScreenshotController controller = ScreenshotController();
  Uint8List? pngBytes;

  Widget buildQR() => Container(
        color: Colors.white,
        child: Center(
          child: QrImage(
            data: widget.url,
          ),
        ),
      );
  Widget buildQR1() => Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.6,
                height: MediaQuery.of(context).size.height * 0.6,
                child: QrImage(
                  data: widget.url,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Image(
                          image: AssetImage(
                            "assets/images/logo2.png",
                          ),
                          fit: BoxFit.fill,
                          width: 50,
                          height: 50,
                        ),
                        Text("Powered by OrangeDigiSolutions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.14,
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo1.png",
                    width: 40,
                    height: 40,
                  ),
                  const Text(
                    " QRange",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xffDDDDDD),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.15),
                child: PopupMenuButton<dynamic>(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  iconSize: 30,
                  color: const Color(0xff555555),
                  itemBuilder: (_) => <PopupMenuEntry<dynamic>>[
                    PopupMenuItem<dynamic>(
                  
                        child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/slider", (_) => false);
                      },
                      title: Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/logo1.png",
                            height: 30,
                            width: 30,
                          ),
                          const Text(
                            "  QRange",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )),
                    PopupMenuItem<dynamic>(
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/createqr", (_) => false);
                        },
                        title: Row(
                          children: const <Widget>[
                            Icon(Icons.qr_code),
                            SizedBox(width: 10),
                            Text("Create QR",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const PopupMenuDivider(
                      height: 20,
                    ),
                    PopupMenuItem<dynamic>(
                      child: ListTile(
                        onTap: Menu.privacyPolicy,
                        title: Row(
                          children: const <Widget>[
                            Icon(Icons.security),
                            SizedBox(width: 10),
                            Text("Privacy Policy",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SizedBox(
            child: Stack(
              children: <Widget>[
                Center(
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 5,
                          ),
                        ),
                        width: MediaQuery.of(context).size.height * 0.7,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: RepaintBoundary(
                            key: _globalKey, child: buildQR1()))),
                Container(
                  color: const Color(0xFF4E4E4E),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          "QR Generated",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: const AutoSizeText(
                            "Thank you for using QRange.The QR Code has been Generated.Please download to print and share.",
                            style: TextStyle(
                              fontFamily: "Raleway",
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w100,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Stack(children: <Widget>[
                          Center(
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 5,
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: buildQR())),

                        ]),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Image(
                                    image: AssetImage(
                                      "assets/images/logo2.png",
                                    ),
                                    fit: BoxFit.fill,
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text("Powered by Orange DigiSolutions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: const BorderSide()))),
                          onPressed: () async {
                            try {
                              final RenderRepaintBoundary boundary =
                                  _globalKey.currentContext!.findRenderObject()!
                                      as RenderRepaintBoundary;
                              final ui.Image image1 = await boundary.toImage(
                                  pixelRatio: ui.window.devicePixelRatio);
                              final ByteData? byteData = await image1
                                  .toByteData(format: ui.ImageByteFormat.png);
                              pngBytes = byteData!.buffer.asUint8List();
                              debugPrint(widget.url);

                              // ignore: avoid_catches_without_on_clauses
                            } catch (e) {
                              debugPrint("hello");
                            }
                            if (kIsWeb) {
                              html.Blob(<dynamic>[base64Encode(pngBytes!)],
                                  "image/png");
                              html.AnchorElement()
                                // ignore: unsafe_html
                                ..href =
                                    "${Uri.dataFromBytes(pngBytes!, mimeType: "image/png")}"
                                ..download = "QRange $dateToday.png"
                                ..click();
                            } else if (Platform.isAndroid) {
                              final Uint8List image = await controller
                                  .captureFromWidget(buildQR1());
                              await saveImage(image);
                            }
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Download complete")));
                            });
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 8,
                                            right: 8,
                                            left: 8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xffE75527),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.file_download,
                                          color: Colors.white,
                                        )),
                                    const Text(
                                      "  Download",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
