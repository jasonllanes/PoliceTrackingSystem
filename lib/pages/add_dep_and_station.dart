import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/add_account_dialog.dart';
import 'package:sentinex/custom_widgets/edit_text_widget.dart';
import 'package:sentinex/main.dart';
import 'package:sentinex/models/patrol_account_details.dart';

import 'package:sentinex/utils/my_colors.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as helper;

import '../custom_widgets/add_deployement.dart';
import '../custom_widgets/add_station.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class Add_Dep_And_Station extends StatefulWidget {
  const Add_Dep_And_Station({key});

  @override
  State<Add_Dep_And_Station> createState() => _Add_Dep_And_StationState();
}

class _Add_Dep_And_StationState extends State<Add_Dep_And_Station> {
  MyColors my_colors = MyColors();
  bool _isLoading = false;

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
          const CircularProgressIndicator(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
