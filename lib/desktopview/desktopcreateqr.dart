import 'package:QRange/desktopview/desktopvcardcat.dart';
import "package:flutter/material.dart";
import "package:sliding_up_panel/sliding_up_panel.dart";
import "/desktopview/desktopurlcat.dart";
import "/home/menu.dart";
import "desktopimagecat.dart";
import "desktoppdfcat.dart";
import "desktoptextcat.dart";

class DesktopCreateQr extends StatefulWidget {
  const DesktopCreateQr({Key? key}) : super(key: key);

  @override
  _DesktopCreateQrState createState() => _DesktopCreateQrState();
}

class _DesktopCreateQrState extends State<DesktopCreateQr> {
  final Color _selectedIconBgColor = const Color(0xffE75527);
  final Color _unselectedIconBgColor = const Color(0xff353535);
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DesktopImageCat(),
    DesktopPDFCat(),
    DesktopUrlCat(),
    DesktopTextCat(),
    DesktopVcardCat()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Color _getIconBgColor(int index) =>
      _selectedIndex == index ? _selectedIconBgColor : _unselectedIconBgColor;

  Widget _buildIcon(IconData iconData, String text, int index) => SizedBox(
        child: SizedBox(
          child: InkWell(
            onTap: () => _onItemTapped(index),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Icon(
                    iconData,
                    color: _getIconBgColor(index),
                    size: 45,
                  ),
                  Text(text,
                      style: TextStyle(
                          fontSize: 25, color: _getIconBgColor(index))),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        //body
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15),
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  LayoutBuilder(
                    builder: (_, __) =>
                        _widgetOptions.elementAt(_selectedIndex),
                  ),
                  SlidingUpPanel(
                    renderPanelSheet: false,
                    backdropOpacity: 0,
                    isDraggable: false,
                    defaultPanelState: PanelState.OPEN,
                    minHeight: MediaQuery.of(context).size.height * 0.04,
                    maxHeight: MediaQuery.of(context).size.height * 0.2,
                    color: Colors.transparent,
                    panel: Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.30),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          color: const Color(0xffDDDDDD).withOpacity(0.7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _buildIcon(Icons.image_outlined, "Image", 0),
                                  _buildIcon(Icons.picture_as_pdf, "PDF", 1),
                                  _buildIcon(Icons.link, "URL", 2),
                                  _buildIcon(Icons.text_fields, "Text", 3),
                                  _buildIcon(Icons.file_copy, "Vcard", 4),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        //Appbar
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
                  PopupMenuItem<dynamic>(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/createqr", (_) => false);
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
                  const PopupMenuDivider(
                    height: 20,
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
                ],
              ),
            ),
          ],
        ),
      );
}
