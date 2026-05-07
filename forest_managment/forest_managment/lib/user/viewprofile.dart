import 'package:flutter/material.dart';
import 'package:forest_managment/user/changepassword.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'editprofile.dart';
void main() {
  runApp(const ViewProfile());
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Profile',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const view_profile(title: 'View Profile'),
    );
  }
}

class view_profile extends StatefulWidget {
  const view_profile({super.key, required this.title});

  final String title;

  @override
  State<view_profile> createState() => _view_profileState();
}

class _view_profileState extends State<view_profile> {

  _view_profileState()
  {
    _send_data();
  }
  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>user_homepage()));
        return true; },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>user_homepage()));

          } , ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[


              CircleAvatar(radius: 50,
              backgroundImage: NetworkImage(photo_),),
              Column(
                children: [
                  // Image(image: NetworkImage(photo_),height: 200,width: 200,),
                  Padding(
                    padding: EdgeInsets.all(5),
                  child: Text(name_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(dob_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(gender_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(email_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(number_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(place_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(state_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(pincode_),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(district_),
                  ),

                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => usereditprofile(title: "Edit Profile"),));
                },
                child: Text("Edit Profile"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => change_password(title: "Edit Profile"),));
                },
                child: Text("Change Password"),
              ),

            ],
          ),
        ),
      ),
    );
  }


  String name_="";
  String dob_="";
  String gender_="";
  String email_="";
  String state_="";
  String place_="";
  String number_="";
  String pincode_="";
  String district_="";
  String photo_="";

  void _send_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String lid = sh.getString('lid').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/user_viewprofile_post/');
    try {
      final response = await http.post(urls, body: {
      'lid':lid



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String name=jsonDecode(response.body)['name'].toString();
          String dob=jsonDecode(response.body)['dob'].toString();
          String gender=jsonDecode(response.body)['gender'].toString();
          String email=jsonDecode(response.body)['email'].toString();
          String state=jsonDecode(response.body)['state'].toString();
          String place=jsonDecode(response.body)['place'].toString();
          String number=jsonDecode(response.body)['number'].toString();
          String pincode=jsonDecode(response.body)['pincode'].toString();
          String district=jsonDecode(response.body)['disrict'].toString();
          String photo=img_url+jsonDecode(response.body)['photo'].toString();

          setState(() {

            name_= name;
            dob_= dob;
            gender_= gender;
            email_= email;
            state_= state;
            place_= place;
            number_= number;
            pincode_= pincode;
            district_= district;
            photo_= photo;
          });





        }else {
          Fluttertoast.showToast(msg: 'Not Found');
        }
      }
      else {
        Fluttertoast.showToast(msg: 'Network Error');
      }
    }
    catch (e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
