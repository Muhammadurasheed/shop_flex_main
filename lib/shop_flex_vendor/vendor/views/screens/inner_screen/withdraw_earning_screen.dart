import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class WithdrawEarningScreen extends StatefulWidget {
  @override
  State<WithdrawEarningScreen> createState() => _WithdrawEarningScreenState();
}

class _WithdrawEarningScreenState extends State<WithdrawEarningScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late String accountName;

  late String bankName;

  late String accountNumber;

  late String amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw Earnings'),
        iconTheme: IconThemeData(color: Colors.yellow.shade900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  bankName = value;
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Bank Name',
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500),
                    hintText: 'Enter Bank Name..'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  accountName = value;
                },
                decoration: InputDecoration(
                    labelText: 'Account Name',
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500),
                    hintText: 'Enter account Name..'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  accountNumber = value;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Account Number',
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500),
                    hintText: 'Enter account number..'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  amount = value;
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500),
                    hintText: 'Enter amount..'),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  DocumentSnapshot userDoc = await _firestore
                      .collection('vendors')
                      .doc(_auth.currentUser!.uid)
                      .get();
                  if (_formkey.currentState!.validate()) {
                    final withdrawalId = Uuid().v4();
                    EasyLoading.show(status: 'processing');
                    await _firestore
                        .collection('withdrawals')
                        .doc(withdrawalId)
                        .set({
                      'bankName': bankName,
                      'accountNumber': accountNumber,
                      'amount': amount,
                      'accountName': accountName,
                      'businessName':
                          (userDoc.data() as Map<String, dynamic>)['businessName']
                    }).whenComplete(() {
                      EasyLoading.showSuccess('Completed');
                    });
                  } else {
                    print('bad');
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade900,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text('Get Cash',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 4,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
