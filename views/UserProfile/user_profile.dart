import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/services/addFavorites.dart';
import 'package:sauftrag/services/updateUserProfile.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/common_functions.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class UserProfile extends StatefulWidget {

  const UserProfile({Key? key}) : super(key: key);


  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            print("");
            //FocusScope.of(context).unfocus();
          },
          child: /*model.isLoading == false ? AllPageLoader() :*/
          SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                      children: [
                        SizedBox(height: Dimensions.topMargin),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(
                            //   "Settings",
                            //   style: TextStyle(
                            //     color: ColorUtils.black,
                            //     fontFamily: FontUtils.modernistBold,
                            //     fontSize: 3.t,
                            //   ),
                            // ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate(
                                  'user_profile_text_1')!,
                              style: TextStyle(
                                fontFamily:
                                FontUtils.modernistBold,
                                fontSize: 3.t,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),

                        ///--------------Event Name--------------------///
                        GestureDetector(
                          onTap: () async {
                            model.isUserProfile = true;
                            model.notifyListeners();
                            model.navigateToUserDetailSettings();
                            PrefrencesViewModel prefs =
                            locator<PrefrencesViewModel>();
                            model.updateUserAbout.text = model.userModel!.about!;
                            model.drinkList =
                            await Addfavorites().GetFavoritesDrink();
                            model.clubList =
                            await Addfavorites().GetFavoritesClub();
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
                            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: ColorUtils.red_color,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorUtils.black
                                                .withOpacity(0.12),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      // onPressed: () {
                                      //  /* showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context){
                                      //         return DrinkStatusDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                      //       }
                                      //   );*/
                                      // },
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
                                      //     child: model.userModel?.profile_picture == null ?
                                      //         SvgPicture.asset(
                                      //           ImageUtils.matchIcon,
                                      //           fit: BoxFit.cover,
                                      //           height: 15.i,
                                      //           width: 15.i,
                                      //         ) :
                                      //     Image(
                                      //       image: NetworkImage(model.userModel!.profile_picture!),
                                      //       fit: BoxFit.cover,
                                      //       height: 15.i,
                                      //       width: 15.i,
                                      //     )),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(right: 20),
                                    //   child: RoundImage(
                                    //     url: widget.profile.imageurl,
                                    //     txtsize: 18,
                                    //     txt: widget.profile.fullName,
                                    //     width: 50,
                                    //     height: 50,
                                    //     borderRadius: 15,
                                    //   ),
                                    // ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 35.w,
                                          child: Text(
                                            model.userModel!.username!,
                                            style: TextStyle(
                                              color: ColorUtils.black,
                                              fontFamily: FontUtils.modernistBold,
                                              fontSize: 2.t,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        model.userModel!.phone_no == null ?
                                        Text(
                                          "0321-1234567",
                                          style: TextStyle(
                                            color: ColorUtils.text_grey,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 1.7.t,
                                          ),
                                        )
                                        :Text(
                                          model.userModel!.phone_no!,
                                          style: TextStyle(
                                            color: ColorUtils.text_grey,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 1.7.t,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  size: 30,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: ColorUtils.text_red,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                ImageUtils.levelStar,
                                height: 20.i,
                                width: 20.i,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Level 21",
                                      style: TextStyle(
                                        fontFamily: FontUtils.modernistBold,
                                        color: Colors.white,
                                        fontSize: 2.5.t,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 2.h,
                                    // ),
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width / 1.5,
                                      child: Text(
                                        "You are just 25 points away to reach next level",
                                        style: TextStyle(
                                          fontFamily: FontUtils.modernistRegular,
                                          color: Colors.white,
                                          fontSize: 1.6.t,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1.0.h,
                                    ),
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width / 1.6,
                                      child: SizedBox(
                                          height: 8,
                                          child: LiquidLinearProgressIndicator(
                                            value: 0.45,
                                            // Defaults to 0.5.
                                            valueColor: AlwaysStoppedAnimation(
                                                ColorUtils.settingsProgress),
                                            // Defaults to the current Theme's accentColor.
                                            backgroundColor: Colors.white,
                                            // Defaults to the current Theme's backgroundColor.
                                            //borderColor: Colors.red, //border color of the bar
                                            //borderWidth: 5.0, //border width of the bar
                                            borderRadius: 12.0,
                                            //border radius
                                            direction: Axis.horizontal,
                                            // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                            //center: Text("50%"), //text inside bar
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),

                        ///--------------Settings Options--------------------///
                        ExpandTapWidget(
                          onTap: () {
                            model.navigateToUserProfileAccountScreen();
                          },
                          tapPadding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(ImageUtils.userProfileAccount),
                                  SizedBox(
                                    width: 1.5.h,
                                  ),
                                  // Text(
                                  //   "Accounts",
                                  //   style: TextStyle(
                                  //     color: ColorUtils.black,
                                  //     fontFamily: FontUtils.modernistBold,
                                  //     fontSize: 2.t,
                                  //   ),
                                  // ),

                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate(
                                        'user_profile_text_2')!,
                                    style: TextStyle(
                                      fontFamily:
                                      FontUtils.modernistBold,
                                      fontSize: 2.t,
                                    ),
                                  ),

                                  // Container(
                                  //   margin: EdgeInsets.only(right: 20),
                                  //   child: RoundImage(
                                  //     url: widget.profile.imageurl,
                                  //     txtsize: 18,
                                  //     txt: widget.profile.fullName,
                                  //     width: 50,
                                  //     height: 50,
                                  //     borderRadius: 15,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 30,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        ExpandTapWidget(
                          onTap: () {
                            model
                                .navigateToUserProfileAccountNotificationScreen();
                          },
                          tapPadding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      ImageUtils.userProfileNotification),
                                  SizedBox(
                                    width: 1.5.h,
                                  ),
                                  // Text(
                                  //   "Notification",
                                  //   style: TextStyle(
                                  //     color: ColorUtils.black,
                                  //     fontFamily: FontUtils.modernistBold,
                                  //     fontSize: 2.t,
                                  //   ),
                                  // ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate(
                                        'user_profile_text_3')!,
                                    style: TextStyle(
                                      fontFamily:
                                      FontUtils.modernistBold,
                                      fontSize: 2.t,
                                    ),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.only(right: 20),
                                  //   child: RoundImage(
                                  //     url: widget.profile.imageurl,
                                  //     txtsize: 18,
                                  //     txt: widget.profile.fullName,
                                  //     width: 50,
                                  //     height: 50,
                                  //     borderRadius: 15,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 30,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        ExpandTapWidget(
                          onTap: () {
                            model.navigateToUserProfileAccountLegalTermScreen();
                          },
                          tapPadding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                      ImageUtils.userProfileLegalTerms),
                                  SizedBox(
                                    width: 1.5.h,
                                  ),
                                  // Text(
                                  //   "Legal Terms",
                                  //   style: TextStyle(
                                  //     color: ColorUtils.black,
                                  //     fontFamily: FontUtils.modernistBold,
                                  //     fontSize: 2.t,
                                  //   ),
                                  // ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate(
                                        'user_profile_text_4')!,
                                    style: TextStyle(
                                      fontFamily:
                                      FontUtils.modernistBold,
                                      fontSize: 2.t,
                                    ),
                                  ),
                                  // Container(
                                  //   margin: EdgeInsets.only(right: 20),
                                  //   child: RoundImage(
                                  //     url: widget.profile.imageurl,
                                  //     txtsize: 18,
                                  //     txt: widget.profile.fullName,
                                  //     width: 50,
                                  //     height: 50,
                                  //     borderRadius: 15,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 30,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                    ImageUtils.userProfileInviteFriends),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                // Text(
                                //   "Invite Your Friends",
                                //   style: TextStyle(
                                //     color: ColorUtils.black,
                                //     fontFamily: FontUtils.modernistBold,
                                //     fontSize: 2.t,
                                //   ),
                                // ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'user_profile_text_5')!,
                                  style: TextStyle(
                                    fontFamily:
                                    FontUtils.modernistBold,
                                    fontSize: 2.t,
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(right: 20),
                                //   child: RoundImage(
                                //     url: widget.profile.imageurl,
                                //     txtsize: 18,
                                //     txt: widget.profile.fullName,
                                //     width: 50,
                                //     height: 50,
                                //     borderRadius: 15,
                                //   ),
                                // ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 30,
                              color: Colors.black,
                            )
                          ],
                        ),
                        SizedBox(height: 3.h),

                        ExpandTapWidget(
                          onTap: (){

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  content: SizedBox(
                                    height: 28.h,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            model.navigateBack();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              SvgPicture.asset(
                                                ImageUtils.cancelIcon,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                                          child: Column(
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                    'user_profile_text_6')!,
                                                style: TextStyle(
                                                  fontFamily:
                                                  FontUtils.modernistBold,
                                                  fontSize: 2.t,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Material(
                                                elevation: 10,
                                                shadowColor: ColorUtils.black
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                BorderRadius.circular(7),
                                                child: Container(
                                                  // padding: EdgeInsets.all(20),
                                                  height: 8.h,
                                                  // width: 100.w,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: ColorUtils.red_color),
                                                      borderRadius: BorderRadius.circular(7)),
                                                  child: DropdownFormField<Map<String, dynamic>>(
                                                    onEmptyActionPressed: () async {},
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      suffixIcon: Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: ColorUtils.black,
                                                      ),
                                                    ),
                                                    onSaved: (dynamic str) {
                                                      //print("onSaved" + str);
                                                    },
                                                    onChanged:
                                                        (dynamic str) async {
                                                      //print("onChanged" + str);
                                                      model.selectedrole = str;
                                                      print(str);
                                                      model.checkLang = str;
                                                      if (model.checkLang == model.roles[1]) {
                                                        model.selectedAppLanguage = 1;
                                                        model.prefrencesViewModel.preferences!.setInt('selectedAppLanguage',
                                                            model.selectedAppLanguage);
                                                        model.notifyListeners();
                                                      } else {
                                                        model.selectedAppLanguage = 0;
                                                        model.prefrencesViewModel.preferences!.setInt('selectedAppLanguage', model.selectedAppLanguage);
                                                        model.notifyListeners();
                                                      }
                                                    },
                                                    validator: (dynamic str) {},
                                                    findFn:
                                                        (dynamic str) async => model.roles,
                                                    displayItemFn: (dynamic item) =>
                                                        Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [

                                                        SizedBox(
                                                          // width: 5.w,
                                                          width: 2.5.w,
                                                        ),
                                                        model.checkLang == model.roles[1] ?
                                                          Image.asset(
                                                            (item ??
                                                                {})['image'] ??
                                                                model.roles[1]
                                                                ["image"],
                                                            // scale: 5,
                                                            scale: 5,
                                                            // fit: BoxFit.fill,
                                                          ):
                                                        Image.asset(
                                                          (item ??
                                                              {})['image'] ??
                                                              model.roles[0]
                                                              ["image"],
                                                          // scale: 5,
                                                          scale: 5,
                                                          // fit: BoxFit.fill,
                                                        ),
                                                          SizedBox(
                                                            width: 2.w,
                                                            height: 20.h,
                                                          ),
                                                        model.checkLang == model.roles[1] ?
                                                          Text(
                                                            (item ??
                                                                {})['name'] ??
                                                                model.roles[1] ["name"],
                                                            style: TextStyle(
                                                                fontSize: 2.t,
                                                                fontFamily: FontUtils
                                                                    .modernistBold),
                                                          ) :
                                                        Text(
                                                          (item ??
                                                              {})['name'] ??
                                                              model.roles[0] ["name"],
                                                          style: TextStyle(
                                                              fontSize: 2.t,
                                                              fontFamily: FontUtils
                                                                  .modernistBold),
                                                        ),


                                                      ],
                                                    ),
                                                    selectedFn: (dynamic item1,
                                                        dynamic item2) {
                                                      if (item1 != null &&
                                                          item2 != null) {
                                                        return item1['name'] ==
                                                            item2['name'];
                                                      }
                                                      return false;
                                                    },

// filterFn: (dynamic item, str) => item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
                                                    dropdownItemFn: (dynamic item,
                                                        int position,
                                                        bool focused,
                                                        bool selected,
                                                        Function() onTap) => ListTile(
                                                      title: Row(
                                                        children: [
                                                          Image.asset(
                                                            (item ?? {})['image'] ?? '',
                                                            scale: 5,
                                                          ),
                                                          SizedBox(
                                                            width: 3.w,
                                                          ),
                                                          Text(item['name']),
                                                        ],
                                                      ),
                                                      tileColor: focused
                                                          ? ColorUtils.red_color
                                                          : Colors.transparent,
                                                      onTap: onTap,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4.h,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    print(model.checkLang);
                                                    print(model.selectedAppLanguage);
                                                    if (model.selectedAppLanguage == 1 &&
                                                        model.prefrencesViewModel.preferences!.getInt('selectedAppLanguage') == 1) {
                                                      model.appLanguage.changeLanguage(
                                                          Locale('de'));
                                                    }
                                                    else {
                                                      model.appLanguage.changeLanguage(
                                                          Locale('en'));
                                                    }
                                                    model.navigateBack();
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: ColorUtils.red_color,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(15)),
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 1.7.h),
                                                      child: Center(
                                                        child: Text(
                                                          AppLocalizations.of(context)!
                                                              .translate('user_profile_text_6')!,
                                                          style: TextStyle(
                                                              color: ColorUtils.white,
                                                              fontFamily: FontUtils.modernistBold),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                //  Button(
                                                //     AppLocalizations.of(
                                                //             context)!
                                                //         .translate(
                                                //             'user_change_name_text_2')!,
                                                //     15)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },

                          tapPadding: EdgeInsets.all(8),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  children:[
                                    // SvgPicture.asset(
                                    //     ImageUtils.userProfileInviteFriends),
                                    Icon(Icons.language_outlined),
                                    SizedBox(width: 1.5.h,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate('user_profile_text_6')!,
                                          style: TextStyle(
                                              fontFamily: FontUtils.modernistBold,
                                              fontSize: 2.t),
                                        ),
                                        SizedBox(height: 0.5.h,),
                                        if (model.selectedAppLanguage == 1)
                                          Text(
                                            model.roles[1]['name'],
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistRegular,
                                                fontSize: 1.5.t),
                                          )
                                        else if (model.prefrencesViewModel.preferences!.getInt('selectedAppLanguage') ==
                                            1)
                                          Text(
                                            model.roles[1]['name'],
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistRegular,
                                                fontSize: 1.5.t),
                                          )
                                        else
                                          Text(
                                            model.roles[0]['name'],
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistRegular,
                                                fontSize: 2.t),
                                          )
                                      ],

                                    ),
                                  ]),
                              // Icon(
                              //   Icons.arrow_forward_ios,
                              //   color: ColorUtils.black,
                              //   size: 4.i,
                              // )
                              // SizedBox(width: 15.h,),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 30,
                                color: Colors.black,
                              )


                            ],

                          ),
                        ),

                        SizedBox(height: 3.h),

                        /*ExpandTapWidget(
                        onTap: () {
                          model.navigateToUserProfileAccountGpsScreen();
                        },
                        tapPadding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageUtils.userProfileGPs),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                Text(
                                  "GPS",
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.t,
                                  ),
                                ),
                                // Container(
                                //   margin: EdgeInsets.only(right: 20),
                                //   child: RoundImage(
                                //     url: widget.profile.imageurl,
                                //     txtsize: 18,
                                //     txt: widget.profile.fullName,
                                //     width: 50,
                                //     height: 50,
                                //     borderRadius: 15,
                                //   ),
                                // ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              size: 30,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),*/
                      ]
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onModelReady: (model){

      },
    );
  }
}