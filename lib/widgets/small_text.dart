import 'package:flutter/cupertino.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';

class SmallText extends StatelessWidget {

  Color? color;
  final String text;
  double size;
  double height;
  int? maxLines;
  TextOverflow? overFLow;

  SmallText({Key? key, this.color = const Color(0xFFccc7c5),
    required this.text,
    this.size = 0,
    this.height = 1.2,
    this.maxLines,
    this.overFLow,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overFLow,
      style: TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize: size==0?Dimensions.font12:size,
        height: height,
      ),
    );
  }
}
