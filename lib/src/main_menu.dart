import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  bool _isTitle = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _toggleImage() {
    setState(() {
      _isTitle = !_isTitle;
    });

    if (_isTitle) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RotationTransition(
              turns: _animation,
              child: GestureDetector(
                onTap: _toggleImage,
                child: SvgPicture.asset(
                  _isTitle
                      ? 'assets/svg/app_title.svg'
                      : 'assets/svg/app_logo.svg',
                  width: 200,
                  height: 87,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.inverseSurface,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/categories');
                  },
                  child: const Text('Play Game'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
