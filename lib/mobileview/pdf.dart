import "dart:io";
import "dart:typed_data";
import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:syncfusion_flutter_pdfviewer/pdfviewer.dart";
import "package:top_snackbar_flutter/custom_snack_bar.dart";
import "package:top_snackbar_flutter/top_snack_bar.dart";
import "package:uuid/uuid.dart";
import "/firebase/pdfuploader.dart";
import "mobileqr.dart";

class PdfCat extends StatefulWidget {
  const PdfCat({Key? key}) : super(key: key);

  @override
  _PdfCatState createState() => _PdfCatState();
}

class _PdfCatState extends State<PdfCat> {
  Uuid uuid = const Uuid();
  Uint8List? path1;
  File? path2;
  bool waiting = false;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Stack(children: <Widget>[
            Container(
              color: const Color(0xFF4E4E4E),
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
                        if (path1 != null || path2 != null)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.62,
                            child: Stack(
                              children: <Widget>[
                                if (path1 != null)
                                  SfPdfViewer.memory(
                                    path1!,
                                    enableDoubleTapZooming: false,
                                  )
                                else
                                  const SizedBox.shrink(),
                                if (path2 != null)
                                  SfPdfViewer.file(
                                    path2!,
                                    enableDoubleTapZooming: false,
                                  )
                                else
                                  const SizedBox.shrink()
                              ],
                            ),
                          )
                        else
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.picture_as_pdf,
                                  size: MediaQuery.of(context).size.width * 0.2,
                                ),
                                const Text(
                                  "Add PDF to generate QR",
                                  style: TextStyle(fontSize: 20),
                                )
                              ])
                      ],
                    ))),

            //code for buttons
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.58),
              child: Column(
                children: <Widget>[
                  if (path1 != null || path2 != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              top: 5, right: 10, left: 10, bottom: 5),
                          primary: const Color(0xffDD4C00),
                          shape: const CircleBorder(),
                          shadowColor: Colors.grey
                          // shape:
                          ),
                      onPressed: () {
                        if (kIsWeb) {
                          if (path1 != null && waiting == false) {
                            final String v4 = uuid.v4();
                            setState(() {
                              waiting = true;
                            });
                            pdfUpload(v4, path1!).then((__) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (_) => MobileQR(url: __)));
                              // context.vxNav
                              //     .push(Uri.parse("/mobileqr"), params: __);
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.success(
                                  message: "File upload successfully",
                                ),
                              );
                            });
                          } else {
                            if (waiting == true) {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message: "wait until file upload",
                                ),
                              );
                            } else {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message: "Please select a pdf file first.",
                                ),
                              );
                            }
                          }
                        } else if (Platform.isAndroid) {
                          if (path2 != null && waiting == false) {
                            final String v4 = uuid.v4();
                            setState(() {
                              waiting = true;
                            });
                            pdfUpload1(v4, path2!).then((__) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (_) => MobileQR(url: __)));
                              // context.vxNav
                              //     .push(Uri.parse("/mobileqr"), params: __);
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.success(
                                  message: "File upload successfully",
                                ),
                              );
                            });
                          } else {
                            if (waiting == true) {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message: "wait until file upload",
                                ),
                              );
                            } else {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message: "Please select a pdf file first.",
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (waiting == false)
                              const Icon(
                                Icons.check,
                                size: 50,
                                color: Colors.white,
                              )
                            else
                              const CircularProgressIndicator()
                          ],
                        ),
                      ),
                    ),
                  if (path1 != null || path2 != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
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
                        if (kIsWeb) {
                          final FilePickerResult? bytesFromPicker =
                              await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: <String>["pdf"]);
                          final PlatformFile file =
                              bytesFromPicker!.files.first;
                          if (file.size < 10240000) {
                            if (bytesFromPicker.isSinglePick) {
                              setState(() {
                                showTopSnackBar(
                                  context,
                                  const CustomSnackBar.success(
                                    message: "File selected successfully",
                                  ),
                                );
                                final List<Uint8List?> res = bytesFromPicker
                                    .files
                                    .map((_) => _.bytes)
                                    .toList();
                                path1 = res.first!.buffer.asUint8List();
                              });
                            }
                          } else {
                            setState(() {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message:
                                      "Please select a file less than 10 mb",
                                ),
                              );
                            });
                          }
                        } else if (Platform.isAndroid) {
                          final FilePickerResult? bytesFromPicker =
                              await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: <String>["pdf"]);
                          final PlatformFile file =
                              bytesFromPicker!.files.first;
                          if (file.size < 10240000) {
                            if (bytesFromPicker.isSinglePick) {
                              setState(() {
                                showTopSnackBar(
                                  context,
                                  const CustomSnackBar.success(
                                    message: "File selected successfully",
                                  ),
                                );
                                final File file1 = File(file.path!);
                                setState(() {
                                  path2 = file1;
                                });
                              });
                            }
                          } else {
                            setState(() {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(
                                  message:
                                      "Please select a file less than 10 mb",
                                ),
                              );
                            });
                          }
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            AutoSizeText(
                              "Upload PDF",
                              minFontSize: 18,
                              maxFontSize: 26,
                              style: TextStyle(
                                color: Colors.black,
                              ),
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
      );
}
