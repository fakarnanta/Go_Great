import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/sign_up.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant.dart';
import 'dart:async';

class Onboard {
  final String image, title, description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<Onboard> Data = [
  Onboard(
    image: 'assets/onboard1.png',
    title: 'Upgrade your \n‘Good’ to ‘Great’',
    description: 'You can Improve your skills,\nGet Your project here, Right here!',
  ),
];

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_pageIndex < Data.length - 1) {
        _pageIndex++;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
        );
        _timer?.cancel();
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _pageIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(
            children: [
              OnBoardContent(
                image: Data[0].image,
                title: Data[0].title,
                description: Data[0].description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardContent extends StatelessWidget {
  OnBoardContent({
    required this.image,
    required this.title,
    required this.description,
  });

  String image;
  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 60),
        Center(
          child: Image.asset(image,
          width: 295,
          height: 295,
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          title,
          style: GoogleFonts.raleway(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 9),
        Text(
          description,
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 48,),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Container(
            height: 44,
            width: 127,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'Get Started',
                style: GoogleFonts.raleway(
                  color: primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
