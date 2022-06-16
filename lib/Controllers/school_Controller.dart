import 'package:flutter/material.dart';
import 'package:form/Model/distribution.dart';
import 'package:form/Model/expensehead.dart';
import 'package:form/Model/programme.dart';
import 'package:form/Model/school_data.dart';
import 'package:form/Model/staff_data.dart';
import 'package:form/Model/tour.dart';
import 'package:form/forms/tour_da.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'apiCalls.dart';

class SchoolController extends GetxController {
  var isLoading = false.obs;

  bool? setboolValue(bool value, bool assign) {
    value = assign;
    update();
    return value;
  }

  List<TourId>? _schoolTourList = [];
  List<TourId>? get schoolTourList => _schoolTourList!;

  void filterList(String office) {
    isLoading.value = true;
    _schoolTourList = [];
    try {
      _schoolTourList = tour!
          .where((element) => element.officeName == office.removeAllWhitespace)
          .toList();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      update();
    } finally {
      TourId item = TourId(tourId: 'NA');

      _schoolTourList!.insert(0, item);
      update();
    }
  }

  final List<String>? _car = [];
  List<String>? get car => _car;

  // setCarData() {
  //   _car = [];
  //   _car = DataModel().officeVehicles;
  //   update();
  // }

//school Validation

  final TextEditingController _distributionText = TextEditingController();
  final TextEditingController _visitDataController = TextEditingController();
  final TextEditingController _otherProgramController = TextEditingController();

  TextEditingController get distributionText => _distributionText;
  TextEditingController get visitDataController => _visitDataController;
  TextEditingController get otherProgramController => _otherProgramController;

  bool? _validateName = false;
  bool? _validateDate = false;
  bool? _validateProgramme = false;
  bool? _validateActivity = false;
  bool? _validateDistribution = false;
  bool? _validateSetup = false;
  bool? _validateCollection = false;

  bool? get validateName => _validateName;
  bool? get validateDate => _validateDate;
  bool? get validateProgramme => _validateProgramme;
  bool? get validateActivity => _validateActivity;
  bool? get validateDistribution => _validateDistribution;
  bool? get validateSetup => _validateSetup;
  bool? get validateCollection => _validateCollection;

  validateSchool() {
    _schoolName != null ? _validateName = false : _validateName = true;

    _visitDataController.text.isNotEmpty
        ? _validateDate = false
        : _validateDate = true;

    _selectedProgramme.isNotEmpty
        ? _validateProgramme = false
        : _validateProgramme = true;

    _selectedActivity.isNotEmpty
        ? _validateActivity = false
        : _validateActivity = true;

    _selectedActivity.contains('Distribution') &&
            _selectedDistribution.isNotEmpty
        ? _validateDistribution = false
        : _validateDistribution = true;

    _selectedActivity.contains('Setup') && _selectedSetup.isNotEmpty
        ? _validateSetup = false
        : _validateSetup = true;

    _selectedActivity.contains('Data Collection') &&
            _selectedCollection.isNotEmpty
        ? _validateCollection = false
        : _validateCollection = true;

    update();
  }

//school Validation
//validate Staff Transport

  bool? _validateStaffMode = false;
  bool? get validateStaffMode => _validateStaffMode;

  bool? _validateStaffDistance = false;
  bool? get validateStaffDistance => _validateStaffDistance;

  bool? _validateStaffAmount = false;
  bool? get validateStaffAmount => _validateStaffAmount;

  bool? _validateStaffVehicle = false;
  bool? get validateStaffVehicle => _validateStaffVehicle;

  bool? _validateStaffCar = false;
  bool? get validateStaffCar => _validateStaffCar;

  validateStaffTransport() {
    _selectedStaffMode != null
        ? _validateStaffMode = false
        : _validateStaffMode = true;

    if (_selectedStaffMode == 'Office Car' && car!.isNotEmpty) {
      _officeCar != null ? _validateStaffCar = false : _validateStaffCar = true;

      // _selectedCar.isNotEmpty
      //     ? _validateStaffCar = false
      //     : _validateStaffCar = true;
    }

    if (_selectedStaffMode == 'Rented Car') {
      _vehicle.text.isNotEmpty
          ? _validateStaffVehicle = false
          : _validateStaffVehicle = true;
    }

    _distance.text.isNotEmpty
        ? _validateStaffDistance = false
        : _validateStaffDistance = true;

    _amount.text.isNotEmpty
        ? _validateStaffAmount = false
        : _validateStaffAmount = true;

    update();
  }

//Validation For Transport
  bool? _validateGoodsMode = false;
  bool? get validateGoodsMode => _validateGoodsMode;

  bool? _validateGOfficeCar = false;
  bool? get validateGOfficeCar => _validateGOfficeCar;

  bool? _validateGDistance = false;
  bool? get validateGDistance => _validateGDistance;

  final TextEditingController _distance = TextEditingController();
  TextEditingController get distance => _distance;

  bool? C = false;
  final TextEditingController _amount = TextEditingController();
  TextEditingController get amount => _amount;

  bool? _validateGAmount = false;
  bool? get validateGAmount => _validateGAmount;

  final TextEditingController _vehicle = TextEditingController();
  TextEditingController get vehicle => _vehicle;

  bool? _validateVehicleNo = false;
  bool? get validateVehicleNo => _validateVehicleNo;

  bool? _validateGoodsAfjal = false;
  bool? get validateGoodsAfjal => _validateGoodsAfjal;

  validateGoodsAll() {
    _selectedGoods.isNotEmpty
        ? _validateGoodsAfjal = false
        : _validateGoodsAfjal = true;
    _selectedGoodsMode != null
        ? _validateGoodsMode = false
        : _validateGoodsMode = true;

    if ((_selectedGoodsMode == ('Office Car') && car!.isNotEmpty)) {
      officeCar != null
          ? _validateGOfficeCar = false
          : _validateGOfficeCar = true;
    }

    _distance.text.isNotEmpty
        ? _validateGDistance = false
        : _validateGDistance = true;

    _amount.text.isNotEmpty
        ? _validateGAmount = false
        : _validateGAmount = true;

    if (_selectedGoodsMode == ('Rented Car')) {
      _vehicle.text.isNotEmpty
          ? _validateVehicleNo = false
          : _validateVehicleNo = true;
    }

    update();
  }

  // void selectProgram(BuildContext context) async {
  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(title: 'Select Programme', programme: programme);
  //     },
  //   );

  //   if (results != null) {
  //     update();
  //   }
  // }

  // // void selectVehicleMode(BuildContext context, String value) async {
  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Vehicle',
  //           mode: value == 'Goods Transport'
  //               ? DataModel().modeOfGoodsTransport
  //               : DataModel().modeOfStaffTransport);
  //     },
  //   );
  //   update();
  //   // Update UI
  //   if (results != null) {
  //     update();
  //   }
  // }

  //void selectTypesofGoods(BuildContext context) async {
  // a list of selectable items
  // these items can be hard-coded or dynamically fetched from a database/API

  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Goods', goods: DataModel().typeOfGoods);
  //     },
  //   );

  //   // Update UI
  //   // if (results != null) {
  //   //   _selectedGoods.addAll(results);
  //   //   update();
  //   // }
  // }

  // void selectActivity(BuildContext context) async {
  //   // a list of selectable items
  //   // these items can be hard-coded or dynamically fetched from a database/API

  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Activity', activity: DataModel().activity);
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedActivity.addAll(results);
  //     update();
  //   }
  // }

  // void selectDistribution(BuildContext context) async {
  //   // a list of selectable items
  //   // these items can be hard-coded or dynamically fetched from a database/API
  //   // List<String> arr = ["a", "a", "b", "c", "b", "d"];
  //   // List<Data1> result = LinkedHashSet<Data1>.from(distribution!).toList();
  //   // Set<Data1> help = distribution!.toSet();

  //   var seen = <String>{};
  //   List<Data1> finalList = [];
  //   List<Data1> uniquelist =
  //       distribution!.where((student) => seen.add(student.itemName!)).toList();

  //   for (var p in selectedProgramme) {
  //     finalList.addAll(uniquelist
  //         .where((student) => student.programmeId == p.programId)
  //         .toList());
  //   }

  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Distribution', distribution: finalList);
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedDistribution.addAll(results);
  //     update();
  //   }
  // }

  // void selectCollection(BuildContext context) async {
  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Collection', collection: DataModel().collectionType);
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedCollection.addAll(results);
  //     update();
  //   }
  // }

  // void selectSetup(BuildContext context) async {
  //   // a list of selectable items
  //   // these items can be hard-coded or dynamically fetched from a database/API

  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(title: 'Select Setup', setup: selectedProgramme);
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedSetup.addAll(results);
  //     update();
  //   }
  // }

  final List<String> _selectedMainTransport = [];
  List<String> get selectedMainTransport => _selectedMainTransport;

  // void selectMainTransport(BuildContext context) async {
  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Transport', items4: DataModel().Transport);
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedMainTransport.addAll(results);
  //     update();
  //   }
  // }

  // void selectOfficeCars(BuildContext context) async {
  //   // a list of selectable items
  //   // these items can be hard-coded or dynamically fetched from a database/API

  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select Vehicle', officeCar: DataModel().officeVehicles);
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedCar.addAll(results);
  //     update();
  //   }
  // }

  final List<AddSchool> _schoolData = [];
  List<AddSchool>? get schoolData => _schoolData;
  final List<AddItems> _itemsData = [];
  List<AddItems>? get itemsData => _itemsData;

  final List<AddTransport> _staffData = [];
  List<AddTransport>? get staffData => _staffData;

  final List<AddTransport> _goodsData = [];
  List<AddTransport>? get goodsData => _goodsData;

  void addSchoolData(List<AddSchool> data) {
    List<AddSchool> _schoolData1 = [];
    _schoolData1.addAll(data);
    _schoolData.addAll(_schoolData1);
    update();
  }

  void addItemsData(AddItems data) {
    List<AddItems> _itemsData1 = [];
    _itemsData1.add(data);
    _itemsData.addAll(_itemsData1);
    update();
  }

  void addStaffData(AddTransport data) {
    List<AddTransport> _schoolData1 = [];
    _schoolData1.add(data);
    _staffData.addAll(_schoolData1);

    for (int i = 0; i < _staffData.length; i++) {
      _smode.add(_staffData[i].modeofTransport!);
      _sgoods.addAll(_staffData[i].typeOfGoods!);
      _sdistance.add(_staffData[i].distance!);
      _svehicleNo.add(_staffData[i].vehicleNo!);
      _sSelectCar.add(_staffData[i].selectedVehicle!);
      _samount.add(_staffData[i].amount!);
    }

    update();
  }

  String? _teamleader;
  String? get teamleader => _teamleader;

  String? _officeCar;
  String? get officeCar => _officeCar;

  setLeader(String? leader) {
    _teamleader = leader;
    checkStaff(_teamleader!);

    update();
  }

  setCar(String? car) {
    _officeCar = car;

    update();
  }

  void checkStaff(String value) {
    if (_selectedStaff.contains(value) && _teamleader == value) {
    } else {
      if (!_selectedStaff.contains(value)) {
        _selectedStaff.add(value);
      } else {
        _selectedStaff.remove(value);
      }
    }
    update();
  }

  // void checkTransport(String value) {
  //   if (!_selectedVehicle.contains(value)) {
  //     _selectedVehicle.add(value);
  //   } else {
  //     _selectedVehicle.remove(value);
  //   }
  //   update();
  // }

  void checkMainTransport(String value) {
    if (!_selectedMainTransport.contains(value)) {
      _selectedMainTransport.add(value);
    } else {
      _selectedMainTransport.remove(value);
    }
    update();
  }

  void checkGoods(String value) {
    if (!_selectedGoods.contains(value)) {
      _selectedGoods.add(value);
    } else {
      _selectedGoods.remove(value);
    }
    update();
  }

  void checkVehicle(String value) {
    if (!_selectedCar.contains(value)) {
      _selectedCar.add(value);
    } else {
      _selectedCar.remove(value);
    }
    update();
  }

  void checkDistribution(String value) {
    if (!_selectedDistribution.contains(value)) {
      _selectedDistribution.add(value);
    } else {
      _selectedDistribution.remove(value);
    }
    update();
  }

  // List<Data1>? _ffdistribution;
  // List<Data1>? get ffdistribution => _fdistribution;

  void checkProgramme(ProgrammeMaster value) {
    if (!_selectedProgramme.contains(value)) {
      _selectedProgramme.add(value);
    } else {
      _selectedProgramme.remove(value);
    }
    update();
  }

  void checkActivity(String value) {
    if (value == 'Setup') {
      if (!_selectedActivity.contains(value)) {
        _selectedActivity.add(value);
        if (!_selectedActivity.contains('Distribution')) {
          _selectedActivity.add('Distribution');
        }
      } else {
        _selectedActivity.remove(value);
      }
    } else {
      if (!_selectedActivity.contains(value)) {
        _selectedActivity.add(value);
      } else {
        _selectedActivity.remove(value);
      }
    }
    update();
  }

  void checkSetup(String value) {
    if (!_selectedSetup.contains(value)) {
      _selectedSetup.add(value);
    } else {
      _selectedSetup.remove(value);
    }
    update();
  }

  void checkCollection(String value) {
    if (!_selectedCollection.contains(value)) {
      _selectedCollection.add(value);
    } else {
      _selectedCollection.remove(value);
    }
    update();
  }

  final List<String> _gmode = [];
  List<String> get gmode => _gmode;

  final List<String> _goods = [];
  List<String> get goods => _goods;
  final List<String> _gdistance = [];
  List<String> get gdistance => _gdistance;
  final List<String> _gvehicleNo = [];
  List<String> get gvehicleNo => _gvehicleNo;
  final List<String> _gSelectCar = [];
  List<String> get gSelectCar => _gSelectCar;

  final List<String> _gamount = [];
  List<String> get gamount => _gamount;

  final List<String> _smode = [];
  List<String> get smode => _smode;

  final List<String> _sgoods = [];
  List<String> get sgoods => _sgoods;
  final List<String> _sdistance = [];
  List<String> get sdistance => _sdistance;
  final List<String> _svehicleNo = [];
  List<String> get svehicleNo => _svehicleNo;
  final List<String> _sSelectCar = [];
  List<String> get sSelectCar => _sSelectCar;

  final List<String> _samount = [];
  List<String> get samount => _samount;

  void addGoodsData(AddTransport data) {
    List<AddTransport> _schoolData1 = [];
    _schoolData1.add(data);
    _goodsData.addAll(_schoolData1);

    for (int i = 0; i < _goodsData.length; i++) {
      _gmode.add(_goodsData[i].modeofTransport!);
      _goods.addAll(_goodsData[i].typeOfGoods!);
      _gdistance.add(_goodsData[i].distance!);
      _gvehicleNo.add(_goodsData[i].vehicleNo!);
      _gSelectCar.add(_goodsData[i].selectedVehicle!);
      _gamount.add(_goodsData[i].amount!);
    }

    update();
  }

  List<SchoolData>? _schoolList;
  List<ProgrammeMaster> _selectedProgramme = [];
  List<ProgrammeMaster> get selectedProgramme => _selectedProgramme;
  List<String> _selectedSetup = [];
  List<String> get selectedSetup => _selectedSetup;

  List<String> _selectedCar = [];
  List<String> get selectedSCar => _selectedCar;

  List<String> _selectedCollection = [];
  List<String> get selectedCollection => _selectedCollection;

  String? _selectedVehicle;
  String? get selectedVehicle => _selectedVehicle;

  String? _selectedStaffMode;
  String? get selectedStaffMode => _selectedStaffMode;

  String? _selectedGoodsMode;
  String? get selectedGoodsMode => _selectedGoodsMode;

  void setDropVal(String title, String drop) {
    if (title == 'Goods Transport') {
      _selectedGoodsMode = drop;
    } else if (title == 'Staff Transport') {
      _selectedStaffMode = drop;
    }

    update();
  }

  List<String> _selectedGoods = [];
  List<String> get selectedGoods => _selectedGoods;

  final List<String> _selectedStaff = [];
  List<String> get selectedStaff => _selectedStaff;

  List<String> _selectedActivity = [];
  List<String> get selectedActivity => _selectedActivity;
  set schoolName1(String value) {
    _schoolName = null;
    update();
  }

  List<String> _selectedDistribution = [];
  List<String> get selectedDistribution => _selectedDistribution;

  void clearData() {
    _selectedProgramme = [];
    _selectedSetup = [];
    _selectedActivity = [];
    _selectedCollection = [];
    _selectedDistribution = [];
    update();
  }

  void clearTransport() {
    _selectedGoods = [];
    _selectedCar = [];
    _selectedStaffMode = null;
    _selectedGoodsMode = null;

    update();
  }

  List<SchoolData> _filterd = [];
  List<SchoolData> get filterd => _filterd;

  List<SchoolData> get schoolList => _schoolList!;
  List<String> _selectedSchools = [];
  String? _schoolName;
  String? get schoolName => _schoolName;

  void setValue(String value) {
    _schoolName = value;
    update();
  }

  DateTime selectedDate = DateTime.now(), initialDate = DateTime.now();
  DateTime? _from;
  DateTime? get from => _from;
  DateTime? _to;
  DateTime? get to => _to;

  selectDate(
    BuildContext context,
    TextEditingController date,
  ) async {
    final DateTime? selected = await showDatePicker(
      locale: const Locale('en', 'IN'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: _from!,
      lastDate: _to!,
      builder: (context, picker) {
        return Theme(data: theme, child: picker!);
      },
    );
    if (selected != null) {
      selectedDate = selected;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      date.text = formattedDate;
      //    (getNumber(int.parse(DateFormat('dd').format(selectedDate))));
      update();
    }
  }

  setDate(DateTime date, String a) {
    if (a == 'from') {
      _from = date;
    } else if (a == 'to') {
      _to = date;
    }
    update();
  }

  @override
  Future<void> onInit() async {
    // setCarData();
    fetchSchool();

    fetchDistribution();
    fetchProgramme();
    fetchTour();
    fetchExpenseHead();
    filterList(GetStorage().read('office'));

    super.onInit();
    _selectedSchools = [];
  }

  List<Data1>? _distribution;
  List<Data1>? get distribution => _distribution;

  void fetchDistribution() async {
    try {
      isLoading.value = (true);
      var orders = await ApiCalls.fetchDistribution();

      _distribution = null;
      _distribution = orders.data;
      isLoading.value = (false);

      update();
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }

  // final List<Data1>? _fdistribution;
  // List<Data1>? get fdistribution => _fdistribution;

  // filterDistribution() {
  //   List<Data1>? _schoolData1 = [];
  //   // _schoolData1 = _distribution!.data!
  //   //     .where((element) => element.programmeId == value)
  //   //     .toList();
  //   if (_schoolData1 != null) {
  //     _fdistribution!.addAll(_schoolData1);
  //   }
  //   update();
  //   // _schoolData1 = _distribution!.data!
  //   //     .where((element) => element.itemName!.toLowerCase() == value)
  //   //     .toList();
  //   // _fdistribution!.addAll(_schoolData1);
  // }

  clearTour() {
    _teamleader = null;
    _from = null;
    _to = null;
    _schoolName = null;
    _schoolData.clear();
    _selectedStaff.clear();
    _selectedMainTransport.clear();
    _gmode.clear();
    _gvehicleNo.clear();
    _gSelectCar.clear();
    _gamount.clear();
    _gdistance.clear();
    _sSelectCar.clear();
    _smode.clear();
    _samount.clear();
    _svehicleNo.clear();
    update();
  }

  bool checkOther(String other) {
    List<ProgrammeMaster> k = [];

    k = _selectedProgramme
        .where((element) => element.program == other)
        .toList();

    if (k.length == 1) {
      return true;
    } else {
      return false;
    }
  }

  List<ProgrammeMaster>? _programme;
  List<ProgrammeMaster>? get programme => _programme;

  void fetchProgramme() async {
    try {
      isLoading.value = (true);
      var orders = await ApiCalls.fetchProgram();

      _programme = null;
      _programme = orders;
      isLoading.value = (false);

      update();
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }

  filterdata(String value) {
    _filterd = [];
    _filterd =
        _schoolList!.where((element) => element.blockName == value).toList();
    update();
  }

  // void showMultiSelect(String value, BuildContext context) async {
  //   // a list of selectable items
  //   // these items can be hard-coded or dynamically fetched from a database/API

  //   List<String>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelect(
  //           title: 'Select School',
  //           items: schoolList
  //               .where((element) => element.blockName == value)
  //               .toList());
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     _selectedSchools.addAll(results);
  //     update();
  //   }
  // }

//fetch Tour id

  List<TourId>? _tour;
  List<TourId>? get tour => _tour;
  List<TourId>? _newtour = [];
  List<TourId>? get newtour => _newtour;
  String? _fromtour;
  String? _totour;
  String? get fromtour => _fromtour;
  String? get totour => _totour;
  String? _mytourid;
  String? get mytourid => _mytourid;
  mytour(String tourid) {
    print("my tour function is called");
    _mytourid = tourid;
    print("this is mytour id" + _mytourid!);
    _newtour = tour!.where((element) => element.tourId == _mytourid).toList();
    _fromtour = _newtour![0].datefrom;
    _totour = _newtour![0].dateto;
    print(_fromtour);
    print(_totour);

    print(_newtour!.length);
    update();
    return _newtour;
  }

  void fetchTour() async {
    try {
      isLoading.value = (true);
      var orders = await ApiCalls.fetchTourId();
      TourId item = TourId(tourId: 'NA');

      _tour = null;
      _tour = orders;
      _tour!.insert(0, item);
      isLoading.value = (false);
      print("this is from tourid");

      update();
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }

  //fetch expense head
  List<ExpenseHead>? _expensehead;
  List<ExpenseHead>? get expensehead => _expensehead;

  void fetchExpenseHead() async {
    try {
      isLoading.value = (true);
      var orders = await ApiCalls.fetchExpenseHead();

      _expensehead = null;
      _expensehead = orders;
      isLoading.value = (false);

      update();
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }

  void fetchSchool() async {
    try {
      isLoading.value = (true);
      // bool hey = await Controller.isInternet();

      // if (hey) {
      var orders = await ApiCalls.readJson();

      _schoolList = null;
      _schoolList = orders;
      isLoading.value = (false);

      // for (int i = 0; i < _schoolList!.length; i++) {
      //   await Controller().addSchoolData(_schoolList![i]);
      // }

      // update();
      // } else {
      //List<SchoolData>? data;

      // data = await Controller().readAllSchool();
      // _schoolList = null;
      // _schoolList = data;
      // isLoading.value = (false);
      update();
      // }
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }
}

class StaffController extends GetxController {
  var isLoading = true.obs;

  List<Staff> _staffList = [];

  List<Staff> get staffList => _staffList;

  @override
  void onInit() {
    fetchStaff(
      GetStorage().read('office').toString(),
    );

    super.onInit();
  }

  // List<StaffDetails>? _staffList1;
  // List<StaffDetails> get staffList1 => _staffList1!;
  // void filterList(String help) {
  //   _staffList!.where((element) => element.location == help).toList();
  //   update();
  // }

  void fetchStaff(String office) async {
    try {
      isLoading.value = (true);
      var orders = await ApiCalls.fetchStaff(office);

      _staffList = [];
      _staffList.add(orders);

      update();
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }
}

class AuthorityController extends GetxController {
  var isLoading = true.obs;

  List<Authority>? _authList;

  List<Authority> get authList => _authList!;

  @override
  Future<void> onInit() async {
    fetchAuth();

    super.onInit();
  }

  // List<StaffDetails>? _staffList1;
  // List<StaffDetails> get staffList1 => _staffList1!;
  // void filterList(String help) {
  //   _staffList!.where((element) => element.location == help).toList();
  //   update();
  // }

  void fetchAuth() async {
    try {
      isLoading.value = (true);
      var orders = await ApiCalls.fetchAuthority();

      _authList = null;
      _authList = orders;
      isLoading.value = (false);

      update();
    } finally {
      isLoading.value = (false);
      update();
    }
    update();
  }
}

class AddSchool {
  String? schoolName;
  String? visitDate;

  List<ProgrammeMaster>? programme;
  List<String>? activity;
  List<String>? distribution;
  List<String>? setup;
  List<String>? collection;

  AddSchool(
      {this.schoolName,
      this.visitDate,
      this.programme,
      this.activity,
      this.distribution,
      this.setup,
      this.collection});
}

class AddTransport {
  String? modeofTransport;
  List<String>? typeOfGoods;
  String? vehicleNo;
  String? amount;
  String? distance;
  String? selectedVehicle;

  AddTransport(
      {this.vehicleNo,
      this.amount,
      this.modeofTransport,
      this.typeOfGoods,
      this.distance,
      this.selectedVehicle});
}

class AddItems {
  String? itemRecievedId;
  String? itemsName;
  String? itemQty;

  AddItems({
    this.itemRecievedId,
    this.itemsName,
    this.itemQty,
  });
}
