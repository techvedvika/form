// ignore_for_file: unnecessary_null_comparison, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:form/Controllers/pendingExpenses_Controller.dart';
import 'package:form/Controllers/school_Controller.dart';
import 'package:form/Controllers/stockdispatch_controller.dart';
import 'package:form/Controllers/stockpurchase_controller.dart';
import 'package:form/Model/state_model.dart' as c;
import 'package:form/custom_dialog.dart';
import 'package:form/forms/tour_da.dart';
import 'package:form/home_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../colors.dart';
import '../data.dart';
import '../my_text.dart';

final StateController _stateController = Get.put(StateController());
final DistrictController _districtController = Get.put(DistrictController());
final BlockController _blockController = Get.put(BlockController());
final StaffController staffController = Get.put(StaffController());
final StockPurchaseController stockController =
    Get.put(StockPurchaseController());
final StockDispatchController stockdispatchController =
    Get.put(StockDispatchController());

class StockPurchase extends StatefulWidget {
  const StockPurchase({Key? key}) : super(key: key);

  @override
  _StockPurchaseState createState() => _StockPurchaseState();
}

class _StockPurchaseState extends State<StockPurchase> {
  TextEditingController _officeController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _daController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _visitController = TextEditingController();
  TextEditingController _purposeController = TextEditingController();
  TextEditingController _noOfDayController = TextEditingController();
  // TextEditingController _qtyController = TextEditingController();
  List<TextEditingController> _qtyControllers = [];

  bool _validatestate = false;
  bool _validateTourId = false;

  bool _validateblock = false;
  bool _validateDistrict = false;
  bool _validateFrom = false;
  bool _validateTo = false;
  bool _validateDA = false;
  bool _validateDays = false;

  bool _validateVisit = false;
  bool _validatePurpose = false;
  String? _districtName;
  String? _state;
  String? _blockName;
  String? _programName;
  String? _fromDate;
  String? _toDate;
  bool? _value = false;

  String? stateValue;
  String? districtValue;
  String? blockValue;
  String? dropdownValue3;
  String? dropdownValue4;
  String? dropdownValue5;
  String? dropdownValue6;
  String? dropdownValue7;
  bool? itemValue;

  int? from;
  int? to;

  var isLoading = false.obs;
  getNumber(int a) {
    return a;
  }

  //bool _validateState = false;

  DateTime selectedDate = DateTime.now(), initialDate = DateTime.now();

  _selectDate(
    BuildContext context,
    TextEditingController date,
    String title,
  ) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale('en', 'IN'),
      context: context,
      initialDate: title == 'to' ? schoolController.from! : DateTime.now(),
      firstDate: title == 'to' ? schoolController.from! : DateTime(2017),
      lastDate: DateTime(2040),
      builder: (context, picker) {
        return Theme(
            data: theme,
            child: picker!);
      },
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        schoolController.setDate(selected, title);
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date.text = formattedDate;
        if (title == 'from') {
          _toController.clear();
        }
        //    (getNumber(int.parse(DateFormat('dd').format(selectedDate))));
      });
    }
  }

  // int daysBetween(DateTime from, DateTime to) {
  //   from = DateTime(from.day);
  //   to = DateTime(to.day);
  //   return (to.difference(from).inHours / 24).round();
  // }

  @override
  void initState() {
    super.initState();

    //  _districtController.fetchDistrict('LADAKH');

    // for (int i = 0; i <= stateController.stateList.data!.length; i++) {
    //   state.add(stateController.stateList.data![i].state!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF8A2724),
          title: const Text(
            'Stock Received',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: GetBuilder<StockDispatchController>(
            init: StockDispatchController(),
            builder: (stockdispatchController) {
              return Obx(
                () => stockdispatchController.isLoading || isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    // ignore: avoid_unnecessary_containers
                    : stockdispatchController.dispatchList.length == 0
                        ? const Center(
                            child: Text(
                            'No Data Found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: stockdispatchController
                                          .dispatchList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        _qtyControllers
                                            .add(TextEditingController());
                                        _qtyControllers[index].text =
                                            stockdispatchController
                                                .dispatchList[index].itemQty!
                                                .toString();

                                        return Column(
                                          children: [
                                            CheckboxListTile(
                                              // Text(stockdispatchController.dispatchList[index].itemQty!.toString())
                                              title: Text(
                                                  stockdispatchController
                                                      .dispatchList[index]
                                                      .itemName!),
                                              // subtitle: Text(stockdispatchController
                                              //     .dispatchList[index].itemQty!
                                              //     .toString()),
                                              subtitle: SizedBox(
                                                width: 400,
                                                child: TextField(
                                                  onSubmitted: (value) {},
                                                  maxLines: 1,
                                                  controller:
                                                      _qtyControllers[index],
                                                  decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              top: -12,
                                                              left: 6),
                                                      // border: new OutlineInputBorder(
                                                      //     borderSide: new BorderSide(
                                                      //         color: Colors.teal)),
                                                      hintText:
                                                          "Enter recieved quantity",
                                                      hintStyle: MyText.body1(
                                                              context)!
                                                          .copyWith(
                                                              color: MyColors
                                                                  .grey_40)),
                                                ),
                                              ),
                                              secondary: const Icon(Icons.list),
                                              autofocus: false,
                                              activeColor: Colors.black,
                                              checkColor: Colors.white,
                                              selected: true,
                                              value: stockdispatchController
                                                  .getitemid
                                                  .contains(
                                                      stockdispatchController
                                                          .dispatchList[index]
                                                          .itemName!),
                                              onChanged: (bool? value) {
                                                stockdispatchController
                                                    .getReceivedItem(
                                                        stockdispatchController
                                                            .dispatchList[index]
                                                            .itemName!
                                                            .toString());
                                                stockdispatchController
                                                    .getReceivedQty(
                                                        _qtyControllers[index]
                                                            .text);
                                                stockdispatchController
                                                    .getPurchaseid(
                                                        stockdispatchController
                                                            .dispatchList[index]
                                                            .purchaseId
                                                            .toString());
                                                stockdispatchController
                                                    .getitemuniqueid(
                                                        stockdispatchController
                                                            .dispatchList[index]
                                                            .itemuniqueId
                                                            .toString());
                                                stockdispatchController
                                                    .getDispatchId(
                                                        stockdispatchController
                                                            .dispatchList[index]
                                                            .dispatchcommonId
                                                            .toString());
                                                // stockdispatchController.getEditQty(
                                                //     _qtyControllers[index].text);

                                                print(_qtyControllers[index]
                                                    .text);

                                                print(stockdispatchController
                                                    .getitemid
                                                    .toString());
                                                print(stockdispatchController
                                                    .getitemqty);
                                                print(stockdispatchController
                                                    .getpurchaseid
                                                    .toString());
                                                print(stockdispatchController
                                                    .getdispatchid
                                                    .toString());
                                                // print(stockdispatchController
                                                //     .geteditqty
                                                //     .toString());

                                                // setState(() {
                                                //   _value = value;
                                                // });
                                              },
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: const Color(0xFF8A2724),
                                            elevation: 0),
                                        child: Text("Submit",
                                            style: MyText.subhead(context)!
                                                .copyWith(color: Colors.white)),
                                        onPressed: () async {
                                          print("hello");
                                          var rsp = await insert_stockrecieve(
                                            GetStorage()
                                                .read('username')
                                                .toString(),
                                            stockdispatchController.getitemid
                                                .toString(),
                                            stockdispatchController.getitemqty
                                                .toString(),
                                            stockdispatchController
                                                .getpurchaseid
                                                .toString(),
                                            stockdispatchController.getuniqueid
                                                .toString(),
                                            stockdispatchController
                                                .getdispatchid
                                                .toString(),
                                            // stockdispatchController.geteditqty
                                            //     .toString(),
                                            GetStorage()
                                                .read('userId')
                                                .toString(),
                                          );
                                          if (rsp['status'] == 1) {
                                            isLoading.value = false;
                                            stockdispatchController.getitemid
                                                    .toString() ==
                                                null;
                                            stockdispatchController.getitemqty
                                                    .toString() ==
                                                null;
                                            stockdispatchController
                                                    .getdispatchid
                                                    .toString() ==
                                                null;
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    const CustomEventDialog(
                                                        title: "Home"));
                                          } else {
                                            isLoading.value = false;
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Something Went Wrong'),
                                                    content: const Text(
                                                        'Try Again!!'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: const Text('OK'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          }
                                        })),
                              ],
                            ),
                          ),
                //  ),
              );
            }));
  }

  Future insert_stockrecieve(
    String recieved_by,
    String item_name,
    String item_qty,
    String purchaseId,
    String itemuniqueid,
    String dispatchid,
    // String editqty,
    String officeid,
  ) async {
    print('insert stock is called');
    print(recieved_by);
    print(item_name);
    print(item_qty);
    print(purchaseId);
    print(itemuniqueid);
    print(dispatchid);
    print(officeid);
    // print(editqty);

    var response = await http
        .post(Uri.parse(MyColors.baseUrl + 'insert_stockrecieve'), headers: {
      "Accept": "Application/json"
    }, body: {
      'recieved_by': recieved_by,
      'item_name': item_name,
      'item_qty': item_qty,
      'purchase_id': purchaseId,
      'item_unique_id': itemuniqueid,
      'dispatch_common_id': dispatchid,
      // 'received_edit_qty': editqty,
      'office_id': officeid,
    });
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  // Row titleView(String name, String value, String staff) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Column(
  //         children: [
  //           Text(name,
  //               style: const TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                   color: MyColors.grey_95)),
  //         ],
  //       ),
  //       Column(
  //         children: [
  //           Text(value,
  //               style: const TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                   color: MyColors.grey_95)),
  //         ],
  //       ),
  //       Column(
  //         children: [
  //           Text(staff,
  //               style: const TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                   color: MyColors.grey_95)),
  //         ],
  //       )
  //     ],
  //   );
  // }

//   Row titleView1(String name, String value, String staff) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GetBuilder<DistrictController>(
//             init: DistrictController(),
//             builder: (districtController) {
//               List<c.District>? district;
//               district = districtController.districtList.value.data;

//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.white, spreadRadius: 1, blurRadius: 5)
//                   ],
//                 ),
//                 child: Stack(children: [
//                   DropdownButton<String>(
//                     value: districtValue1,
//                     iconSize: 14,

//                     hint: Text(
//                       'Select District'.tr,
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                     // ignore: can_be_null_after_null_aware
//                     items: district?.map((value) {
//                       return DropdownMenuItem<String>(
//                         value: value.district.toString(),
//                         child: Text(
//                           value.district.toString(),
//                           style: const TextStyle(fontSize: 9),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (data) {
//                       setState(() {
//                         districtValue1 = data;
//                       });
//                     },
//                   ),
//                 ]),
//               );
//             }),
//         Text(value,
//             style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: MyColors.grey_95)),
//         Text(staff,
//             style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: MyColors.grey_95))
//       ],
//     );
//   }
// }

}
