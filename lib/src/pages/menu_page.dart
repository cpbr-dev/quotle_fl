import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quotle/src/widgets/help_overlay.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  bool _isTitle = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool overlayActive = false;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/categories');
                    },
                    child: Text(AppLocalizations.of(context)!.playButton),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    child: Text(AppLocalizations.of(context)!.settingsButton),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsetsDirectional.only(bottom: 16, top: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/about');
                    },
                    child: Text(AppLocalizations.of(context)!.aboutButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          setState(() {
            if (overlayActive) {
              overlayEntry.remove();
              overlayActive = false;
            } else {
              showHelpOverlay(context, overlayEntry);
              overlayActive = true;
            }
          });
        },
        icon: overlayActive ? const Icon(Icons.close) : const Icon(Icons.help),
        iconSize: 48,
      ),
    );
  }
}

final overlayEntry = OverlayEntry(
  builder: (context) {
    return Positioned(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.8,
      left: MediaQuery.of(context).size.width * .1,
      top: MediaQuery.of(context).size.height * .1,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text(
            AppLocalizations.of(context)!.helpTitle,
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.helpText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ]),
      ),
    );
  },
);

void showHelpOverlay(BuildContext context, OverlayEntry overlayEntry) {
  OverlayState overlayState = Overlay.of(context);
  overlayState.insert(overlayEntry);
}
