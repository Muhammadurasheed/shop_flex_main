import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_flex/shop_flex_vendor/vendor/views/screens/inner_screen/vendor_chat_screen.dart';


class VendorRecentMessage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorChatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorChatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, String> lastBuyerProductById = {};
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];

              Map<String, dynamic> data =
                  documentSnapshot.data()! as Map<String, dynamic>;

              String message = data['message'].toString();
              String senderId = data['senderId'].toString();
              String productId = data['productId'].toString();
              bool isVendorMessage = senderId == _auth.currentUser!.uid;

              if (!isVendorMessage) {
                String key = senderId + '_' + productId;
                if (!lastBuyerProductById.containsKey(key)) {
                  lastBuyerProductById[key] = productId;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorChatScreen(
                            productId: productId,
                            buyerId: data['buyerId'],
                            vendorId: _auth.currentUser!.uid,
                            data: data,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(data['buyerPhoto']),
                      ),
                      title: Text(message),
                      subtitle: Text('Sent by buyer'),
                    ),
                  );
                }
              }
              print({'photo':data['buyerPhoto']});
              print({'message':message});
              return SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
