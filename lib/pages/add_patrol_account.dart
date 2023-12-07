import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/add_account_dialog.dart';
import 'package:sentinex/custom_widgets/edit_text_widget.dart';
import 'package:sentinex/models/patrol_account_details.dart';
import 'package:sentinex/utils/my_colors.dart';
import 'package:sentinex/views/accounts_items.dart';

import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class Add_Patrol_Account extends StatefulWidget {
  const Add_Patrol_Account({super.key});

  @override
  State<Add_Patrol_Account> createState() => _Add_Patrol_AccountState();
}

class _Add_Patrol_AccountState extends State<Add_Patrol_Account> {
  List<Object> _patrolAccounts = [];

  MyColors my_colors = MyColors();
  bool _isLoading = false;
  bool _isLoadingList = false;
  bool sortAscending = true;

  final TextEditingController _patrolNameController = TextEditingController();
  final TextEditingController _patrolBadgeNumberController =
      TextEditingController();

  Future viewAllPatrolAccounts() async {
    setState(() {
      _isLoadingList = true;
    });
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .orderBy("timestamp", descending: true)
        .get();

    setState(() {
      _patrolAccounts = List.from(
          querySnapshot.docs.map((e) => PatrolAccountDetails.fromSnap(e)));
      if (_patrolAccounts.isEmpty) {
        _isLoadingList = false;
        showSnackBar(context, "No Patrol Accounts Found");
      } else {
        _isLoadingList = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewAllPatrolAccounts();
  }

  @override
  void dispose() {
    super.dispose();
    _patrolNameController.dispose();
    _patrolBadgeNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: MaterialButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogAddAccount();
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
                      "Add Patrol Account",
                      style: TextStyle(color: Colors.white),
                    ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          _isLoadingList
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 1000,
                    child: SingleChildScrollView(
                      child: DataTable(
                          border: TableBorder.all(
                              color: my_colors.primaryColor, width: 2),
                          sortColumnIndex: 0,
                          showBottomBorder: true,
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => my_colors.primaryColor),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  my_colors.primaryColor.withOpacity(0.2)),
                          dividerThickness: 2,
                          columns: [
                            DataColumn(
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    if (columnIndex == 0) {
                                      if (sortAscending) {
                                        _patrolAccounts.sort((a, b) =>
                                            (a as PatrolAccountDetails)
                                                .name!
                                                .compareTo(
                                                    (b as PatrolAccountDetails)
                                                        .name!));
                                        sortAscending = false;
                                      } else {
                                        _patrolAccounts.sort((a, b) =>
                                            (b as PatrolAccountDetails)
                                                .name!
                                                .compareTo(
                                                    (a as PatrolAccountDetails)
                                                        .name!));
                                        sortAscending = true;
                                      }
                                    }
                                  });
                                },
                                label: Text('Name')),
                            DataColumn(label: Text('Badge Number')),
                            DataColumn(label: Text('Date Created')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                          rows: [
                            for (var i = 0; i < _patrolAccounts.length; i++)
                              DataRow(
                                cells: [
                                  DataCell(
                                    showEditIcon: true,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                              backgroundColor: Colors.white,
                                              child: IntrinsicHeight(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      28.0),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        (_patrolAccounts[i]
                                                                as PatrolAccountDetails)
                                                            .name,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                      );
                                    },
                                    AccountsItems(
                                      accountDetails: _patrolAccounts[i]
                                          as PatrolAccountDetails,
                                      column: "name",
                                    ),
                                  ),
                                  DataCell(
                                    AccountsItems(
                                      accountDetails: _patrolAccounts[i]
                                          as PatrolAccountDetails,
                                      column: "badge_number",
                                    ),
                                  ),
                                  DataCell(
                                    AccountsItems(
                                      accountDetails: _patrolAccounts[i]
                                          as PatrolAccountDetails,
                                      column: "date_created",
                                    ),
                                  ),
                                  DataCell(
                                    AccountsItems(
                                      accountDetails: _patrolAccounts[i]
                                          as PatrolAccountDetails,
                                      column: "delete",
                                    ),
                                  ),
                                  DataCell(
                                    AccountsItems(
                                      accountDetails: _patrolAccounts[i]
                                          as PatrolAccountDetails,
                                      column: "update",
                                    ),
                                  ),
                                ],
                              )
                          ]),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
