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

class MySideMenu extends StatefulWidget {
  const MySideMenu({Key? key}) : super(key: key);

  @override
  _MySideMenuState createState() => _MySideMenuState();
}

class _MySideMenuState extends State<MySideMenu> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //User
              GestureDetector(
                onTap: () async {
                  // model.isUserProfile = true;
                  // model.notifyListeners();
                  // model.navigateToUserDetailSettings();
                  //model.isUserProfile = false;
                  // model.notifyListeners();
                  model.isUserProfile = true;
                  model.notifyListeners();
                  model.navigateToUserDetailSettings();
                  PrefrencesViewModel prefs = locator<PrefrencesViewModel>();

                  model.drinkList = await Addfavorites().GetFavoritesDrink();
                  model.clubList = await Addfavorites().GetFavoritesClub();
                  model.vacationList =
                      await Addfavorites().GetFavoritesPartyVacation();

                  model.userModel = (await prefs.getUser())!;
                  if (model.userModel!.profile_picture != null &&
                      model.userModel!.profile_picture!.isNotEmpty) {
                    model.imageFiles.removeAt(0);
                    model.imageFiles
                        .insert(0, model.userModel!.profile_picture!);
                  }
                  if (model.userModel!.catalogue_image1 != null &&
                      model.userModel!.catalogue_image1!.isNotEmpty) {
                    model.imageFiles.removeAt(1);
                    model.imageFiles
                        .insert(1, model.userModel!.catalogue_image1!);
                  }
                  if (model.userModel!.catalogue_image2 != null &&
                      model.userModel!.catalogue_image2!.isNotEmpty) {
                    model.imageFiles.removeAt(2);
                    model.imageFiles
                        .insert(2, model.userModel!.catalogue_image2!);
                  }
                  if (model.userModel!.catalogue_image3 != null &&
                      model.userModel!.catalogue_image3!.isNotEmpty) {
                    model.imageFiles.removeAt(3);
                    model.imageFiles
                        .insert(3, model.userModel!.catalogue_image3!);
                  }
                  if (model.userModel!.catalogue_image4 != null &&
                      model.userModel!.catalogue_image4!.isNotEmpty) {
                    model.imageFiles.removeAt(4);
                    model.imageFiles
                        .insert(4, model.userModel!.catalogue_image4!);
                  }
                  if (model.userModel!.catalogue_image5 != null &&
                      model.userModel!.catalogue_image5!.isNotEmpty) {
                    model.imageFiles.removeAt(5);
                    model.imageFiles
                        .insert(5, model.userModel!.catalogue_image5!);
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
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: model.userModel?.profile_picture == null ?
                            SvgPicture.asset(ImageUtils.logo,
                              fit: BoxFit.fill,
                              height: 15.i,
                              width: 15.i,

                            )
                                : Image(
                              image: NetworkImage(model.userModel!.profile_picture!),
                              fit: BoxFit.fill,
                              height: 15.i,
                              width: 15.i,
                            )),
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(50),
                        //     child: Image(
                        //       image: NetworkImage(
                        //           model.userModel!.profile_picture!),
                        //       fit: BoxFit.cover,
                        //       height: 15.i,
                        //       width: 15.i,
                        //     )),
                      ),
                      SizedBox(
                        width: 2.5.w,
                      ),
                      Flexible(
                        child: Text(
                          model.userModel!.username!,
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

              //Ranking List
              InkWell(
                onTap: () {
                  model.navigateToRatingList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.containerHorizontalPadding,
                      vertical: Dimensions.containerVerticalPadding),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtils.rankingListIcon),
                      SizedBox(width: 2.w),
                      Text(
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_1')!,
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
              //language


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
                            fontSize: 1.8.t),
                      ),
                      SizedBox(width: 0.8.w,),
                      if(model.notificationModel?.unRead !=0)
                      Container(
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

              //Matched
              InkWell(
                onTap: () {
                  model.navigateToMatchedList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.containerHorizontalPadding,
                      vertical: Dimensions.containerVerticalPadding),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtils.matchedIcon),
                      SizedBox(width: 2.w),
                      Text(
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_3')!,
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

              //Bars & Clubs
              InkWell(
                onTap: () {
                  model.navigateToBarAndClubsScreen();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.containerHorizontalPadding,
                      vertical: Dimensions.containerVerticalPadding),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtils.barsIcon),
                      SizedBox(width: 2.w),
                      Text(
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_4')!,
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

              //Followers
              // InkWell(
              //   onTap: () {
              //     model.navigateToFollowersListScreen();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: Dimensions.containerHorizontalPadding,
              //         vertical: Dimensions.containerVerticalPadding),
              //     child: Row(
              //       children: [
              //         SvgPicture.asset(ImageUtils.followersIcon),
              //         SizedBox(width: 2.w),
              //         Text(
              //           "Bars & Clubs",
              //           style: TextStyle(
              //             color: ColorUtils.white,
              //             fontFamily: FontUtils.modernistBold,
              //             fontSize: 1.8.t,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              //Bars
              // InkWell(
              //   onTap: () {
              //     model.navigateToListOfBar();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(
              //         horizontal: Dimensions.containerHorizontalPadding,
              //         vertical: Dimensions.containerVerticalPadding),
              //     child: Row(
              //       children: [
              //         SvgPicture.asset(ImageUtils.barsIcon),
              //         SizedBox(width: 2.w),
              //         Text(
              //           "Followed Bars & Clubs",
              //           style: TextStyle(
              //             color: ColorUtils.white,
              //             fontFamily: FontUtils.modernistBold,
              //             fontSize: 1.8.t,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              //QR Code
              InkWell(
                onTap: () {
                  model.navigateToUserBarCodeScanner();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.containerHorizontalPadding,
                      vertical: Dimensions.containerVerticalPadding),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImageUtils.qrCodeIcon),
                      SizedBox(width: 2.w),
                      Text(
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_5')!,
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

                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return DialogEvent(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                      }
                  ) ;
                  //model.navigateToUpcomingEvent();
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
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_6')!,
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

              //FeedBack
              InkWell(
                onTap: () {

                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context){
                  //       return DialogEvent(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                  //     }
                  // ) ;
                  model.navigateToUserFeedbackScreen();
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
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_7')!,
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
                        AppLocalizations.of(
                            context)!
                            .translate('my_side_menu_text_8')!,
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
      // viewModelBuilder: () => locator<MainViewModel>(),
      // disposeViewModel: false,
    );
  }
}
