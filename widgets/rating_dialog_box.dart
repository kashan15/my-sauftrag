import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/view_profile.dart';
import 'package:stacked/stacked.dart';

import '../models/user_models.dart';
import '../utils/app_localization.dart';
import 'loader.dart';

class RatingDialogBox extends StatefulWidget {
  String title;
  String btnTxt;
  String icon;

  RatingDialogBox(
      {Key? key, required this.title, required this.btnTxt, required this.icon})
      : super(key: key);

  @override
  _RatingDialogBoxState createState() => _RatingDialogBoxState();
}

class _RatingDialogBoxState extends State<RatingDialogBox> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      //onModelReady: (data) => data.initializeShareDialog(),
      builder: (context, model, child) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        model.navigateBack();
                      },
                      iconSize: 15.0,
                      //padding: EdgeInsets.all(20),
                      //constraints: BoxConstraints(),
                      icon: SvgPicture.asset(ImageUtils.cancelIcon),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding,
                      vertical: Dimensions.verticalPadding),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 1.h),
                        Text(
                          "How did we do it?",
                          style: TextStyle(
                            color: ColorUtils.black,
                            fontFamily: FontUtils.modernistBold,
                            fontSize: 2.5.t,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          alignment: Alignment.center,
                          child: RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 10.i,
                            itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star_rounded,
                              color: ColorUtils.red_color,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                              model.rate = rating;
                            },
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          //width: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(color: ColorUtils.red_color)),
                          child: TextField(
                            onTap: () {},
                            //enabled: true,
                            // readOnly: true,

                            //focusNode: model.searchFocus,
                            controller: model.barGiveRating,
                            decoration: InputDecoration(
                              hintText: "Write your comment",
                              hintStyle: TextStyle(
                                //fontFamily: FontUtils.proximaNovaRegular,
                                color: ColorUtils.icon_color,
                                fontSize: SizeConfig.textMultiplier * 1.8,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.heightMultiplier * 1.8),
                            ),
                            maxLines: 6,
                            maxLength: 150,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                          child: ElevatedButton(
                            onPressed: () async {
                              model.isLoading = true;
                              model.notifyListeners();
                              await model.giveRatingToBar();
                              // await model.getListOfAllBars();
                              model.selectedBar = await model.userGetBarInfo(
                                  model.selectedBar!.id.toString());
                              ;
                              model.notifyListeners();
                              model.navigateBack();
                              model.navigateBack();
                              model.isLoading = false;
                              model.notifyListeners();
                              //model.navigateToBarProfile();
                              //model.navigateBack();
                              print(model.rate);
                            },
                            child: const Text("Submit"),
                            style: ElevatedButton.styleFrom(
                              primary: ColorUtils.text_red,
                              onPrimary: ColorUtils.white,
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      Dimensions.containerVerticalPadding),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.roundCorner)),
                              textStyle: TextStyle(
                                color: ColorUtils.white,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 1.8.t,
                                //height: 0
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }
}

class ReportChatDialogBox extends StatefulWidget {
  String? id;

  String? name;
  String? email;
  String? user;

  ReportChatDialogBox({Key? key, this.name, this.email, this.id, this.user})
      : super(key: key);

  @override
  _ReportChatDialogBoxState createState() => _ReportChatDialogBoxState();
}

class _ReportChatDialogBoxState extends State<ReportChatDialogBox> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      //onModelReady: (data) => data.initializeShareDialog(),
      builder: (context, model, child) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        model.openBurgerMenu = false;
                        model.openBurgerMenu = false;
                        model.notifyListeners();
                        model.navigateBack();
                      },
                      iconSize: 15.0,
                      //padding: EdgeInsets.all(20),
                      //constraints: BoxConstraints(),
                      icon: SvgPicture.asset(ImageUtils.cancelIcon),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding,
                      vertical: Dimensions.verticalPadding),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 7.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.containerVerticalPadding,
                                  horizontal:
                                      Dimensions.containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.roundCorner)),
                                  border:
                                      Border.all(color: ColorUtils.divider)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      // focusNode: model.signUpBarUserFocus,
                                      controller: model.chat_name,
                                      readOnly: true,

                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              color: ColorUtils.white,
                              child: Text(
                                // "Bar Name",
                                AppLocalizations.of(context)!
                                    .translate('report_chat_dia_text_1')!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorUtils.text_grey,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.5.t,
                                    height: .4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Stack(
                          children: [
                            Container(
                              height: 7.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.containerVerticalPadding,
                                  horizontal:
                                      Dimensions.containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.roundCorner)),
                                  border:
                                      Border.all(color: ColorUtils.divider)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      // focusNode: model.signUpBarUserFocus,
                                      controller: model.chat_email,
                                      readOnly: true,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              color: ColorUtils.white,
                              child: Text(
                                // "Email",
                                AppLocalizations.of(context)!
                                    .translate('report_chat_dia_text_2')!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorUtils.text_grey,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.5.t,
                                    height: .4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          //width: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(color: ColorUtils.red_color)),
                          child: ValueListenableBuilder<bool>(
                              valueListenable: model.writeComment,
                              builder: (_, value, child) => TextField(
                                    onTap: () {},
                                    enabled: true,
                                    readOnly: value,
                                    //focusNode: model.searchFocus,
                                    controller: model.chatReport,
                                    decoration: InputDecoration(
                                      hintText:
                                      // "Write your comment",
                                      AppLocalizations.of(context)!
                                          .translate('report_chat_dia_text_3')!,
                                      hintStyle: TextStyle(
                                        //fontFamily: FontUtils.proximaNovaRegular,
                                        color: ColorUtils.icon_color,
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.heightMultiplier *
                                                  1.8),
                                    ),
                                    maxLines: 6,
                                    maxLength: 150,
                                  )),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                          child: ElevatedButton(
                            onPressed: () async {
                              model.isLoading = true;
                              model.notifyListeners();
                              if (model.userModel == null) {
                                await model.reportBarIndChat(context, widget.id!);
                              } else {
                                await model.reportUserIndChat(
                                    widget.id!, widget.user!);
                              }
                              // await model.getListOfAllBars();
                              //model.selectedBar = await model.userGetBarInfo(model.selectedBar!.id.toString());;
                              model.notifyListeners();

                              model.isLoading = false;
                              model.notifyListeners();
                              //model.navigateToBarProfile();
                              //model.navigateBack();
                              print(model.rate);
                            },
                            child:
                            // const
                            Text(
                                // "Submit"
                              AppLocalizations.of(context)!
                                  .translate('report_chat_dia_text_4')!,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorUtils.text_red,
                              onPrimary: ColorUtils.white,
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      Dimensions.containerVerticalPadding),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.roundCorner)),
                              textStyle: TextStyle(
                                color: ColorUtils.white,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 1.8.t,
                                //height: 0
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
        model.chat_name.text = widget.name!;
        model.chat_email.text = widget.email!;
      },
    );
  }
}

class ShowReportDialogBox extends StatefulWidget {
  String? id;
  String? name;
  String? email;
  String? user;
  String? body;

  ShowReportDialogBox(
      {Key? key, this.name, this.email, this.id, this.user, this.body})
      : super(key: key);

  @override
  _ShowReportDialogBoxState createState() => _ShowReportDialogBoxState();
}

class _ShowReportDialogBoxState extends State<ShowReportDialogBox> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      //onModelReady: (data) => data.initializeShareDialog(),
      builder: (context, model, child) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        model.openBurgerMenu = false;
                        model.notifyListeners();
                        model.navigateBack();
                      },
                      iconSize: 15.0,
                      //padding: EdgeInsets.all(20),
                      //constraints: BoxConstraints(),
                      icon: SvgPicture.asset(ImageUtils.cancelIcon),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding,
                      vertical: Dimensions.verticalPadding),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 7.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.containerVerticalPadding,
                                  horizontal:
                                      Dimensions.containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.roundCorner)),
                                  border:
                                      Border.all(color: ColorUtils.divider)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      // focusNode: model.signUpBarUserFocus,
                                      controller: model.chat_name,
                                      readOnly: true,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              color: ColorUtils.white,
                              child: Text(
                                "${model.selectedReport!.body!.split(":")[0]} Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorUtils.text_grey,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.5.t,
                                    height: .4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Stack(
                          children: [
                            Container(
                              height: 7.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.containerVerticalPadding,
                                  horizontal:
                                      Dimensions.containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.roundCorner)),
                                  border:
                                      Border.all(color: ColorUtils.divider)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      // focusNode: model.signUpBarUserFocus,
                                      controller: model.chat_email,
                                      readOnly: true,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              color: ColorUtils.white,
                              child: Text(
                                "Email",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorUtils.text_grey,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.5.t,
                                    height: .4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          //width: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(color: ColorUtils.red_color)),
                          child: TextField(
                            onTap: () {},
                            enabled: true,
                            readOnly: true,
                            //readOnly: true,
                            //focusNode: model.searchFocus,
                            controller: model.chatReport,
                            decoration: InputDecoration(
                              hintText: "Write your comment",
                              hintStyle: TextStyle(
                                //fontFamily: FontUtils.proximaNovaRegular,
                                color: ColorUtils.icon_color,
                                fontSize: SizeConfig.textMultiplier * 1.8,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.heightMultiplier * 1.8),
                            ),
                            maxLines: 6,
                            maxLength: 150,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SendCommentDialogBox(
                                          id: widget.id,
                                        );
                                      });
                                },
                                child: const Text("Comment"),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.text_red,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.containerVerticalPadding),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.roundCorner)),
                                  textStyle: TextStyle(
                                    color: ColorUtils.white,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  showGeneralDialog(
                                      context: model.navigationService
                                          .navigationKey.currentState!.context,
                                      barrierDismissible: false,
                                      barrierColor:
                                          Colors.white.withOpacity(0.6),
                                      pageBuilder:
                                          (context, animation1, animation2) {
                                        return Container(
                                          child: Center(
                                            child: RedLoader(),
                                          ),
                                        );
                                      });
                                  var request;
                                  if (model.selectedReport!.body!
                                          .split(":")[0] ==
                                      "User") {
                                    request =
                                        await model.userGetAnotherUserInfo(model
                                            .selectedReport!.body!
                                            .split(":")[1]);
                                  } else {
                                    model.selectedBar =
                                        await model.userGetBarInfo(model
                                            .selectedReport!.body!
                                            .split(":")[1]);
                                    //model.barIndex = index;
                                    model.notifyListeners();
                                    model.navigateToReportedBar();
                                  }
                                  //model.setBusyForObject("gettingProfile",false);
                                  if (request is UserModel) {
                                    model.navigateBack();
                                    model.navigateBack();
                                    model.navigateToReportedUser();
                                  } else {
                                    model.navigateBack();
                                  }
                                },
                                child: const Text("View Profile"),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.text_red,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.containerVerticalPadding),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.roundCorner)),
                                  textStyle: TextStyle(
                                    color: ColorUtils.white,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
        model.chat_name.text = widget.name!;
        model.chat_email.text = widget.email!;
        model.chatReport.text = widget.body!.split(":").last;
      },
    );
  }
}

class SendCommentDialogBox extends StatefulWidget {
  String? id;
  String? name;
  String? email;
  String? user;
  String? body;

  SendCommentDialogBox(
      {Key? key, this.name, this.email, this.id, this.user, this.body})
      : super(key: key);

  @override
  _SendCommentDialogBoxState createState() => _SendCommentDialogBoxState();
}

class _SendCommentDialogBoxState extends State<SendCommentDialogBox> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      //onModelReady: (data) => data.initializeShareDialog(),
      builder: (context, model, child) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        model.openBurgerMenu = false;
                        model.notifyListeners();
                        model.navigateBack();
                      },
                      iconSize: 15.0,
                      //padding: EdgeInsets.all(20),
                      //constraints: BoxConstraints(),
                      icon: SvgPicture.asset(ImageUtils.cancelIcon),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding,
                      vertical: Dimensions.verticalPadding),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //width: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(color: ColorUtils.red_color)),
                          child: TextField(
                            onTap: () {},
                            enabled: true,
                            //readOnly: true,
                            //focusNode: model.searchFocus,
                            controller: model.adminComment,
                            decoration: InputDecoration(
                              hintText: "Write your comment",
                              hintStyle: TextStyle(
                                //fontFamily: FontUtils.proximaNovaRegular,
                                color: ColorUtils.icon_color,
                                fontSize: SizeConfig.textMultiplier * 1.8,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.heightMultiplier * 1.8),
                            ),
                            maxLines: 6,
                            maxLength: 150,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  model.isLoading = true;
                                  showGeneralDialog(
                                      context: model.navigationService
                                          .navigationKey.currentContext!,
                                      barrierDismissible: false,
                                      barrierColor:
                                          Colors.white.withOpacity(0.6),
                                      pageBuilder:
                                          (context, animation1, animation2) {
                                        return Container(
                                          child: Center(
                                            child: RedLoader(),
                                          ),
                                        );
                                      });
                                  //model.notifyListeners();
                                  await model.sendComment(
                                      model.selectedReport!.id.toString());
                                  model.notifyListeners();

                                  model.isLoading = false;
                                  model.notifyListeners();
                                  //model.navigateToBarProfile();
                                  //model.navigateBack();
                                  print(model.rate);
                                },
                                child: const Text("Submit"),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.text_red,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.containerVerticalPadding),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.roundCorner)),
                                  textStyle: TextStyle(
                                    color: ColorUtils.white,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
        // model.chat_name.text = widget.name!;
        // model.chat_email.text = widget.email!;
        // model.chatReport.text = widget.body!.split(":").last;
      },
    );
  }
}

class ShowReportNotificationDialogBox extends StatefulWidget {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic user;
  dynamic body;

  ShowReportNotificationDialogBox(
      {Key? key, this.name, this.email, this.id, this.user, this.body})
      : super(key: key);

  @override
  _ShowReportNotificationDialogBoxState createState() =>
      _ShowReportNotificationDialogBoxState();
}

class _ShowReportNotificationDialogBoxState
    extends State<ShowReportNotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (data) {
        data.chat_name.text = widget.name.toString();
        data.chat_email.text = widget.email.toString();
        data.chatReport.text = widget.body.toString();
      },
      builder: (context, model, child) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        model.openBurgerMenu = false;
                        model.notifyListeners();
                        model.navigateBack();
                      },
                      iconSize: 15.0,
                      //padding: EdgeInsets.all(20),
                      //constraints: BoxConstraints(),
                      icon: SvgPicture.asset(ImageUtils.cancelIcon),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding,
                      vertical: Dimensions.verticalPadding),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 7.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.containerVerticalPadding,
                                  horizontal:
                                      Dimensions.containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.roundCorner)),
                                  border:
                                      Border.all(color: ColorUtils.divider)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      // focusNode: model.signUpBarUserFocus,
                                      controller: model.chat_name,
                                      readOnly: true,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              color: ColorUtils.white,
                              child: Text(
                                "Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorUtils.text_grey,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.5.t,
                                    height: .4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Stack(
                          children: [
                            Container(
                              height: 7.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.containerVerticalPadding,
                                  horizontal:
                                      Dimensions.containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimensions.roundCorner)),
                                  border:
                                      Border.all(color: ColorUtils.divider)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      // focusNode: model.signUpBarUserFocus,
                                      controller: model.chat_email,
                                      readOnly: true,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.w),
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              color: ColorUtils.white,
                              child: Text(
                                "Email",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorUtils.text_grey,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.5.t,
                                    height: .4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Container(
                          //width: 200.0,
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                              border: Border.all(color: ColorUtils.red_color)),
                          child: TextField(
                            onTap: () {},
                            enabled: true,
                            readOnly: true,
                            //readOnly: true,
                            //focusNode: model.searchFocus,
                            controller: model.chatReport,
                            decoration: InputDecoration(
                              hintText: "Write your comment",
                              hintStyle: TextStyle(
                                //fontFamily: FontUtils.proximaNovaRegular,
                                color: ColorUtils.icon_color,
                                fontSize: SizeConfig.textMultiplier * 1.8,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.heightMultiplier * 1.8),
                            ),
                            maxLines: 6,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      // onModelReady: (model){
      //   model.chat_name.text = widget.name!;
      //   model.chat_email.text = widget.email!;
      //   model.chatReport.text = widget.body!.split(":").last;
      // },
    );
  }
}
