import 'package:flutter/cupertino.dart';
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
import 'package:sauftrag/widgets/dialog_event.dart';
import 'package:sauftrag/widgets/logout_dialog.dart';
import 'package:sauftrag/widgets/round_image.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class MySideMenu extends StatefulWidget {
  const MySideMenu({Key? key}) : super(key: key);

  @override
  _MySideMenuState createState() => _MySideMenuState();
}

class _MySideMenuState extends State<MySideMenu> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (model) {

      },
      //onModelReady: (data) => data.initializeLoginModel(),
      builder: (context, model, child) {
        return Container(
          color: ColorUtils.text_red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User
              GestureDetector(
                onTap: () async {
                  //model.navigateToBarDetails();
                  model.navigateToBarDetails();
                  PrefrencesViewModel prefs = locator<PrefrencesViewModel>();
                  model.barModel = await prefs.getBarUser();
                  if (model.barModel!.profile_picture != null &&
                      model.barModel!.profile_picture!.isNotEmpty) {
                    model.imageFiles.removeAt(1);
                    model.imageFiles
                        .insert(1, model.barModel!.profile_picture!);
                  }
                  if (model.barModel!.catalogue_image1 != null &&
                      model.barModel!.catalogue_image1!.isNotEmpty) {
                    model.imageFiles.removeAt(2);
                    model.imageFiles
                        .insert(2, model.barModel!.catalogue_image1!);
                  }
                  if (model.barModel!.catalogue_image2 != null &&
                      model.barModel!.catalogue_image2!.isNotEmpty) {
                    model.imageFiles.removeAt(3);
                    model.imageFiles
                        .insert(3, model.barModel!.catalogue_image2!);
                  }
                  if (model.barModel!.catalogue_image3 != null &&
                      model.barModel!.catalogue_image3!.isNotEmpty) {
                    model.imageFiles.removeAt(4);
                    model.imageFiles
                        .insert(4, model.barModel!.catalogue_image3!);
                  }
                  if (model.barModel!.catalogue_image4 != null &&
                      model.barModel!.catalogue_image4!.isNotEmpty) {
                    model.imageFiles.removeAt(5);
                    model.imageFiles
                        .insert(5, model.barModel!.catalogue_image4!);
                  }
                  if (model.barModel!.catalogue_image5 != null &&
                      model.barModel!.catalogue_image5!.isNotEmpty) {
                    model.imageFiles.removeAt(5);
                    model.imageFiles
                        .insert(5, model.barModel!.catalogue_image5!);
                  }
                  model.isUserProfile = false;
                  model.notifyListeners();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.containerVerticalPadding,
                      horizontal: Dimensions.containerHorizontalPadding),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          //color: ColorUtils.red_color,
                          boxShadow: [
                            BoxShadow(
                              color: ColorUtils.white.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child:
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(50),
                        //     child: Image(
                        //       image: NetworkImage(
                        //           model.barModel!.profile_picture!),
                        //       fit: BoxFit.fill,
                        //       height: 15.i,
                        //       width: 15.i,
                        //     )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: model.barModel?.profile_picture == null ?
                            SvgPicture.asset(ImageUtils.logo,
                              fit: BoxFit.fill,
                              height: 15.i,
                              width: 15.i,

                            )
                                : Image(
                              image: NetworkImage(model.barModel!.profile_picture!),
                              fit: BoxFit.fill,
                              height: 15.i,
                              width: 15.i,
                            )),
                      ),
                      SizedBox(
                        width: 2.5.w,
                      ),
                      Container(
                        width: 30.w,
                        child: Text(
                          model.barModel!.username!,
                          style: TextStyle(
                            color: ColorUtils.white,
                            fontFamily: FontUtils.modernistBold,
                            fontSize: 2.2.t,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),

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
                      Text(
                        // "Notification",
                        AppLocalizations.of(
                            context)!
                            .translate('bar_news_feed_text_2')!,
                        style: TextStyle(
                          color: ColorUtils.white,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 1.8.t,
                        ),
                      ),
                      SizedBox(width: 0.8.w,),
                      if(model.notificationModel?.unRead !=0)
                        Container(
                          height: 3.h,
                          width: 3.5.w,
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
              //Followers
              InkWell(
                onTap: () {
                  model.navigateToBarFollowersListScreen();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.containerHorizontalPadding,
                      vertical: Dimensions.containerVerticalPadding),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtils.followersIcon),
                      SizedBox(width: 2.w),
                      Text(
                        // "Bar Followers",
                        AppLocalizations.of(
                            context)!
                            .translate('bar_news_feed_text_3')!,
                        style: TextStyle(
                          color: ColorUtils.white,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 1.8.t,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Events
              InkWell(
                onTap: () {
                  //model.navigateToBarEventScreen();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogEvent(
                            title: "Add New Location",
                            btnTxt: "Add Location",
                            icon: ImageUtils.addLocationIcon);
                      });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.containerHorizontalPadding,
                      vertical: Dimensions.containerVerticalPadding),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtils.eventsIcon),
                      SizedBox(width: 2.w),
                      Text(
                        // "Events",
                        AppLocalizations.of(
                            context)!
                            .translate('bar_news_feed_text_4')!,
                        style: TextStyle(
                          color: ColorUtils.white,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 1.8.t,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Logout
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
                        // "Logout",
                        AppLocalizations.of(
                            context)!
                            .translate('bar_news_feed_text_5')!,
                        style: TextStyle(
                          color: ColorUtils.white,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 1.8.t,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }
}
