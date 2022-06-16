import 'package:form/Controllers/networ_Controller.dart';
import 'package:form/Controllers/offlineHandler.dart';
import 'package:form/Controllers/pendingExpenses_Controller.dart';
import 'package:form/Controllers/school_Controller.dart';
import 'package:form/Controllers/stockpurchase_controller.dart';
import 'package:form/Controllers/tourController.dart';
import 'package:form/Controllers/userTaskController.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    // Get.lazyPut<OfflineHandler>(() => OfflineHandler());
    // Get.lazyPut<GetXNetworkManager>(() => GetXNetworkManager());
    // Get.lazyPut<PendingController>(() => PendingController());
    // Get.lazyPut<StateController>(() => StateController());
    // Get.lazyPut<DistrictController>(() => DistrictController());
    // Get.lazyPut<BlockController>(() => BlockController());
    // Get.lazyPut<StockPurchaseController>(() => StockPurchaseController());
    // Get.lazyPut<SchoolController>(() => SchoolController());
    // Get.lazyPut<TaskController>(() => TaskController());
    // Get.lazyPut<TourController>(() => TourController());
  }
}
