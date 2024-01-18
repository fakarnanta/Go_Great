import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_great/constant.dart';
import 'package:go_great/sign_up.dart';
import 'package:go_great/user_preferences0.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 37),
          child: Column(children: [
            SizedBox(
              height: 160,
            ),
            Center(
              child: Text(
                'Sign Up',
                style: header,
              ),
            ),
            SizedBox(height: 70,),
            SignUpForm()

          ]),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
            border: Border.all(color: Color(0xBF5F5F5F), width: 1),
          ),
          child: TextFormField(
            controller: _emailController,
            style: content,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: content,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(height: 18),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          width: MediaQuery.of(context).size.width * 1,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xBF5F5F5F), width: 1),
          ),
          child: TextFormField(
            controller: _passwordController,
            style: content,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: content,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        SizedBox(height: 50),
        Container(
          height: 48,
          width: MediaQuery.of(context).size.width * 1,
          child: ElevatedButton(
            onPressed: () {
              _signUpWithEmailAndPassword();
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                primaryColor, // Customize button color
              ),
            ),
            child: Text(
              'Sign Up',
              style: content.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
         Spacer(),
                Center(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Already have an account?',
                        style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: primaryColor,
                            fontWeight: FontWeight.w400)),
                    WidgetSpan(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                      },
                      child: Text(
                        'Sign in',
                        style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ))
                  ])),
                )
      ],
    );
  }

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Preferences0()),
            );
    } catch (e) {
      // Handle sign-up errors (display a message, etc.)
      print("Error signing up: $e");
    }
  }
}