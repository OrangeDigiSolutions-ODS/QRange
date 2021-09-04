import "package:flutter/material.dart";
import "mobilecreateqr.dart";

class AnimatedSlideUp extends StatefulWidget {
  const AnimatedSlideUp({Key? key}) : super(key: key);

  @override
  _AnimatedSlideUpState createState() => _AnimatedSlideUpState();
}

class _AnimatedSlideUpState extends State<AnimatedSlideUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _position;
  late Animation<double> _opacity;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _position = Tween<double>(begin: 20, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 1)),
    )..addListener(() {
        setState(() {});
      });

    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(.5, 1)),
    )..addListener(() {
        setState(() {});
      });
    // Always repeat animation
    _controller.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          const Text(
            "Swipe up for other formats",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: _position.value),
            child: Opacity(
              opacity: _opacity.value,
              child: GestureDetector(
                onTap: () {
                  const MobileCreateQr();
                },
                child: const Icon(
                  Icons.keyboard_arrow_up,
                  // CommunityMaterialIcons.chevron_double_up,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      );
}
