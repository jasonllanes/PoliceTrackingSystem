//import material
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/my_colors.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    MyColors my_colors = MyColors();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
      ),
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            color: my_colors.primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        print('Home clicked');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Home'),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        print('Deployments clicked');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Deployments'),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: my_colors.primaryColor,
                        textStyle: TextStyle(color: my_colors.secondaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () {
                        print('Exit clicked');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Exit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
