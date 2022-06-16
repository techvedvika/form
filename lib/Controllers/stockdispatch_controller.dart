import 'package:form/Controllers/apiCalls.dart';
import 'package:form/Model/stockdispatch_model.dart';
import 'package:form/Model/stockpurchase_model.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class StockDispatchController extends GetxController {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<StockDispatch>? _dispatchList;
  List<StockDispatch> get dispatchList => _dispatchList!;
  List<StockDispatch>? _newdispatchList;
  List<StockDispatch> get newdispatchList => _newdispatchList!;
  String? _itemsqty;
  String? get itemsqty => _itemsqty;
  void qtySetter(String value) {
    _itemsqty = value;
    update();
  }

  String? _itemsname;
  String? get itemsname => _itemsname;
  void itemSetter(String value) {
    _itemsname = value;
    update();
  }

  String? _itemnameValue;
  String? get itemnameValue => _itemnameValue;

  void setValue(String data) {
    if (data == '') {
      _itemnameValue = null;
      _itemnameValue = data;
    } else {}
    update();
  }

  @override
  void onInit() {
    fetchStockDispatch();
    super.onInit();
  }

  void fetchStockDispatch() async {
    try {
      _isLoading = (true);
      var orders = await ApiCalls.fetchStockDispatch();
      if (orders != null) {
        _dispatchList = [];
        _newdispatchList = [];
        _newdispatchList = [];
        _dispatchList = orders;
        print("dispatch length");
        print(dispatchList.length);
        update();
      }
    } finally {
      _isLoading = (false);
    }
    update();
  }

  List<String> _getitemqtyy = [];
  List<String> get getitemqtyy => _getitemqtyy;

  List<String> _getitemid = [];
  List<String> get getitemid => _getitemid;
  void getReceivedItem(
    String itemid,
  ) {
    if (_getitemid.contains(itemid)) {
      getitemid.remove(itemid);
    } else {
      _getitemid.add(itemid);
    }
    update();
  }

  List<String> _getitemqty = [];
  List<String> get getitemqty => _getitemqty;
  void getReceivedQty(
    String itemqty,
  ) {
    _getitemqty.add(itemqty);

    update();
  }

  List<String> _getuniqueid = [];
  List<String> get getuniqueid => _getuniqueid;
  void getitemuniqueid(
    String uniqueid,
  ) {
    _getuniqueid.add(uniqueid);

    update();
  }

  String? _getPurchaseid = null;
  String? get getpurchaseid => _getPurchaseid;
  void getPurchaseid(String purchaseid) {
    _getPurchaseid = purchaseid;
    update();
  }

  List<String> _getdispatchid = [];
  List<String> get getdispatchid => _getdispatchid;
  void getDispatchId(
    String dispatchid,
  ) {
    _getdispatchid.add(dispatchid);

    update();
  }

  List<String> _geteditqty = [];
  List<String> get geteditqty => _geteditqty;
  void getEditQty(
    String qty,
  ) {
    if (_geteditqty.contains(qty)) {
      geteditqty.remove(qty);
    } else {
      _geteditqty.add(qty);
    }
    update();
  }
}
