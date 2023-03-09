import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:stacked/stacked.dart';

import '../utils/app_localization.dart';

class DialogEvent extends StatefulWidget {

  String title;
  String btnTxt;
  String icon;

  DialogEvent({Key? key, required this.title, required this.btnTxt, required this.icon}) : super(key: key);

  @override
  _DialogEventState createState() => _DialogEventState();
}

class _DialogEventState extends State<DialogEvent> {
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<AuthenticationViewModel>.reactive(
      //onModelReady: (data) => data.initializeShareDialog(),
      builder: (context, model, child){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding, vertical: Dimensions.verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 1.h),

                SvgPicture.asset(ImageUtils.eventLock),
                SizedBox(height: 3.h),

                //Not Possible To Choose
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    // "Sorry :(",
                    AppLocalizations.of(
                        context)!
                        .translate('dialog_text_1')!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.red_color,
                      fontFamily: FontUtils.modernistBold,
                      fontSize: 2.4.t,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                //Not Possible To Choose
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    //"Currently we are working on this amazing feature.",
                    AppLocalizations.of(
                        context)!
                        .translate('dialog_text_2')!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontFamily: FontUtils.modernistRegular,
                      fontSize: 1.8.t,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<AuthenticationViewModel>(),
      disposeViewModel: false,
    );
  }
}

//
class DialogEventOne extends StatefulWidget {

  String title;
  String btnTxt;
  String icon;

  DialogEventOne({Key? key, required this.title, required this.btnTxt, required this.icon}) : super(key: key);

  @override
  _DialogEventOneState createState() => _DialogEventOneState();
}

class _DialogEventOneState extends State<DialogEventOne> {
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<AuthenticationViewModel>.reactive(
      //onModelReady: (data) => data.initializeShareDialog(),
      builder: (context, model, child){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding, vertical: Dimensions.verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 1.h),

                SvgPicture.asset(ImageUtils.eventLock),
                SizedBox(height: 3.h),

                //Not Possible To Choose
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Please",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.red_color,
                      fontFamily: FontUtils.modernistBold,
                      fontSize: 2.4.t,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                //Not Possible To Choose
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Add atleast one image",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontFamily: FontUtils.modernistRegular,
                      fontSize: 1.8.t,
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<AuthenticationViewModel>(),
      disposeViewModel: false,
    );
  }
}
