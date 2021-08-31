import "dart:async";
import "package:firebase_core/firebase_core.dart";
import "package:device_preview/device_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:url_strategy/url_strategy.dart";
import "/desktopview/desktopqrview.dart";
import "/home/createqr.dart";
import "/home/sliderpage.dart";
import "/mobileview/mobileqr.dart";
import "/qrviewer/qrviewimage.dart";
import "/qrviewer/qrviewpdf1.dart";

Future<void> main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  //   DevicePreview(
  //       enabled: !kReleaseMode, builder: (_) => const MyApp()),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        title: "QRange",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // initialRoute: "/",
        // // routeInformationParser: VxInformationParser(),

        // routerDelegate:
        //     // ignore: avoid_annotating_with_dynamic
        //     VxNavigator(routes: <Pattern, Page<dynamic> Function(Uri, dynamic)>{
        // "/": (_, __) => const MaterialPage<dynamic>(child: MyHomePage()),
        // "/slider": (_, __) =>
        //     const MaterialPage<dynamic>(child: SliderPage()),
        // // "/scan": (_, __) => const MaterialPage<dynamic>(child: ScanPage()),
        // "/createqr": (_, __) =>
        //     const MaterialPage<dynamic>(child: CreateQr()),
        // "/mobileqr": (_, __) =>
        //     MaterialPage<dynamic>(child: MobileQR(url: __.toString())),
        // "/desktopqr": (_, __) =>
        //     MaterialPage<dynamic>(child: DesktopQRView(url: __.toString())),
        // "/viewqrimage": (_, __) => MaterialPage<dynamic>(
        //         child: ViewQRImage(
        //       uri: __.toString(),
        //     )),
        // "/viewqrpdf": (_, __) => MaterialPage<dynamic>(
        //         child: ViewQRPDF(
        //       url: __.toString(),
        //     )),
        // "/viewqrimage/image": (_, __) => MaterialPage<dynamic>(
        //         child: ViewQRImage(
        //       uri: _.toString(),
        //     )),

        // }),

        // home: const MyHomePage(),
        // initialRoute: "/",
        onGenerateRoute: (__) {
          if (__.name!.contains("images/viewqr")) {
            final Uri setttingsUri = Uri.parse(__.name!);
            final String? postid = setttingsUri.queryParameters["id"];
            return MaterialPageRoute<dynamic>(
                builder: (_) => ViewQRImage(
                      uri: postid,
                    ));
          } else if (__.name!.contains("pdf/viewqr")) {
            final Uri setttingsUri = Uri.parse(__.name!);
            final String? postid = setttingsUri.queryParameters["id"];
            return MaterialPageRoute<dynamic>(
                builder: (_) => ViewQRPDF(
                      url: postid,
                    ));
          }
        },
        routes: <String, WidgetBuilder>{
          "/": (_) => const MyHomePage(),
          "/slider": (_) => const SliderPage(),
          "/createqr": (_) => const CreateQr(),
          "/mobileqr": (_) =>
              MobileQR(url: "https://www.orangedigisolutions.com/"),
          "/desktopqr": (_) =>
              DesktopQRView(url: "https://www.orangedigisolutions.com/"),
          // "/viewqrimage": (_, __) => MaterialPage<dynamic>(
          //         child: ViewQRImage(
          //       uri: __.toString(),
          //     )),
          // "/viewqrpdf": (_, __) => MaterialPage<dynamic>(
          //         child: ViewQRPDF(
          //       url: __.toString(),
          //     )),
          // "/viewqrimage/image": (_, __) => MaterialPage<dynamic>(
          //         child: ViewQRImage(
          //       uri: _.toString(),
          //     )),
        },
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (kIsWeb) {
        Navigator.pushNamedAndRemoveUntil(context, "/createqr", (_) => false);
        // context.vxNav.clearAndPush(Uri.parse("/createqr"));
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/slider", (_) => false);
        // context.vxNav.clearAndPush(Uri.parse("/slider"));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xffEDEEF1),
        body: Stack(
          // mainAxisAlignment: MainAxisAlignment.,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: const Image(
                  image: AssetImage(
                    "assets/images/logo1.png",
                  ),
                  width: 100,
                  height: 100,
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Image(
                        image: AssetImage(
                          "assets/images/logo2.png",
                        ),
                        fit: BoxFit.fill,
                        width: 90,
                        height: 90,
                      ),
                      Column(
                        children: const <Widget>[
                          Text("Powered by",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.black54,
                              )),
                          Text(
                            "orange",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Colors.black),
                          ),
                          Text(
                            "DigiSolution",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
