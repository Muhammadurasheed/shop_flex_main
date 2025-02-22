import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorChatScreen extends StatefulWidget {
  final String productId;
  final String buyerId;
  final String vendorId;
  final dynamic data;

  const VendorChatScreen({
    super.key,
    required this.productId,
    required this.buyerId,
    required this.vendorId,
    required this.data,
  });

  @override
  State<VendorChatScreen> createState() => _VendorChatScreenState();
}

class _VendorChatScreenState extends State<VendorChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  late Stream<QuerySnapshot> _chatStream;

  void _sendMessageToCloud() async {
    DocumentSnapshot buyerDoc =
        await _firestore.collection('buyers').doc(widget.buyerId).get();
    DocumentSnapshot vendorDoc =
        await _firestore.collection('vendors').doc(widget.vendorId).get();
    String message = _messageController.text.trim();

    if (message.isNotEmpty) {
      await _firestore.collection('chats').add({
        'buyerId': widget.buyerId,
        'vendorId': widget.vendorId,
        'senderId': _auth.currentUser!.uid,
        'productId': widget.productId,
        'buyerName': (buyerDoc.data() as Map<String, dynamic>)['fullName'],
        'buyerPhoto':
            (buyerDoc.data() as Map<String, dynamic>)['profileImageUrl'],
        'vendorPhoto':
            (vendorDoc.data() as Map<String, dynamic>)['vendorImageURL'],
        'timeStamp': DateTime.now(),
        'message': message,
      }).whenComplete(() {
        _messageController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _chatStream = _firestore
        .collection('chats')
        .where('buyerId', isEqualTo: widget.buyerId)
        .where('vendorId', isEqualTo: widget.vendorId)
        .where('productId', isEqualTo: widget.productId)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Screen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    String senderId = data['senderId'];
                    bool isBuyer = senderId == widget.buyerId;
                    String senderType = isBuyer ? 'Customer' : 'Vendor';
                    return Column(
                      crossAxisAlignment: isBuyer
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: isBuyer
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['buyerPhoto']),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['vendorPhoto']),
                                ),
                          title: Container(
                            decoration: BoxDecoration(
                                color: isBuyer
                                    ? Colors.yellow.shade900
                                    : Colors.yellow.shade200,
                                borderRadius: isBuyer
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12))
                                    : BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12))),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  data['message'],
                                  style: TextStyle(
                                      color: isBuyer
                                          ? Colors.white
                                          : Colors.black54),
                                ),
                              ),
                            ),
                          ),
                          subtitle: Text(
                            'Sent by ' + senderType,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Type message here...',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessageToCloud,
                  icon: Icon(
                    Icons.send,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
