import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
    final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 37),
      child: Column(
        children: [
          Header()
        ],
      ),
      )),
    );;
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/splash.png',
        width: 80,
        color: grey,
        ),
        SizedBox(height: 10,),
        Text('Your Profile', style: header,),
        SizedBox(height: 35,),
        Container(
          padding: EdgeInsets.all(7),
          width: MediaQuery.of(context).size.width*1,
          height: 56,
          decoration: ShapeDecoration(
              color: Color(0xBFD3D3D3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          ),
          child: Text.rich(
              TextSpan(
                  children: [
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                              color: Color(0xFFC40202),
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w400,
                              height: 0,
                              letterSpacing: 0.01,
                          ),
                      ),
                      TextSpan(
                          text: 'Please complete your profile fisrt to apply the projects and lessons',
                          style: content,
                      ),
                  ],
              ),
          )
      )
      ],
    );
  }
}