import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FinalAddProject extends StatelessWidget {
  const FinalAddProject({super.key});

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
              'You have add your project.',
              style: header,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 1,
              height: 235,
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
                      'Thank You for your project that has been added to our company. For further information, please wait for our email, we will review and probably contact your company for collaboration. Thank you for using our service !',
                      style: GoogleFonts.openSans(
                          fontSize: 14, color: primaryColor)),
                          SizedBox(height: 12,),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width*1,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)
                              , color: primaryColor
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Our Email :', style: GoogleFonts.raleway(fontSize: 12, color: Colors.white),),
                                SizedBox(height: 3,),
                                Text('admin@gogreat.com', style: GoogleFonts.raleway(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700))
                              ],
                            ),
                          )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      )),
    );
  }
}
