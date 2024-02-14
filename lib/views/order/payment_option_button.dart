import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/controllers/order_controller.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:temis_special_snacks/utils/styles.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final int index;

  const PaymentOptionButton({Key? key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController){
      bool _selected = orderController.paymentIndex==index;
      return InkWell(
        onTap: ()=>orderController.setPaymentIndex(index),
        child: Container(
          padding: EdgeInsets.only(bottom: Dimensions.height10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20/4),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1,
                )
              ]
          ),
          child: ListTile(
            leading: Icon(
              icon,
              size: 40,
              color: _selected?AppColors.mainColor:Theme.of(context).disabledColor,
            ),
            title: Text(
              title,
              style: fontMedium.copyWith(fontSize: Dimensions.font20),
            ),
            subtitle: Text(
              subTitle,
              style: fontRegular.copyWith(fontSize: Dimensions.font16,
                color: Theme.of(context).disabledColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: _selected?Icon(Icons.check_circle, color: Theme.of(context).primaryColor,):null,
          ),
        ),
      );
    });
  }
}
