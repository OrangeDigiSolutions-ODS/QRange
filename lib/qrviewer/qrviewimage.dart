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
  const ViewQRImage({
    required this.uri,
    Key? key,
  }) : super(key: key);
  final String uri;
  @override
  _ViewQRImageState createState() => _ViewQRImageState();
}

class _ViewQRImageState extends State<ViewQRImage> {
  final GlobalKey<CarouselSliderState> sslKey = GlobalKey();
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
  CollectionReference<Object> images =
      FirebaseFirestore.instance.collection("images");
  CollectionReference<Object> id = FirebaseFirestore.instance.collection("id");

  @override
  Widget build(BuildContext context) {
    String? urisplit;
    setState(() {
      urisplit = widget.uri.split("=").last;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Preview",
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
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
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
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
                      Text("Create QR", style: TextStyle(color: Colors.white)),
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

                            ),
                            itemCount: imageurl1.length,
                            key: sslKey,
                            itemBuilder: (_, __, ___) => Card(
                              margin: const EdgeInsets.all(5),
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
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
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
