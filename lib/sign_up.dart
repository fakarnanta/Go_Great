import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/login.dart';
import 'package:go_great/user_preferences0.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 205,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                LoginForm(),
                SizedBox(
                  height: 22,
                ),
                Row(children: [
                  Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFF9A9A9A),
                          ))),
                  Text(
                    'or',
                    style: GoogleFonts.sourceSans3(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9A9A9A)),
                  ),
                  Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFF9A9A9A),
                          ))),
                ]),
                SizedBox(
                  height: 22,
                ),
                SocialSignIn(),
                Spacer(),
                Center(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Don’t have an account yet?',
                        style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: primaryColor,
                            fontWeight: FontWeight.w400)),
                    WidgetSpan(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ))
                  ])),
                )
              ]),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _emailController,
            style: content, // Customize text color
            decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 18),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xBF5F5F5F), width: 1)),
          child: TextFormField(
            controller: _passwordController,
            style: content, // Customize text color
            obscureText: true, // Hide password
            decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: content, // Customize label color
                border: OutlineInputBorder(borderSide: BorderSide.none)),
          ),
        ),
        SizedBox(height: 50),
        Container(
          height: 48,
          width: MediaQuery.of(context).size.width * 1,
          child: ElevatedButton(
            onPressed: () {
              _signInWithEmailAndPassword();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              backgroundColor: MaterialStateProperty.all<Color>(
                primaryColor, // Customize button color
              ),
            ),
            child: Text('Sign In',
                  style: GoogleFonts.sourceSans3(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white))),
          ),
      ],
    );
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Preferences0()),
            );
    } catch (e) {
      // Handle login errors (display a message, etc.)
      print("Error signing in: $e");
    }
  }
}

class SocialSignIn extends StatelessWidget {
  const SocialSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 48,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xFF9A9A9A)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              'assets/google.png',
            ),
            SizedBox(
              width: 20,
            ),
            Center(
              child: Text('Continue with Google',
                  style: GoogleFonts.openSans(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            )
          ]),
        )
      ],
    );
  }
}
