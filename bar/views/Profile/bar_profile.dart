import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/bar_model.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/widgets/round_image.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/app_localization.dart';

class BarProfile extends StatefulWidget {
  const BarProfile({Key? key}) : super(key: key);

  @override
  _BarProfileState createState() => _BarProfileState();
}

class _BarProfileState extends State<BarProfile> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
        // model.saveBarDetails();
        // model.notifyListeners();
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
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
                          Text(
                            // "Settings",
                            AppLocalizations.of(context)!
                                .translate(
                                'bar_profile_text_1')!,
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontFamily: FontUtils.modernistBold,
                              fontSize: 3.t,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),

                      ///--------------Event Name--------------------///
                      GestureDetector(
                        onTap: () async {
                          //model.notifyListeners();
                          model.isUserProfile = true;
                          model.notifyListeners();
                          model.navigateToBarDetails();
                          PrefrencesViewModel prefs =
                              locator<PrefrencesViewModel>();
                          model.updateBarAbout.text = model.barModel!.about!;
                          model.barModel = await prefs.getBarUser();
                          if (model.barModel!.profile_picture != null &&
                              model.barModel!.profile_picture!.isNotEmpty) {
                            model.imageFiles.removeAt(0);
                            model.imageFiles
                                .insert(0, model.barModel!.profile_picture!);
                          }
                          if (model.barModel!.catalogue_image1 != null &&
                              model.barModel!.catalogue_image1!.isNotEmpty) {
                            model.imageFiles.removeAt(1);
                            model.imageFiles
                                .insert(1, model.barModel!.catalogue_image1!);
                          }
                          if (model.barModel!.catalogue_image2 != null &&
                              model.barModel!.catalogue_image2!.isNotEmpty) {
                            model.imageFiles.removeAt(2);
                            model.imageFiles
                                .insert(2, model.barModel!.catalogue_image2!);
                          }
                          if (model.barModel!.catalogue_image3 != null &&
                              model.barModel!.catalogue_image3!.isNotEmpty) {
                            model.imageFiles.removeAt(3);
                            model.imageFiles
                                .insert(3, model.barModel!.catalogue_image3!);
                          }
                          if (model.barModel!.catalogue_image4 != null &&
                              model.barModel!.catalogue_image4!.isNotEmpty) {
                            model.imageFiles.removeAt(4);
                            model.imageFiles
                                .insert(4, model.barModel!.catalogue_image4!);
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
                          // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    // onPressed: () {
                                    //  /* showDialog(
                                    //       context: context,
                                    //       builder: (BuildContext context){
                                    //         return DrinkStatusDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                    //       }
                                    //   );*/
                                    // },
                                    child: Container(
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
                                      child:
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
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      model.barModel!.bar_name == null ?
                                          Text("Sauftrag",
                                            style: TextStyle(
                                              color: ColorUtils.black,
                                              fontFamily: FontUtils.modernistBold,
                                              fontSize: 2.t,
                                            ),
                                          ):
                                      Text(
                                        model.barModel!.bar_name!,
                                        style: TextStyle(
                                          color: ColorUtils.black,
                                          fontFamily: FontUtils.modernistBold,
                                          fontSize: 2.t,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Container(
                                        width: 50.w,
                                        child: model.barModel!.address == null ?
                                        Text(
                                          "Sauftrag Address",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: ColorUtils.text_grey,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 1.7.t,
                                          ),
                                          maxLines: 2,
                                        )
                                        :Text(
                                          model.barModel!.address!,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: ColorUtils.text_grey,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 1.7.t,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 30,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      ///--------------Settings Options--------------------///
                      GestureDetector(
                        onTap: () {

                          model.navigateToBarAccounts();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageUtils.profile),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                Text(
                                  // "Accounts",
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'bar_profile_text_2')!,
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
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),

                      GestureDetector(
                        onTap: () {
                          model
                              .navigateToUserProfileAccountNotificationScreen();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageUtils.notification),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                Text(
                                  // "Notification",
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'bar_profile_text_3')!,
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
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: () {
                          model.navigateToUserProfileAccountLegalTermScreen();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageUtils.terms),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                Text(
                                  // "Others",
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'bar_profile_text_4')!,
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
                              color: Colors.grey,
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
                              SvgPicture.asset(ImageUtils.packages),
                              SizedBox(
                                width: 1.5.h,
                              ),
                              Text(
                                // "Packages",
                                AppLocalizations.of(context)!
                                    .translate(
                                    'bar_profile_text_5')!,
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
                            color: Colors.grey,
                          )
                        ],
                      ),

                      //GPS
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: () {
                          model.navigateToUserProfileAccountGpsScreen();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageUtils.gps),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                Text(
                                  // "GPS",
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'bar_profile_text_6')!,
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
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),

                      //Faqs
                      SizedBox(height: 3.h),
                      GestureDetector(
                        onTap: () {
                          model.navigateToFaqScreen();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageUtils.gps),
                                SizedBox(
                                  width: 1.5.h,
                                ),
                                Text(
                                  // "FAQ",
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'bar_profile_text_7')!,
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
                              color: Colors.grey,
                            )
                          ],
                        ),
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
                                                  'bar_profile_text_8')!,
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


                                                     if
                                                     (model.checkLang == model.roles[1])
                                                     {
                                                      model.selectedAppLanguage = 1;
                                                      model.prefrencesViewModel.preferences!.setInt('selectedAppLanguage',
                                                          model.selectedAppLanguage);
                                                      model.notifyListeners();

                                                    }
                                                         else {
                                                      model.selectedAppLanguage = 0;
                                                      model.prefrencesViewModel.preferences!.setInt('selectedAppLanguage',
                                                          model.selectedAppLanguage);
                                                      model.notifyListeners();
                                                    }
                                                  },
                                                  validator: (dynamic str) {},
                                                  findFn:
                                                      (dynamic str) async => model.roles,
                                                  displayItemFn: (dynamic item) => Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        // width: 5.w,
                                                        width: 2.5.w,
                                                      ),
                                                      // Image.asset(
                                                      //   (item ?? {})['image'] ??
                                                      //       model.roles[0]
                                                      //       ["image"],
                                                      //   // scale: 5,
                                                      //   scale: 5,
                                                      //   // fit: BoxFit.fill,
                                                      // ),
                                                      // SizedBox(
                                                      //   width: 2.w,
                                                      //   height: 20.h,
                                                      // ),
                                                      // Text(
                                                      //   (item ??
                                                      //       {})['name'] ??
                                                      //       model.roles[0]
                                                      //       ["name"],
                                                      //   style: TextStyle(
                                                      //       fontSize: 2.t,
                                                      //       fontFamily: FontUtils.modernistBold),
                                                      // ),

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
                                                  dropdownItemFn: (
                                                      dynamic item,
                                                      int position,
                                                      bool focused,
                                                      bool selected,
                                                      Function() onTap) =>
                                                      ListTile(
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
                                                    model.appLanguage
                                                        .changeLanguage(
                                                        Locale('de'));
                                                  }

                                                  else {
                                                    model.appLanguage
                                                        .changeLanguage(
                                                        Locale('en'));
                                                  }
                                                  setState(() {

                                                  });
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
                                                            .translate('bar_profile_text_8')!,
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
                                            .translate('bar_profile_text_8')!,
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
                              color: Colors.grey,
                            )


                          ],

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
