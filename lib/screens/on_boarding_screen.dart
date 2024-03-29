import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insult_me/screens/quote_screen.dart';
import 'package:insult_me/services/locator_service.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  final String routeName = "onboarding";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: OnBoardingSlider(
        onFinish: () async {
          await LocatorService.sharedPreferenceHelper.saveInitScreen(1);
          if (context.mounted) {
            await Navigator.of(context)
                .pushReplacementNamed(const QuoteScreen().routeName);
          }
        },
        centerBackground: true,
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Let\'s go!',
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: Colors.black,
        ),
        skipTextButton: const Text('Skip'),
        background: [
          SvgPicture.asset(
            "assets/images/onboarding/welcome.svg",
            semanticsLabel: 'welcome illustration',
            height: MediaQuery.of(context).size.width * 0.80,
          ),
          SvgPicture.asset(
            "assets/images/onboarding/boost.svg",
            semanticsLabel: 'boost illustration',
            height: MediaQuery.of(context).size.width * 0.80,
          ),
          SvgPicture.asset(
            "assets/images/onboarding/time.svg",
            semanticsLabel: 'clock illustration',
            height: MediaQuery.of(context).size.width * 0.80,
          ),
          SvgPicture.asset(
            "assets/images/onboarding/share.svg",
            semanticsLabel: 'share illustration',
            height: MediaQuery.of(context).size.width * 0.80,
          ),
          SvgPicture.asset(
            "assets/images/onboarding/simple.svg",
            semanticsLabel: 'welcome illustration',
            height: MediaQuery.of(context).size.width * 0.80,
          ),
        ],
        totalPage: 5,
        speed: 1.8,
        pageBodies: [
          onBoardingItem(context, 'Welcome to InsultMe!',
              'Discover a daily dose of humor and motivation with unique insults. Let\'s make your day extraordinary!'),
          onBoardingItem(context, 'Daily Dynamo Boost',
              'Get a daily dynamo boost with a single, powerful insult. Ready to turn ordinary days into adventures?'),
          onBoardingItem(context, 'Pick Your Insult Time',
              'Personalize your experience by choosing when you receive your daily insult. Your day, your rules!'),
          onBoardingItem(context, 'Add Your Spark',
              'Contribute your own wit! Add insults to share laughter and brighten someone else\'s day.'),
          onBoardingItem(context, 'Keep It Simple, Stay Brilliant',
              'InsultMe keeps it refreshingly simple—no frills, just daily fuel for resilience. Make every day extraordinary!'),
        ],
      ),
    );
  }

  Widget onBoardingItem(
      BuildContext context, String title, String description) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
