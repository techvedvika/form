import 'package:flutter/material.dart';
import 'package:form/Controllers/networ_Controller.dart';
import 'package:form/Controllers/pendingExpenses_Controller.dart';
import 'package:form/colors.dart';
import 'package:form/forms/pendingForm.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

final PendingController _pendingController = Get.put(PendingController());
final GetXNetworkManager _networkManager = Get.put(GetXNetworkManager());

 class PendingScreen extends StatefulWidget {
   const PendingScreen({ Key? key }) : super(key: key);
 
   @override
   State<PendingScreen> createState() => _PendingScreenState();
 }
 
 class _PendingScreenState extends State<PendingScreen> {
    @override
  void initState() {
    super.initState();
    stateController.fetchState();
    authController.fetchAuth();
    schoolController.fetchSchool();
    pendingController.fetchPending();


  }
   @override
   Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primary,
          title: const Text('Pending Payments '),
          actions: [
            IconButton(
                onPressed: () {
                  //    _offlineHandler.expenses.clear();
                },
                icon: const Icon(Icons.clear))
          ],
        ),
        body: Obx(
          () => _networkManager.connectionType.value == 0
              ? const Center(
                  child: FittedBox(
                    child: Text('Connect to Internet to view this section',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                  ),
                )
              : GetBuilder<PendingController>(
                  init: PendingController(),
                  builder: (pendingController) {
                    return pendingController.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : pendingController.pendingList.isEmpty
                            ? const Center(
                                child: Text(
                                'No Pending Form Data',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.primary),
                              ))
                            : Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: ListView.separated(
                                        itemCount: pendingController
                                            .pendingList.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            leading: Text(
                                                "(${(index + 1)})   " +
                                                    pendingController
                                                        .pendingList[index]
                                                        .submissionDate
                                                        .toString()),
                                            title: Text(
                                              pendingController
                                                  .pendingList[index].vendorName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Invoice Amount :" +
                                                      pendingController
                                                          .pendingList[index]
                                                          .invoiceAmt
                                                          .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Invoice No :" +
                                                      pendingController
                                                          .pendingList[index]
                                                          .invoiceNo
                                                          .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Invoice Date :" +
                                                      pendingController
                                                          .pendingList[index]
                                                          .dateOfInvoice
                                                          .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: MyColors.primary,
                                              ),
                                              onPressed: () {
                                                Get.to(() => PendingForm(
                                                    pendingExpense:
                                                        pendingController
                                                                .pendingList[
                                                            index]));
                                                // _networkManager.insertData(
                                                //   _offlineHandler.expenses[index].office
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].submissionDate
                                                //       .toString(),
                                                //   _offlineHandler.expenses[index].tourID
                                                //       .toString(),
                                                //   _offlineHandler.expenses[index].vendorName
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].invoiceNumber
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].invoiceDate
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].invoiceAmount
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].towardsCost
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].expenseHead
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].projectName
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].sponsorName
                                                //       .toString(),
                                                //   _offlineHandler.expenses[index].expenseBy
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].expenseApprovedBy
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].invoiceImage
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].dateOfPayment
                                                //       .toString(),
                                                //   _offlineHandler.expenses[index].paidBy
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].paymentApprovedBy
                                                //       .toString(),
                                                //   _offlineHandler.expenses[index].paidAmount
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].paymentType
                                                //       .toString(),
                                                //   _offlineHandler
                                                //       .expenses[index].paymentMode
                                                //       .toString(),
                                                //   _offlineHandler.expenses[index].userId
                                                //       .toString(),
                                                // );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              );
                  }),
        ));

  
    }
 }



// class PendingScreen extends StatelessWidget {
//   const PendingScreen({Key? key}) : super(key: key);
   
  

//   @override
  // Widget build(BuildContext context) {
   
// }
