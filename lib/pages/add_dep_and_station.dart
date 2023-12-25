import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/add_account_dialog.dart';
import 'package:sentinex/custom_widgets/delete_deployment_prompt.dart';
import 'package:sentinex/custom_widgets/edit_text_widget.dart';
import 'package:sentinex/main.dart';
import 'package:sentinex/models/patrol_account_details.dart';

import 'package:sentinex/utils/my_colors.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as helper;

import '../custom_widgets/add_deployement.dart';
import '../custom_widgets/add_station.dart';
import '../custom_widgets/delete_station_prompt.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class Add_Dep_And_Station extends StatefulWidget {
  const Add_Dep_And_Station({key});

  @override
  State<Add_Dep_And_Station> createState() => _Add_Dep_And_StationState();
}

List<String> _listStations = [""];
List<String> _listDeployments = [""];

List<Offset> pointList = <Offset>[];
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rankSelected = "";

class _Add_Dep_And_StationState extends State<Add_Dep_And_Station> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

  Future<List<String>> fetchStations() async {
    List<String> list = [];
    await _firestore.collection('Dropdown').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        List<String> stations = List<String>.from(result.data()['stations']);
        list.addAll(stations);
      });
    });
    return list;
  }

  Future<List<String>> fetchDeployments() async {
    List<String> list = [];
    await _firestore.collection('Dropdown').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        List<String> stations = List<String>.from(result.data()['deployments']);
        list.addAll(stations);
      });
    });
    return list;
  }

  @override
  void initState() {
    super.initState();

    fetchStations().then((list) => setState(() {
          _listStations = list;
        }));
    fetchDeployments().then((list) => setState(() {
          _listDeployments = list;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogAddDeployment();
                      },
                    );
                  },
                  color: my_colors.primaryColor,
                  minWidth: 300,
                  height: 50,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Add a new Deployment",
                          style: TextStyle(color: Colors.white),
                        ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogAddStation();
                      },
                    );
                  },
                  color: my_colors.primaryColor,
                  minWidth: 300,
                  height: 50,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Add a new Station",
                          style: TextStyle(color: Colors.white),
                        ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Dropdown').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Deployments',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data!.docs[index];
                                  List deployment = ds['deployments'];

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: deployment.length,
                                    itemBuilder: (context, stationIndex) {
                                      return GestureDetector(
                                        onTap: () {
                                          print(deployment[stationIndex]);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteDeployment(
                                                deployment:
                                                    deployment[stationIndex],
                                              );
                                            },
                                          );
                                        },
                                        child: Card(
                                          color: MyColors().primaryColor,
                                          child: ListTile(
                                            title:
                                                Text(deployment[stationIndex]),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('Stations',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data!.docs[index];
                                  List stations = ds['stations'];

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: stations.length,
                                    itemBuilder: (context, stationIndex) {
                                      return GestureDetector(
                                        onTap: () {
                                          print(stations[stationIndex]);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteStation(
                                                station: stations[stationIndex],
                                              );
                                            },
                                          );
                                        },
                                        child: Card(
                                          color: MyColors().primaryColor,
                                          child: ListTile(
                                            title: Text(stations[stationIndex]),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
