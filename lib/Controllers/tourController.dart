import 'package:form/Controllers/apiCalls.dart';
import 'package:form/Model/tour.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TourController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<TourId>? _allTourList;
  List<TourId>? get allTourList => _allTourList;
  List<TourId>? _filterTourList;
  List<TourId>? get filterTourList => _filterTourList;
  String? _mytourid;
  String? get mytourid => _mytourid; 
  void onInit(){
    fetchTourDetails();
    super.onInit();
  }

  void fetchTourDetails()async {
    var orders = await ApiCalls.fetchTourDetails();
    if(orders != null){
    try{
      _allTourList = [];
      _allTourList = orders;
    // print(_allTourList!.length);
    _filterTourList = _allTourList!.where((element) => element.tourId == mytourid).toList();
     print(_filterTourList!.length.toString());
     print(_filterTourList![0].tourId);



     


    }finally{
      _isLoading =(false);
    }
    update();
    }


  }
 

// Here you can write your code
 mytour(String? tourid){
   _mytourid = tourid;

    
}

  


 
  

   
  
}