import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:temis_special_snacks/utils/colors.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? AppColors.mainColor : Colors.green,
          ),
        );
      },
    );
    return Center(
      child: Container(
        height: Dimensions.height20*5,
        width: Dimensions.height20*5,
        alignment: Alignment.center,
        child: spinkit,
      ),
    );
  }
}
