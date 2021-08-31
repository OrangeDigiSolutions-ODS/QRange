import "package:flutter/material.dart";
import "package:sliding_up_panel/sliding_up_panel.dart";
import "/home/menu.dart";
import "desktopimagecat.dart";
import "desktoppdfcat.dart";

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
    DesktopPDFCat()
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
                    // backdropEnabled: true,
                    backdropOpacity: 0,
                    isDraggable: false,
                    // isDraggable: false,
                    defaultPanelState: PanelState.OPEN,
                    // header: Row(
                    //   children: <Widget>[
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.02,
                    //       width: MediaQuery.of(context).size.width * 0.25,
                    //     ),
                    //     Center(
                    //       child: Container(
                    //         decoration: BoxDecoration(
                    //             color: const Color(0xffDDDDDD).withOpacity(0.7),
                    //             borderRadius: const BorderRadius.only(
                    //                 topLeft: Radius.circular(20),
                    //                 topRight: Radius.circular(20))),
                    //         height: MediaQuery.of(context).size.height * 0.02,
                    //         width: MediaQuery.of(context).size.width * 0.2,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.02,
                    //       width: MediaQuery.of(context).size.width * 0.20,
                    //     ),
                    //   ],
                    // ),
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
                                  _buildIcon(Icons.picture_as_pdf, "PDF", 1)
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
                      child: Image.asset(
                    "assets/images/logo1.png",
                    height: 30,
                    width: 30,
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
      );
}
