import "dart:io";
import "dart:typed_data";
import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:syncfusion_flutter_pdfviewer/pdfviewer.dart";
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
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.58),
              child: Column(
                children: <Widget>[
                  if (path1 != null || path2 != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(
                                top: 5, right: 2, left: 2, bottom: 5),
                            primary: const Color(0xFFFFFFFF),
                          
                            shadowColor: Colors.grey,
                            shape: const StadiumBorder()
                      
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
                                            builder: (_) => MobileQR(url: __)))
                                    .whenComplete(() {
                                  setState(() {
                                    path1 = null;
                                    waiting = false;
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("File upload successfully")));
                             
                              });
                            } else {
                              if (waiting == true) {
                             
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("wait until file upload")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please select a pdf file first.")));
                                
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
                                            builder: (_) => MobileQR(url: __)))
                                    .whenComplete(() {
                                  setState(() {
                                    path2 = null;
                                    waiting = false;
                                  });
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("File upload successfully")));
                              
                              });
                            } else {
                              if (waiting == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("wait until file upload")));
                               
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please select a pdf file first.")));
                               
                              }
                            }
                          }
                        },
                        child: SizedBox(
                          child: Row(
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
                                    ))
                              else
                                const CircularProgressIndicator(),
                              const AutoSizeText(
                                "  Generated QR",
                                minFontSize: 18,
                                maxFontSize: 26,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "File selected successfully")));
                               
                                final File file1 = File(file.path!);
                                setState(() {
                                  path2 = file1;
                                });
                              });
                            }
                          } else {
                            setState(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please select a file less than 10 mb")));
                             
                            });
                          }
                        }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, right: 8, left: 8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffE75527),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Icons.file_upload,
                                    color: Colors.white,
                                  )),
                              const SizedBox(width: 10),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if (path1 != null || path2 != null)
                                      const Text(
                                        "Change PDF",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      )
                                    else
                                      const Text(
                                        "Upload PDF",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
}
