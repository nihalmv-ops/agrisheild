import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:forest_managment/user/userhomepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp( add_product(title: '',));
}

class add_product extends StatefulWidget {
  const add_product({super.key, required this.title});

  final String title;
  @override
  State<add_product> createState() => _add_productState();

}
class _add_productState extends State<add_product> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nametextController = TextEditingController();
  final TextEditingController _QuantitytextController = TextEditingController();
  final TextEditingController _pricetextController = TextEditingController();
  final TextEditingController _descriptiontextController = TextEditingController();

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
    String? lid = sh.getString('lid');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    final uri = Uri.parse('$url/user_add_product/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['Name'] = uname;
    request.fields['Quantity'] = Quantity;
    request.fields['price'] = price;
    request.fields['description'] = description;
    request.fields['lid'] = lid!;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'ok') {
        Fluttertoast.showToast(msg: "Submitted successfully.");
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
                    ? Image.file(_selectedImage!, height: 150)
                    : const Text("No Image Selected"),
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
