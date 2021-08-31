import "package:flutter/material.dart";
import "/desktopview/desktopcreateqr.dart";
import "/mobileview/mobilecreateqr.dart";

class CreateQr extends StatefulWidget {
  const CreateQr({Key? key}) : super(key: key);

  @override
  _CreateQrState createState() => _CreateQrState();
}

class _CreateQrState extends State<CreateQr> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: LayoutBuilder(
          builder: (_, __) {
            if (__.maxWidth < 768) {
              return const MobileCreateQr();
            } else {
              return const DesktopCreateQr();
            }
          },
        ),
      );
}
