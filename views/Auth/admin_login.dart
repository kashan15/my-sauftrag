import 'package:date_picker_timeline/extra/dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class LoginOne extends StatefulWidget {
  const LoginOne({Key? key}) : super(key: key);

  @override
  _LoginOneState createState() => _LoginOneState();
}

class _LoginOneState extends State<LoginOne> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
                top: false,
                bottom: false,
                child: AbsorbPointer(
                  absorbing: model.logIn,
                  child: Scaffold(
                    backgroundColor: ColorUtils.white,
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                        ),
                        child: Container(
                          height: 85.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding,
                                vertical: Dimensions.verticalPadding),
                            child: AbsorbPointer(
                              absorbing: model.logIn,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [


                                      GestureDetector(
                                        onTap: (){
                                          model.navigateToLoginScreen();
                                        },
                                        child: Container(
                              child: Icon(Icons.arrow_back,
                              color: ColorUtils.red_color,
                                size: 4.t,
                              )
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 2.h),

                                  //LogoS
                                  SvgPicture.asset(ImageUtils.logo),







                                  //Welcome back!
                                  Column(
                                    children:[
                                      // SizedBox(height: 0.5.h,),
                                      Text(
                                      "Admin Login",
                                      // AppLocalizations.of(
                                      //     context)!
                                      //     .translate('login_text_1')!,
                                      style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistBold,
                                        fontSize: 4.t,
                                      ),
                                    ),
                                  ]),

                                  //Username
                                  Stack(
                                    children: [
                                      Container(
                                        height: 7.h,
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimensions
                                                .containerVerticalPadding,
                                            horizontal: Dimensions
                                                .containerHorizontalPadding),
                                        decoration: BoxDecoration(
                                            color: ColorUtils.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimensions.roundCorner)),
                                            border: Border.all(
                                                color: ColorUtils.divider)),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              model.logInUserSelected
                                                  ?
                                              ImageUtils.userIcon
                                                  :
                                              ImageUtils.barIcon,
                                            ),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: TextField(
                                                focusNode:
                                                model.logInUserFocus,
                                                controller:
                                                model.logInUserController,
                                                keyboardType:
                                                TextInputType.text,
                                                textInputAction:
                                                TextInputAction.next,
                                                style: TextStyle(
                                                  color: ColorUtils.red_color,
                                                  fontFamily: FontUtils
                                                      .modernistRegular,
                                                  fontSize: 2.t,
                                                ),
                                                decoration:
                                                const InputDecoration(
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // SizedBox(height: 7.h,),
                                      Container(
                                        margin: EdgeInsets.only(left: 5.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        color: ColorUtils.white,
                                        child: Text(
                                          AppLocalizations.of(
                                              context)!
                                              .translate('login_text_5')!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorUtils.text_grey,
                                              fontFamily:
                                              FontUtils.modernistRegular,
                                              fontSize: 1.5.t,
                                              height: .4),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //Password
                                  Stack(
                                    children: [
                                      Container(
                                        height: 7.h,
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimensions
                                                .containerVerticalPadding,
                                            horizontal: Dimensions
                                                .containerHorizontalPadding),
                                        decoration: BoxDecoration(
                                            color: ColorUtils.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimensions.roundCorner)),
                                            border: Border.all(
                                                color: ColorUtils.divider)),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                ImageUtils.passwordIcon),
                                            SizedBox(width: 4.w),
                                            Expanded(
                                              child: TextField(
                                                focusNode:
                                                model.loginPasswordFocus,
                                                obscureText: !model
                                                    .loginPasswordVisible,
                                                controller: model
                                                    .logInPasswordController,
                                                textAlign: TextAlign.start,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                textInputAction:
                                                TextInputAction.next,
                                                // obscureText: true,
                                                style: TextStyle(
                                                  color: ColorUtils.red_color,
                                                  fontFamily: FontUtils
                                                      .modernistRegular,
                                                  fontSize: 2.t,
                                                ),
                                                decoration:
                                                const InputDecoration(
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 3.w),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  model.loginPasswordVisible =
                                                  !model
                                                      .loginPasswordVisible;
                                                });
                                              },
                                              icon: Icon(
                                                model.loginPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: ColorUtils.red_color,
                                                //size: 6 * SizeConfig.imageSizeMultiplier,
                                                //color: ColorUtils.textFormColor,),
                                              ),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        color: ColorUtils.white,
                                        child: Text(
                                          AppLocalizations.of(
                                              context)!
                                              .translate('login_text_6')!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: ColorUtils.text_grey,
                                              fontFamily:
                                              FontUtils.modernistRegular,
                                              fontSize: 1.5.t,
                                              height: .4),
                                        ),
                                      ),
                                    ],
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      model.navigateToForgetPasswordScreen();
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          AppLocalizations.of(
                                              context)!
                                              .translate('login_text_7')!,
                                          style: TextStyle(
                                            color: ColorUtils.text_grey,
                                            fontFamily:
                                            FontUtils.modernistRegular,
                                            fontSize: 1.5.t,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //Sign in Button
                                  SizedBox(
                                    width: double.infinity,
                                    //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        //model.navigateToHomeScreen(2);
                                        var position = await model.determinePosition(context);
                                        model.latitude = position.latitude;
                                        model.latitude = position.longitude;

                                        model.mymodel.getAllUserForChat();
                                        model.notifyListeners();
                                        model.onLogInOne();
                                      },
                                      child: model.logIn == false
                                          ? Text(
                                        AppLocalizations.of(
                                            context)!
                                            .translate('login_text_8')!,
                                      )
                                          : Loader(),
                                      style: ElevatedButton.styleFrom(
                                        primary: ColorUtils.text_red,
                                        onPrimary: ColorUtils.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimensions
                                                .containerVerticalPadding),
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
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


                                ])),
                      ),
                    )),
                )),
          )
          );
        },
        viewModelBuilder: () => locator<RegistrationViewModel>(),
        disposeViewModel: false,
        onModelReady: (model) {
          // model.determinePosition();
          // model.getCurrentLocation();
          model.logInPasswordController.clear();
          model.logIn = false;
        });
  }
}
