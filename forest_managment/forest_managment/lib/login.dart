// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import 'home.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const login(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class login extends StatefulWidget {
//   const login({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<login> createState() => _loginState();
// }
//
// class _loginState extends State<login> {
//   // ✅ Create a TextEditingController
//   final TextEditingController _usernametextController = TextEditingController();
//   final TextEditingController _passwordtextController = TextEditingController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // ✅ TextField with controller
//               TextField(
//                 controller: _usernametextController,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Username or Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordtextController,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter Your Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // ✅ ElevatedButton
//               ElevatedButton(
//                 onPressed: () {
//                 _send_data();
//                 },
//                 child: const Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   void _send_data() async{
//
//     String uname=_usernametextController.text;
//     String password=_passwordtextController.text;
//
//     SharedPreferences sh = await SharedPreferences.getInstance();
//     String url = sh.getString('url').toString();
//
//     final urls = Uri.parse('$url/flutter_logins/');
//     try {
//       final response = await http.post(urls, body: {
//         'Username':uname,
//         'Password':password,
//       });
//       if (response.statusCode == 200) {
//         String status = jsonDecode(response.body)['status'];
//         if (status=='ok') {
//           String lid=jsonDecode(response.body)['lid'];
//           sh.setString("lid", lid);
//
//           Navigator.push(context, MaterialPageRoute(
//             builder: (context) => HomePage(),));
//         }else {
//           Fluttertoast.showToast(msg: 'Not Found');
//         }
//       }
//       else {
//         Fluttertoast.showToast(msg: 'Network Error');
//       }
//     }
//     catch (e){
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forest_managment/user/signup.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: login(title: 'Login'),
  ));
}

class login extends StatefulWidget {
  const login({super.key, required this.title});
  final String title;

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _usernametextController = TextEditingController();
  final TextEditingController _passwordtextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)),
      );
      return false; // Prevent default pop
    },
    child:Scaffold(
      backgroundColor: const Color(0xFFEFF3FF), // Light blue background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Shape and Logo
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0047AB),
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(80)),
                  ),
                ),
                const Positioned(
                  top: 100,
                  left: 20,
                  child: Text(
                    'AGRI GUARD',
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email id",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _usernametextController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Password",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordtextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _send_data,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Login",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password ?",
                          style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Divider
                  Row(children: const <Widget>[
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or"),
                    ),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 20),

                  // Facebook Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {},
                  //     icon: const Icon(Icons.facebook, color: Colors.white),
                  //     label: const Text("Log in with Facebook"),
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: const Color(0xFF1877F2),
                  //         padding: const EdgeInsets.symmetric(vertical: 14),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8))),
                  //   ),
                  // ),
                  const SizedBox(height: 30),

                  // Register Prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Text("Don't have an account? ",
                          style: TextStyle(color: Colors.black87)),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>signup(title: '',)));
                      }, child:  Text("Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),)

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  void _send_data() async {
    String uname = _usernametextController.text;
    String password = _passwordtextController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();

    final urls = Uri.parse('$url/userloginpage_post/');
    try {
      final response = await http.post(urls, body: {
        'username': uname,
        'password': password,
      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status == 'ok') {
          String lid = jsonDecode(response.body)['lid'].toString();
          sh.setString("lid", lid);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => user_homepage()),
          );
        } else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      } else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
