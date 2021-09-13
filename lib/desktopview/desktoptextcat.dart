import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "desktopqrview.dart";

class DesktopTextCat extends StatefulWidget {
  const DesktopTextCat({Key? key}) : super(key: key);

  @override
  _DesktopTextCatState createState() => _DesktopTextCatState();
}

class _DesktopTextCatState extends State<DesktopTextCat> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Container(
            color: const Color(0xFF4E4E4E),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  const Text(
                    "Text To QR Code",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Stack(children: <Widget>[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const AutoSizeText(
                            "Enter Text to generate QR",
                            minFontSize: 18,
                            maxFontSize: 26,
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(150),
                            child: TextField(
                              controller: textController,
                              maxLength: 200,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                                labelText: "Text",
                                hintText: "Text",
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  top: 1, right: 1, left: 1, bottom: 1),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              shadowColor: Colors.grey
                          
                              ),
                          onPressed: () {
                            if (textController.text != "") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (_) => DesktopQRView(
                                          url: textController.text)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter text")));
                            }
                          },
                          child: SizedBox(
                            width: 200,
                    
                            child: Row(
                              children: <Widget>[
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
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
}
