import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Header(
              name: 'Daffa Damadhika',
              location: 'Malang, Indonesia',
              job: 'Software Engineer')
        ],
      )),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.name,
    required this.location,
    required this.job,
  }) : super(key: key);

  final String name;
  final String location;
  final String job;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 320,
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Image.asset(
                'assets/profile_banner_temp.jpeg',
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 21, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    (FirebaseAuth.instance.currentUser?.displayName ?? 'User'),
                    style: GoogleFonts.sourceSans3(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: primaryColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/location.svg'),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        location,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: grey),
                      ),
                     
                    ],
                  ),
                   SizedBox(height: 7,),
                      Text(
                        job, style: GoogleFonts.openSans(fontSize: 14),
                      )
                ],
              ),
            )
          ],
        ),
      ),
      Positioned(
          left: 15,
          top: 70,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 218, 217, 217),
            radius: 60,
          )),
    ]);
  }
}

class Body extends StatelessWidget {
   const Body({
    Key? key,
    required this.name,
    required this.location,
    required this.job,
  }) : super(key: key);

  final String name;
  final String location;
  final String job;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 64,
                decoration: ShapeDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29),
                    ),
                ),
            ),
            Column(
              children: [
                
              ],
            )
            ],
          )
        ],
      ),
    );
  }
}