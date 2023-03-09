
import 'package:flutter/material.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/app_language.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'package:sauftrag/views/Auth/login.dart';
import 'package:sauftrag/widgets/dialog_button.dart';
import 'package:stacked/stacked.dart';




class WidgetTwo extends StatelessWidget {

  WidgetTwo({Key? key,}) : super(key: key);

  // RegistrationViewModel model1 = locator<RegistrationViewModel>();
  @override
  Widget build(BuildContext context) {
    return
      Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.i),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 3.h,),
          // Icon(
          //     Icons.error_outlined,
          //     color: Colors.black,size : 10.i),
          SizedBox(height: 1.5.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child:
            Text(
              "requested",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
          SizedBox(height: 3.h,),
          DialogButton(
            buttonText:
            "OK",
            buttonBackground: ColorUtils.text_red,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            buttonPress: () {

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  Login()), (Route<dynamic> route) => false);

              // Navigator.pop(context);
            },
          ),
          SizedBox(height:3.h,)
        ],
      ),
    );

  }
}
