import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:barcode_scan2/barcode_scan2.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:images_picker/images_picker.dart";
import "package:scan/scan.dart";
import "/desktopview/desktopslider.dart";
import "/home/scanpage.dart";

class SliderPg extends StatefulWidget {
  const SliderPg({Key? key}) : super(key: key);

  @override
  _SliderPgState createState() => _SliderPgState();
}

class _SliderPgState extends State<SliderPg> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: LayoutBuilder(
          builder: (_, __) {
            if (__.maxWidth > 768) {
              return const DesktopSlider();
            } else {
              return const SliderPage();
            }
          },
        ),
      );
}

final List<String> imgList = <String>[
  "assets/images/slider.png",
  "assets/images/slider.png",
];

final ValueNotifier<int> themeMode = ValueNotifier<int>(1);

class SliderPage extends StatefulWidget {
  const SliderPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
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
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.65;
  
    return SafeArea(
      child: Container(
        color: const Color(0xffE5E5E5),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                    height: height,
                    autoPlay: true,
                    viewportFraction: 1,
                    onPageChanged: (_, __) {
                      setState(() {
                        _current = _;
                      });
                    }),
                items: imgList
                    .map((_) => Center(
                            child: Image.asset(
                          _,
                          fit: BoxFit.cover,
                          height: height,
                          width: MediaQuery.of(context).size.width,
                        )))
                    .toList(),
              ),
              Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(top: 32, left: 24),
                  child: Image.asset("assets/images/logo1.png")),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList
                  .asMap()
                  .entries
                  .map((_) => GestureDetector(
                        onTap: () => _controller.animateToPage(_.key),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.01,
                            height: MediaQuery.of(context).size.height * 0.01,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == _.key ? 0.9 : 0.4)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: MediaQuery.of(context).size.height * 0.07),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      if (!kIsWeb)
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                                padding: const EdgeInsets.only(
                                    top: 5, right: 10, left: 2, bottom: 5),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                shadowColor: Colors.grey
                    
                                ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        backgroundColor:
                                            const Color(0xffE5E5E5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    right: 15,
                                                                    left: 10,
                                                                    bottom: 5),
                                                            primary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            shadowColor:
                                                                Colors.grey),
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
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                          " Scan from Camera",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    right: 20,
                                                                    left: 10,
                                                                    bottom: 5),
                                                            primary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            shadowColor:
                                                                Colors.grey
                                                        
                                                            ),
                                                    onPressed: () async {
                                                      final List<Media>? res =
                                                          await ImagesPicker
                                                              .pick();
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
                                                              color:
                                                                  Colors.white,
                                                                                                                           
                                                            )),
                                                        Text(
                                                          " Scan from Gallery",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                            child: Row(
                              children: <Widget>[
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE75527),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                    )),
                                const AutoSizeText(
                                  " Scan QR",
                                  minFontSize: 18,
                                  maxFontSize: 26,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                      if (!kIsWeb) const SizedBox(width: 5),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  top: 5, right: 10, left: 2, bottom: 5),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              shadowColor: Colors.grey
                            
                              ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/createqr");

                    
                          },
                    
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffE75527),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                  )),
                              const AutoSizeText(
                                " Create QR",
                                minFontSize: 18,
                                maxFontSize: 26,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
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
