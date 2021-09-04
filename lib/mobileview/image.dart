import "dart:io";
import "dart:typed_data";
import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:images_picker/images_picker.dart";
// import "package:top_snackbar_flutter/custom_snack_bar.dart";
// import "package:top_snackbar_flutter/top_snack_bar.dart";
import "package:uuid/uuid.dart";
import "/firebase/imageuploader.dart";
import "mobileqr.dart";

class ImageCat extends StatefulWidget {
  const ImageCat({Key? key}) : super(key: key);

  @override
  _ImageCatState createState() => _ImageCatState();
}

class _ImageCatState extends State<ImageCat> {
  Uuid? uuid;
  List<String> path1 = <String>[];
  List<Media>? res;
  List<Uint8List> path2 = <Uint8List>[];
  bool waiting = false;
  bool condition = false;
  GlobalKey<CarouselSliderState> sslKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Stack(children: <Widget>[
              Container(
                color: const Color(0xFF4E4E4E),
                // color: Colors.blue,
                height: MediaQuery.of(context).size.height,
              ),
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  child: Container(
                      color: const Color(0xffEDEEF1),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (path1.isNotEmpty || path2.isNotEmpty)
                            if (path1.isNotEmpty)
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.62,
                                  child: slider(sslKey))
                            else
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.62,
                                  child: slider1(sslKey))
                          else
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.image_outlined,
                                    size:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  const Text("Add Images to generate QR",
                                      style: TextStyle(fontSize: 20))
                                ])
                        ],
                      ))),

              //code for buttons
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.58),
                child: Column(
                  children: <Widget>[
                    if (path1.isNotEmpty || path2.isNotEmpty)
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
                          // style: ButtonStyle(
                          //     backgroundColor: MaterialStateProperty.all(
                          //         const Color(0xffDD4C00)),
                          //     shape: MaterialStateProperty.all<
                          //             RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(50),
                          //             side: const BorderSide()))),
                          // style: ButtonStyle(
                          //     backgroundColor: MaterialStateProperty.all(
                          //         const Color(0xffDD4C00)),
                          //     shape: MaterialStateProperty.all<
                          //             RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(50),
                          //             side: const BorderSide()))),
                          onPressed: () {
                            if (path1.isNotEmpty && waiting == false) {
                              uuid = const Uuid();
                              final String v4 = uuid!.v4();
                              setState(() {
                                waiting = true;
                              });
                              for (int i = 0; i < path1.length; i++) {
                                imageUpload(v4, path1[i]).whenComplete(() {
                                  if (i == 0) {
                                    setState(() {
                                      condition = true;
                                    });
                                    uploadpic(v4);
                                  }
                                });
                              }
                            } else if (path2.isNotEmpty && waiting == false) {
                              setState(() {
                                waiting = true;
                              });
                              uuid = const Uuid();
                              final String v4 = uuid!.v4();
                              for (int i = 0; i < path2.length; i++) {
                                imageUpload1(v4, path2[i]).whenComplete(() {
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
                                // showTopSnackBar(
                                //   context,
                                //   const CustomSnackBar.error(
                                //     message: "wait until file upload",
                                //   ),
                                // );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("wait until file upload")));
                              } else {
                                // showTopSnackBar(
                                //   context,
                                //   const CustomSnackBar.error(
                                //     message: "Please select a image file first.",
                                //   ),
                                // );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please select a image file first.")));
                              }
                            }
                          },
                          child: SizedBox(
                            // height: 50,
                            // width: 50,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                if (waiting == false)
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8, right: 8, left: 8),
                                      decoration: BoxDecoration(
                                          color: const Color(0xffE75527),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        // size: MediaQuery.of(context).size.width *
                                        //     0.045,
                                      ))
                                else
                                  const CircularProgressIndicator(),
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
                      ),
                    if (path1.isNotEmpty || path2.isNotEmpty)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                    if (!kIsWeb)
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
                        onPressed: () async {
                          List<String> img = <String>[];
                          res = await ImagesPicker.openCamera(
                              quality: 0.5, cropOpt: CropOption());
                          if (res != null) {
                            img = res!.map((_) => _.path).toList();
                            setState(() {
                              for (int i = 0; i < img.length; i++) {
                                path1.add(img[i]);
                              }
                            });
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (path1.isNotEmpty || path2.isNotEmpty)
                                Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 8,
                                            left: 8),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE75527),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                          // size: MediaQuery.of(context).size.width *
                                          //     0.045,
                                        )),
                                    const SizedBox(width: 10),
                                    const Center(
                                      child: AutoSizeText(
                                        " Add Images",
                                        minFontSize: 18,
                                        maxFontSize: 26,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              else
                                Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 8,
                                            left: 8),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE75527),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                          // size: MediaQuery.of(context).size.width *
                                          //     0.045,
                                        )),
                                    const SizedBox(width: 10),
                                    const Center(
                                      child: AutoSizeText(
                                        " Use Camera",
                                        minFontSize: 18,
                                        maxFontSize: 26,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    if (!kIsWeb)
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 15),
                              child: Divider(
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              )),
                        ),
                        const Text("OR"),
                        Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 15, right: 10),
                              child: Divider(
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              )),
                        ),
                      ]),
                    Center(
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
                        onPressed: () async {
                          List<String> img1 = <String>[];
                          if (kIsWeb) {
                            multipleimage();
                          } else if (Platform.isAndroid) {
                            res = await ImagesPicker.pick(
                              count: 15,
                              maxSize: 1000000,
                              cropOpt: CropOption(),
                            );
                            if (res != null) {
                              img1 = res!.map((_) => _.path).toList();
                              setState(() {
                                for (int i = 0; i < img1.length; i++) {
                                  path1.add(img1[i]);
                                }
                              });
                            }
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (kIsWeb)
                                Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 8,
                                            left: 8),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE75527),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Icon(
                                          Icons.collections,
                                          color: Colors.white,
                                          // size: MediaQuery.of(context).size.width *
                                          //     0.045,
                                        )),
                                    const AutoSizeText(
                                      " Upload Images",
                                      minFontSize: 16,
                                      maxFontSize: 26,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              else if (path1.isNotEmpty || path2.isNotEmpty)
                                Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 8,
                                            left: 8),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE75527),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Icon(
                                          Icons.collections,
                                          color: Colors.white,
                                          // size: MediaQuery.of(context).size.width *
                                          //     0.045,
                                        )),
                                    const AutoSizeText(
                                      " Add Gallery",
                                      minFontSize: 16,
                                      maxFontSize: 26,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                              else
                                Row(
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            right: 8,
                                            left: 8),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE75527),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Icon(
                                          Icons.collections,
                                          color: Colors.white,
                                          // size: MediaQuery.of(context).size.width *
                                          //     0.045,
                                        )),
                                    const AutoSizeText(
                                      " Import Gallery",
                                      minFontSize: 16,
                                      maxFontSize: 26,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(18),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     children: const <Widget>[
                    //       // Text("Swipe Up",style: TextStyle(color: Colors.grey,fontSize: 15),),
                    //       AnimatedSlideUp()
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ]),
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
          path2.add(img[i]!);
        }
      });
    }
  }

  void uploadpic(String v4) {
    Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
                builder: (_) => MobileQR(
                    url:
                        "https://crud-operation-cdbf0.web.app/images/viewqr?id=$v4")))
        .whenComplete(() {
      setState(() {
        path1.clear();
        path2.clear();
        res!.clear();
        waiting = false;
      });
    });

    // context.vxNav.push(Uri.parse("/mobileqr"),
    //     params: "https://crud-operation-cdbf0.web.app/images/viewqr?id=$v4");
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File upload successfully")));

    // showTopSnackBar(
    //   context,
    //   const CustomSnackBar.success(
    //     message: "File upload successfully",
    //   ),
    // );
  }

  Widget slider(GlobalKey<CarouselSliderState> sslkey) =>
      CarouselSlider.builder(
        options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 1,
          aspectRatio: 1,
        ),
        itemCount: path1.length,
        key: sslkey,
        itemBuilder: (_, __, ___) => SizedBox(
          // height: MediaQuery.of(context).size.height * 0.50,
          width: double.infinity,
          child: Stack(children: <Widget>[
            Center(
              child: GestureDetector(
                child: Image.file(
                  File(path1[__]),
                  // fit: BoxFit.contain,
                  // height: MediaQuery.of(context).size.height * 0.50,
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
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            //   child: IconButton(
            //       onPressed: () {
            //         sslkey.currentState!.pageController!.previousPage(
            //             duration: const Duration(milliseconds: 300),
            //             curve: Curves.linear);
            //       },
            //       icon: const Icon(Icons.keyboard_arrow_left)),
            // ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            //   child: IconButton(
            //       onPressed: () {
            //         sslkey.currentState!.pageController!.nextPage(
            //             duration: const Duration(milliseconds: 300),
            //             curve: Curves.linear);
            //       },
            //       icon: const Icon(Icons.keyboard_arrow_right)),
            // ),
          ]),
        ),
      );
  Widget slider1(GlobalKey<CarouselSliderState> sslkey) =>
      CarouselSlider.builder(
        options: CarouselOptions(
          enableInfiniteScroll: false,
          viewportFraction: 1,
          aspectRatio: 1,
        ),
        itemCount: path2.length,
        key: sslkey,
        itemBuilder: (_, __, ___) => SizedBox(
          // height: MediaQuery.of(context).size.height * 0.50,
          width: double.infinity,
          child: Stack(children: <Widget>[
            Center(
              child: GestureDetector(
                child: Image.memory(
                  path2[__],
                  // fit: BoxFit.contain,
                  // height: MediaQuery.of(context).size.height * 0.50,
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
                      path2.remove(path2[__]);
                    });
                  },
                  icon: const Icon(Icons.close)),
            ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            //   child: IconButton(
            //       onPressed: () {
            //         sslkey.currentState!.pageController!.previousPage(
            //             duration: const Duration(milliseconds: 300),
            //             curve: Curves.linear);
            //       },
            //       icon: const Icon(Icons.keyboard_arrow_left)),
            // ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            //   child: IconButton(
            //       onPressed: () {
            //         sslkey.currentState!.pageController!.nextPage(
            //             duration: const Duration(milliseconds: 300),
            //             curve: Curves.linear);
            //       },
            //       icon: const Icon(Icons.keyboard_arrow_right)),
            // ),
          ]),
        ),
      );
}
