import 'package:flutter/material.dart';
import 'package:sentinex/resources/auth_methods.dart';
import 'package:sentinex/utils/my_colors.dart';
import 'package:sentinex/pages/dashboard.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  MyColors my_colors = MyColors();

  bool _obscureText = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          color: my_colors.primaryColor,
          margin: const EdgeInsets.all(30),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(58.0),
            child: Container(
              width: 300,
              height: 500,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "SentiNex",
                    style: TextStyle(
                      color: my_colors.secondaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Image(
                    image: AssetImage("assets/images/sentinex_logo.png"),
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hoverColor: my_colors.secondaryColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: my_colors.secondaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: my_colors.secondaryColor,
                          ),
                        ),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: my_colors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _passwordController,
                      style: TextStyle(
                        color: my_colors.secondaryColor,
                      ),
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: my_colors.secondaryColor,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: my_colors.secondaryColor,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: my_colors.secondaryColor,
                        ),
                        labelText: 'Password',
                        hintStyle: TextStyle(
                          color: my_colors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: my_colors.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          onPressed: () async {
                            String res = await MAuthMethods().singUpUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            print(res);
                          },

                          // {

                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Dashboard()),
                          //   );
                          // },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: my_colors.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
