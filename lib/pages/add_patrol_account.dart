import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/add_account_dialog.dart';
import 'package:sentinex/custom_widgets/edit_text_widget.dart';
import 'package:sentinex/main.dart';
import 'package:sentinex/models/patrol_account_details.dart';

import 'package:sentinex/utils/my_colors.dart';
import 'package:sentinex/views/accounts_items.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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

  late List<PatrolAccountDetails> _employees;
  late EmployeeDataSource _employeeDataSource;
  late DataGridController _dataGridController;

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
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        _patrolAccounts = List.from(
            querySnapshot.docs.map((e) => PatrolAccountDetails.fromSnap(e)));
        if (_patrolAccounts.isEmpty) {
          _isLoadingList = false;
          showSnackBar(context, "No Patrol Accounts Found");
        } else {
          _isLoadingList = false;
          _employees = getEmployeeData();
          _employeeDataSource = EmployeeDataSource(_employees);
        }
      });
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
              : table_1(context),
          // table_1(context),
        ],
      ),
    );
  }

  Padding table_1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1000,
        child: SingleChildScrollView(
          child: _isLoadingList
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : SfDataGrid(
                  allowFiltering: true,
                  columnResizeMode: ColumnResizeMode.onResize,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.auto,
                  columnWidthCalculationRange:
                      ColumnWidthCalculationRange.allRows,
                  allowSorting: true,
                  selectionMode: SelectionMode.multiple,
                  source: _employeeDataSource,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'name',
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Name',
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                    GridColumn(
                        columnName: 'badge_number',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Badge Number',
                              overflow: TextOverflow.fade,
                            ))),
                    GridColumn(
                        columnName: 'deployment',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Deployment',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'image_evidence',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Image Evidence',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'location',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Location',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'station',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Station',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'status',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Status',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'timestamp',
                        label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Timestamp',
                              overflow: TextOverflow.ellipsis,
                            ))),
                  ],
                ),
        ),
      ),
    );
  }

  List<PatrolAccountDetails> getEmployeeData() {
    return [
      for (var i = 0; i < _patrolAccounts.length; i++)
        PatrolAccountDetails(
          name: (_patrolAccounts[i] as PatrolAccountDetails).name,
          badge_number:
              (_patrolAccounts[i] as PatrolAccountDetails).badge_number,
          deployment: (_patrolAccounts[i] as PatrolAccountDetails).deployment,
          image_evidence:
              (_patrolAccounts[i] as PatrolAccountDetails).image_evidence,
          location: (_patrolAccounts[i] as PatrolAccountDetails).location,
          station: (_patrolAccounts[i] as PatrolAccountDetails).station,
          status: (_patrolAccounts[i] as PatrolAccountDetails).status,
          timestamp: (_patrolAccounts[i] as PatrolAccountDetails).timestamp,
        ),
    ];
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<PatrolAccountDetails> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(
                  columnName: 'badge_number', value: dataGridRow.badge_number),
              DataGridCell<String>(
                  columnName: 'deployment', value: dataGridRow.deployment),
              DataGridCell<String>(
                  columnName: 'image_evidence',
                  value: dataGridRow.image_evidence),
              DataGridCell<String>(
                  columnName: 'location',
                  value: dataGridRow.location.toString()),
              DataGridCell<String>(
                  columnName: 'station', value: dataGridRow.station),
              DataGridCell<String>(
                  columnName: 'status', value: dataGridRow.status),
              DataGridCell<String>(
                  columnName: 'timestamp',
                  value: dataGridRow.timestamp.toDate().toString()),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: (dataGridCell.columnName == 'name' ||
                  dataGridCell.columnName == 'badge_number')
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }
}
