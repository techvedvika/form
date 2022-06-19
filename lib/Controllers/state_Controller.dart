import 'package:form/Controllers/apiCalls.dart';
import 'package:form/Model/blockModel.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class StateInfoController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<StateInfo> _stateInfo = [];
  List<StateInfo> get stateInfo => _stateInfo;

  List<StateInfo> _uniquelist = [];
  List<StateInfo> get uniquelist => _uniquelist;

  filter() {
    print('objec t  statefilter');
    
    var seen = <String>{};

    _uniquelist =
        _stateInfo.where((student) => seen.add(student.stateName!)).toList();

    print('objec t  statefilter ${_uniquelist.length}');

    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    _isLoading = true;

    try {
      var state = await ApiCalls.fetchStateInfo();

      _stateInfo.addAll(state);
      _isLoading = false;
      update();
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }
}
