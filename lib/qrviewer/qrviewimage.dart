import "package:barcode_scan2/barcode_scan2.dart";
import "package:carousel_slider/carousel_options.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/services.dart";
import "package:images_picker/images_picker.dart";
import "package:scan/scan.dart";
import "/colors/colorcode.dart";
import "/home/menu.dart";
import "/home/scanpage.dart";

// ignore: must_be_immutable
class ViewQRImage extends StatefulWidget {
  ViewQRImage({
    this.uri,
    Key? key,
  }) : super(key: key);
  String? uri;
  @override
  // ignore: no_logic_in_create_state
  _ViewQRImageState createState() => _ViewQRImageState(uri!);
}

class _ViewQRImageState extends State<ViewQRImage> {
  _ViewQRImageState(this.uri);
  String uri;
  final GlobalKey<CarouselSliderState> sslKey = GlobalKey();
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
  CollectionReference<Object> images =
      FirebaseFirestore.instance.collection("images");
  CollectionReference<Object> id = FirebaseFirestore.instance.collection("id");

  @override
  Widget build(BuildContext context) {
    String? urisplit;
    setState(() {
      urisplit = uri.split("=").last;
    });
    // if (urisplit!.contains(uri) == true) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Preview",
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
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        // width: 150,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                // fixedSize: Size(
                                                //     MediaQuery.of(context).size.width * 0.3, 50),
                                                padding: const EdgeInsets.only(
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
                                            //       MaterialPageRoute<dynamic>(
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
                                                                .circular(50)),
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
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                                                padding: const EdgeInsets.only(
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
                                                    MaterialPageRoute<dynamic>(
                                                        builder: (_) =>
                                                            ScanCopy(
                                                              scantext: scanr!,
                                                            )));
                                              }
                                            },
                                            // icon: Icon(Icons.camera_alt_outlined,),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffE75527),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
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
                                                      fontSize:
                                                          MediaQuery.of(context)
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
                  title: Text("Rate us", style: TextStyle(color: Colors.white)),
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
      body: Container(
        alignment: Alignment.center,
        color: ColorCode.black,
        child: Builder(
          builder: (_) => FutureBuilder<DocumentSnapshot<Object>>(
            future: images.doc(urisplit).get(),
            builder: (_, __) {
              if (__.connectionState == ConnectionState.done &&
                  __.hasData &&
                  __.data != null) {
                final List<int> itemabx = <int>[];
                List<dynamic> imageurl1 = <dynamic>[];
                final int data = int.parse(__.data!["image"].toString());
                // print(data);

                return FutureBuilder<DocumentSnapshot<Object>>(
                    future: images
                        .doc(urisplit)
                        .collection("value")
                        .doc("links")
                        .get(),
                    builder: (_, __) {
                      if (__.connectionState == ConnectionState.done) {
                        final Map<String, dynamic> data1 =
                            // ignore: cast_nullable_to_non_nullable
                            __.data!.data() as Map<String, dynamic>;

                        imageurl1 = data1.values.toList();
                        for (int item = 0; item < data; item++) {
                          itemabx.add(item);
                        }

                        return SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height,
                              viewportFraction: 1,

                              // aspectRatio: 1,
                            ),
                            itemCount: imageurl1.length,
                            key: sslKey,
                            itemBuilder: (_, __, ___) => Card(
                              margin: const EdgeInsets.all(5),
                              // color: ColorCode.orange,
                              child: Stack(children: <Widget>[
                                Center(
                                  child: Image(
                                      image: NetworkImage("${imageurl1[__]}"),
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                                  child: IconButton(
                                      onPressed: () {
                                        sslKey.currentState!.pageController!
                                            .previousPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear);
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_left)),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                  child: IconButton(
                                      onPressed: () {
                                        sslKey.currentState!.pageController!
                                            .nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear);
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_right)),
                                ),
                              ]),
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                // : Image.asset("assets/Artboard.png");
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
    // }
    // return const Text("hello");
    // Center(
    //   child: CircularProgressIndicator(),
    // );
  }

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
