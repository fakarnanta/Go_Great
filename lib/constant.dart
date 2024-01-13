
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF063F5C);
const Color secondaryColor = Color(0xFFF7AD1A);
const Color grey = Color(0xFF9A9A9A);
final header = GoogleFonts.raleway(
    fontSize: 32, fontWeight: FontWeight.w700, color: primaryColor);
final subHeader = GoogleFonts.raleway(
    fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor);
final content = GoogleFonts.openSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: primaryColor);

class Dummy extends StatefulWidget {
  const Dummy({super.key});

  @override
  _DummyState createState() => _DummyState();
}

class _DummyStatelessState extends State<DummyStateless> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
      child: Column(
        children: [
          
        ],
      ),
      )),
    );
  }
}

class DummyStateless extends StatefulWidget {
  const DummyStateless({super.key});

  @override
  State<DummyStateless> createState() => _DummyStatelessState();
}

class _DummyState extends State<DummyStateless> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
      child: Column(
        children: [
          
        ],
      ),
      )),
    );
  }
}