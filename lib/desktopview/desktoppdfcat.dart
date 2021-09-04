import "dart:typed_data";
import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:dotted_border/dotted_border.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_dropzone/flutter_dropzone.dart";
import "package:syncfusion_flutter_pdfviewer/pdfviewer.dart";
// import "package:top_snackbar_flutter/custom_snack_bar.dart";
// import "package:top_snackbar_flutter/top_snack_bar.dart";
import "package:uuid/uuid.dart";
import "/firebase/pdfuploader.dart";
import "desktopqrview.dart";

class DesktopPDFCat extends StatefulWidget {
  const DesktopPDFCat({Key? key}) : super(key: key);

  @override
  _DesktopPDFCatState createState() => _DesktopPDFCatState();
}

class _DesktopPDFCatState extends State<DesktopPDFCat> {
  Uuid uuid = const Uuid();
  Uint8List? path1;
  bool waiting = false;
  late DropzoneViewController controller;
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
                    "PDF To QR Code",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: const AutoSizeText(
                      "Browse/ Drag and drop into the provided section .A PDF file with max size 10MB",
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
                          if (path1 != null)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: SfPdfViewer.memory(
                                path1!,
                                enableDoubleTapZooming: false,
                              ),
                            )
                          else
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                // color: Colors.blue,
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
                                            Icons.picture_as_pdf,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: 200,
                                              child: AutoSizeText(
                                                "Add PDF to Generate Qr",
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
                                              "Drag PDF here",
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

                    //code for buttons
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "File selected successfully")));
                                    // showTopSnackBar(
                                    //   context,
                                    //   const CustomSnackBar.success(
                                    //     message: "File selected successfully",
                                    //   ),
                                    // );
                                    final List<Uint8List?> res = bytesFromPicker
                                        .files
                                        .map((_) => _.bytes)
                                        .toList();
                                    path1 = res.first!.buffer.asUint8List();
                                  });
                                }
                              } else {
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please select a file less than 10 mb")));
                                  // showTopSnackBar(
                                  //   context,
                                  //   const CustomSnackBar.error(
                                  //     message:
                                  //         "Please select a file less than 10 mb",
                                  //   ),
                                  // );
                                });
                              }
                            }
                          },
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: const Center(
                                child: Text(
                                  "Upload Pdf",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  if (path1 != null)
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
                        if (path1 != null && waiting == false) {
                          final String v4 = uuid.v4();
                          setState(() {
                            waiting = true;
                          });
                          pdfUpload(v4, path1!).then((__) {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                        builder: (_) => DesktopQRView(url: __)))
                                .whenComplete(() {
                              setState(() {
                                waiting = false;
                                path1 = null;
                              });
                            });
                            // context.vxNav
                            //     .push(Uri.parse("/desktopqr"), params: __);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("File upload successfully")));
                            // showTopSnackBar(
                            //   context,
                            //   const CustomSnackBar.success(
                            //     message: "File upload successfully",
                            //   ),
                            // );
                          });
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
                                        "Please select a pdf file first.")));
                            // showTopSnackBar(
                            //   context,
                            //   const CustomSnackBar.error(
                            //     message: "Please select a pdf file first.",
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
  Future<Uint8List?> uploadedFile(_) async {
    final Uint8List path2 = await controller.getFileData(_);
    final int size = await controller.getFileSize(_);
    if (size < 10240000) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("File selected successfully")));
        // showTopSnackBar(
        //   context,
        //   const CustomSnackBar.success(
        //     message: "File selected successfully",
        //   ),
        // );
        path1 = path2;
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please select a file less than 10 mb")));
        // showTopSnackBar(
        //   context,
        //   const CustomSnackBar.error(
        //     message: "Please select a file less than 10 mb",
        //   ),
        // );
      });
    }
    return path1;
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
