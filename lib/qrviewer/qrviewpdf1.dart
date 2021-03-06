import "dart:io";
import "dart:typed_data";
import "package:barcode_scan2/barcode_scan2.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:images_picker/images_picker.dart";
import "package:path_provider/path_provider.dart";
import "package:scan/scan.dart";
import "package:syncfusion_flutter_pdfviewer/pdfviewer.dart";
import "/home/menu.dart";
import "/home/scanpage.dart";


class ViewQRPDF extends StatefulWidget {
  const ViewQRPDF({required this.url, Key? key}) : super(key: key);
  final String url;

  @override
  _ViewQRPDFState createState() => _ViewQRPDFState();
}

class _ViewQRPDFState extends State<ViewQRPDF> {
  ScanResult? scanResult;
  final TextEditingController _flashOnController =
      TextEditingController(text: "Flash on");
  final TextEditingController _flashOffController =
      TextEditingController(text: "Flash off");
  final TextEditingController _cancelController =
      TextEditingController(text: "Cancel");

  final double _aspectTolerance = 0;
  final int _selectedCamera = -1;
  final bool _useAutoFocus = true;
  final bool _autoEnableFlash = false;
  String? scanr;

  static final List<BarcodeFormat> _possibleFormats = BarcodeFormat.values
      .toList()
        ..removeWhere((_) => _ == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = <BarcodeFormat>[..._possibleFormats];
  @override
  void initState() {
    super.initState();
    _downloadFile(widget.url, "ssc.pdf");
  }

  File? ssc;
  HttpClient httpClient = HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    final HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();
    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File("$dir/$filename");
    await file.writeAsBytes(bytes);
    setState(() {
      ssc = file;
    });
    return file;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "PDF Preview",
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffDDDDDD),
          actions: <Widget>[
            PopupMenuButton<dynamic>(
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
                if (!kIsWeb)
                  PopupMenuItem<dynamic>(
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  backgroundColor: const Color(0xffE5E5E5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
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
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
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
                                  ),
                                ));
                      },
                      title: Row(
                        children: const <Widget>[
                          Icon(Icons.camera),
                          SizedBox(width: 10),
                          Text(
                            "Scan QR",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/createqr");
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
                PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.rateus,
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.star),
                        SizedBox(width: 10),
                        Text("Rate us", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.aboutus,
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.info),
                        SizedBox(width: 10),
                        Text("About us", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.share,
                    title: Row(
                      children: const <Widget>[
                        Icon(Icons.share),
                        SizedBox(width: 10),
                        Text("Share", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Builder(builder: (_) {
          if (ssc != null) {
            return SfPdfViewer.file(ssc!);
          }
          return const Center(child: CircularProgressIndicator());
        }),
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
