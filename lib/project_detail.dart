import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetail extends StatefulWidget {
  ProjectDetail(
      {Key? key,
      required this.title,
      required this.jobState,
      required this.location,
      required this.description,
      required this.personNeed,
      required this.projectLength,
      required this.companyName,
      required this.companySize,
      required this.tag});

  String title;
  String jobState;
  String location;
  String description;
  String personNeed;
  String projectLength;
  String companyName;
  String companySize;
  final List<String> tag;

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset('assets/nextbutton.svg'),
            SizedBox(
              height: 20,
            ),
            Text(widget.title,
                style: GoogleFonts.sourceSans3(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: primaryColor)),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/briefcase.svg'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.jobState,
                  style: GoogleFonts.openSans(
                      fontSize: 13, fontWeight: FontWeight.w400, color: grey),
                ),
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset('assets/location.svg'),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.location,
                  style: GoogleFonts.openSans(
                      fontSize: 13, fontWeight: FontWeight.w400, color: grey),
                )
              ],
            ),
            Text(
              widget.description,
              style: GoogleFonts.sourceSans3(
                  fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/calendar.png',
                ),
                SizedBox(
                  width: 9,
                ),
                Column(
                  children: [
                    Text(
                      widget.projectLength,
                      style: GoogleFonts.openSans(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Project Length',
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: grey),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset('assets/people_company.svg'),
                Column(
                  children: [
                    Text(
                      widget.personNeed,
                      style: GoogleFonts.openSans(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Participants',
                      style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: grey),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'About The Company',
              style: header,
            ),
            Row(
              children: [
                Container(
                  width: 69,
                  height: 69,
                  decoration: ShapeDecoration(
                    color: Color(0xFF063F5C),
                    shape: OvalBorder(),
                  ),
                  child: Center(child: SvgPicture.asset('assets/business.svg')),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  children: [
                    Text(
                      widget.companyName,
                      style: GoogleFonts.openSans(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(widget.companySize, style: GoogleFonts.openSans(fontSize: 13, fontWeight: FontWeight.w400),)
                  ],
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}

class TagContainer extends StatelessWidget {
  const TagContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the list of tags (replace with your actual list)
    final List<String> tags = [/* your list of tags here */];

    // Determine the appropriate container based on the list size
    if (tags.isEmpty) {
      // Handle the case where there are no tags
      return const Center(child: Text('No tags to display'));
    } else if (tags.length == 1) {
      // Display a single tag
      return Container(
        width: 169,
        height: 30,
        decoration: ShapeDecoration(
          color: Color(0x7FF7AD1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(75),
          ),
        ),
        child: Center(
          child: Text(
            tags.first,
            style: GoogleFonts.openSans(
                fontSize: 13, fontWeight: FontWeight.w600, color: primaryColor),
          ),
        ),
      );
    } else {
      // Display multiple tags in a row or column
      return Wrap(
        spacing: 8.0, // Adjust spacing between tags
        children: tags
            .map((tag) => Chip(
                    label: Text(
                  tag,
                  style: GoogleFonts.openSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryColor),
                )))
            .toList(),
        // Customize styling for multiple tags here
      );
    }
  }
}
