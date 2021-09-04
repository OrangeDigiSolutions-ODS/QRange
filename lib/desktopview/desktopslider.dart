import "package:auto_size_text_pk/auto_size_text_pk.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "/home/menu.dart";

final List<String> imgList = <String>[
  "assets/images/slider.png",
  "assets/images/slider.png",
];

final ValueNotifier<int> themeMode = ValueNotifier<int>(1);

class DesktopSlider extends StatefulWidget {
  const DesktopSlider({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DesktopSliderState();
}

class _DesktopSliderState extends State<DesktopSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.7;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.14,
          ),
          child: Row(
            children: <Widget>[
              Image.asset(
                "assets/images/logo1.png",
                width: 40,
                height: 40,
              ),
              const Text(
                " QRange",
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffDDDDDD),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.15),
            child: PopupMenuButton<dynamic>(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              iconSize: 30,
              color: const Color(0xff555555),
              itemBuilder: (_) => <PopupMenuEntry<dynamic>>[
                PopupMenuItem<dynamic>(
                    enabled: false,
                    child: Row(
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
                    )),
                PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/createqr", (_) => false);
                      // context.vxNav.push(Uri.parse("/createqr"));
                    },
                    title: const Text("Create QR",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const PopupMenuDivider(
                  height: 20,
                ),
                const PopupMenuItem<dynamic>(
                  child: ListTile(
                    onTap: Menu.privacyPolicy,
                    // leading: Icon(Icons.anchor, color: Colors.white),
                    title: Text("Privacy Policy",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.15),
          child: Container(
            color: const Color(0xffE5E5E5),
            child: Column(
              children: <Widget>[
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                      height: height,
                      autoPlay: true,
                      viewportFraction: 1,
                      onPageChanged: (_, __) {
                        setState(() {
                          _current = _;
                        });
                      }),
                  items: imgList
                      .map((_) => Center(
                              child: Image.asset(
                            _,
                            fit: BoxFit.cover,
                            height: height,
                            // width: MediaQuery.of(context).size.width,
                          )))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList
                      .asMap()
                      .entries
                      .map((_) => GestureDetector(
                            onTap: () => _controller.animateToPage(_.key),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.01,
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(
                                            _current == _.key ? 0.9 : 0.4)),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                Container(
                  // color: Colors.white,
                  color: const Color(0xFF4E4E4E),
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              // fixedSize: Size(
                              //     MediaQuery.of(context).size.width * 0.45, 50),
                              padding: const EdgeInsets.only(
                                  top: 5, right: 10, left: 10, bottom: 5),
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              shadowColor: Colors.grey
                              // shape:
                              ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/createqr");

                            // context.vxNav.push(Uri.parse("/createqr"));
                          },
                          // icon: Icon(Icons.camera_alt_outlined,),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffE75527),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                    // size: MediaQuery.of(context).size.width *
                                    //     0.045,
                                  )),
                              const AutoSizeText(
                                " Create QR",
                                minFontSize: 18,
                                maxFontSize: 26,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
