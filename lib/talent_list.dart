import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/main.dart';
import 'package:go_great/soon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';

class TalentList extends StatefulWidget {
  const TalentList({super.key});

  @override
  State<TalentList> createState() => _TalentListState();
}

class _TalentListState extends State<TalentList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                width: MediaQuery.of(context).size.width * 1,
                height: 300,
                decoration: ShapeDecoration(
                  color: Color(0xFFFFCB66),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/backbutton_blue.svg'),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      'Talents',
                      style: header,
                    ),
                    Text(
                      'Find talent by your own\nto work and learn together',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 35,
                  left: 120,
                  child: Image.asset(
                    'assets/a1.png',
                    color: Color.fromARGB(255, 226, 165, 43),
                  ))
            ]
            ),
            TalentListCard(),
          ],
        ),
      ),
    );
  }
}

class TalentListCard extends StatefulWidget {
  const TalentListCard({Key? key}) : super(key: key);

  @override
  State<TalentListCard> createState() => _TalentListCardState();
}

class _TalentListCardState extends State<TalentListCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
                 List<Map<String, dynamic>> userDataList = snapshot.data!.docs
              .map((doc) => {
                    'name': doc['name'].toString(),
                    'job': doc['job'].toString(),
                  })
              .toList();
      
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true, // Allows the ListView to take the minimum required space
              itemCount: userDataList.length,
              separatorBuilder: (context, index) => SizedBox(height: 10,), // Add a separator
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Soon()),
         );
                  },
                  child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    width: MediaQuery.of(context).size.width*1,
                    height: 79,
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                        ),
                        shadows: [
                              BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                              )
                        ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 40, backgroundColor: primaryColor,),
                        SizedBox(height: 9,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(userDataList[index]['name'], style: GoogleFonts.sourceSans3(fontSize: 16, fontWeight: FontWeight.w700, color: primaryColor),),
                              Row(children: [
                                Text(userDataList[index]['job'], style: GoogleFonts.openSans(fontSize: 13, color: grey),)
                              ],)
                          ],
                        )
                      ],
                    ),
                    ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
