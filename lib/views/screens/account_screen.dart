import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_flex/views/screens/auths/customer_login_screen.dart';
import 'package:shop_flex/views/screens/inner_screen/customer_order_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});


  @override
  Widget build(BuildContext context) {
    CollectionReference _buyers =
        FirebaseFirestore.instance.collection('buyers');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sunny_snowing,
              color: Colors.yellow.shade900,
              size: 30,
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _buyers.doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(child: Text("Document does not exist"));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
                print({'data': data});
            return Center(

              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(data['profileImageUrl']),
                    radius: 65,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['fullName'].toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['email'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 90,
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.phone),
                          title: Text('Phone'),
                          subtitle: Text('2348162958127'),
                        ),
                        ListTile(
                          leading: Icon(CupertinoIcons.cart),
                          title: Text('Cart'),
                        ),
                        ListTile(
                          onTap: () {
                            Get.to(CustomerOrderScreen());
                          },
                          leading: Icon(CupertinoIcons.bag),
                          title: Text('Order'),
                        ),
                        ListTile(
                          onTap: () async {
                            await _auth.signOut().whenComplete(() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CustomerLoginScreen();
                                  },
                                ),
                              );
                            });
                          },
                          leading: Icon(Icons.logout),
                          title: Text(
                            'Logout',
                            style: TextStyle(color: Colors.yellow.shade900),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
