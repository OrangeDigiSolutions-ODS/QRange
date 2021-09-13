import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "mobileqr.dart";

class TextCat extends StatefulWidget {
  const TextCat({Key? key}) : super(key: key);

  @override
  _TextCatState createState() => _TextCatState();
}

class _TextCatState extends State<TextCat> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Center(
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.62,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const AutoSizeText(
                                  "Enter Text to generate QR",
                                  minFontSize: 18,
                                  maxFontSize: 26,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: TextField(
                                    controller: textController,
        
                                    maxLength: 200,
                                    maxLines: 6,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Text",
                                        hintText: "Text",
                                        alignLabelWithHint: true),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.58),
                  child: Column(
                    children: <Widget>[
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
                            if (textController.text != "") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (_) =>
                                          MobileQR(url: textController.text)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter text")));
                            }
                          },
                          child: SizedBox(
                            child: Row(
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
                                    )),
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
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
}
