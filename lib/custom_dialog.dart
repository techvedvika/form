import 'package:flutter/material.dart';
import 'package:form/home_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'colors.dart';

class CustomEventDialog extends StatefulWidget {
  final String? desc;
  final String? title;
  const CustomEventDialog({
    Key? key,
    this.desc,
    this.title,
  }) : super(key: key);

  @override
  CustomEventDialogState createState() => CustomEventDialogState();
}

class CustomEventDialogState extends State<CustomEventDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: MyColors.primary,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    const Icon(Icons.verified_user,
                        color: Colors.white, size: 80),
                    Container(height: 10),
                    const Text("Details Sent Successfully!",
                        style: TextStyle(color: Colors.white)),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Text(
                      widget.desc ?? "",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: MyColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      child: const Text("Okay",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        if (widget.title.toString() == 'Homer') {
                          Get.to(() => const HomeScreen());
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Confirmation extends StatefulWidget {
  final String? desc;
  final String? title;
  final bool? settle;
  final Callback? onPressed;

  const Confirmation({
    Key? key,
    this.desc,
    this.title,
    this.settle,
    this.onPressed,
  }) : super(key: key);

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: MyColors.primary,
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    const Icon(Icons.warning, color: Colors.white, size: 80),
                    Container(height: 10),
                    const Text("Confirm?",
                        style: TextStyle(color: Colors.white)),
                    Container(height: 10),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(height: 10),
                    Text(
                      widget.desc ?? "",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Container(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: MyColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      child: const Text("Yes",
                          style: TextStyle(color: Colors.white)),
                      onPressed: widget.onPressed!,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: MyColors.primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                      ),
                      child: const Text("No",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
