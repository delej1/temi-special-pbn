import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/widgets/big_text.dart';

void showCustomSnackBar(String message, {bool isError = true, String title = ''}){
  Get.snackbar(title, message,
  titleText: BigText(text: title, color: Colors.white,),
    messageText: Text(message, style: const TextStyle(
      color: Colors.white,
    ),),
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.black45,
    dismissDirection: DismissDirection.vertical,
    isDismissible: true,
  );
}