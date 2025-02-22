import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class VendorOrderScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatDate(date) {
    final outputDateFormat = DateFormat('dd/mm/yyyy');

    final outputDate = outputDateFormat.format(date);

    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order',
          style: TextStyle(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _orderStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Slidable(
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await _firestore
                            .collection('orders')
                            .doc(data['orderId'])
                            .update(
                          {'accepted': false},
                        );
                      },
                      backgroundColor: Colors.yellow.shade900,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Reject',
                      flex: 2,
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        await _firestore
                            .collection('orders')
                            .doc(data['orderId'])
                            .update(
                          {'accepted': true},
                        );
                      },
                      flex: 2,
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.check_circle,
                      label: 'Accept',
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: data['accepted'] == true
                            ? Icon(Icons.delivery_dining)
                            : Icon(Icons.access_time),
                      ),
                      title: data['accepted'] == true
                          ? Text(
                              'Accepted',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              'Not Accepted',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      trailing: Text(
                        '\$' + data['price'].toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        'Order details',
                        style: TextStyle(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                      subtitle: Text('View Order Details'),
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Image.network(data['productImage'][0]),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['productName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data['requestedQuantity'].toString(),
                                    style: TextStyle(
                                      color: Colors.yellow.shade900,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          subtitle: ListTile(
                            title: Text(
                              'Buyer Details',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['fullName'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['email'],
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Order date:' +
                                      ' ' +
                                      formatDate(
                                        data['dateTime'].toDate(),
                                      ),
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
