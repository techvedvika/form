// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:form/Controllers/pendingExpenses_Controller.dart';
import 'package:form/Controllers/school_Controller.dart';
import 'package:form/Model/state_model.dart' as c;
import 'package:form/custom_dialog.dart';
import 'package:form/data.dart';
import 'package:form/forms/tour_da.dart';
import 'package:form/home_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../colors.dart';
import '../my_text.dart';

final StateController _stateController = Get.put(StateController());
final DistrictController _districtController = Get.put(DistrictController());
final BlockController _blockController = Get.put(BlockController());
final StaffController staffController = Get.put(StaffController());

class DaForm extends StatefulWidget {
  const DaForm({Key? key}) : super(key: key);

  @override
  _DaFormState createState() => _DaFormState();
}

class _DaFormState extends State<DaForm> {
  final TextEditingController _officeController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _daController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _visitController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _noOfDayController = TextEditingController();

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

  String? stateValue;
  String? districtValue;
  String? blockValue;
  String? dropdownValue3;
  String? dropdownValue4;
  String? dropdownValue5;
  String? dropdownValue6;
  String? dropdownValue7;
  String? tourValue;

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
        return Theme(data: theme, child: picker!);
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
            'Daily Allowance Form',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: Obx(
          () => staffController.isLoading.value || isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Tour ID:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.grey_95)),
                        Container(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 1,
                                  blurRadius: 5)
                            ],
                          ),
                          child: Stack(children: [
                            DropdownButton<String>(
                              value: tourValue,
                              iconSize: 24,
                              elevation: 2,
                              hint: Text(
                                'Select Tour Id'.tr,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              // ignore: can_be_null_after_null_aware
                              items: schoolController.tour?.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value.tourId.toString(),
                                  child: Text(value.tourId.toString()),
                                );
                              }).toList(),
                              onChanged: (data) {
                                setState(() {
                                  tourValue = data;

                                  _validatePurpose = false;
                                  _validateVisit = false;
                                });
                              },
                            ),
                          ]),
                        ),
                        _validateTourId
                            ? const Text('Please select a Tour Id',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const Text('State:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.grey_95)),
                        Container(height: 10),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : GetBuilder<StateController>(
                                init: StateController(),
                                builder: (stateController) {
                                  List<c.State>? state;
                                  state = _stateController.stateList.data;

                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 1,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: Stack(children: [
                                      DropdownButton<String>(
                                        value: stateValue,
                                        iconSize: 24,
                                        elevation: 2,
                                        hint: Text(
                                          'Select State'.tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        // ignore: can_be_null_after_null_aware
                                        items: DataModel().state.map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value.toString(),
                                            child: Text(value.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (data) {
                                          setState(() {
                                            stateValue = data;
                                            districtValue = null;
                                          });
                                        },
                                      ),
                                    ]),
                                  );
                                }),
                        _validatestate
                            ? const Text('Please select State',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        tourValue == 'NA'
                            ? Container(height: 10)
                            : const SizedBox(),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const SizedBox(
                                height: 10,
                              ),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const Text('District:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.grey_95)),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : Container(height: 10),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : GetBuilder<DistrictController>(
                                init: DistrictController(),
                                builder: (districtController) {
                                  List<c.District>? district;
                                  district = districtController
                                      .districtList.value.data;

                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 1,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: Stack(children: [
                                      DropdownButton<String>(
                                        value: districtValue,
                                        iconSize: 24,
                                        elevation: 2,
                                        hint: Text(
                                          'Select District'.tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        // ignore: can_be_null_after_null_aware
                                        items: DataModel()
                                            .districtWithState
                                            .where((element) =>
                                                element.state == stateValue)
                                            .map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value.district.toString(),
                                            child:
                                                Text(value.district.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (data) {
                                          setState(() {
                                            districtValue = data;
                                            blockValue = null;
                                          });
                                        },
                                      ),
                                    ]),
                                  );
                                }),
                        _validateDistrict
                            ? const Text('Please select District',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        tourValue == 'NA'
                            ? Container(height: 10)
                            : const SizedBox(),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const Text('Block Name:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.grey_95)),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : Container(height: 10),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : GetBuilder<BlockController>(
                                init: BlockController(),
                                builder: (blockController) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 1,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: Stack(children: [
                                      DropdownButton<String>(
                                        value: blockValue,
                                        iconSize: 24,
                                        elevation: 2,
                                        hint: Text(
                                          'Select Block'.tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        // ignore: can_be_null_after_null_aware
                                        items: DataModel()
                                            .blockWithDistrict
                                            .where((element) =>
                                                element.district ==
                                                districtValue)
                                            .map((value) {
                                          return DropdownMenuItem<String>(
                                            value: value.block.toString(),
                                            child: Text(value.block.toString()),
                                          );
                                        }).toList(),
                                        onChanged: (data) {
                                          setState(() {
                                            blockValue = data;
                                            dropdownValue4 = null;
                                          });
                                        },
                                      ),
                                    ]),
                                  );
                                }),
                        _validateblock
                            ? const Text('Please select a Block',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        Container(height: 10),
                        const Text('From:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.grey_95)),
                        Container(height: 10),
                        Container(
                          height: 45,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Container(width: 15),
                              Expanded(
                                child: TextField(
                                  onTap: () {
                                    _selectDate(
                                        context, _fromController, 'from');
                                  },
                                  readOnly: true,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  maxLines: 1,
                                  style: MyText.body2(context)!
                                      .copyWith(color: MyColors.grey_40),
                                  keyboardType: TextInputType.datetime,
                                  controller: _fromController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(-12),
                                      border: InputBorder.none,
                                      hintText: "Starting Date(yyyy-mm-dd)",
                                      hintStyle: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_40)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectDate(
                                          context, _fromController, 'from');
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_today,
                                      color: MyColors.grey_40))
                            ],
                          ),
                        ),
                        _validateFrom
                            ? const Text('Please select a date',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        const Text('To:',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.grey_95)),
                        Container(height: 10),
                        Container(
                          height: 45,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Container(width: 15),
                              Expanded(
                                child: TextField(
                                  onTap: () async {
                                    await _selectDate(
                                        context, _toController, 'to');

                                    String formattedToDate = DateFormat('dd')
                                        .format(DateFormat('yyyy-MM-dd')
                                            .parse(_toController.text));
                                    String formattedFromDate = DateFormat('dd')
                                        .format(DateFormat('yyyy-MM-dd')
                                            .parse(_fromController.text));

                                    setState(() {
                                      _daysController.text =
                                          ((int.parse(formattedToDate) -
                                                      int.parse(
                                                          formattedFromDate)) +
                                                  1)
                                              .toString();
                                      _daController
                                          .text = ((int.parse(formattedToDate) -
                                                  int.parse(formattedFromDate) +
                                                  1) *
                                              250)
                                          .toString();
                                    });
                                  },
                                  readOnly: true,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  maxLines: 1,
                                  style: MyText.body2(context)!
                                      .copyWith(color: MyColors.grey_40),
                                  keyboardType: TextInputType.datetime,
                                  controller: _toController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(-12),
                                      border: InputBorder.none,
                                      hintText: "Ending Date(yyyy-mm-dd)",
                                      hintStyle: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_40)),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await _selectDate(
                                        context, _toController, 'to');

                                    final birthday = DateFormat('yyyy-MM-dd')
                                        .parse(_toController.text);
                                    final date2 = DateFormat('yyyy-MM-dd')
                                        .parse(_fromController.text);
                                    final difference =
                                        birthday.difference(date2).inDays;

                                    setState(() {
                                      _daysController.text =
                                          (difference + 1).toString();
                                      _daController.text =
                                          ((difference + 1) * 250).toString();
                                    });
                                  },
                                  icon: const Icon(Icons.calendar_today,
                                      color: MyColors.grey_40))
                            ],
                          ),
                        ),
                        _validateTo
                            ? const Text('Please select a date',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        Container(height: 10),
                        Container(height: 20),
                        const Text('No of Days:',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: MyColors.grey_95)),
                        Container(height: 10),
                        Container(
                          height: 45,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {},
                            maxLines: 1,
                            controller: _daysController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: "No of days",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                        _validateDays
                            ? const Text('Please fill No of days',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(height: 20),
                        const Text('DA (Daily Allowance):',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: MyColors.grey_95)),
                        Container(height: 10),
                        Container(
                          height: 45,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: TextField(
                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {},
                            maxLines: 1,
                            controller: _daController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(-12),
                                border: InputBorder.none,
                                hintText: "DA",
                                hintStyle: MyText.body1(context)!
                                    .copyWith(color: MyColors.grey_40)),
                          ),
                        ),
                        _validateDA
                            ? const Text('Please fill DA',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        const SizedBox(
                          height: 15,
                        ),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const Text('Place of Visit:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.grey_95)),
                        Container(height: 10),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : Container(
                                height: 45,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (value) {},
                                  maxLines: 1,
                                  controller: _visitController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(-12),
                                      border: InputBorder.none,
                                      hintText: "Place of visit",
                                      hintStyle: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_40)),
                                ),
                              ),
                        _validateVisit
                            ? const Text('Please fill place of visit',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const SizedBox(
                                height: 15,
                              ),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : const Text('Purpose of Visit:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.grey_95)),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : Container(height: 10),
                        tourValue != 'NA'
                            ? const SizedBox()
                            : Container(
                                height: 45,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextField(
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (value) {},
                                  maxLines: 1,
                                  controller: _purposeController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(-12),
                                      border: InputBorder.none,
                                      hintText: "Purpose of visit",
                                      hintStyle: MyText.body1(context)!
                                          .copyWith(color: MyColors.grey_40)),
                                ),
                              ),
                        _validatePurpose
                            ? const Text('Please fill purpose of visit',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const SizedBox(),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF8A2724), elevation: 0),
                            child: Text("Submit",
                                style: MyText.subhead(context)!
                                    .copyWith(color: Colors.white)),
                            onPressed: () async {
                              setState(() {
                                tourValue != null
                                    ? _validateTourId = false
                                    : _validateTourId = true;

                                _fromController.text.isNotEmpty
                                    ? _validateFrom = false
                                    : _validateFrom = true;
                                _toController.text.isNotEmpty
                                    ? _validateTo = false
                                    : _validateTo = true;
                                _daController.text.isNotEmpty
                                    ? _validateDA = false
                                    : _validateDA = true;
                                _daysController.text.isNotEmpty
                                    ? _validateDays = false
                                    : _validateDays = true;

                                if (tourValue == 'NA') {
                                  _visitController.text.isNotEmpty
                                      ? _validateVisit = false
                                      : _validateVisit = true;
                                  _purposeController.text.isNotEmpty
                                      ? _validatePurpose = false
                                      : _validatePurpose = true;
                                  stateValue != null
                                      ? _validatestate = false
                                      : _validatestate = true;
                                  districtValue != null
                                      ? _validateDistrict = false
                                      : _validateDistrict = true;
                                  blockValue != null
                                      ? _validateblock = false
                                      : _validateblock = true;
                                }
                              });
                              if (!_validatestate &&
                                  !_validateDA &&
                                  !_validateDistrict &&
                                  !_validateFrom &&
                                  !_validateTo &&
                                  !_validatePurpose &&
                                  !_validateVisit &&
                                  !_validateblock) {
                                isLoading.value = true;
                                var rsp = await insert_da(
                                  stateValue.toString(),
                                  districtValue.toString(),
                                  blockValue.toString(),
                                  _fromController.text,
                                  _toController.text,
                                  _daController.text,
                                  _visitController.text,
                                  _purposeController.text,
                                  tourValue.toString(),
                                  GetStorage().read('userId').toString(),
                                );
                                if (rsp['status'].toString() == '1') {
                                  isLoading.value = false;

                                  showDialog(
                                      context: context,
                                      builder: (_) => const CustomEventDialog(
                                          title: 'Home'));
                                  setState(() {
                                    stateValue = null;
                                    districtValue = null;
                                    blockValue = null;
                                    tourValue = null;
                                    _fromController.clear();
                                    _toController.clear();
                                    _daController.clear();
                                    _visitController.clear();
                                    _purposeController.clear();
                                    _daysController.clear();
                                  });
                                } else {
                                  print('something went wrong');
                                }
                                // _stateController.toString(),
                                // _districtController.toString(),
                                // _blockController.toString(),
                                // _fromController.text,
                                // _toController.text,
                                // _daController.text,
                                // _visitController.text,
                                // _purposeController.text

                              }

                              // setState(() {
                              //   _daController.clear();
                              // });

                              //     }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          //  ),
        ));
  }

  Future insert_da(
    String state,
    String dist,
    String block,
    String visitfrom,
    String visitto,
    String amount,
    String visitplace,
    String visitpurpose,
    String tourid,
    String userid,
  ) async {
    print('insert da is called');
    print(state);
    print(dist);
    print(block);
    print(visitfrom);
    print(visitto);
    print(amount);
    print(visitplace);
    print(visitpurpose);
    print(tourid);
    print(userid);

    var response =
        await http.post(Uri.parse(MyColors.baseUrl + 'da'), headers: {
      "Accept": "Application/json"
    }, body: {
      'state_name': state,
      'dist_name': dist,
      'block_name': block,
      'dateto': visitfrom,
      'datefrom': visitto,
      'amount': amount,
      'place': visitplace,
      'purpose': visitpurpose,
      'tour_id': tourid,
      'userid': userid,
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
