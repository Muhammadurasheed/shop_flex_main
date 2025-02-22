import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_flex/controllers/auth_controller.dart';
import 'package:shop_flex/controllers/text_form_field_controller.dart';
import 'package:shop_flex/views/screens/auths/customer_register_screen.dart';
import 'package:shop_flex/views/screens/map_screen.dart';

class CustomerLoginScreen extends StatefulWidget {
  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  late String email;

  late String password;

  bool _isLoading = false;

  _loginUser() async {
    String result = await _authController.loginUser(email, password);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      if (result == 'success') {
        setState(() {
          _isLoading = true;
        });
        Get.to(MapScreen());
        Get.snackbar('Logged In', 'Logged in successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar('Error occured', result.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      return 'not valid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              CreateTextFormField(
                validationWarning: 'Email field cannot be empty',
                fieldIcon: Icon(
                  Icons.email,
                  color: Colors.yellow.shade900,
                ),
                label: 'Email',
                hintText: 'Enter your eamil...',
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 25,
              ),
              CreateTextFormField(
                validationWarning: 'Enter a valid password',
                fieldIcon: Icon(
                  Icons.lock,
                  color: Colors.yellow.shade900,
                ),
                label: 'Password',
                hintText: 'Enter your password...',
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  _loginUser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CustomerRegisterScreen();
                        },
                      ),
                    );
                  },
                  child: Text('Need an account?')),
            ],
          ),
        ),
      ),
    );
  }
}
