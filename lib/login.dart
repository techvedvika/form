// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/Controllers/da_controller.dart';
import 'package:form/Controllers/networ_Controller.dart';
import 'package:form/colors.dart';
import 'package:form/home_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

// networkController.connectionStatus.value == 0

class Signin2Page extends StatefulWidget {
  @override
  _Signin2PageState createState() => _Signin2PageState();
}

class _Signin2PageState extends State<Signin2Page> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  final GetXNetworkManager _networkManager = Get.put(GetXNetworkManager());
  final DaController _daController = Get.put(DaController());

  final Color _gradientTop = const Color.fromRGBO(211, 194, 169, 1);
  final Color _gradientBottom = const Color.fromRGBO(211, 194, 169, 1);
  final Color _mainColor = const Color(0xFF8A2724);
  final Color _underlineColor = const Color(0xFFCCCCCC);
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorkey =
      GlobalKey<RefreshIndicatorState>();
  String? myTask;

  Future _refreshList(BuildContext context) async {
    return _refreshApp(context);
  }

  Future _refreshApp(BuildContext context) async {
    _networkManager.GetConnectionType();

    setState(() {});
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
  }

  bool _validate = false;
  bool _validate1 = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetXNetworkManager>(
        init: GetXNetworkManager(),
        builder: (_networkManager) {
          _networkManager.GetConnectionType();

          return RefreshIndicator(
            key: _refreshIndicatorkey,
            onRefresh: () => _refreshList(context),
            child: Scaffold(
                backgroundColor: const Color.fromRGBO(211, 194, 169, 1),
                body: Obx(() => isLoading.value
                    ? Stack(
                        children: [
                          Center(
                            child: Container(
                                color: const Color.fromRGBO(211, 194, 169, 1),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/17000ft.jpg',
                                      height: 60,
                                      width: 60,
                                    ),
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          MyColors.primary),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text('  Fetching Your Details...',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))
                                  ],
                                ))),
                          )
                        ],
                      )
                    : AnnotatedRegion<SystemUiOverlayStyle>(
                        value: const SystemUiOverlayStyle(
                            statusBarIconBrightness: Brightness.light),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              // top blue background gradient
                              // Container(
                              //   height: MediaQuery.of(context).size.height,
                              //   width: MediaQuery.of(context).size.width,
                              //   decoration: BoxDecoration(
                              //     gradient: LinearGradient(
                              //       begin: Alignment.topCenter,
                              //       end: Alignment.bottomCenter,
                              //       colors: [_gradientTop, _gradientBottom],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 200,
                              // ),
                              // Container(
                              //   height:
                              //       MediaQuery.of(context).size.height / 3.5,
                              //   decoration: BoxDecoration(
                              //       gradient: LinearGradient(
                              //           colors: [_gradientTop, _gradientBottom],
                              //           begin: Alignment.topCenter,
                              //           end: Alignment.bottomCenter)),
                              // ),
                              // set your logo here
                              Container(
                                  padding: const EdgeInsets.only(top: 100),
                                  alignment: Alignment.topCenter,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(211, 194, 169, 1),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30))),
                                  child: Image.asset(
                                    'assets/17000ft.jpg',
                                    height: 120,
                                    width: MediaQuery.of(context).size.width,
                                  )),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 15,
                                      margin: const EdgeInsets.fromLTRB(
                                          32, 30, 32, 0),
                                      color: const Color.fromRGBO(
                                          211, 194, 169, 1),
                                      child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              24, 0, 24, 20),
                                          child: Column(
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Center(
                                                child: Text(
                                                  'SIGN IN',
                                                  style: TextStyle(
                                                      color: _mainColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Text(
                                                (_networkManager
                                                            .connectionType ==
                                                        0)
                                                    ? '(You are Offline)'
                                                    : (_networkManager
                                                                .connectionType ==
                                                            1)
                                                        ? '(You are Connected to Wifi)'
                                                        : '(You are Connected to Mobile Internet)',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                //  validator: validateEmail,

                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                controller: _userController,
                                                decoration: InputDecoration(
                                                    errorText: _validate
                                                        ? "This field can't be empty"
                                                        : null,
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    Colors.grey[
                                                                        600]!)),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              _underlineColor),
                                                    ),
                                                    labelText: 'Username',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Colors.grey[700])),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextField(
                                                obscureText: _obscureText,
                                                controller: _passController,
                                                decoration: InputDecoration(
                                                  errorText: _validate1
                                                      ? "This field can't be empty"
                                                      : null,
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]!)),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: _underlineColor),
                                                  ),
                                                  labelText: 'Password',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey[700]),
                                                  suffixIcon: IconButton(
                                                      icon: Icon(_iconVisible,
                                                          color:
                                                              Colors.grey[700],
                                                          size: 20),
                                                      onPressed: () {
                                                        _toggleObscureText();
                                                      }),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: double.maxFinite,
                                                child: TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith<
                                                                  Color>(
                                                        (Set<MaterialState>
                                                                states) =>
                                                            _mainColor,
                                                      ),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .transparent),
                                                      shape: MaterialStateProperty
                                                          .all(
                                                              RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      )),
                                                    ),
                                                    onPressed: () async {
                                                      if ((_networkManager
                                                              .connectionType
                                                              .value !=
                                                          0)) {
                                                        _passController
                                                                .text.isEmpty
                                                            ? _validate1 = true
                                                            : _validate1 =
                                                                false;
                                                        _userController
                                                                .text.isEmpty
                                                            ? _validate = true
                                                            : _validate = false;

                                                        if (!_validate1 &&
                                                            !_validate) {
                                                          isLoading.value =
                                                              true;

                                                          var rsp =
                                                              await loginUser(
                                                                  _userController
                                                                      .text,
                                                                  _passController
                                                                      .text);
                                                          if (rsp['status']
                                                                  .toString() ==
                                                              '1') {
                                                            GetStorage().write(
                                                                'isLogged',
                                                                true);
                                                            GetStorage().write(
                                                                'username',
                                                                rsp['username']);
                                                            GetStorage().write(
                                                                'userId',
                                                                rsp['emp_id']);
                                                            PackageInfo
                                                                packageInfo =
                                                                await PackageInfo
                                                                    .fromPlatform();

                                                            var version =
                                                                await insertVersion(
                                                              uid: rsp['emp_id']
                                                                  .toString(),
                                                              version:
                                                                  packageInfo
                                                                      .version,
                                                            );

                                                            GetStorage().write(
                                                                'role',
                                                                rsp['role_name']);

                                                            List<String>
                                                                _office =
                                                                rsp['office_name']
                                                                    .split(',');

                                                            if (_office
                                                                    .length ==
                                                                1) {
                                                              GetStorage().write(
                                                                  'office',
                                                                  rsp['office_name']);

                                                              isLoading.value =
                                                                  false;
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  () {
                                                                Get.offAll(() =>
                                                                    const HomeScreen());
                                                              });
                                                            } else if (_office
                                                                    .length >
                                                                1) {
                                                              // _daController
                                                              //     .addOffice(
                                                              //         _office);
                                                              GetStorage().write(
                                                                  'officeList',
                                                                  _office
                                                                      .toList());

                                                              print(_office);
                                                              showDailog(
                                                                  context,
                                                                  _office);

                                                              isLoading.value =
                                                                  false;
                                                            }
                                                          } else if (rsp[
                                                                      'status']
                                                                  .toString() ==
                                                              '0') {
                                                            isLoading.value =
                                                                false;

                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Invalid Credentials'),
                                                                    content:
                                                                        const Text(
                                                                            'Fill Correct Details'),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: const Text(
                                                                            'OK'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          } else {
                                                            isLoading.value =
                                                                false;

                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Error'),
                                                                    content:
                                                                        Text(rsp[
                                                                            'message']),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                        child: const Text(
                                                                            'OK'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                            isLoading.value =
                                                                false;
                                                          }
                                                        }
                                                        isLoading.value = false;
                                                      } else {
                                                        _passController
                                                                .text.isEmpty
                                                            ? _validate1 = true
                                                            : _validate1 =
                                                                false;
                                                        _userController
                                                                .text.isEmpty
                                                            ? _validate = true
                                                            : _validate = false;

                                                        if (!_validate1 &&
                                                            !_validate) {
                                                          isLoading.value =
                                                              true;
                                                          // var rsp = offlineLogin(
                                                          //     _userController
                                                          //         .text,
                                                          //     _passController
                                                          //         .text);

                                                          // GetStorage().write(
                                                          //     'isLogged', true);
                                                          // GetStorage().write(
                                                          //     'username',
                                                          //     rsp.username);
                                                          // GetStorage().write(
                                                          //     'email',
                                                          //     rsp.email);
                                                          // GetStorage().write(
                                                          //     'office',
                                                          //     rsp.office);
                                                          // GetStorage().write(
                                                          //     'name', rsp.name);
                                                          // GetStorage().write(
                                                          //     'userId',
                                                          //     rsp.loginId);

                                                          // isLoading.value =
                                                          //     false;

                                                          Get.offAll(() =>
                                                              const HomeScreen());
                                                        }
                                                      }
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Text(
                                                        'LOGIN',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Color.fromRGBO(
                                                                    211,
                                                                    194,
                                                                    169,
                                                                    1)),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    // create sign up link
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ))),
          );
        });
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!) || value.isEmpty) {
      return 'Enter a valid email address';
    } else {
      return '';
    }
  }
}

Future loginUser(String uname, String upass) async {
  var response = await http.post(Uri.parse(MyColors.baseUrl + 'new_login'),
      headers: {"Accept": "Application/json"},
      body: {'username': uname, 'password': upass});
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

// UserModel offlineLogin(String username, String password) {
//   UserModel? verifiedUser;
//   for (var element in DataModel().user) {
//     if (element.username == username && element.password == password) {
//       verifiedUser = element;
//     }
//   }
//   return verifiedUser!;
// }

showDailog(BuildContext context, List<String> list) {
  GetStorage().write('office', list[0]);

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<DaController>(
            init: DaController(),
            builder: (daController) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(20),
                title: const Center(
                  child: Text('Select Office',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      for (var i = 0; i < list.length; i++)
                        RadioListTile(
                          title: Text(list[i],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF8A2724))),
                          value: list[i],
                          groupValue: daController.selectedRadio,
                          onChanged: (String? value) {
                            daController.setRadio(value);
                            GetStorage().write('office', list[i]);
                            schoolController
                                .filterList(GetStorage().read('office'));
                          },
                        ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Center(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) =>
                                  const Color(0xFF8A2724),
                            ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                          ),
                          child: const Text('OK',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(211, 194, 169, 1))),
                          onPressed: () {
                            Get.offAll(() => const HomeScreen());
                          }),
                      // FlatButton(
                      //   child: const Text('SUBMIT'),
                      //   onPressed: () {
                      //     Get.offAll(() => const HomeScreen());
                      //   },
                      // ),
                    ),
                  )
                ],
              );
            });
      });
}

Future insertVersion({String? uid, String? version}) async {
  var response = await http.post(Uri.parse(MyColors.baseUrl + 'version'),
      headers: {"Accept": "Application/json"},
      body: {'uid': uid, 'version': version});
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}
