import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/views/Auth/signup_map.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
      builder: (context, model, child) {
        // model.signInUser = false;
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
              top: true,
              bottom: false,
              child: AbsorbPointer(
                absorbing: model.signInUser,
                child: Scaffold(
                    backgroundColor: ColorUtils.white,
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.horizontalPadding,
                            vertical: Dimensions.verticalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: model.role==1
                              ?
                          [
                            SizedBox(height: Dimensions.topMargin),

                            //Logo
                            SvgPicture.asset(ImageUtils.logo),
                            SizedBox(height: 5.h),

                            //Create your account
                            Text(
                              // "Create your account",
                              AppLocalizations.of(
                                  context)!
                                  .translate('signup_1')!,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 3.t,
                              ),
                            ),
                            SizedBox(height: 5.h),

                            //Account Selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //User
                                ElevatedButton(
                                  onPressed: () {
                                    model.selectRole(Constants.user);
                                  },
                                  child:
                                  // const
                                  Text(
                                      // "User"
                                    AppLocalizations.of(
                                        context)!
                                        .translate('signup_2')!,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: model.role == Constants.user
                                        ? ColorUtils.text_red
                                        : ColorUtils.white,
                                    onPrimary: model.role == Constants.user
                                        ? ColorUtils.white
                                        : ColorUtils.text_red,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.5.h, horizontal: 10.w),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.text_red, width: 1)),
                                    textStyle: TextStyle(
                                      //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                      fontFamily: model.role == Constants.user
                                          ? FontUtils.modernistBold
                                          : FontUtils.modernistRegular,
                                      fontSize: 1.8.t,
                                      //height: 0
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: 5.w,
                                ),

                                //Bar
                                ElevatedButton(
                                  onPressed: () {
                                    model.selectRole(Constants.bar);
                                    //model.navigateToSignUpBar();
                                  },
                                  child:
                                  // const
                                  Text(
                                      // "Bar"
                                    AppLocalizations.of(
                                        context)!
                                        .translate('signup_3')!,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: model.role == Constants.bar
                                        ? ColorUtils.text_red
                                        : ColorUtils.white,
                                    onPrimary: model.role == Constants.bar
                                        ? ColorUtils.white
                                        : ColorUtils.text_red,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.5.h, horizontal: 10.w),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.text_red, width: 1)),
                                    textStyle: TextStyle(
                                      //color: model.role == Constants.bar ? ColorUtils.white : ColorUtils.text_red,
                                      fontFamily: model.role == Constants.bar
                                          ? FontUtils.modernistBold
                                          : FontUtils.modernistRegular,
                                      fontSize: 1.8.t,
                                      //height: 0
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),

                            //Username
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
                                      SvgPicture.asset(ImageUtils.userIcon),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: TextField(
                                          focusNode: model.signUpUserFocus,
                                          controller: model.signUpUserController,
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
                                    // "Username",
                                    AppLocalizations.of(context)!
                                        .translate('signup_4')!,
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

                            //Email
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
                                      SvgPicture.asset(ImageUtils.emailIcon),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: TextField(
                                          focusNode: model.signUpEmailFocus,
                                          controller: model.signUpEmailController,
                                          keyboardType: TextInputType.emailAddress,
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
                                        .translate('signup_5')!,
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

                            // //Confirm Email
                            // Stack(
                            //   children: [
                            //     Container(
                            //       height: 7.h,
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: Dimensions.containerVerticalPadding,
                            //           horizontal:
                            //           Dimensions.containerHorizontalPadding),
                            //       decoration: BoxDecoration(
                            //           color: ColorUtils.white,
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(Dimensions.roundCorner),),
                            //           border:
                            //           Border.all(color: ColorUtils.divider)),
                            //       child: Row(
                            //         children: [
                            //           SvgPicture.asset(ImageUtils.emailIcon),
                            //           SizedBox(width: 4.w),
                            //           Expanded(
                            //             child: TextField(
                            //               focusNode: model.signUpConfirmEmailFocus,
                            //               controller: model.signUpConfirmEmailController,
                            //               keyboardType: TextInputType.emailAddress,
                            //               textInputAction: TextInputAction.next,
                            //               style: TextStyle(
                            //                 color: ColorUtils.red_color,
                            //                 fontFamily: FontUtils.modernistRegular,
                            //                 fontSize: 1.9.t,
                            //               ),
                            //               decoration: const InputDecoration(
                            //                 border: InputBorder.none,
                            //                 isDense: true,
                            //                 contentPadding: EdgeInsets.symmetric(
                            //                     horizontal: 0, vertical: 0),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.only(left: 5.w),
                            //       padding: EdgeInsets.symmetric(horizontal: 1.w),
                            //       color: ColorUtils.white,
                            //       child: Text(
                            //         "Confirm Email",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //             color: ColorUtils.text_grey,
                            //             fontFamily: FontUtils.modernistRegular,
                            //             fontSize: 1.5.t,
                            //             height: .4),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 3.h),

                            //Phone No.
                            Stack(
                              children: [
                                // Container(
                                //   height: 7.h,
                                //   padding: EdgeInsets.symmetric(
                                //       vertical: Dimensions.containerVerticalPadding,
                                //       horizontal:
                                //       Dimensions.containerHorizontalPadding),
                                //   decoration: BoxDecoration(
                                //       color: ColorUtils.white,
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(Dimensions.roundCorner)),
                                //       border:
                                //       Border.all(color: ColorUtils.divider)),
                                //   child: Row(
                                //     children: [
                                //       SvgPicture.asset(ImageUtils.phoneIcon),
                                //       SizedBox(width: 4.w),
                                //       Expanded(
                                //         child: TextField(
                                //           focusNode: model.signUpPhoneFocus,
                                //           controller: model.signUpPhoneController,
                                //           keyboardType: TextInputType.phone,maxLength: 11,
                                //           obscureText: false,
                                //           textInputAction: TextInputAction.next,
                                //           style: TextStyle(
                                //             color: ColorUtils.red_color,
                                //             fontFamily: FontUtils.modernistRegular,
                                //             fontSize: 1.9.t,
                                //           ),
                                //           decoration: const InputDecoration(
                                //             border: InputBorder.none,
                                //             isDense: true,
                                //             counterText: "",
                                //             contentPadding: EdgeInsets.symmetric(
                                //                 horizontal: 0, vertical: 0),
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
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
                                  child: IntlPhoneField(
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(12),],
                                    textAlignVertical: TextAlignVertical.center,
                                    // countryCodeTextColor: ColorUtils.red_color,
                                    // focusNode: model.signUpPhoneFocus,
                                    // controller: model.signUpPhoneController,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    dropdownIconPosition: IconPosition.trailing,
                                    //dropDownIcon: Icon(Icons.),
                                    //showDropdownIcon: false,
                                    style: TextStyle(
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.9.t,
                                        color: ColorUtils.red_color
                                    ),
                                    // autoValidate: false,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText:
                                      // 'Enter Your Phone number',
                                      AppLocalizations.of(context)!
                                          .translate('signup_6')!,
                                      hintStyle:
                                      TextStyle(
                                          color: ColorUtils.text_grey,
                                          fontSize: 1.9.t,
                                          fontFamily: FontUtils.modernistRegular
                                      ),
                                      suffixText: "",
                                      isDense: true,
                                      alignLabelWithHint: true,
                                      counterText: "",
                                      contentPadding: EdgeInsets.only(top: 0.h,left: 0.w,right: 0.w,bottom: 0.2.h),
                                      focusedBorder: InputBorder.none,
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 0.0.t,
                                      ),
                                      //alignLabelWithHint: true,
                                      //contentPadding: EdgeInsets.zero,
                                      //labelText: 'Phone Number',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onTap: (){},
                                    initialCountryCode: 'DE',
                                    onChanged: (phone) {
                                      //model.loginCountryCode = phone.countryCode ;
                                      // model.loginPhoneController.text = phone.number!;
                                      model.signUpPhoneController.text = phone.completeNumber;
                                      model.notifyListeners();
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Phone No.",
                                    AppLocalizations.of(context)!
                                        .translate('signup_7')!,
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

                            //Gender
                            Stack(
                              children: [
                                Container(
                                  height: 7.h,
                                  padding: EdgeInsets.symmetric(
                                      vertical: .8.h,
                                      horizontal:
                                      Dimensions.containerHorizontalPadding),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(Dimensions.roundCorner)),
                                      border:
                                      Border.all(color: ColorUtils.divider)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: DropdownButton<String>(
                                            value: model.genderValueStr,
                                            items: model.genderList
                                                .asMap()
                                                .values
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  "${AppLocalizations.of(
                                                      context)!
                                                      .translate(value)}",
                                                  style: TextStyle(
                                                    fontSize: 1.9.t,
                                                    fontFamily:
                                                    FontUtils.modernistRegular,
                                                    color: ColorUtils.red_color,
                                                    //height: 1.8
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (data) {
                                              setState(() {
                                                model.genderValueStr = data as String;
                                                model.genderValue = model
                                                    .genderMap[model.genderValueStr]
                                                as int;
                                              });
                                            },
                                            hint: Text(
                                              // "Select an option",
                                              AppLocalizations.of(context)!
                                                  .translate('signup_8')!,
                                              style: TextStyle(
                                                fontSize: 1.8.t,
                                                fontFamily: FontUtils.modernistRegular,
                                                color: ColorUtils.text_grey,
                                              ),
                                            ),
                                            isExpanded: true,
                                            underline: Container(),
                                            icon: Align(
                                                alignment: Alignment.centerRight,
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  color: ColorUtils.black,
                                                )),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Gender",
                                    AppLocalizations.of(context)!
                                        .translate('signup_9')!,
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

                            //Password
                            Stack(
                              children: [
                                Container(
                                  height: 8.h,
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
                                      SvgPicture.asset(ImageUtils.passwordIcon),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                          child: TextField(
                                            focusNode: model.signUpPasswordFocus,
                                            controller:
                                            model.signUpPasswordController,
                                            obscureText: !model.signupPasswordVisible,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                              color: ColorUtils.red_color,
                                              fontFamily: FontUtils.modernistRegular,
                                              fontSize: 1.9.t,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                              // "Hint: Abc!123",
                                              AppLocalizations.of(context)!
                                                  .translate('signup_10')!,
                                              hintStyle: TextStyle(
                                                color: ColorUtils.text_grey,
                                                fontFamily: FontUtils.modernistRegular,
                                                fontSize: 1.9.t,
                                                //height: .4
                                              ),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 0),
                                            ),
                                          )
                                      ),
                                      SizedBox(width: 3.w),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            model.signupPasswordVisible = !model.signupPasswordVisible;
                                          });
                                        },
                                        icon: Icon(model.signupPasswordVisible
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
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Password",
                                    AppLocalizations.of(context)!
                                        .translate('signup_10a')!,
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

                            // //Verify Password
                            // Stack(
                            //   children: [
                            //     Container(
                            //       height: 7.h,
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: Dimensions.containerVerticalPadding,
                            //           horizontal:
                            //           Dimensions.containerHorizontalPadding),
                            //       decoration: BoxDecoration(
                            //           color: ColorUtils.white,
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(Dimensions.roundCorner)),
                            //           border:
                            //           Border.all(color: ColorUtils.divider)),
                            //       child: Row(
                            //         children: [
                            //           SvgPicture.asset(ImageUtils.passwordIcon),
                            //           SizedBox(width: 4.w),
                            //           Expanded(
                            //             child: TextField(
                            //               focusNode:
                            //               model.signUpVerifyPasswordFocus,
                            //               controller:
                            //               model.signUpVerifyPasswordController,
                            //               obscureText: !model.signupVerifyPasswordVisible,
                            //               keyboardType: TextInputType.text,
                            //               textInputAction: TextInputAction.next,
                            //               style: TextStyle(
                            //                 color: ColorUtils.red_color,
                            //                 fontFamily: FontUtils.modernistRegular,
                            //                 fontSize: 1.9.t,
                            //               ),
                            //               decoration: InputDecoration(
                            //                 hintText: "Hint: Abc!123",
                            //                 hintStyle: TextStyle(
                            //                   color: ColorUtils.text_grey,
                            //                   fontFamily: FontUtils.modernistRegular,
                            //                   fontSize: 1.9.t,
                            //                   //height: .4
                            //                 ),
                            //                 border: InputBorder.none,
                            //                 isDense: true,
                            //                 contentPadding: EdgeInsets.symmetric(
                            //                     horizontal: 0, vertical: 0),
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(width: 3.w),
                            //           IconButton(
                            //             onPressed: () {
                            //               setState(() {
                            //                 model.signupVerifyPasswordVisible = !model.signupVerifyPasswordVisible;
                            //               });
                            //             },
                            //             icon: Icon(model.signupVerifyPasswordVisible
                            //                 ? Icons.visibility
                            //                 : Icons.visibility_off,
                            //               color: ColorUtils.red_color,
                            //               //size: 6 * SizeConfig.imageSizeMultiplier,
                            //               //color: ColorUtils.textFormColor,),
                            //             ),
                            //             padding: EdgeInsets.zero,
                            //             constraints: BoxConstraints(),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.only(left: 5.w),
                            //       padding: EdgeInsets.symmetric(horizontal: 1.w),
                            //       color: ColorUtils.white,
                            //       child: Text(
                            //         "Verify Password",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //             color: ColorUtils.text_grey,
                            //             fontFamily: FontUtils.modernistRegular,
                            //             fontSize: 1.5.t,
                            //             height: .4),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 3.h),

                            //Enter your address
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
                                  child: GestureDetector(
                                    onTap: () async {
                                      model.navigateToAddAddressScreen();
                                      var position = await model.determinePosition(context);
                                      model.latitude = position.latitude;
                                      model.latitude = position.longitude;
                                    },
                                    child: Row(
                                      children: [
                                        Container(child: SvgPicture.asset(ImageUtils.locationIcon)
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: TextField(
                                            focusNode: model.signUpAddressFocus,
                                            controller: model.signUpAddressController,
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
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Enter your city",
                                    AppLocalizations.of(context)!
                                        .translate('signup_11')!,
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

                            //----- Date of Birth
                            Stack(
                              children: [

                                GestureDetector(
                                  onTap: () {
                                    model.openAndSelectDob(context);
                                    context.unFocus();
                                  },
                                  child: Container(
                                    height: 7.h,
                                    padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding, horizontal: Dimensions.containerHorizontalPadding),
                                    decoration: BoxDecoration(
                                        color: ColorUtils.white,
                                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.roundCorner)),
                                        border: Border.all(color: ColorUtils.divider)
                                    ),
                                    child: Row(
                                      children: [

                                        SvgPicture.asset(ImageUtils.calendarIcon),

                                        SizedBox(width: 4.w),

                                        Expanded(
                                            child: Stack(
                                              children: <Widget>[
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 2.5.w, right: 4.w),
                                                    child: Text(
                                                      model.signUpDOBController.text,
                                                      style: model.selectedDOB == null
                                                          ? TextStyle(
                                                          color: model.signUpDOBFocus
                                                              .hasFocus ||
                                                              model.signUpDOBController
                                                                  .text.length !=
                                                                  0
                                                              ? ColorUtils.red_color
                                                              : ColorUtils.text_grey,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 1.9.t)
                                                          : TextStyle(
                                                          color: ColorUtils.red_color),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Container(
                                                    margin: EdgeInsets.only(right: 4.w),
                                                    child: SvgPicture.asset(
                                                      ImageUtils.calender,
                                                      width: 4.5.i,
                                                      height: 4.5.i,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Date of Birth",
                                    AppLocalizations.of(context)!
                                        .translate('signup_12')!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.text_grey,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.5.t,
                                        height: .4
                                    ),
                                  ),
                                ),
                              ],
                            ),


                            // InkWell(
                            //   onTap: () {
                            //     model.openAndSelectDob(context);
                            //     context.unFocus();
                            //   },
                            //   child: Container(
                            //       height: 6.h,
                            //       decoration: BoxDecoration(
                            //           shape: BoxShape.rectangle,
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(
                            //             6,
                            //           ),
                            //           border:
                            //               Border.all(color: ColorUtils.red_color)),
                            //       // margin: EdgeInsets.only(
                            //       //     top: 2.7.h,
                            //       //     right: 3.5.w,
                            //       //     left: 3.5.w),
                            //       child: Stack(
                            //         children: <Widget>[
                            //           Align(
                            //             alignment: Alignment.centerLeft,
                            //             child: Container(
                            //               margin: EdgeInsets.only(
                            //                   left: 2.5.w, right: 4.w),
                            //               child: Text(
                            //                 model.selectedDOB == null
                            //                     ? "Date of Birth"
                            //                     : DateFormat('dd/MM/yyyy')
                            //                         .format(model.selectedDOB),
                            //                 style: model.selectedDOB == null
                            //                     ? TextStyle(
                            //                         color: model.signUpDOBFocus
                            //                                     .hasFocus ||
                            //                                 model.signUpDOBController
                            //                                         .text.length !=
                            //                                     0
                            //                             ? ColorUtils.red_color
                            //                             : ColorUtils.text_grey,
                            //                         fontWeight: FontWeight.w400,
                            //                         fontSize: 1.9.t)
                            //                     : TextStyle(
                            //                         color: ColorUtils.red_color),
                            //               ),
                            //             ),
                            //           ),
                            //           Align(
                            //             alignment: Alignment.centerRight,
                            //             child: Container(
                            //               margin: EdgeInsets.only(right: 4.w),
                            //               child: SvgPicture.asset(
                            //                 ImageUtils.calender,
                            //                 width: 4.5.i,
                            //                 height: 4.5.i,
                            //               ),
                            //             ),
                            //           )
                            //         ],
                            //       )),
                            // ),
                            SizedBox(height: 3.h),

                            //Relationship
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
                                      SvgPicture.asset(ImageUtils.relationIcon),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                          child: DropdownButton<String>(
                                            value: model.relationStatusValueStr,
                                            items: model.relationStatusList
                                                .asMap()
                                                .values
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  "${AppLocalizations.of(context)!.translate(value)}",
                                                  style: TextStyle(
                                                    fontSize: 1.9.t,
                                                    fontFamily:
                                                    FontUtils.modernistRegular,
                                                    color: ColorUtils.red_color,
                                                    //height: 1.8
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (data) {
                                              setState(() {
                                                model.relationStatusValueStr = data as String;
                                                model.relationStatusValue = model
                                                    .relationStatusMap[model.relationStatusValueStr]
                                                as int;
                                              });
                                            },
                                            hint: Text(
                                              // "Select an option",
                                              AppLocalizations.of(context)!
                                                  .translate('signup_13')!,
                                              style: TextStyle(
                                                fontSize: 1.8.t,
                                                fontFamily: FontUtils.modernistRegular,
                                                color: ColorUtils.text_grey,
                                              ),
                                            ),
                                            isExpanded: true,
                                            underline: Container(),
                                            icon: Align(
                                                alignment: Alignment.centerRight,
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  color: ColorUtils.black,
                                                )),
                                          )
                                      ),

                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Relationship",
                                    AppLocalizations.of(context)!
                                        .translate('signup_14')!,
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

                            SizedBox(height: 1.5.h,),
                            GestureDetector(
                                onTap: () {
                                  model.signupCheck = true ;
                                  model.notifyListeners();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: ColorUtils.text_grey,
                                      ),
                                      child: Checkbox(
                                        checkColor: ColorUtils.white,
                                        activeColor: ColorUtils.text_red,
                                        value: model.isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            model.isChecked = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: (){
                                          model.navigateToStaticTermsAndConditionScreen();
                                        },
                                        child: Text(
                                          // "Accept terms & condition, privacy policy, data protection.",
                                          AppLocalizations.of(context)!
                                              .translate('signup_15')!,
                                          style: TextStyle(
                                            color: ColorUtils.red_color,
                                            fontFamily: FontUtils.modernistRegular,
                                            fontSize: 1.5.t,
                                            decoration: TextDecoration.underline,
                                          ),

                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 3.h),

                            //Sign up Button
                            SizedBox(
                              width: double.infinity,

                              //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                              child:

                              ElevatedButton(
                                onPressed: () async {
                                  //model.navigateToFavoriteScreen();
                                  var position = await model.determinePosition(context);
                                  model.latitude = position.latitude;
                                  model.latitude = position.longitude;
                                  model.createUserAccount(context);

                                },
                                child: model.signInUser == false ? Text(
                                    // "Next"
                                  AppLocalizations.of(context)!
                                      .translate('signup_16')!,
                                ) : Loader(),
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
                            SizedBox(height: 3.h),
                            //Already have an account? Sign Up
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // "Already have an account? ",
                                  AppLocalizations.of(context)!
                                      .translate('signup_17')!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.8.t,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    // if(model.logInUserSelected == true){
                                    //   model.navigateToSignUpScreen();
                                    // }
                                    // else if(model.logInBarSelected == true){
                                    //   model.navigateToSignUpBar();
                                    // }
                                    model.navigateToLoginScreen();
                                  },
                                  child: Text(
                                    // "Login",
                                    AppLocalizations.of(context)!
                                        .translate('signup_18')!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorUtils.
                                      text_red,
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 1.8.t,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                          ]
                              :
                          [
                            SizedBox(height: Dimensions.topMargin),
                            //Logo
                            SvgPicture.asset(ImageUtils.logo),
                            SizedBox(height: 5.h),

                            //Create your account
                            Text(
                              // "Create your account",
                              AppLocalizations.of(context)!
                                  .translate('signup_1')!,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 3.t,
                              ),
                            ),
                            SizedBox(height: 5.h),

                            //Account Selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //User
                                ElevatedButton(
                                  onPressed: () {
                                    model.selectRole(Constants.user);
                                    //model.navigateToSignUpScreen();
                                  },
                                  child:
                                  // const
                                  Text(
                                      // "User"
                                    AppLocalizations.of(context)!
                                        .translate('signup_2')!,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: model.role == Constants.user ? ColorUtils.text_red : ColorUtils.white,
                                    onPrimary: model.role == Constants.user ? ColorUtils.white : ColorUtils.text_red,
                                    padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 10.w),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.text_red,
                                            width: 1
                                        )
                                    ),
                                    textStyle: TextStyle(
                                      //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                      fontFamily: model.role == Constants.user ? FontUtils.modernistBold : FontUtils.modernistRegular,
                                      fontSize: 1.8.t,
                                      //height: 0
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5.w,),

                                //Bar
                                ElevatedButton(
                                  onPressed: () {
                                    model.selectRole(Constants.bar);
                                    //model.navigateToSignUpBar();
                                  },
                                  child:
                                  // const
                                  Text(
                                      // "Bar"
                                    AppLocalizations.of(context)!
                                        .translate('signup_3')!,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: model.role == Constants.bar ? ColorUtils.text_red : ColorUtils.white,
                                    onPrimary: model.role == Constants.bar ? ColorUtils.white : ColorUtils.text_red,
                                    padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 10.w),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.text_red,
                                            width: 1
                                        )
                                    ),
                                    textStyle: TextStyle(
                                      //color: model.role == Constants.bar ? ColorUtils.white : ColorUtils.text_red,
                                      fontFamily: model.role == Constants.bar ? FontUtils.modernistBold : FontUtils.modernistRegular,
                                      fontSize: 1.8.t,
                                      //height: 0
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 5.h),

                            //Username
                            Stack(
                              children: [

                                Container(
                                  height: 7.h,
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding, horizontal: Dimensions.containerHorizontalPadding),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.roundCorner)),
                                      border: Border.all(color: ColorUtils.divider)
                                  ),
                                  child: Row(
                                    children: [

                                      SvgPicture.asset(ImageUtils.userIcon),

                                      SizedBox(width: 4.w),

                                      Expanded(
                                        child: TextField(
                                          focusNode: model.signUpBarUserFocus,
                                          controller: model.signUpBarUserController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                            color: ColorUtils.red_color,
                                            fontFamily: FontUtils.modernistRegular,
                                            fontSize: 1.9.t,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense:true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                                        .translate('signup_bar_1')!,

                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.text_grey,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.5.t,
                                        height: .4
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                            //Enter your address
                            Stack(
                              children: [

                                Container(
                                  height: 7.h,
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding, horizontal: Dimensions.containerHorizontalPadding),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.roundCorner)),
                                      border: Border.all(color: ColorUtils.divider)
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      model.navigateToAddAddressBarScreen();
                                      var position = await model.determinePosition(context);
                                      model.latitude = position.latitude;
                                      model.latitude = position.longitude;
                                    },
                                    child: Row(
                                      children: [

                                        Icon(Icons.pin_drop_outlined,color: ColorUtils.text_red),

                                        SizedBox(width: 4.w),

                                        Expanded(
                                          child: TextField(
                                            focusNode: model.signUpBarAddressFocus,
                                            controller: model.signUpBarAddressController,
                                            keyboardType: TextInputType.text,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                              color: ColorUtils.red_color,
                                              fontFamily: FontUtils.modernistRegular,
                                              fontSize: 1.9.t,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense:true,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Address",
                                    AppLocalizations.of(context)!
                                        .translate('signup_bar_2')!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.text_grey,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.5.t,
                                        height: .4
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                            //Email
                            Stack(
                              children: [

                                Container(
                                  height: 7.h,
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding, horizontal: Dimensions.containerHorizontalPadding),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.roundCorner)),
                                      border: Border.all(color: ColorUtils.divider)
                                  ),
                                  child: Row(
                                    children: [

                                      SvgPicture.asset(ImageUtils.emailIcon),

                                      SizedBox(width: 4.w),

                                      Expanded(
                                        child: TextField(
                                          focusNode: model.signUpBarEmailFocus,
                                          controller: model.signUpBarEmailController,
                                          //obscureText: !model.signupEmailVisible,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                            color: ColorUtils.red_color,
                                            fontFamily: FontUtils.modernistRegular,
                                            fontSize: 1.9.t,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense:true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                                        .translate('signup_bar_3')!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.text_grey,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.5.t,
                                        height: .4
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                            //Password
                            Stack(
                              children: [

                                Container(
                                  height: 7.h,
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding, horizontal: Dimensions.containerHorizontalPadding),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.roundCorner)),
                                      border: Border.all(color: ColorUtils.divider)
                                  ),
                                  child: Row(
                                    children: [

                                      SvgPicture.asset(ImageUtils.passwordIcon),

                                      SizedBox(width: 4.w),

                                      Expanded(
                                        child: TextField(
                                          focusNode: model.signUpBarPasswordFocus,
                                          controller: model.signUpBarPasswordController,
                                          obscureText: !model.signupPasswordVisible,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                            color: ColorUtils.red_color,
                                            fontFamily: FontUtils.modernistRegular,
                                            fontSize: 1.9.t,
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                            // "Hint: Abc!123",
                                            AppLocalizations.of(context)!
                                                .translate('signup_bar_4')!,
                                            hintStyle: TextStyle(
                                              color: ColorUtils.text_grey,
                                              fontFamily: FontUtils.modernistRegular,
                                              fontSize: 1.9.t,
                                              //height: .4
                                            ),
                                            border: InputBorder.none,
                                            isDense:true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            model.signupPasswordVisible = !model.signupPasswordVisible;
                                          });
                                        },
                                        icon: Icon(model.signupPasswordVisible
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
                                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                                  color: ColorUtils.white,
                                  child: Text(
                                    // "Password",
                                    AppLocalizations.of(context)!
                                        .translate('signup_bar_5')!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorUtils.text_grey,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.5.t,
                                        height: .4
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),


                            //Verify Password
                            // Stack(
                            //   children: [
                            //
                            //     Container(
                            //       height: 7.h,
                            //       padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding, horizontal: Dimensions.containerHorizontalPadding),
                            //       decoration: BoxDecoration(
                            //           color: ColorUtils.white,
                            //           borderRadius: BorderRadius.all(Radius.circular(Dimensions.roundCorner)),
                            //           border: Border.all(color: ColorUtils.divider)
                            //       ),
                            //       child: Row(
                            //         children: [
                            //
                            //           SvgPicture.asset(ImageUtils.passwordIcon),
                            //
                            //           SizedBox(width: 4.w),
                            //
                            //           Expanded(
                            //             child: TextField(
                            //               focusNode: model.signUpBarVerifyPasswordFocus,
                            //               controller: model.signUpBarVerifyPasswordController,
                            //               keyboardType: TextInputType.text,
                            //               textInputAction: TextInputAction.next,
                            //               obscureText: !model.signupVerifyPasswordVisible,
                            //               style: TextStyle(
                            //                 color: ColorUtils.red_color,
                            //                 fontFamily: FontUtils.modernistRegular,
                            //                 fontSize: 1.9.t,
                            //               ),
                            //               decoration: InputDecoration(
                            //                 hintText: "Hint: Abc!123",
                            //                 hintStyle: TextStyle(
                            //                   color: ColorUtils.text_grey,
                            //                   fontFamily: FontUtils.modernistRegular,
                            //                   fontSize: 1.9.t,
                            //                   //height: .4
                            //                 ),
                            //                 border: InputBorder.none,
                            //                 isDense:true,
                            //                 contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(width: 3.w),
                            //           IconButton(
                            //             onPressed: () {
                            //               setState(() {
                            //                 model.signupVerifyPasswordVisible = !model.signupVerifyPasswordVisible;
                            //               });
                            //             },
                            //             icon: Icon(model.signupVerifyPasswordVisible
                            //                 ? Icons.visibility
                            //                 : Icons.visibility_off,
                            //               color: ColorUtils.red_color,
                            //               //size: 6 * SizeConfig.imageSizeMultiplier,
                            //               //color: ColorUtils.textFormColor,),
                            //             ),
                            //             padding: EdgeInsets.zero,
                            //             constraints: BoxConstraints(),
                            //           ),
                            //
                            //         ],
                            //       ),
                            //     ),
                            //
                            //     Container(
                            //       margin: EdgeInsets.only(left: 5.w),
                            //       padding: EdgeInsets.symmetric(horizontal: 1.w),
                            //       color: ColorUtils.white,
                            //       child: Text(
                            //         "Verify Password",
                            //         textAlign: TextAlign.center,
                            //         style: TextStyle(
                            //             color: ColorUtils.text_grey,
                            //             fontFamily: FontUtils.modernistRegular,
                            //             fontSize: 1.5.t,
                            //             height: .4
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 6.h),

                            //Sign up Button
                            SizedBox(
                              width: double.infinity,
                              //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                              child: ElevatedButton(
                                onPressed: () async {
                                  var position = await model.determinePosition(context);
                                  model.latitude = position.latitude;
                                  model.longitude = position.longitude;
                                  model.signupBarScreen();
                                },
                                child: model.checkSignupUser == false ? Text(
                                    // "Next"
                                  AppLocalizations.of(context)!
                                      .translate('signup_bar_6')!,
                                ) : Loader(),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.text_red,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.roundCorner)
                                  ),
                                  textStyle: TextStyle(
                                    color: ColorUtils.white,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.8.t,
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    // if(model.logInUserSelected == true){
                                    //   model.navigateToSignUpScreen();
                                    // }
                                    // else if(model.logInBarSelected == true){
                                    //   model.navigateToSignUpBar();
                                    // }
                                    model.navigateToLoginScreen();
                                  },
                                  child: Text(
                                    "Login",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorUtils.text_red,
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 1.8.t,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),

                          ],
                        ),
                      ),
                    )),
              )
          ),
        );
      },
      viewModelBuilder: () => locator<RegistrationViewModel>(),
      onModelReady: (model) =>
      {
        model.signUpUserController.clear(),
        model.signUpEmailController.clear(),
        model.signUpConfirmEmailController.clear(),
        model.signUpPhoneController.clear(),
        model.signUpPasswordController.clear(),
        model.signUpVerifyPasswordController.clear(),
        model.signUpAddressController.clear(),
        model.signUpDOBController.clear(),
        model.signUpRelationshipController.clear()
      },
      disposeViewModel: false,
    );
  }
}
