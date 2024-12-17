import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalApply extends StatelessWidget {
  const FinalApply({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 173,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            SizedBox(height: 38,),
            GestureDetector(
              onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
              },
              child: Container(
                width: 232,
                height: 52,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(32),
              ),
              child: Center(child: Text('Back to home', style: GoogleFonts.raleway(fontSize: 18, color: Colors.white),)),
                      ),
            )],
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/splash.png',
              width: 80,
              color: lightGrey,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'You have submitted.',
              style: header,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 1,
              height: 185,
              decoration: ShapeDecoration(
                color: Color(0xBFD3D3D3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Thank You for your submission has been delivered to our company. For further information, please click on the provided group link to join the community and information.',
                      style: GoogleFonts.openSans(
                          fontSize: 14, color: primaryColor)),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                            const urlString = 'https://discord.gg/geDv3QZhUa';
                           final url = Uri.parse(urlString);
                        try {
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                             AnimatedSnackBar.material(
                              'Link error, please contact developer',
                              type: AnimatedSnackBarType.error,
                            ).show(context);
                          }
                        } catch (e) {
                          print('Error launching URL: $e');
                        }

                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            'Discord Link',
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 1,
              height: 115,
              decoration: ShapeDecoration(
                color: Color(0xBFD3D3D3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36, // Ensure equal height for a circle
                    decoration: BoxDecoration(
                      color: secondaryColor, // Customize the color as needed
                      shape: BoxShape.circle,
                    ),
                    child:
                        Center(child: SvgPicture.asset('assets/warning.svg')),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 265,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'The company will contact you and send an email if you are accepted. Please check your ',
                                style: content,
                              ),
                              TextSpan(
                                  text: 'email',
                                  style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              TextSpan(
                                  text:
                                      ' or spam folder after the specified time.',
                                  style: content),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
