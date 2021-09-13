import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "desktopqrview.dart";

class DesktopVcardCat extends StatefulWidget {
  const DesktopVcardCat({Key? key}) : super(key: key);

  @override
  _DesktopVcardCatState createState() => _DesktopVcardCatState();
}

class _DesktopVcardCatState extends State<DesktopVcardCat> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController phoneWorkController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController designationController = TextEditingController();
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
                    "Vcard To QR Code",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Stack(children: <Widget>[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const AutoSizeText(
                            "Enter Vcard detail to generate QR",
                            minFontSize: 18,
                            maxFontSize: 26,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: TextFormField(
                                      controller: nameController,
                                      keyboardType: TextInputType.name,
                    
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Name",
                                          hintText: "Name",
                                          alignLabelWithHint: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: TextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                          
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
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
                            
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
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
                  
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
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
                        
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
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
                                      keyboardType: TextInputType.streetAddress,
                      
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(),
                                          labelText: "Address",
                                          hintText: "Address",
                                          alignLabelWithHint: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: TextField(
                                      controller: organizationController,
                                      keyboardType: TextInputType.text,
                          
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
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
                          
                                      decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          border: OutlineInputBorder(),
                                          labelText: "Designation",
                                          hintText: "Designation",
                                          alignLabelWithHint: true),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        top: 1, right: 1, left: 1, bottom: 1),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    shadowColor: Colors.grey
                    
                                    ),
                                onPressed: () {
                                  if (nameController.text != "" &&
                                      phoneController.text != "") {
                                    final String vcard =
                                        "BEGIN:VCARD\nVERSION:3.0\nREV:2021-09-07T17:28:28Z\nN;CHARSET=utf-8:${nameController.text};;;;\nFN;CHARSET=utf-8:${nameController.text}\nTEL;PREF:${phoneController.text}\nTEL;WORK:${phoneWorkController.text}\nemail;internet:${emailController.text}\nTITLE;CHARSET=utf-8:${designationController.text}\nORG;CHARSET=utf-8:${organizationController.text}\nADR;WORK;POSTAL;CHARSET=utf-8:;${addressController.text};;;;;\nURL:${websiteController.text}\nEND:VCARD";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                            builder: (_) =>
                                                DesktopQRView(url: vcard)));
                                  } else {
                                    if (nameController.text == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Please enter name")));
                                    } else if (phoneController.text == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please enter phone number")));
                                    }
                                  }
                                },
                                child: SizedBox(
                                  width: 200,
                                  child: Row(
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
                        ],
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
