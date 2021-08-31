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
  // int _numberOfCameras = 0;
  final int _selectedCamera = -1;
  final bool _useAutoFocus = true;
  final bool _autoEnableFlash = false;
  String? scanr;

  static final List<BarcodeFormat> _possibleFormats = BarcodeFormat.values
      .toList()
        ..removeWhere((_) => _ == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = <BarcodeFormat>[..._possibleFormats];

  static const List<Widget> _widgetOptions = <Widget>[ImageCat(), PdfCat()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _getIconBgColor(int index) =>
      _selectedIndex == index ? _selectedIconBgColor : _unselectedIconBgColor;

  Widget _buildIcon(IconData iconData, String text, int index) => SizedBox(
        // width: MediaQuery.of(context).size.width * 0.01,
        height: MediaQuery.of(context).size.height * 0.1,
        child: SizedBox(
          child: InkWell(
            onTap: () => _onItemTapped(index),
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

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          //body
          body: Stack(
            children: <Widget>[
              _widgetOptions.elementAt(_selectedIndex),
              SlidingUpPanel(
                renderPanelSheet: false,
                backdropEnabled: true,
                backdropOpacity: 0,
                defaultPanelState: PanelState.OPEN,
                // backdropTapClosesPanel: false,
                body: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const <Widget>[
                      // Text(
                      //   "Swipe Up",
                      //   style: TextStyle(color: Colors.grey, fontSize: 15),
                      // ),
                      AnimatedSlideUp()
                    ],
                  ),
                ),
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: MediaQuery.of(context).size.width * 0.35,
                      // color: const Color(0xffDDDDDD).withOpacity(0.7),
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
                        // color: const Color(0xffDDDDDD).withOpacity(0.7),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      width: MediaQuery.of(context).size.width * 0.35,
                      // color: const Color(0xffDDDDDD).withOpacity(0.7),
                    ),
                  ],
                ),
                minHeight: MediaQuery.of(context).size.height * 0.05,
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                // color: const Color(0xffDDDDDD).withOpacity(0.7),
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
                              // Text("ac"), Text("ff")
                              _buildIcon(Icons.image_outlined, "Image", 0),
                              _buildIcon(Icons.picture_as_pdf, "PDF", 1)
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
                      child: Image.asset(
                    "assets/images/logo1.png",
                    height: 30,
                    width: 30,
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: SizedBox(
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                    shadowColor: Colors.grey),
                                                onPressed: () {
                                                  _scan();
                                                  if (scanResult != null) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute<
                                                                dynamic>(
                                                            builder: (_) =>
                                                                ScanCopy(
                                                                  scantext:
                                                                      scanResult!
                                                                          .rawContent,
                                                                )));
                                                  }
                                                },
                                                // icon: Icon(Icons.camera_alt_outlined,),
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                          Icons.camera_alt,
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
                      title: Text("Rate us",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  // const PopupMenuDivider(
                  //   height: 20,
                  // ),
                  const PopupMenuItem<dynamic>(
                    child: ListTile(
                      onTap: Menu.aboutus,
                      // leading: Icon(Icons.anchor, color: Colors.white),
                      title: Text("About us",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  // const PopupMenuDivider(
                  //   height: 20,
                  // ),
                  const PopupMenuItem<dynamic>(
                    child: ListTile(
                      onTap: Menu.share,
                      // leading: Icon(Icons.anchor, color: Colors.white),
                      title:
                          Text("Share", style: TextStyle(color: Colors.white)),
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
    if (!scanResult.contains("")) {
      Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => ScanCopy(
                    scantext: scanResult,
                  )));
    }
  }
}
