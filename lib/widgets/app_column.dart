import 'package:flutter/material.dart';
import 'package:temis_special_snacks/widgets/small_text.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'big_text.dart';
import 'icon_and_text_widget.dart';

class AppColumn extends StatelessWidget {
  final String nameText;
  final String? descText;
  final String starText;
  final int starInt;
  final String price;

  const AppColumn({Key? key, required this.nameText, this.descText, required this.starText, required this.starInt, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BigText(
          text: nameText,
          size: Dimensions.font20,),
        SizedBox(height: Dimensions.height10/2,),
        SmallText(
          text: descText??"",
          maxLines: 1,
          overFLow: TextOverflow.ellipsis,
          size: Dimensions.font26/2,),
        SizedBox(height: Dimensions.height10/2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Wrap(
                  children: List.generate(
                      starInt, (index) => Icon(
                    Icons.star,
                    color: AppColors.mainColor,
                    size: Dimensions.iconSize15,
                      )),
                ),
                SizedBox(width: Dimensions.width10,),
                SmallText(text: starText),
              ],
            ),
            SizedBox(height: Dimensions.height20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                IconAndTextWidget(
                    icon: Icons.access_time_rounded,
                    text: "Within 24hrs",
                    iconColor: AppColors.iconColor2)
              ],
            ),
          ],
        ),
        SizedBox(height: Dimensions.height10/2,),
        Align(alignment: Alignment.bottomRight,
            child: Text(price,
              style: const TextStyle(color: Colors.green),)
        )
      ],
    );
  }
}
