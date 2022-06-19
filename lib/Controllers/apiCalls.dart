import 'package:form/Model/blockModel.dart';
import 'package:form/Model/distribution.dart';
import 'package:form/Model/expensehead.dart';
import 'package:form/Model/issue.dart';
import 'package:form/Model/issue_atrr.dart';
import 'package:form/Model/pending_expenses.dart';
import 'package:form/Model/programme.dart';
import 'package:form/Model/school_data.dart';
import 'package:form/Model/staff_data.dart';
import 'package:form/Model/state_model.dart';
import 'package:form/Model/stockdispatch_model.dart';
import 'package:form/Model/stockpurchase_model.dart';
import 'package:form/Model/tour.dart';
import 'package:form/Model/usertaskModel.dart';
import 'package:form/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiCalls {
  static var client = http.Client();

  static Future<List<PendingExpense>> fetchPendingForms() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl +
            'pending_expense?uid=${GetStorage().read('userId')}'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return expenseFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<StateModel> fetchState() async {
    var response = await client.get(Uri.parse(MyColors.baseUrl + 'school_data'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return stateModelFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<ExpenseClaimHead>> fetchExpenseHeader() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'master_expense_claim'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return expenseClaimHeadFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Authority>> fetchAuthority() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'approval_authority'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return authorityFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // static Future<StateModel> fetchDynamic(
  //     String value, String state, String district) async {
  //   var response = await client.get(Uri.parse(MyColors.baseUrl + 'school_data'),
  //       headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     var jsonString = response.body;
  //     return stateModelFromJson(jsonString);
  //   } else {
  //     throw Exception('Failed to load post');
  //   }
  // }

  static Future<DistributionActivity> fetchDistribution() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'distribution_activity'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print(jsonString);
      return distributionActivityFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<StateInfo>> fetchStateInfo() async {
    var response = await client.get(Uri.parse(MyColors.baseUrl + 'block'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return stateInfoFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<ProgrammeMaster>> fetchProgram() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'programme_master'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print(jsonString);

      return programmeMasterFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<IssueTypeComponent>> fetchComponents(String id) async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'issue_type_components?component_id=$id'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return issueTypeComponentFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<GradeComponents>> fetchCgiGradesComponents() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'grade_components'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return gradeComponentsFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<ZoneGrade>> fetchCgiGrades() async {
    var response = await client.get(Uri.parse(MyColors.baseUrl + 'zone_grade'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return zoneGradeFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<CheckboxAttr>> fetchCheckBoxAtrr() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'issue_attribute'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return checkboxAttrFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<CgiappZones>> fetchCgiZones() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'cgiapp_zones'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return cgiappZonesFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<IssueComponent>> fetchIssue() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'issue_component'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return issueComponentFromMap(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<TourId>> fetchTourId() async {
    var response = await client.get(Uri.parse(MyColors.baseUrl + 'tour_id'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return tourIdFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<ExpenseHead>> fetchExpenseHead() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'expense_head'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return expenseHeadFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<DistrictModel> fetchData(
      String value, String state, String district) async {
    var response = await client
        .post(Uri.parse(MyColors.baseUrl + 'school_data'), headers: {
      "Accept": "application/json"
    }, body: {
      "valueq": value,
      "state": state,
      "district": district,
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return districtModelFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<Staff> fetchStaff(String office) async {
    var response =
        await client.post(Uri.parse(MyColors.baseUrl + 'staff'), headers: {
      "Accept": "application/json"
    }, body: {
      "office": office,
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return staffFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // static Future<List<SchoolData>> readJson() async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/school_basic.json');
  //   final data = await json.decode(response);

  //   return data.map<SchoolData>((json) => SchoolData.fromJson(json)).toList();

  //   // ...
  // }

//all_schools

  static Future<List<SchoolData>> readJson() async {
    var response = await client.get(
      Uri.parse(MyColors.baseUrl + 'all_schools'),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return schoolDataFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<BlockModel> fetchSchool(
      String value, String state, String district) async {
    var response = await client
        .post(Uri.parse(MyColors.baseUrl + 'school_data'), headers: {
      "Accept": "application/json"
    }, body: {
      "valueq": value,
      "state": state,
      "district": district,
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return blockModelFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  // static Future<List<StaffDetails>> readStaff() async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/employee_details.json');
  //   final data = await json.decode(response);

  //   return data
  //       .map<StaffDetails>((json) => StaffDetails.fromJson(json))
  //       .toList();

  //   // ...
  // }
  static Future<List<StockRecieved>> fetchStockRecieved() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'stock_receive'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print("from api calls");
      // print(jsonString);
      return stockRecievedFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<StockDispatch>> fetchStockDispatch() async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'stock_dispatch'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // print("from api calls dispatch");
      // print(jsonString);
      return stockDispatchFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<BlockModel> fetchBlock(
      String value, String state, String district) async {
    var response = await client
        .post(Uri.parse(MyColors.baseUrl + 'school_data'), headers: {
      "Accept": "application/json"
    }, body: {
      "valueq": value,
      "state": state,
      "district": district,
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return blockModelFromJson(jsonString);
    } else {
      throw Exception('Failed to load post');
    }
  }

  //for forms
  // static Future<List<Forms>> fetchForms(String id) async {
  //   var response = await client.get(Uri.parse(MyColors.baseUrl + 'form_name'),
  //       headers: {"Accept": "application/json"});
  //   if (response.statusCode == 200) {
  //     var jsonString = response.body;
  //     // print("This is from forms");
  //     // print(jsonString);
  //     return formsFromJson(jsonString);
  //   } else {
  //     throw Exception("Data is not found");
  //   }
  // }

//for tasks
//for forms
  static Future<List<TaskId>> fetchTasks(String id) async {
    var response = await client.get(
        Uri.parse(MyColors.baseUrl + 'emp_task?empId=$id'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;
      print(jsonString);

      return taskIdFromJson(jsonString);
    } else {
      throw Exception("Data is not found");
    }
  }

//for tour details
  static Future<List<TourId>> fetchTourDetails() async {
    var response = await client.get(Uri.parse(MyColors.baseUrl + 'tour_detail'),
        headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var jsonString = response.body;

      return tourIdFromJson(jsonString);
    } else {
      throw Exception("Data is not found");
    }
  }

// Future userTask(String empId) async {
//   var response = await http.post(Uri.parse(MyColors.baseUrl + 'emp_task'),
//       headers: {"Accept": "Application/json"},
//       body: {'empId': empId, });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

}
