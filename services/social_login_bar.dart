import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/app_language.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/dialog_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/views/Auth/signup.dart';
import 'package:path/path.dart' as path;
import 'package:sauftrag/views/Auth/social_signup_screen.dart';
import 'package:sauftrag/widgets/error_widget.dart';
import 'package:sauftrag/widgets/error_widget_one.dart';

import '../app/locator.dart';
import '../widgets/dialog_event.dart';

class SocialSignupBar {
  //var _dioService = DioService.getInstance();
  // NavigationViewModel Mymodel = locator<NavigationViewModel>();
  Dio dio = Dio();

  Future SocialSignUpBar(BuildContext context,
      String userName,
      String barName,
      String email,
      String about,
      String address,
      int role,
      List<int> barKind,
      List<int> workingDays,
      String openingTime,
      String closingTime,
      String breakOpeningTime,
      String breakClosingTime,
      List<int> weekendDays,
      String weekendOpeningTime,
      String weekendClosingTime,
      String weekendBreakOpeningTime,
      String weekendBreakClosingTime,
      File barLogo,
      File catalogueImage1,
      File catalogueImage2,
      File catalogueImage3,
      File catalogueImage4,
      File catalogueImage5,
      bool termsConditions,
      bool dataProtection,
      double latitude,
      double longitude,
      ) async {
    String profilePic = "";
    String catalogue_image1 = "";
    String catalogue_image2 = "";
    String catalogue_image3 = "";
    String catalogue_image4 = "";
    String catalogue_image5 = "";
    if (barLogo.path.isNotEmpty){
      String media = "data:${lookupMimeType(barLogo.path)};base64," +
          base64Encode(barLogo.readAsBytesSync());
      profilePic = media;
    }
    if (catalogueImage1.path.isNotEmpty){
      String media = "data:${lookupMimeType(catalogueImage1.path)};base64," +
          base64Encode(catalogueImage1.readAsBytesSync());
      catalogue_image1 = media;
    }
    if (catalogueImage2.path.isNotEmpty){
      String media = "data:${lookupMimeType(catalogueImage2.path)};base64," +
          base64Encode(catalogueImage2.readAsBytesSync());
      catalogue_image2 = media;
    }
    if (catalogueImage3.path.isNotEmpty){
      String media = "data:${lookupMimeType(catalogueImage3.path)};base64," +
          base64Encode(catalogueImage3.readAsBytesSync());
      catalogue_image3 = media;
    }
    if (catalogueImage4.path.isNotEmpty){
      String media = "data:${lookupMimeType(catalogueImage4.path)};base64," +
          base64Encode(catalogueImage4.readAsBytesSync());
      catalogue_image4 = media;
    }
    if (catalogueImage5.path.isNotEmpty){
      String media = "data:${lookupMimeType(catalogueImage5.path)};base64," +
          base64Encode(catalogueImage5.readAsBytesSync());
      catalogue_image5 = media;
    }

    try {
      var param = {
        'username': userName,
        'bar_name': barName,
        'email': email,
        'about' : about,
        'address': address,
        'role': "2",
        'bar_kind': [2],
        'working_days': workingDays,
        'opening_time': openingTime,
        'closing_time': closingTime,
        if(breakOpeningTime != '') 'break_opening_time': breakOpeningTime,
        if(breakClosingTime != '') 'break_closing_time': breakClosingTime,
        'weekend_days': weekendDays,
        'weekend_opening_time': weekendOpeningTime,
        'weekend_closing_time': weekendClosingTime,
        if(weekendBreakOpeningTime != '') 'weekend_break_opening_time': weekendBreakOpeningTime,
        if(weekendBreakClosingTime != '') 'weekend_break_closing_time': weekendBreakClosingTime,
        if (profilePic.isNotEmpty)'profile_picture': profilePic,
        if (catalogue_image1.isNotEmpty)'catalogue_image1': catalogue_image1,
        if (catalogue_image2.isNotEmpty)'catalogue_image2': catalogue_image2,
        if (catalogue_image3.isNotEmpty)'catalogue_image3': catalogue_image3,
        if (catalogue_image4.isNotEmpty)'catalogue_image4': catalogue_image4,
        if (catalogue_image5.isNotEmpty)'catalogue_image5': catalogue_image5,
        'terms_conditions': true,
        'data_protection': true,
        'latitude': latitude,
        'longitude':longitude
      };
      print("Testing");

      var response = await dio.post(Constants.BaseUrlPro + Constants.googleSignupBar, data: param,options: Options(contentType: Headers.jsonContentType));
      print(response.data);

      //
      if (response.data["status"] == 200) {
        var userDataList = (response.data['data'] as List).map((e) => UserModel.fromJson(e)).toList();
        print(userDataList);
        return userDataList;

      }

      //

      if (response.statusCode == 200 || response.statusCode == 201) {

        if (response.data['detail'] ==
            "Ihr Konto wurde erstellt, aber Sie können sich erst anmelden, wenn Sauftrag Social Admin Ihr Konto aktiviert. Sie erhalten die Nachricht, wenn Ihr Konto aktiviert wird") {

          DialogUtils().showDialog(
              MyErrorWidgetOne(
            error:
            "Your Request has been sent",
          ));



          // model.signInBar = false;
          // model.notifyListeners();
          // // Mymodel.navigateToSignUpScreen();
          // navigateToSignUpScreen();

        }
        else {
          var oldUser = NewBarModel.fromJson(response.data);
          var userData = NewBarModel.fromJson(response.data);
          userData.token = oldUser.token;
          return userData;
        }
      }

      else {
        return response.data['message'];
      }
    } catch (e) {
      print(e);

      if ((e as DioError).response!.data is Map &&
          (e).response!.data["detail"] != null) {
        DialogUtils().showDialog(
            MyErrorWidget(error: (e).response!.data["detail"].toString()));
      } else {
        DialogUtils().showDialog(
            MyErrorWidget(error: "Bar name already exist"));
        //return (e).error.toString();
      }

      DialogUtils().showDialog(MyErrorWidget(
          error: (e as DioError).response!.data["details"].toString()));
      print(e);
      return (e as DioError).response!.data["details"].toString();
    }
  }


}