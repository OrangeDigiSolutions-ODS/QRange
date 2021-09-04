import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "dart:ui" as ui;
import "package:barcode_scan2/barcode_scan2.dart";
import "package:flutter/services.dart";
import "package:images_picker/images_picker.dart";
import "package:scan/scan.dart";
// import "package:top_snackbar_flutter/custom_snack_bar.dart";
// import "package:top_snackbar_flutter/top_snack_bar.dart";
import "package:universal_html/html.dart" as html;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:path_provider/path_provider.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:screenshot/screenshot.dart";
import "package:share_plus/share_plus.dart";
import "/colors/colorcode.dart";
import "/home/menu.dart";
import "/home/scanpage.dart";

// ignore: must_be_immutable
class MobileQR extends StatefulWidget {
  MobileQR({required this.url, Key? key}) : super(key: key);
  String url;
  @override
  _MobileQRState createState() => _MobileQRState();
}

class _MobileQRState extends State<MobileQR> {
  ScanResult? scanResult;
  final TextEditingController _flashOnController =
      TextEditingController(text: "Flash on");
  final TextEditingController _flashOffController =
      TextEditingController(text: "Flash off");
  final TextEditingController _cancelController =
      TextEditingController(text: "Cancel");

  final double _aspectTolerance = 0;
  // int _numberOfCameras = 0;
  final int _selectedCamera = -1;
  final bool _useAutoFocus = true;
  final bool _autoEnableFlash = false;
  String? scanr;

  static final List<BarcodeFormat> _possibleFormats = BarcodeFormat.values
      .toList()
        ..removeWhere((_) => _ == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = <BarcodeFormat>[..._possibleFormats];
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
    // print(directory);
    final List<String> paths = directory!.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      final String folder = paths[x];
      if (folder != "Android") {
        newPath += "/$folder";
      } else {
        break;
      }
    }
    newPath = "$newPath/Download";
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${directory.path}${"/QRange $dateToday.png"}")));
      return file;
    }
  }

  Future<dynamic> saveAndShare(Uint8List bytes) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File image = File("${directory.path}/flutter.png");
    const String text =
        "Create QR Code in just 4 easy steps.Download QRange App: https://bit.ly/3BxNG0b or visit website:  https://www.qrange.in/";
    image.writeAsBytesSync(bytes);
    await Share.shareFiles(<String>[image.path], text: text);
  }

  final ScreenshotController controller = ScreenshotController();
  Uint8List? pngBytes;

  Widget buildQR() => Container(
        color: ColorCode.white,
        child: Center(
          child: QrImage(
            data: widget.url,
          ),
        ),
      );
  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "QR Generated",
            style: TextStyle(color: Colors.black),
          ),
          // backwardsCompatibility: false,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffDDDDDD),
          actions: <Widget>[
            PopupMenuButton<dynamic>(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              iconSize: 30,
              // offset: const Offset(0, 60),
              color: const Color(0xff555555),
              itemBuilder: (_) => <PopupMenuEntry<dynamic>>[
                PopupMenuItem<dynamic>(
                    enabled: false,
                    child: Row(
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
                    )),
                if (!kIsWeb)
                  PopupMenuItem<dynamic>(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  // insetPadding: EdgeInsets.all(80),
                                  backgroundColor: const Color(0xffE5E5E5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  content: SizedBox(
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          // width: 150,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  // fixedSize: Size(
                                                  //     MediaQuery.of(context).size.width * 0.3, 50),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          right: 15,
                                                          left: 10,
                                                          bottom: 5),
                                                  primary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  shadowColor: Colors.grey),
                                              onPressed: _scan,
                                              // if (scanResult != null) {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute<
                                              //               dynamic>(
                                              //           builder: (_) =>
                                              //               ScanCopy(
                                              //                 scantext:
                                              //                     scanResult!
                                              //                         .rawContent,
                                              //               )));
                                              // }
                                              // },
                                              // icon: Icon(Icons.camera_alt_outlined,),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8,
                                                              right: 8,
                                                              bottom: 8,
                                                              left: 8),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xffE75527),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                      )),
                                                  Text(
                                                    " Scan from Camera",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          // width: 150,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  // fixedSize: Size(
                                                  //     MediaQuery.of(context).size.width * 0.45, 50),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5,
                                                          right: 20,
                                                          left: 10,
                                                          bottom: 5),
                                                  primary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  shadowColor: Colors.grey
                                                  // shape:
                                                  ),
                                              onPressed: () async {
                                                final List<Media>? res =
                                                    await ImagesPicker.pick();
                                                if (res != null) {
                                                  final String? str =
                                                      await Scan.parse(
                                                          res[0].path);
                                                  if (str != null) {
                                                    setState(() {
                                                      scanr = str;
                                                    });
                                                  }
                                                }
                                                if (scanr != null) {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute<
                                                              dynamic>(
                                                          builder: (_) =>
                                                              ScanCopy(
                                                                scantext:
                                                                    scanr!,
                                                              )));
                                                }
                                              },
                                              // icon: Icon(Icons.camera_alt_outlined,),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xffE75527),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                      child: const Icon(
                                                        Icons.collections,
                                                        color: Colors.white,
                                                        // size: MediaQuery.of(context).size.width *
                                                        //     0.045,
                                                      )),
                                                  Text(
                                                    " Scan from Gallery",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                    // color: Colors.accents,
                                  ),
                                ));

                        // // Navigator.pop(context);
                        // // Navigator.pushNamedAndRemoveUntil(
                        // //     context, "/scan", (_) => false);
                        // context.vxNav.push(Uri.parse("/scan"));
                      },
                      // leading: Icon(Icons.add, color: Colors.white),
                      title: const Text(
                        "Scan QR",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                // const PopupMenuDivider(
                //   height: 20,
                // ),
                PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/createqr");
                      // context.vxNav.push(Uri.parse("/createqr"));
                    },
                    // leading: Icon(Icons.anchor, color: Colors.white),
                    title: const Text("Create QR",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                // const PopupMenuDivider(
                //   height: 20,
                // ),
                const PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.privacyPolicy,
                    // leading: Icon(Icons.anchor, color: Colors.white),
                    title: Text("Privacy Policy",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                // const PopupMenuDivider(
                //   height: 20,
                // ),
                const PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.rateus,
                    // leading: Icon(Icons.anchor, color: Colors.white),
                    title:
                        Text("Rate us", style: TextStyle(color: Colors.white)),
                  ),
                ),
                // const PopupMenuDivider(
                //   height: 20,
                // ),
                const PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.aboutus,
                    // leading: Icon(Icons.anchor, color: Colors.white),
                    title:
                        Text("About us", style: TextStyle(color: Colors.white)),
                  ),
                ),
                // const PopupMenuDivider(
                //   height: 20,
                // ),
                const PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.share,
                    // leading: Icon(Icons.anchor, color: Colors.white),
                    title: Text("Share", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.20),
              color: const Color(0xFFB5B5B5),
              height: MediaQuery.of(context).size.height,
              child: Column(children: <Widget>[
                Center(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                            color: const Color(0xffEDEEF1),
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: MediaQuery.of(context).size.width * 0.80,
                            child: RepaintBoundary(
                                key: _globalKey, child: buildQR())),
                      ),
                      // Container(
                      //   alignment: Alignment.bottomRight,
                      //   padding: const EdgeInsets.only(right: 15),
                      //   height: MediaQuery.of(context).size.width * 0.87,
                      //   child: ElevatedButton(
                      //     style: ButtonStyle(
                      //         backgroundColor: MaterialStateProperty.all(
                      //             const Color(0xffDD4C00)),
                      //         shape: MaterialStateProperty.all<
                      //                 RoundedRectangleBorder>(
                      //             RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(50),
                      //                 side: const BorderSide()))),
                      //     onPressed: () {},
                      //     child: SizedBox(
                      //       width: 40,
                      //       height: 50,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: const <Widget>[
                      //           Icon(
                      //             Icons.edit,
                      //             color: Colors.white,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //code for buttons
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              top: 2, right: 2, left: 5, bottom: 2),
                          primary: const Color(0xFFFFFFFF),
                          // shape: const CircleBorder(),
                          shadowColor: Colors.grey,
                          shape: const StadiumBorder()
                          // shape:
                          ),
                      onPressed: () async {
                        try {
                          final RenderRepaintBoundary boundary =
                              _globalKey.currentContext!.findRenderObject()!
                                  as RenderRepaintBoundary;
                          final ui.Image image1 = await boundary.toImage(
                              pixelRatio: ui.window.devicePixelRatio);
                          final ByteData? byteData = await image1.toByteData(
                              format: ui.ImageByteFormat.png);
                          pngBytes = byteData!.buffer.asUint8List();
                          debugPrint(widget.url);
                          // ignore: avoid_catches_without_on_clauses
                        } catch (e) {
                          debugPrint("hello");
                        }
                        if (kIsWeb) {
                          html.Blob(
                              <dynamic>[base64Encode(pngBytes!)], "image/png");
                          html.AnchorElement()
                            // ignore: unsafe_html
                            ..href =
                                "${Uri.dataFromBytes(pngBytes!, mimeType: "image/png")}"
                            ..download = "$dateToday.png"
                            ..click();
                        } else if (Platform.isAndroid) {
                          final Uint8List image =
                              await controller.captureFromWidget(buildQR());

                          await saveImage(image);
                        }
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Download complete")));
                          // showTopSnackBar(
                          //   context,
                          //   const CustomSnackBar.success(
                          //     message: "Download complete",
                          //   ),
                          // );
                        });
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Center(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.cen,
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 8, right: 8, left: 8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffE75527),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.file_download,
                                      color: Colors.white,
                                      // size: MediaQuery.of(context).size.width *
                                      //     0.045,
                                    )),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                const Text(
                                  "  Download",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (kIsWeb)
                  const SizedBox.shrink()
                else
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              top: 5, right: 2, left: 5, bottom: 5),
                          primary: const Color(0xFFFFFFFF),
                          // shape: const CircleBorder(),
                          shadowColor: Colors.grey,
                          shape: const StadiumBorder()
                          // shape:
                          ),
                      onPressed: () async {
                        final Uint8List image =
                            await controller.captureFromWidget(buildQR());
                        saveAndShare(image);
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 8, right: 8, left: 4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffE75527),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      // size: MediaQuery.of(context).size.width *
                                      //     0.045,
                                    )),
                                const Text(
                                  "  Share",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      );
  Future<void> _scan() async {
    try {
      final ScanResult result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: <String, String>{
            "cancel": _cancelController.text,
            "flash_on": _flashOnController.text,
            "flash_off": _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
      _scanResult(scanResult!.rawContent);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? "The user did not grant the camera permission!"
              : "Unknown error: $e",
        );
      });
    }
  }

  void _scanResult(String scanResult) {
    if (scanResult != "") {
      Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => ScanCopy(
                    scantext: scanResult,
                  )));
    }
  }
}
