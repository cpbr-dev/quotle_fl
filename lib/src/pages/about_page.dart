//Standard about page for the app
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    //Display the app name and version
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutButton),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Flexible(
                flex: 4,
                child: Text(
                  'Quotle',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  AppLocalizations.of(context)!.aboutTextContent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Text(
                  AppLocalizations.of(context)!.aboutTextContent2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 48,
                      onPressed: () => {
                        _launchURL('https://munstermc.github.io'),
                      },
                      icon: const FaIcon(FontAwesomeIcons.github),
                    ),
                    IconButton(
                      iconSize: 48,
                      onPressed: () => {
                        _launchURL('https://www.buymeacoffee.com/munster'),
                      },
                      icon: const FaIcon(FontAwesomeIcons.circleDollarToSlot),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dataCreditsText),
                    IconButton(
                      onPressed: () => {
                        _launchURL('https://fauconnier.github.io/'),
                      },
                      icon: const FaIcon(FontAwesomeIcons.githubAlt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
