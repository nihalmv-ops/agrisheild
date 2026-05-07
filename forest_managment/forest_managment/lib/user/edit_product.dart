import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:forest_managment/user/view_product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp( edit_product(title: '',));
}

class edit_product extends StatefulWidget {
  const edit_product({super.key, required this.title});

  final String title;
  @override
  State<edit_product> createState() => _edit_productState();

}
class _edit_productState extends State<edit_product> {

  _edit_productState(){
    _get_data();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _QuantitytextController = TextEditingController();
  final TextEditingController _pricetextController = TextEditingController();
  final TextEditingController _descriptiontextController = TextEditingController();

  String upic="";



  void _get_data() async{



    SharedPreferences sh = await SharedPreferences.getInstance();
    String url = sh.getString('url').toString();
    String pid = sh.getString('pid').toString();
    String img_url = sh.getString('img_url').toString();

    final urls = Uri.parse('$url/edit_product/');
    try {
      final response = await http.post(urls, body: {
        'pid':pid



      });
      if (response.statusCode == 200) {
        String status = jsonDecode(response.body)['status'];
        if (status=='ok') {
          String name=jsonDecode(response.body)['name'].toString();
          String quantity=jsonDecode(response.body)['quantity'].toString();
          String image=img_url+jsonDecode(response.body)['image'].toString();
          String price=jsonDecode(response.body)['price'].toString();
          String description=jsonDecode(response.body)['description'].toString();


          setState(() {

            _nametextController.text= name;
            _QuantitytextController.text= quantity;
            _pricetextController.text= price;
            _descriptiontextController.text= description;
            upic= image;
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


  File? _selectedImage;
  Future<void> _chooseImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  Future<void> _sendData() async {
    String uname = _nametextController.text;
    String Quantity= _QuantitytextController.text;
    String price = _pricetextController.text;
    String description = _descriptiontextController.text;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? pid = sh.getString('pid');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/edit_product_post/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = uname;
    request.fields['quantity'] = Quantity;
    request.fields['price'] = price;
    request.fields['description'] = description;
    request.fields['pid'] = pid!;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>view_product(title: 'View Product',)));
      } else {
        Fluttertoast.showToast(msg: "Submission failed.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
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
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  height: 150,
                )
                    : (upic.isNotEmpty
                    ? Image.network(
                  upic,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) =>
                  const Text("Failed to load image"),
                )
                    : const Text("No Image Selected")),

                // _selectedImage != null
                //     ? Image.file(_selectedImage!, height: 150)
                //     : const Text("No Image Selected"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _chooseImage,
                  child: const Text("Upload Image"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nametextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _QuantitytextController,
                  decoration: const InputDecoration(
                    labelText: 'Product Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Quantity is required';
                    }
                    return null;
                  },
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Email is required';
                  //   }
                  //   if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  //     return 'Enter a valid email';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pricetextController,
                  decoration: const InputDecoration(
                    labelText: 'Product Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }
                    return null;
                  },
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Phone number is required';
                  //   }
                  //   if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  //     return 'Enter a valid 10-digit phone number';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptiontextController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),

                  ),
                  // keyboardType: TextInputType.,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  // validator: (value) {
                  //   if (value == null || value.trim().isEmpty) {
                  //     return 'Phone number is required';
                  //   }
                  //   if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  //     return 'Enter a valid 10-digit phone number';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendData();
                    } else {
                      Fluttertoast.showToast(msg: "Please fix errors in the form");
                    }
                  },
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
