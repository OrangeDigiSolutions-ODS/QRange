import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:barcode_scan2/barcode_scan2.dart";
import "package:contacts_service/contacts_service.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:images_picker/images_picker.dart";
import "package:permission_handler/permission_handler.dart";
import "package:scan/scan.dart";
import "package:url_launcher/url_launcher.dart";
import "/qrviewer/qrviewimage.dart";
import "/qrviewer/qrviewpdf1.dart";
import "menu.dart";

class ScanCopy extends StatefulWidget {
  const ScanCopy({required this.scantext, Key? key}) : super(key: key);
  final String scantext;

  @override
  _ScanCopyState createState() => _ScanCopyState();
}

class _ScanCopyState extends State<ScanCopy> {
  Color textcolor = Colors.black;
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
  void initState() {
    super.initState();
    scanText(widget.scantext);
    if (widget.scantext.contains("http")) {
      textcolor = Colors.blue;
    } else {
      textcolor = Colors.black;
    }
  }

  String scanText(String scan) {
    if (widget.scantext.contains("BEGIN:VCARD")) {
      return widget.scantext;
      // const String contactName = "Name: contactName\n";
      // const String contactEmail = "Email: contactEmail\n";
      // const String contactWebsite = "Website: contactWebsite\n";
      // const String contactPhone = "Phone: contactPhone\n";
      // const String contactPhoneWork = "Phone(work): contactPhoneWork\n";
      // const String contactAddress = "Address: contactAddress\n";
      // const String contactOrganization = "Organization: contactOrganization\n";
      // const String contactDesignation = "Designation: contactDesignation";
      // return contactName +
      //     contactEmail +
      //     contactWebsite +
      //     contactPhone +
      //     contactPhoneWork +
      //     contactAddress +
      //     contactOrganization +
      //     contactDesignation;
    } else {
      return widget.scantext;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "QR Result",
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
                                    height: MediaQuery.of(context).size.height *
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
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                          const EdgeInsets.all(
                                                              8),
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
        endDrawer: const Drawer(),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Image.asset(
                "assets/images/scanpage.png",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SimpleDialog(
              backgroundColor: const Color(0xffE5E5E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              children: <Widget>[
                SimpleDialogOption(
                    onPressed: () {},
                    child: const Center(
                        child: Icon(
                      Icons.link,
                      size: 50,
                    ))),
                SimpleDialogOption(
                  onPressed: () {},
                  child: SizedBox(
                    width: 250,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: _clickchange,
                            child: AutoSizeText(
                              scanText(widget.scantext),
                              style: TextStyle(color: textcolor),
                            )),
                        if (widget.scantext.contains("BEGIN:VCARD"))
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                saveContactInPhone();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Contact Save")));
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.grey,
                                primary: const Color(0xffffffff),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              child: const Text(
                                "Save Contact",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        if (!widget.scantext.contains("BEGIN:VCARD"))
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.scantext));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Text copied")));
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.grey,
                                primary: const Color(0xffffffff),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              child: const Text(
                                "Copy Text",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  Future<dynamic> _clickchange() {
    if (widget.scantext.contains("images")) {
      setState(() {
        textcolor = Colors.blue;
      });
      return Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => ViewQRImage(
                    uri: widget.scantext,
                  )));
    } else if (widget.scantext.contains("/o/pdf")) {
      setState(() {
        textcolor = Colors.blue;
      });
      return Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => ViewQRPDF(
                    url: widget.scantext,
                  )));
    } else if (widget.scantext.contains("http") &&
        !widget.scantext.contains("/o/pdf")) {
      setState(() {
        textcolor = Colors.blue;
      });
      return launch(widget.scantext);
    }
    setState(() {
      textcolor = Colors.blue;
    });
    return launch(widget.scantext);
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

  Future<void> saveContactInPhone() async {
    try {
      final PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
      }
      if (permission == PermissionStatus.granted) {
        final Contact newContact = Contact()
          ..givenName = "Test"
          ..emails = <Item>[Item(label: "email", value: "Testing")]
          ..phones = <Item>[Item(label: "mobile", value: "7014174424")];

        await ContactsService.addContact(newContact);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint("$e");
    }
  }
}
