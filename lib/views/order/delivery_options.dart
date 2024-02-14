import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/controllers/order_controller.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/utils/styles.dart';

class DeliveryOptions extends StatelessWidget {
  final String value;
  final String title;
  final int amount;
  final bool isFree;
  const DeliveryOptions({Key? key, required this.value,
    required this.title,
    required this.amount,
    required this.isFree}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController){
      return Row(
        children: [
          Radio(
            onChanged: (String? value){orderController.setDeliveryType(value!);} ,
            groupValue: orderController.orderType,
            value: value,
            activeColor: Theme.of(context).primaryColor,
          ),
          SizedBox(width: Dimensions.width10,),
          Text(title, style: fontRegular.copyWith(fontSize: Dimensions.font20),),
          SizedBox(width: Dimensions.width10,),
          Text('(${(value == 'Pick up' ||isFree)?'Free':'₦${(amount/10).round()}'})',
            style: fontMedium.copyWith(fontSize: Dimensions.font20),
          ),
        ],
      );
    });
  }
}
