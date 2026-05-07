import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forest_managment/user/edit_product.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(const ViewHouseApp());
}

class ViewHouseApp extends StatelessWidget {
  const ViewHouseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: view_product(title: 'View Users'),
    );
  }
}

class view_product extends StatefulWidget {
  const view_product({super.key, required this.title});
  final String title;

  @override
  State<view_product> createState() => _view_productState();
}

class _view_productState extends State<view_product> {
  List<Map<String, dynamic>> users = [];


  @override
  void initState() {
    super.initState();
    viewUsers("");
  }

  Future<void> viewUsers(String searchValue) async {
    try {
      SharedPreferences sh = await SharedPreferences.getInstance();
      String urls = sh.getString('url') ?? '';
      String img = sh.getString('img_url') ?? '';
      String apiUrl = '$urls/view_product/';

      var response = await http.post(Uri.parse(apiUrl), body: {
        'lid':sh.getString('lid').toString()
      });
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == 'ok') {
        List<Map<String, dynamic>> tempList = [];
        for (var item in jsonData['data']) {
          tempList.add({
            'id': item['id'].toString(),
            'name': item['name'].toString(),
            'quantity': item['quantity'].toString(),
            'price': item['price'].toString(),
            'description': item['description'].toString(),
            'image': img + item['image'].toString(),
          });
        }
        setState(() {
          users = tempList;

        });
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const user_homepage()),
      );
      return false; // Prevent default pop
    },
    child:Scaffold(
      appBar:
          AppBar(
            backgroundColor: Color.fromARGB(255, 232, 177, 61),
            title: Text('Search by name'),
          ),

      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['image']),
                radius: 30,
              ),
              title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("quantity: ${user['quantity']}"),
                  Text("price: ${user['price']}"),
                  // Text("image: ${user['image']}"),
                  Text("description: ${user['description']}"),

                  Row(children: [
                    ElevatedButton(onPressed: ()async{
                      SharedPreferences sh=await SharedPreferences.getInstance();
                      sh.setString("pid", user['id'].toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>edit_product(title: 'Edit Product',)));
                    }, child: Text('Edit')),

                    ElevatedButton(onPressed: ()async{

                      SharedPreferences sh = await SharedPreferences.getInstance();
                      String url = sh.getString('url').toString();

                      final urls = Uri.parse('$url/delete_product_post/');
                      try {
                        final response = await http.post(urls, body: {
                          'pid': sh.getString("pid").toString(),
                        });
                        if (response.statusCode == 200) {
                          String status = jsonDecode(response.body)['status'];
                          if (status == 'ok') {

                            Fluttertoast.showToast(msg: 'Success fully deleted ');
                            viewUsers("");

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => user_homepage()),
                            // );
                          } else {
                            Fluttertoast.showToast(msg: 'Not Found');
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'Network Error');
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    }, child: Text('Delete'))
                  ],)
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
