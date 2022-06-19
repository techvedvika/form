import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:form/Controllers/da_controller.dart';
import 'package:form/Controllers/networ_Controller.dart';
import 'package:form/Controllers/offlineHandler.dart';
import 'package:form/Controllers/pendingExpenses_Controller.dart';
import 'package:form/Controllers/school_Controller.dart';
import 'package:form/Controllers/stockdispatch_controller.dart';
import 'package:form/Controllers/stockpurchase_controller.dart';
import 'package:form/Controllers/tourController.dart';
import 'package:form/Controllers/userTaskController.dart';
import 'package:form/Model/expense_model.dart';
import 'package:form/collectionForm/schoolEnrollment.dart';
import 'package:form/da_form.dart';

import 'package:form/forms/issue_tracker.dart';
import 'package:form/forms/stockdistribution.dart';
import 'package:form/forms/stockpurchase.dart';

import 'package:form/pendingScreen.dart';
import 'package:form/syncData_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import 'Controllers/tab.dart';
import 'colors.dart';
import 'form.dart';
import 'forms/expense_claim.dart';
import 'forms/tour_da.dart';
import 'forms/travel_Requisition.dart';
import 'login.dart';

import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Color shimmer_base = Colors.grey.shade200;

Color shimmer_highlighted = Colors.grey.shade500;

final GetXNetworkManager _networkManager = Get.put(GetXNetworkManager());
final OfflineHandler offlineHandler = Get.put(OfflineHandler());

final StateController stateController = Get.put(StateController());
final DistrictController districtController = Get.put(DistrictController());
final BlockController blockController = Get.put(BlockController());
final SchoolController schoolController = Get.put(SchoolController());
final StaffController staffController = Get.put(StaffController());
final AuthorityController authController = Get.put(AuthorityController());
final PendingController pendingController = Get.put(PendingController());
final StockPurchaseController stockController =
    Get.put(StockPurchaseController());
final StockDispatchController stockdispatchController =
    Get.put(StockDispatchController());
// final FormController formController= Get.put(FormController());
final TaskController taskController = Get.put(TaskController());
final TourController tourController = Get.put(TourController());
final DaController daController = Get.put(DaController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool syncinProgress = false;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    stateController.fetchState();
    authController.fetchAuth();
    schoolController.fetchSchool();
    pendingController.fetchPending();
    stockController.fetchStockRecieved();
    stockdispatchController.fetchStockDispatch();
    //staffController.fetchStaff(GetStorage().read('office').toString());
    //formController.fetchForms();
    schoolController.fetchTour();
    taskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    _networkManager.GetConnectionType();
    return GetBuilder<GetXNetworkManager>(
        init: GetXNetworkManager(),
        builder: (networkManager) {
          networkManager.GetConnectionType();

          return RefreshIndicator(
            key: const Key('__RIKEY1__'),
            onRefresh: () async {
              await networkManager.GetConnectionType();
            },
            child: Scaffold(
              drawer: Drawer(
                  child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: MyColors.primary,
                    ),
                    accountName: Text(GetStorage().read("username").toString()),
                    accountEmail: Text(GetStorage().read("role").toString() +
                        '(' +
                        GetStorage().read("office").toString() +
                        ')'),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                          GetStorage()
                              .read("username")
                              .toString()
                              .split('')[0]
                              .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 40.0, color: Colors.black)),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.data_saver_on),
                      title: const Text(
                        'Data to be Synced',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Get.to(() => const SyncData());
                      },
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.center_focus_strong),
                      title: Text(
                        GetStorage()
                                    .read('officeList')
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .split(',')[0] ==
                                'null'
                            ? 'Item 2'
                            : 'Change Office',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        if (GetStorage()
                                .read('officeList')
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .split(',')[0] !=
                            'null') {
                          showDailog(context, daController.officeList);
                        }
                      },
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.comment_outlined),
                      title: const Text(
                        'Form Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Get.to(() => const StatusPage());
                      },
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.comment_outlined),
                      title: const Text(
                        'Item 4',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        'Log out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        GetStorage().write('isLogged', false);
                        GetStorage().remove('username');
                        GetStorage().remove('role');
                        GetStorage().remove('userId');
                        GetStorage().remove('office');
                        GetStorage().remove('officeList');

                        Get.offAll(() => Signin2Page());
                      },
                    ),
                  ),
                ],
              )),
              backgroundColor: const Color.fromRGBO(211, 194, 169, 1),
              appBar: AppBar(
                elevation: 0,
                iconTheme: const IconThemeData(color: MyColors.primary),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.logout_sharp),
                    onPressed: () {
                      GetStorage().write('isLogged', false);
                      GetStorage().remove('username');
                      GetStorage().remove('role');
                      GetStorage().remove('userId');
                      GetStorage().remove('office');
                      GetStorage().remove('officeList');

                      Get.offAll(() => Signin2Page());
                    },
                  ),
                ],
                backgroundColor: const Color.fromRGBO(211, 194, 169, 1),
                title: networkManager.connectionType.value == 0
                    ? const Text('Your are Offline',
                        style: TextStyle(color: MyColors.primary, fontSize: 20))
                    : const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          '17000 Ft Foundation',
                          style:
                              TextStyle(color: MyColors.primary, fontSize: 20),
                        ),
                      ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/17000ft.jpg',
                        fit: BoxFit.contain,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome to the 17000 Ft Foundation',
                            style: TextStyle(
                                color: MyColors.primary, fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          networkManager.connectionType.value == 0
                              ? const Center(
                                  child: Text(
                                  'No Internet(You are Offline)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: MyColors.primary,
                                  ),
                                ))
                              : GridviewWithBuilderPage()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// class ColumnGrid2 extends StatelessWidget {
//   const ColumnGrid2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Color> _color = [
//       Colors.white,
//       Colors.white,
//       Colors.white,
//       Colors.white,
//       Colors.white,
//       Colors.white,
//       Colors.white,
//     ];
//     return Padding(
//       padding: const EdgeInsets.only(top: 15.0),
//       child: ListView(
//         physics: const NeverScrollableScrollPhysics(),
//         children: List.generate(formController.finalformname!.length, (index) {
//           Color bg = _color[index % _color.length];
//           var no = index + 1;
//           return InkWell(
//             onTap: () {
//               if (index == 0) {
//                 Get.to(() => Form1());
//               } else if (index == 1) {
//                 Get.to(() => const PendingScreen());
//               } else if (index == 2) {
//                 Get.to(() => const DaForm());
//               }
//               // } else if (index == 2) {
//               //   Get.to(() => const TourBudget());
//               // }else if (index == 3) {
//               //   Get.to(() => const DaForm());
//               // }
//             },
//             child: Container(
//                 height: 100,
//                 decoration: BoxDecoration(
//                     color: bg, borderRadius: BorderRadius.circular(10.0)),
//                 margin: const EdgeInsets.all(6.0),
//                 child: Center(
//                   child: Text(formController.finalformname![index],
//                       style: const TextStyle(
//                           color: MyColors.primary,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold)),
//                 )),
//           );
//         }),
//       ),
//     );
//   }
// }

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (_networkManager.connectionType.value == 1) {
        return true;
      } else {
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (_networkManager.connectionType.value == 2) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<int> addData(ExpenseModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 1;
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.expenseinfoTable, contactinfoModel.toJson());
    } catch (e) {}
    return result;
  }

  Future<int> updateData(ExpenseModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result = 1;
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.expenseinfoTable, contactinfoModel.toJson(),
          where: 'id=?', whereArgs: [contactinfoModel.tourId]);
    } catch (e) {}
    return result;
  }

  Future fetchData() async {
    var dbclient = await conn.db;
    List expenseList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient
          .query(SqfliteDatabaseHelper.expenseinfoTable, orderBy: 'id DESC');
      for (var item in maps) {
        if (item['userId'] == GetStorage().read('userId').toString()) {
          expenseList.add(item);
        }
      }
    } catch (e) {}
    return expenseList;
  }
}

class SqfliteDatabaseHelper {
  SqfliteDatabaseHelper.internal();
  static final SqfliteDatabaseHelper instance =
      SqfliteDatabaseHelper.internal();
  factory SqfliteDatabaseHelper() => instance;

  static const expenseinfoTable = 'expenseinfoTable';
  static const _version = 1;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<int> delete(String tableName,
      {String? where, List<dynamic>? whereArgs}) async {
    return _db!.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'syncdatabase.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $expenseinfoTable   (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          office TEXT NOT NULL, 
          submissionDate TEXT NOT NULL, 
          tourID TEXT NOT NULL, 
          vendorName TEXT NOT NULL, 
          invoiceNumber TEXT NOT NULL,
          invoiceDate TEXT NOT NULL,
          invoiceAmount TEXT NOT NULL,
          towardsCost TEXT NOT NULL,
          expenseHead TEXT NOT NULL,
          projectName TEXT NOT NULL,
          sponsorName TEXT NOT NULL,
          expenseBy TEXT NOT NULL,
          expenseApprovedBy TEXT NOT NULL,
          invoiceImage TEXT NOT NULL,
          dateOfPayment TEXT NOT NULL,
          paidBy TEXT NOT NULL,
          paymentApprovedBy TEXT NOT NULL,
          paidAmount TEXT NOT NULL,
          paymentType TEXT NOT NULL,
          paymentMode TEXT NOT NULL,
          userId TEXT NOT NULL
          )''');
    }, onUpgrade: (Database db, int oldversion, int newversion) async {
      if (oldversion < newversion) {}
    });
    return openDb;
  }
}

class SyncronizationData {
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (_networkManager.connectionType.value != 0) {
        return true;
      } else {
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (_networkManager.connectionType.value != 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  final conn = SqfliteDatabaseHelper.instance;

  Future<List<ExpenseModel>> fetchAllInfo() async {
    final dbClient = await conn.db;
    List<ExpenseModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.expenseinfoTable);
      for (var item in maps) {
        if (item['userId'] == GetStorage().read('userId').toString()) {
          contactList.add(ExpenseModel.fromJson(item));
        }
      }
    } catch (e) {}
    return contactList;
  }

  Future saveToMysqlWith(List<ExpenseModel> expenseList) async {
    for (var i = 0; i < expenseList.length; i++) {
      Map<String, dynamic> data = {
        "office": expenseList[i].office,
        "submission_date": expenseList[i].submissionDate,
        "tour_id": expenseList[i].tourId,
        "vendor_name": expenseList[i].vendorName,
        "invoice_no": expenseList[i].invoiceNumber,
        "date_of_invoice": expenseList[i].invoiceDate,
        "invoice_amt": expenseList[i].invoiceAmount,
        "towards_cost_of": expenseList[i].towardsCost,
        "expense_head": expenseList[i].expenseHead,
        "project": expenseList[i].projectName,
        "sponsor": expenseList[i].sponsorName,
        "expense_by": expenseList[i].expenseBy,
        "expense_approved_by": expenseList[i].expenseApprovedBy,
        "image": expenseList[i].invoiceImage,
        "date_of_payment": expenseList[i].dateOfPayment,
        "paid_by": expenseList[i].paidBy,
        "payment_approved_by": expenseList[i].paymentApprovedBy,
        "paid_amt": expenseList[i].paidAmount,
        "type_of_payment": expenseList[i].paymentType,
        "mode_of_payment": expenseList[i].paymentMode,
        "uid": expenseList[i].userId,
      };
      var response = await http.post(Uri.parse(MyColors.baseUrl + 'expense'),
          headers: {"Accept": "Application/json"}, body: data);
      if (response.statusCode == 200) {
        SqfliteDatabaseHelper().delete(SqfliteDatabaseHelper.expenseinfoTable,
            where: 'tourId=?', whereArgs: [expenseList[i].tourId]);
      } else {}
    }
  }

  Future<List> fetchAllCustomerInfo() async {
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.expenseinfoTable);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {}
    return contactList;
  }
}

class GridviewWithBuilderPage extends StatefulWidget {
  @override
  _GridviewWithBuilderPageState createState() =>
      _GridviewWithBuilderPageState();
}

class _GridviewWithBuilderPageState extends State<GridviewWithBuilderPage> {
  // initialize global widget
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        init: TaskController(),
        builder: (taskController) {
          return taskController.isLoading
              ? GridView.builder(
                  itemCount: 6,
                  controller: ScrollController(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 35.0,
                  ),
                  padding: const EdgeInsets.all(8),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: shimmer_base,
                      highlightColor: shimmer_highlighted,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: const Offset(0, 3))
                            ]),
                        height: 50,
                        width: 60,
                      ),
                    );
                  },
                )
              : taskController.taskList!.isEmpty
                  ? const Center(
                      child: Text(
                          'No Task Assigned to you\n Please Contact Admin'))
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: taskController.taskList!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        childAspectRatio: 1.5,
                        mainAxisSpacing: 35.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            if (taskController.taskList![index].formName! ==
                                'Daily Allowance') {
                              Get.to(() => const DaForm());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Expense Form') {
                              Get.to(() => const Form1());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Pending Payments') {
                              Get.to(() => const PendingScreen());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Tour Budget') {
                              //   Get.to(() => const TourBudget());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Tour DA') {
                              Get.to(() => const TourDa());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Stock Recieved') {
                              Get.to(() => const StockPurchase());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Stock Distribution') {
                              Get.to(() => const StockDistribution());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Issue Tracker') {
                              Get.to(() => IssueTracker());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Expense Claim Form') {
                              Get.to(() => const ExpenseClaimForm());
                            } else if (taskController
                                    .taskList![index].formName! ==
                                'Travel Requisition Form') {
                              Get.to(() => const TravelRequisition());
                            }else if (taskController
                                    .taskList![index].formName! ==
                                'School Enrollment Form') {
                              Get.to(() => const SchoolEnrollment());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 4,
                                      offset: const Offset(0, 3))
                                ]),
                            child: Center(
                              child: Text(
                                taskController.taskList![index].formName!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: MyColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      });
        });
  }
}

// buildShimmer({scontroller, item_count = 6}) {
//   return GridView.builder(
//     itemCount: item_count,
//     controller: scontroller,
//     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//       childAspectRatio: (1 / 1.2),
//       crossAxisCount: 3,
//       mainAxisSpacing: 10,
//       crossAxisSpacing: 10,
//     ),
//     padding: EdgeInsets.all(8),
//     physics: NeverScrollableScrollPhysics(),
//     shrinkWrap: true,
//     itemBuilder: (context, index) {
//       return Shimmer.fromColors(
//         baseColor: shimmer_base,
//         highlightColor: shimmer_highlighted,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(color: Colors.white, spreadRadius: 4, blurRadius: 60)
//             ],
//           ),
//           height: 50,
//           width: 60,
//         ),
//       );
//     },
//   );
// }

buildFieldShimmer(BuildContext context) {
  return Flexible(
    child: Shimmer.fromColors(
      baseColor: shimmer_base,
      highlightColor: shimmer_highlighted,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 4,
                  offset: const Offset(0, 3))
            ]),
        height: 30,
      ),
    ),
  );
}
