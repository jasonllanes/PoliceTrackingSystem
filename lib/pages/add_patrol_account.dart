import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentinex/custom_widgets/add_account_dialog.dart';
import 'package:sentinex/custom_widgets/delete_prompt.dart';
import 'package:sentinex/custom_widgets/edit_text_widget.dart';
import 'package:sentinex/main.dart';
import 'package:sentinex/models/patrol_account_details.dart';

import 'package:sentinex/utils/my_colors.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as helper;

import '../custom_widgets/edit_account_dialog.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class Add_Patrol_Account extends StatefulWidget {
  const Add_Patrol_Account({key});

  @override
  State<Add_Patrol_Account> createState() => _Add_Patrol_AccountState();
}

class _Add_Patrol_AccountState extends State<Add_Patrol_Account> {
  List<Object> _patrolAccounts = [];

  MyColors my_colors = MyColors();
  bool _isLoading = false;
  bool _isLoadingList = false;

  late List<PatrolAccountDetails> _employees;
  late EmployeeDataSource _employeeDataSource = EmployeeDataSource([]);
  late DataGridController _dataGridController;

  final TextEditingController _patrolNameController = TextEditingController();
  final TextEditingController _patrolBadgeNumberController =
      TextEditingController();

  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  Future<void> exportDataGridToExcel() async {
    final helper.Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "Account_Report.xlsx")
      ..click();
  }

  Future viewAllPatrolAccounts({bool filterByStatus = true}) async {
    setState(() {
      _isLoadingList = true;
    });

    if (filterByStatus) {
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
    } else {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("Logs")
          .where("status", isEqualTo: "Timed In")
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
    return Scaffold(
      backgroundColor: my_colors.oxfordBlue,
      body: Center(
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
                          return DialogAddAccount();
                        },
                      );
                    },
                    color: my_colors.royalBlue,
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
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: MaterialButton(
                    onPressed: exportDataGridToExcel,
                    color: my_colors.royalBlue,
                    minWidth: 300,
                    height: 50,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Export Table",
                            style: TextStyle(color: Colors.white),
                          ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            //Add a 2 tabs here which are All Users and All Deployed Users
            _isLoadingList
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            viewAllPatrolAccounts(filterByStatus: true);
                          },
                          color: my_colors.primaryColor2,
                          minWidth: 300,
                          height: 50,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "All Patrol Accounts",
                                  style: TextStyle(color: Colors.white),
                                ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            viewAllPatrolAccounts(filterByStatus: false);
                          },
                          color: my_colors.primaryColor2,
                          minWidth: 300,
                          height: 50,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "All Deployed Patrol Accounts",
                                  style: TextStyle(color: Colors.white),
                                ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
            _isLoadingList
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : table_1(context),
            // table_1(context),
          ],
        ),
      ),
    );
  }

  Padding table_1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 1500,
        height: 400,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: _isLoadingList
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: my_colors.pictonBlue,
                    gridLineColor: MyColors().pictonBlue,
                    selectionColor: my_colors.pictonBlue,
                    rowHoverColor: const Color.fromARGB(255, 155, 155, 155),
                  ),
                  child: SfDataGrid(
                    key: _key,
                    allowFiltering: true,
                    allowColumnsResizing: true,
                    isScrollbarAlwaysShown: true,
                    columnResizeMode: ColumnResizeMode.onResize,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: ColumnWidthMode.auto,
                    columnWidthCalculationRange:
                        ColumnWidthCalculationRange.allRows,
                    allowSorting: true,
                    selectionMode: SelectionMode.none,
                    source: _employeeDataSource,
                    onCellDoubleTap: (arg) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EditAccountDialog(
                            image_link: (_patrolAccounts[
                                        arg.rowColumnIndex.rowIndex - 1]
                                    as PatrolAccountDetails)
                                .image_evidence,
                            badge_number: (_patrolAccounts[
                                        arg.rowColumnIndex.rowIndex - 1]
                                    as PatrolAccountDetails)
                                .badge_number,
                            first_name: (_patrolAccounts[
                                        arg.rowColumnIndex.rowIndex - 1]
                                    as PatrolAccountDetails)
                                .first_name,
                            last_name: (_patrolAccounts[
                                        arg.rowColumnIndex.rowIndex - 1]
                                    as PatrolAccountDetails)
                                .last_name,
                            rank: (_patrolAccounts[arg.rowColumnIndex.rowIndex -
                                    1] as PatrolAccountDetails)
                                .rank,
                          );
                        },
                      );
                    },
                    onCellLongPress: (arg) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteAccount(
                              badge_number: (_patrolAccounts[
                                          arg.rowColumnIndex.rowIndex - 1]
                                      as PatrolAccountDetails)
                                  .badge_number);
                        },
                      );
                    },
                    columns: <GridColumn>[
                      GridColumn(
                          columnName: 'name',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                              style: TextStyle(color: Colors.white),
                              'Name',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          columnName: 'rank',
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              style: TextStyle(color: Colors.white),
                              'Rank',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          columnName: 'badge_number',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                style: TextStyle(color: Colors.white),
                                'Badge Number',
                                overflow: TextOverflow.fade,
                              ))),
                      GridColumn(
                          columnName: 'deployment',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                style: TextStyle(color: Colors.white),
                                'Deployment',
                                overflow: TextOverflow.ellipsis,
                              ))),
                      // GridColumn(
                      //     columnName: 'image_evidence',
                      //     label: Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 16.0),
                      //         alignment: Alignment.centerLeft,
                      //         child: Text(
                      //           'Image Evidence',
                      //           overflow: TextOverflow.ellipsis,
                      //         ))),
                      GridColumn(
                          columnName: 'location',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                style: TextStyle(color: Colors.white),
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
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridColumn(
                          columnName: 'status',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Status',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridColumn(
                          columnName: 'timestamp',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Timestamp',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridColumn(
                          columnName: 'last_updated',
                          label: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Last Updated',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ))),
                    ],
                  ),
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
          first_name: (_patrolAccounts[i] as PatrolAccountDetails).first_name,
          last_name: (_patrolAccounts[i] as PatrolAccountDetails).last_name,
          rank: (_patrolAccounts[i] as PatrolAccountDetails).rank,
          badge_number:
              (_patrolAccounts[i] as PatrolAccountDetails).badge_number,
          deployment: (_patrolAccounts[i] as PatrolAccountDetails).deployment,
          image_evidence:
              (_patrolAccounts[i] as PatrolAccountDetails).image_evidence,
          location: (_patrolAccounts[i] as PatrolAccountDetails).location,
          station: (_patrolAccounts[i] as PatrolAccountDetails).station,
          status: (_patrolAccounts[i] as PatrolAccountDetails).status,
          timestamp: (_patrolAccounts[i] as PatrolAccountDetails).timestamp,
          lastUpdated: (_patrolAccounts[i] as PatrolAccountDetails).lastUpdated,
        ),
    ];
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<PatrolAccountDetails> employees) {
    dataGridRows = employees
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
              DataGridCell<String>(columnName: 'rank', value: dataGridRow.rank),
              DataGridCell<String>(
                  columnName: 'badge_number', value: dataGridRow.badge_number),
              DataGridCell<String>(
                  columnName: 'deployment', value: dataGridRow.deployment),
              // DataGridCell<String>(
              //     columnName: 'image_evidence',
              //     value: dataGridRow.image_evidence),
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
              DataGridCell<String>(
                  columnName: 'last_updated',
                  value: dataGridRow.lastUpdated.toDate().toString()),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  @override
  List<DataGridRow> get rows => dataGridRows;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: MyColors().secondaryColor,
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: (dataGridCell.columnName == 'name' ||
                      dataGridCell.columnName == 'rank')
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Text(
                dataGridCell.value.toString(),
                maxLines: 1,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }
}
