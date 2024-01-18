import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_great/constant.dart';

class Soon extends StatelessWidget {
  const Soon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/backbutton_blue.svg'),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.6,),
                Center(child: Text('Sorry, this feature is available soon.', style: header,))
          ],
        ),
      )),
    );;
  }
}