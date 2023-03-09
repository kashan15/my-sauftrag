import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/services/addFavorites.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/widgets/round_image.dart';
import 'package:stacked/stacked.dart';
import '../utils/app_localization.dart';
import 'dialog_event.dart';
import 'logout_dialog.dart';

class MySideMenuAdmin extends StatefulWidget {
  const MySideMenuAdmin({Key? key}) : super(key: key);

  @override
  _MySideMenuAdminState createState() => _MySideMenuAdminState();
}

class _MySideMenuAdminState extends State<MySideMenuAdmin> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
      },
      //onModelReady: (data) => data.initializeLoginModel(),
      builder: (context, model, child) {
        return Container(
          child:
              //User

              //Logout
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children:[

                  //Notification
                  InkWell(
                    onTap: () {
                      final _state = model.sideMenuKey.currentState;
                      if (_state!.isOpened)
                        _state.closeSideMenu();
                      model.navigateToNotificationScreen();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.containerHorizontalPadding,
                          vertical: Dimensions.containerVerticalPadding),
                      child: Row(
                        children: [
                          SvgPicture.asset(ImageUtils.notificationIcon),
                          SizedBox(width: 2.w),
                          // Text(
                          //   "Notification",
                          //   style: TextStyle(
                          //     color: ColorUtils.white,
                          //     fontFamily: FontUtils.modernistBold,
                          //     fontSize: 1.8.t,
                          //   ),
                          // ),
                          Text(
                            AppLocalizations.of(
                                context)!
                                .translate('my_side_menu_text_2')!,
                            style: TextStyle(
                                color: ColorUtils.white,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.5.t),
                          ),
                          SizedBox(width: 0.8.w,),
                          if(model.notificationModel?.unRead !=0)
                            Container(
                              margin: EdgeInsets.only(top: 1.h),
                              height: 3.h,
                              width: 4.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorUtils.white,
                              ),
                              child: Center(
                                child: Text(
                                  '${model.notificationModel?.unRead??'0'}',
                                  style: TextStyle(
                                      color: ColorUtils.red_color,
                                      fontSize: 1.5.t
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return LogoutDialog(title: "Add New Location",
                              btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                        }
                    );
                    //model.logOutUser();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.containerHorizontalPadding,
                        vertical: Dimensions.containerVerticalPadding),
                    child: Row(
                      children: [
                        SvgPicture.asset(ImageUtils.logoutIcon),
                        SizedBox(width: 2.w),
                        Text(
                          AppLocalizations.of(
                              context)!
                              .translate('my_side_menu_text_8')!,
                          style: TextStyle(
                            color: ColorUtils.white,
                            fontFamily: FontUtils.modernistBold,
                            fontSize: 2.5.t,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),


        );
      },
      // viewModelBuilder: () => locator<MainViewModel>(),
      // disposeViewModel: false,
    );
  }
}
