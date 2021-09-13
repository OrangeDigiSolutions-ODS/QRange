import "dart:ui";
import "package:barcode_scan2/barcode_scan2.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:images_picker/images_picker.dart";
import "package:scan/scan.dart";
import "package:sliding_up_panel/sliding_up_panel.dart";
import "/home/menu.dart";
import "/home/scanpage.dart";
import "/mobileview/image.dart";
import "/mobileview/pdf.dart";
import "/mobileview/textcat.dart";
import "/mobileview/ulrcat.dart";
import "/mobileview/vcard.dart";
import "slidepanelanimation.dart";

class MobileCreateQr extends StatefulWidget {
  const MobileCreateQr({Key? key}) : super(key: key);

  @override
  _MobileCreateQrState createState() => _MobileCreateQrState();
}

class _MobileCreateQrState extends State<MobileCreateQr> {
  final Color _selectedIconBgColor = const Color(0xffE75527);
  final Color _unselectedIconBgColor = const Color(0xff353535);
  int _selectedIndex = 0;
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

  static const List<Widget> _widgetOptions = <Widget>[
    ImageCat(),
    PdfCat(),
    UrlCat(),
    TextCat(),
    Vcard()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _getIconBgColor(int index) =>
      _selectedIndex == index ? _selectedIconBgColor : _unselectedIconBgColor;

  Widget _buildIcon(IconData iconData, String text, int index) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: SizedBox(
          child: InkWell(
            onTap: () {
              _onItemTapped(index);
              panelController.close();
            },
            child: Column(
              children: <Widget>[
                Icon(
                  iconData,
                  color: _getIconBgColor(index),
                  size: 33,
                ),
                Text(text,
                    style:
                        TextStyle(fontSize: 20, color: _getIconBgColor(index))),
              ],
            ),
          ),
        ),
      );

  PanelController panelController = PanelController();
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _widgetOptions.elementAt(_selectedIndex),
              SlidingUpPanel(
                renderPanelSheet: false,
                backdropEnabled: true,
                backdropOpacity: 0,
                defaultPanelState: PanelState.OPEN,
                controller: panelController,
                body: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[AnimatedSlideUp()],
                  ),
                ),
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffDDDDDD).withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        height: MediaQuery.of(context).size.height * 0.02,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                  ],
                ),
                minHeight: MediaQuery.of(context).size.height * 0.05,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                color: Colors.transparent,
                panel: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02),
                      color: const Color(0xffDDDDDD).withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildIcon(Icons.image_outlined, "Image", 0),
                              _buildIcon(Icons.picture_as_pdf, "PDF", 1),
                              _buildIcon(Icons.link, "Url", 2),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _buildIcon(Icons.text_fields, "Text", 3),
                              _buildIcon(Icons.file_copy, "Vcard", 4),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          //Appbar
          appBar: AppBar(
            title: const Text(
              "Create QR",
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                    shadowColor: Colors.grey),
                                                onPressed: _scan,
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                    shadowColor: Colors.grey),
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
                                                            const EdgeInsets
                                                                .all(8),
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
                          Text("Rate us",
                              style: TextStyle(color: Colors.white)),
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
                          Text("About us",
                              style: TextStyle(color: Colors.white)),
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
