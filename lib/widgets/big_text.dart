import 'package:flutter/cupertino.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';

class BigText extends StatelessWidget {

  Color? color;
  final String text;
  double size;
  TextOverflow overFLow;

   BigText({Key? key, this.color = const Color(0xFF332d2b),
    required this.text,
    this.overFLow = TextOverflow.ellipsis,
    this.size = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFLow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        fontSize: size == 0?Dimensions.font16:size,
      ),
    );
  }
}
