import "dart:typed_data";
import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:dotted_border/dotted_border.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_dropzone/flutter_dropzone.dart";
// import "package:top_snackbar_flutter/custom_snack_bar.dart";
// import "package:top_snackbar_flutter/top_snack_bar.dart";
import "package:uuid/uuid.dart";
import "/firebase/imageuploader.dart";
import "desktopqrview.dart";

class DesktopImageCat extends StatefulWidget {
  const DesktopImageCat({Key? key}) : super(key: key);

  @override
  _DesktopImageCatState createState() => _DesktopImageCatState();
}

class _DesktopImageCatState extends State<DesktopImageCat> {
  Uuid uuid = const Uuid();
  List<Uint8List> path1 = <Uint8List>[];
  bool waiting = false;
  bool condition = false;
  late DropzoneViewController controller;
  GlobalKey<CarouselSliderState> sslKey = GlobalKey();
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Container(
            color: const Color(0xFF4E4E4E),
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  const Text(
                    "Image To QR Code",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: const AutoSizeText(
                      "Browse single or multiple images from system /Drag and drop images into provided section",
                      style: TextStyle(
                        fontFamily: "Raleway",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w100,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Stack(children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          if (path1.isNotEmpty)
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: slider(sslKey))
                          else
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: buildDecoration(
                                    child: Stack(
                                  children: <Widget>[
                                    DropzoneView(
                                      // ignore: always_specify_types
                                      onCreated: (controller) =>
                                          this.controller = controller,
                                      onDrop: uploadedFile,
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const <Widget>[
                                          Icon(
                                            Icons.image_outlined,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: 200,
                                              child: AutoSizeText(
                                                "Add Images to Generate Qr",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Center(
                                            child: Text(
                                              "Drag Images here",
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ))),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.36),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  top: 1, right: 1, left: 1, bottom: 1),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              shadowColor: Colors.grey
                              // shape:
                              ),
                          onPressed: multipleimage,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if (path1.isNotEmpty)
                                      const Text(
                                        "Add Images",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      )
                                    else
                                      const Text(
                                        "Upload Images",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  if (path1.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              top: 1, right: 1, left: 1, bottom: 1),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          shadowColor: Colors.grey
                          // shape:
                          ),
                      onPressed: () {
                        if (path1.isNotEmpty && waiting == false) {
                          final String v4 = uuid.v4();
                          setState(() {
                            waiting = true;
                          });
                          for (int i = 0; i < path1.length; i++) {
                            imageUpload1(v4, path1[i]).whenComplete(() {
                              if (i == 0) {
                                setState(() {
                                  condition = true;
                                });
                                uploadpic(v4);
                              }
                            });
                          }
                        } else {
                          if (waiting == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("wait until file upload")));
                            // showTopSnackBar(
                            //   context,
                            //   const CustomSnackBar.error(
                            //     message: "wait until file upload",
                            //   ),
                            // );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please select a image file first.")));
                            // showTopSnackBar(
                            //   context,
                            //   const CustomSnackBar.error(
                            //     message: "Please select a image file first.",
                            //   ),
                            // );
                          }
                        }
                      },
                      child: SizedBox(
                        width: 200,
                        // height: 50,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 8, right: 8, left: 8),
                                decoration: BoxDecoration(
                                    color: const Color(0xffE75527),
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  // size: MediaQuery.of(context).size.width *
                                  //     0.045,
                                )),
                            const AutoSizeText(
                              "  Generated QR",
                              minFontSize: 18,
                              maxFontSize: 26,
                              style: TextStyle(color: Colors.black87),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
  FilePickerResult? bytesFromPicker;
  List<Uint8List?> img = <Uint8List?>[];
  Future<void> multipleimage() async {
    bytesFromPicker = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);

    if (bytesFromPicker != null) {
      img =
          bytesFromPicker!.files.map((_) => _.bytes).cast<Uint8List>().toList();
      setState(() {
        for (int i = 0; i < img.length; i++) {
          path1.add(img[i]!);
        }
      });
    }
  }

  void uploadpic(String v4) {
    Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
                builder: (_) => DesktopQRView(
                    url:
                        "https://crud-operation-cdbf0.web.app/images/viewqr?id=$v4")))
        .whenComplete(() {
      setState(() {
        waiting = false;
        path1 = <Uint8List>[];
      });
    });
    // context.vxNav.push(Uri.parse("/desktopqr"),
    //     params: "https://crud-operation-cdbf0.web.app/images/viewqr?id=$v4");
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File upload successfully")));
    // showTopSnackBar(
    //   context,
    //   const CustomSnackBar.success(
    //     message: "File upload successfully",
    //   ),
    // );
    setState(() {
      condition = false;
    });
  }

  Widget slider(GlobalKey<CarouselSliderState> sslkey) =>
      CarouselSlider.builder(
        options: CarouselOptions(
          enableInfiniteScroll: false,
          // viewportFraction: 0.9,
          aspectRatio: 3,
          enlargeCenterPage: true,
        ),
        itemCount: path1.length,
        key: sslkey,
        itemBuilder: (_, __, ___) => Card(
          child: SizedBox(
            width: double.infinity,
            child: Stack(children: <Widget>[
              Center(
                child: GestureDetector(
                  child: Image.memory(
                    path1[__],
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: IconButton(
                    onPressed: () {
                      debugPrint("${path1.length}");
                      setState(() {
                        path1.remove(path1[__]);
                      });
                    },
                    icon: const Icon(Icons.close)),
              ),
            ]),
          ),
        ),
      );
  Future<Uint8List?> uploadedFile(_) async {
    final Uint8List path2 = await controller.getFileData(_);
    setState(() {
      path1.add(path2);
    });
    return path2;
  }

  Widget buildDecoration({required Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xffEDEEF1),
          child: DottedBorder(
              borderType: BorderType.RRect,
              strokeWidth: 3,
              dashPattern: const <double>[8, 4],
              radius: const Radius.circular(10),
              padding: EdgeInsets.zero,
              child: child),
        ),
      );
}
