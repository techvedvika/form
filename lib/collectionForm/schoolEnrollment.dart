// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/Controllers/school_Controller.dart';
import 'package:form/Controllers/state_Controller.dart';
import 'package:form/Model/blockModel.dart';
import 'package:form/custom_dialog.dart';
import 'package:form/forms/issue_tracker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../Controllers/pendingExpenses_Controller.dart';
import '../colors.dart';
import 'package:http/http.dart' as http;
import '../my_text.dart';

final staffController = Get.put(StaffController());
final _stateController = Get.put(StateController());
final _schoolController = Get.put(StateController());
final TextEditingController _boyController = TextEditingController();
final TextEditingController _girlController = TextEditingController();
int totalStudent = 0;
int totalboys = 0;
int totalgirls = 0;
int total = 0;
int get _totalgirls => totalgirls;
int get _totalboys => totalboys;
int get _totalStudent => totalStudent;
List<GradeRow> graderowList = [
  GradeRow(
      grade: 'Nursery',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: 'L.K.G',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: 'U.K.G',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '1st',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '2nd',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '3rd',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '4th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '5th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '6th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '7th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '8th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '9th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '10th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '11th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
  GradeRow(
      grade: '12th',
      boyController: TextEditingController(),
      girlController: TextEditingController()),
];

class SchoolEnrollment extends StatefulWidget {
  const SchoolEnrollment({Key? key}) : super(key: key);

  @override
  _SchoolEnrollmentState createState() => _SchoolEnrollmentState();
}

class _SchoolEnrollmentState extends State<SchoolEnrollment> {
  var isLoading = false.obs;
  String? stateValue;
  String? districtValue;
  String? blockValue;
  String? dropdownValue4;
  String? schoolValue;

  final TextEditingController _facilitatorController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _facilitatorController.text = GetStorage().read('username');
    return GetBuilder<StateInfoController>(
        init: StateInfoController(),
        builder: (stateInfoController) {
          var seen = <String>{};
          List<StateInfo> _uniqueState = [];
          List<StateInfo> _uniqueDistrict = [];
          List<StateInfo> _uniqueBlock = [];

          _uniqueState = stateInfoController.stateInfo
              .where((student) => seen.add(student.stateName!))
              .toList();

          if (stateValue != null) {
            _uniqueDistrict = stateInfoController.stateInfo
                .where((student) => student.stateName == stateValue)
                .toList();
            _uniqueDistrict = _uniqueDistrict
                .where((student) => seen.add(student.districtName!))
                .toList();
          }

          if (districtValue != null) {
            _uniqueBlock = stateInfoController.stateInfo
                .where((student) => student.districtName == districtValue)
                .toList();
            _uniqueBlock = _uniqueBlock
                .where((student) => seen.add(student.blockName!))
                .toList();
          }

          return Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF8A2724),
                title: const Text(
                  'School Enrollment Form',
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
                          child: SizedBox(
                            height: 1000,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                //facilitator field
                                const Text(
                                  'Facilitator',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.grey_95),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: TextField(
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (value) {},
                                    maxLines: 1,
                                    controller: _facilitatorController,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(-12),
                                        border: InputBorder.none,
                                        hintStyle: MyText.body1(context)!
                                            .copyWith(color: MyColors.grey_40)),
                                  ),
                                ),
                                //state field
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'State',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.grey_95),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      // ignore: can_be_null_after_null_aware
                                      items: _uniqueState.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.stateName.toString(),
                                          child:
                                              Text(value.stateName.toString()),
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
                                ),

                                //district field
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'District',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.grey_95),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      // ignore: can_be_null_after_null_aware
                                      items: _uniqueDistrict.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.districtName.toString(),
                                          child: Text(
                                              value.districtName.toString()),
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
                                ),

                                //block Value
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Block',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.grey_95),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      // ignore: can_be_null_after_null_aware
                                      items: _uniqueBlock.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.blockName
                                              .toString()
                                              .replaceAll(',', ''),
                                          child: Text(
                                            value.blockName
                                                .toString()
                                                .replaceAll(',', ''),
                                          ),
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
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //school Value
                                const Text(
                                  'School',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.grey_95),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GetBuilder<SchoolController>(
                                    init: SchoolController(),
                                    builder: (_schoolController) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.white,
                                                spreadRadius: 1,
                                                blurRadius: 5)
                                          ],
                                        ),
                                        child: Flexible(
                                          child: Stack(children: [
                                            DropdownButton<String>(
                                              value: schoolValue,
                                              iconSize: 24,
                                              elevation: 2,
                                              isExpanded: true,
                                              hint: Text(
                                                'Select School'.tr,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              // ignore: can_be_null_after_null_aware
                                              items: schoolController.schoolList
                                                  .where((element) =>
                                                      element.distname ==
                                                      districtValue)
                                                  .map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.schoolName
                                                      .toString(),
                                                  child: (Text(value.schoolName
                                                      .toString())),
                                                );
                                              }).toList(),
                                              onChanged: (data) {
                                                setState(() {
                                                  schoolValue = data;
                                                  // dropdownValue4 = null;
                                                });
                                              },
                                            ),
                                          ]),
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Grade',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Boys',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Girls',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                Expanded(
                                  child: ListView.builder(
                                      itemCount: graderowList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // totalboys += int.parse(
                                        //     graderowList[index].boyController!.text);
                                        //         .boyController!
                                        //         .text
                                        // total = int.parse(graderowList[index]
                                        //         .boyController!
                                        //         .text) +
                                        //     int.parse(graderowList[index]
                                        //         .girlController!
                                        //         .text);
                                        // totalStudent = totalStudent + total;
                                        // totalboys = totalboys +
                                        //     int.parse(graderowList[index]
                                        //         .boyController!
                                        //         .text);
                                        // totalgirls = totalgirls +
                                        //     int.parse(graderowList[index]
                                        //         .girlController!
                                        //         .text);
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                graderowList[index].grade!,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: MyColors.grey_95),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: graderowList[index]
                                                    .boyController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ], // Onl
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(0)),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                  controller:
                                                      graderowList[index]
                                                          .girlController,
                                                  keyboardType: TextInputType
                                                      .number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ], // Only numbers can be entered
                                                  decoration:
                                                      const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  0))),
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            Expanded(
                                              child: Text(graderowList[index]
                                                              .boyController!
                                                              .text ==
                                                          '' ||
                                                      graderowList[index]
                                                              .girlController!
                                                              .text ==
                                                          ''
                                                  ? '0'
                                                  : (int.parse(graderowList[
                                                                  index]
                                                              .boyController!
                                                              .text) +
                                                          int.parse(graderowList[
                                                                  index]
                                                              .girlController!
                                                              .text))
                                                      .toString()),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Expanded(
                                      child: Text(
                                        'Grand Total',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$_totalboys',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$_totalgirls',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$_totalStudent',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.grey_95),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
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
                                      for (var i = 0;
                                          i < graderowList.length;
                                          i++) {
                                        var rsp = await insertEnrollment(
                                            GetStorage().read('userId'),
                                            stateValue,
                                            districtValue,
                                            blockValue,
                                            schoolValue,
                                            graderowList[i].grade,
                                            graderowList[i].boyController!.text,
                                            graderowList[i]
                                                .girlController!
                                                .text);
                                        if (i == graderowList.length - 1) {
                                          if (rsp['status'].toString() == '1') {
                                            isLoading.value = false;
                                            stateValue! == null;
                                            districtValue! == null;
                                            blockValue! == null;
                                            schoolValue == null;
                                            graderowList.clear();

                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    const CustomEventDialog(
                                                        title: 'Home'));
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                //Nursery
                              ],
                            ),
                          ),
                        ),
                      ),
                // ),
              ));
        });
  }

  Future insertEnrollment(
    String? facilitatorId,
    String? state,
    String? district,
    String? block,
    String? school,
    String? grade,
    String? boys,
    String? girls,
  ) async {
    var response = await http
        .post(Uri.parse(MyColors.baseUrl + 'insertEnrollment'), headers: {
      "Accept": "application/json"
    }, body: {
      'facilitatorId': facilitatorId,
      'state': state,
      'district': district,
      'block': block,
      'school': school,
      'grade': grade,
      'boys': boys,
      'girls': girls,
    });
  }
}

class GradeRow {
  String? grade;
  TextEditingController? boyController;
  TextEditingController? girlController;

  GradeRow({
    this.grade,
    this.boyController,
    this.girlController,
  });
}
