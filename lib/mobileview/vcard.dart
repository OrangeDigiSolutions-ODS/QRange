import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "mobileqr.dart";

class Vcard extends StatefulWidget {
  const Vcard({Key? key}) : super(key: key);

  @override
  _VcardState createState() => _VcardState();
}

class _VcardState extends State<Vcard> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneWorkController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController designationController = TextEditingController();
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.62,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const AutoSizeText(
                                "Enter Vcard details to generate QR",
                                minFontSize: 18,
                                maxFontSize: 26,
                                style: TextStyle(color: Colors.black87),
                              ),
                              Expanded(
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 4, bottom: 4),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextFormField(
                                              controller: nameController,
                                              keyboardType: TextInputType.name,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Name",
                                                  hintText: "Name",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Email",
                                                  hintText: "Email",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller: websiteController,
                                              keyboardType: TextInputType.url,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Website",
                                                  hintText: "Website",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller: phoneController,
                                              keyboardType: TextInputType.phone,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Phone",
                                                  hintText: "Phone",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller: phoneWorkController,
                                              keyboardType: TextInputType.phone,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Phone(Work)",
                                                  hintText: "Phone(Work)",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller: addressController,
                                              keyboardType:
                                                  TextInputType.streetAddress,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Address",
                                                  hintText: "Address",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller:
                                                  organizationController,
                                              keyboardType: TextInputType.text,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Organization",
                                                  hintText: "Organization",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: TextField(
                                              controller: designationController,
                                              keyboardType: TextInputType.text,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Designation",
                                                  hintText: "Designation",
                                                  alignLabelWithHint: true),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     selectTimePicker(context);
                                          //   },
                                          //   child: Icon(Icons.calendar_today),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ))),

            //code for buttons
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.58),
                child: Column(
                  children: <Widget>[
                    // if (path1 != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(
                                top: 5, right: 2, left: 2, bottom: 5),
                            primary: const Color(0xFFFFFFFF),
                            // shape: const CircleBorder(),
                            shadowColor: Colors.grey,
                            shape: const StadiumBorder()
                            // shape:
                            ),
                        onPressed: () {
                          if (nameController.text != "" &&
                              phoneController.text != "") {
                            final String vcard =
                                "BEGIN:VCARD\nVERSION:3.0\nREV:1999-09-30T17:28:28Z\nN;CHARSET=utf-8:${nameController.text};;;;\nFN;CHARSET=utf-8:${nameController.text}\nTEL;PREF:${phoneController.text}\nTEL;WORK:${phoneWorkController.text}\nemail;internet:${emailController.text}\nTITLE;CHARSET=utf-8:${designationController.text}\nORG;CHARSET=utf-8:${organizationController.text}\nADR;WORK;POSTAL;CHARSET=utf-8:;${addressController.text};;;;;\nURL:${websiteController.text}\nEND:VCARD";
                            Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (_) => MobileQR(url: vcard)));
                          } else {
                            if (nameController.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter name")));
                            } else if (phoneController.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please enter phone number")));
                            }
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
                                    // size: MediaQuery.of(context).size.width *
                                    //     0.045,
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
      );
}
