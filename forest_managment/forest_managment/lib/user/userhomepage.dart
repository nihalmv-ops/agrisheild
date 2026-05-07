import 'package:flutter/material.dart';
import 'package:forest_managment/user/view_product.dart';
import 'package:forest_managment/user/viewprofile.dart';

import 'add_product.dart';
import 'edit_product.dart';


void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: user_homepage(),
  ));
}

class user_homepage extends StatefulWidget {
  const user_homepage({super.key});

  @override
  State<user_homepage> createState() => _user_homepageState();
}

class _user_homepageState extends State<user_homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const Drawer(
      //   child: DrawerContent(),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        // actions: const [
        //   Icon(Icons.notifications_none),
        //   SizedBox(width: 16),
        // ],
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/user.jpg'),
                  radius: 25,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi Admin,',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'What do you want to do today?',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(''),
                      SizedBox(height: 6),
                      Text(
                        '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(''),
                      SizedBox(height: 6),
                      Text(
                        '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  ActionCard(
                    title: 'Profile',
                    color: Colors.pinkAccent,
                    icon: Icons.verified_user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewProfile ()),
                      );
                    },
                  ),
                  ActionCard(
                    title: 'Add Product',
                    color: Colors.pinkAccent,
                    icon: Icons.verified_user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>add_product (title: '')),
                      );
                    },
                  ),
                  ActionCard(
                    title: 'view product',
                    color: Colors.pinkAccent,
                    icon: Icons.verified_user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>view_product (title: '')),
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap; // ADD this

  const ActionCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    this.onTap, // ADD this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // USE this
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}


// class DrawerContent extends StatefulWidget {
//   const DrawerContent({super.key});
//
//   @override
//   State<DrawerContent> createState() => _DrawerContentState();
// }

// class _DrawerContentState extends State<DrawerContent> {
//   void showDrawerMessage(String message) {
//     Navigator.pop(context); // Close drawer
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return ListView(
//   //     padding: EdgeInsets.zero,
//   //     children: [
//   //       const DrawerHeader(
//   //         decoration: BoxDecoration(color: Colors.blue),
//   //         child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
//   //       ),
//   //       ListTile(
//   //         leading: const Icon(Icons.dashboard),
//   //         title: const Text('Dashboard'),
//   //         onTap: () => showDrawerMessage('Dashboard selected'),
//   //       ),
//   //       ListTile(
//   //         leading: const Icon(Icons.receipt),
//   //         title: const Text('Add User'),
//   //         onTap: () => showDrawerMessage('Bills selected'),
//   //       ),
//   //       ListTile(
//   //         leading: const Icon(Icons.send),
//   //         title: const Text('Transfers'),
//   //         onTap: () => showDrawerMessage('Transfers selected'),
//   //       ),
//   //       ListTile(
//   //         leading: const Icon(Icons.settings),
//   //         title: const Text('Settings'),
//   //         onTap: () => showDrawerMessage('Settings selected'),
//   //       ),
//   //     ],
//   //   );
//   // }
// }
