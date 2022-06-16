import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/colors.dart';
import 'package:form/form.dart';
import 'package:form/forms/tour_da.dart';
import 'package:form/forms/travel_Requisition.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../custom_dialog.dart';
import '../my_text.dart';

class ExpenseClaimForm extends StatefulWidget {
  const ExpenseClaimForm({Key? key}) : super(key: key);

  @override
  State<ExpenseClaimForm> createState() => _ExpenseClaimFormState();
}

class _ExpenseClaimFormState extends State<ExpenseClaimForm> {
  TextEditingController _Datecontroller = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool _validateDate = false;
  bool _validateAmount = false;
  bool _validateDescription = false;

  String? expenseHead;
  bool _validateExpenseHead = false;

  FocusNode _amountNode = FocusNode();
  FocusNode _descriptionNode = FocusNode();

  DateTime selectedDate = DateTime.now(), initialDate = DateTime.now();

  _selectDate(
    BuildContext context,
    TextEditingController date,
  ) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale('en', 'IN'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime(2030),
      builder: (context, picker) {
        return Theme(data: theme, child: picker!);
      },
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        date.text = formattedDate;
      });
    }
  }

  String? _imagePicked;
  bool _validateImagePicked = false;

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  List<MultipleImage> _imageList = [];
  List<String>? images64 = [];

  Future<String> takePhoto(ImageSource source) async {
    _image = null;
    final pickedFile = await _picker.getImage(
      source: source,
      imageQuality: 10,
    );
    _imageFile = pickedFile.obs();

    _image = File(_imageFile!.path);
    MultipleImage image = MultipleImage(image: _image);
    _imageList.add(image);
    final bytes = _image!.readAsBytesSync();

    String status = base64Encode(_image!.readAsBytesSync());

    return status;
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      color: MyColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () async {
                  _imagePicked = await takePhoto(
                    ImageSource.camera,
                  );
                  images64!.add(_imagePicked!);

                  // uploadFile(userdata.read('customerID'));
                  Navigator.pop(context);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                label: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              FlatButton.icon(
                onPressed: () async {
                  _imagePicked = await takePhoto(ImageSource.gallery);
                  images64!.add(_imagePicked!);
                  print(images64);

                  Navigator.pop(context);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  var isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? const loadingWidget()
          : Scaffold(
              appBar: AppBar(
                backgroundColor: MyColors.primary,
                title: const Text('Expense Claim Form'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 10),
                      const Text('Date:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_95)),
                      Container(height: 10),
                      Container(
                        height: 45,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Container(width: 15),
                            Expanded(
                              child: TextField(
                                onTap: () {
                                  _selectDate(
                                    context,
                                    _Datecontroller,
                                  );
                                },
                                readOnly: true,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                maxLines: 1,
                                style: MyText.body2(context)!
                                    .copyWith(color: MyColors.grey_40),
                                keyboardType: TextInputType.datetime,
                                controller: _Datecontroller,
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
                                      context,
                                      _Datecontroller,
                                    );
                                  });
                                },
                                icon: const Icon(Icons.calendar_today,
                                    color: MyColors.grey_40))
                          ],
                        ),
                      ),
                      _validateDate
                          ? const Text('Please select a date',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                          : const SizedBox(),
                      Container(height: 15),
                      const Text('Expense Head:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_95)),
                      Container(height: 10),
                      //dropdown
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
                            value: expenseHead,
                            iconSize: 24,
                            elevation: 2,
                            hint: const Text(
                              'Expense Head',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items: [
                              'Hotel',
                              'Meal',
                              'Transport',
                              'Fuel',
                              'Staff Welfare',
                              'Misc.'
                            ].map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (data) {
                              setState(() {
                                expenseHead = data;
                              });
                            },
                          ),
                        ]),
                      ),
                      _validateExpenseHead
                          ? const Text('Please select a Mode of Transport',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                          : const SizedBox(),
                      Container(height: 15),
                      const Text('Amount',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_95)),
                      Container(height: 10),
                      Container(
                        height: 45,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextField(
                          onSubmitted: (value) {
                            //     FocusScope.of(context).requestFocus(_toNode);
                          },
                          focusNode: _amountNode,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]+')),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          maxLines: 1,
                          controller: _amountController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(-12),
                              border: InputBorder.none,
                              hintText: 'Enter Amount',
                              hintStyle: MyText.body1(context)!
                                  .copyWith(color: MyColors.grey_40)),
                        ),
                      ),
                      _validateAmount
                          ? const Text('Please fill the amount',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                          : const SizedBox(),

                      Container(height: 15),

                      buildList(
                          context,
                          'Description',
                          _descriptionNode,
                          _descriptionController,
                          'Enter Description',
                          _validateDescription,
                          'Please fill the description'),

                      Container(height: 15),
                      const Text('Pics for Supporting: ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColors.grey_95)),
                      Container(height: 10),
                      Container(
                        height: 45,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: <Widget>[
                            Container(width: 15),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                onTap: () {
                                  showModalBottomSheet(
                                      backgroundColor: MyColors.primary,
                                      context: context,
                                      builder: ((builder) =>
                                          bottomSheet(context)));
                                },
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                controller: _imageController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(-12),
                                    border: InputBorder.none,
                                    hintText: "Upload Supporting Images",
                                    hintStyle: MyText.body1(context)!
                                        .copyWith(color: MyColors.grey_40)),
                              ),
                            ),
                            IconButton(
                                icon: const Icon(Icons.camera,
                                    color: MyColors.grey_40),
                                onPressed: () {
                                  showModalBottomSheet(
                                      backgroundColor: MyColors.primary,
                                      context: context,
                                      builder: ((builder) =>
                                          bottomSheet(context)));
                                }),
                          ],
                        ),
                      ),
                      _imageList.isNotEmpty
                          ? const SizedBox(
                              height: 20,
                            )
                          : SizedBox(),
                      _imageList.isNotEmpty
                          ? CardListView(
                              name: _imageList,
                            )
                          : SizedBox(),

                      _validateImagePicked
                          ? const Text('Upload Image',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(28.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF8A2724), elevation: 0),
                      child: Text("Claim",
                          style: MyText.subhead(context)!.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        setState(() {
                          _Datecontroller.text.isNotEmpty
                              ? _validateDate = false
                              : _validateDate = true;

                          _amountController.text.isNotEmpty
                              ? _validateAmount = false
                              : _validateAmount = true;
                          _descriptionController.text.isNotEmpty
                              ? _validateDescription = false
                              : _validateDescription = true;
                          _imageList.isNotEmpty
                              ? _validateImagePicked = false
                              : _validateImagePicked = true;

                          expenseHead != null
                              ? _validateExpenseHead = false
                              : _validateExpenseHead = true;
                        });

                        if (!_validateDate &&
                            !_validateExpenseHead &&
                            !_validateAmount &&
                            !_validateDescription &&
                            !_validateImagePicked) {
                          isLoading.value = true;
                          var rsp = await insertClaim(
                            GetStorage().read('userId'),
                            _Datecontroller.text,
                            expenseHead.toString(),
                            _amountController.text,
                            _descriptionController.text,
                          );
                          if (rsp['status'].toString() == '1') {
                            print(rsp);
                            for (int i = 0; i <= images64!.length - 1; i++) {
                              var afjal = await insertImages(
                                  rsp['id'].toString(), images64![i]);
                              print(afjal);
                            }
                            setState(() {
                              isLoading.value = false;

                              _Datecontroller.clear();
                              _amountController.clear();
                              _descriptionController.clear();

                              _imageList.clear();
                              _imagePicked = null;
                              images64!.clear();
                              expenseHead = null;
                            });

                            showDialog(
                                context: context,
                                builder: (_) =>
                                    const CustomEventDialog(title: 'Home'));
                          } else {
                            setState(() {
                              isLoading.value = false;
                            });
                            showDialog(
                                context: context,
                                builder: (_) => const CustomEventDialog(
                                    title: 'Something went wrong'));
                          }
                        }
                      }),
                ),
              ),
            ),
    );
  }
}

Future insertImages(
  String id,
  String image,
) async {
  var response = await http
      .post(Uri.parse(MyColors.baseUrl + 'insert_expenseImg'), headers: {
    "Accept": "Application/json"
  }, body: {
    'expense_claim_id': id,
    'image': image,
  });
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future insertClaim(
  String userid,
  String date,
  String expenseHead,
  String amount,
  String description,
) async {
  var response = await http
      .post(Uri.parse(MyColors.baseUrl + 'insert_expense_claim'), headers: {
    "Accept": "Application/json"
  }, body: {
    'submitted_by': userid,
    'date': date,
    'expense_head': expenseHead,
    'amount': amount,
    'description': description,
  });
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}
