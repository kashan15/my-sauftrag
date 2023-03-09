import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mime/mime.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/dialog_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/views/Auth/signup.dart';
import 'package:sauftrag/widgets/error_widget.dart';

class SocialSignupUser {
  //var _dioService = DioService.getInstance();

  Dio dio = Dio();

  Future SocialSignUpUser(
      String email,
      String about,
      String username,
      // String country_code,
      String phone_no,
      String relationship,
      String latitude,
      String longitude,
      String address,
      String gender,
      String DOB,
      List<int> selectedDrinkList,
      List<int> selectedClubList,
      List<int> selectedVacationList,
      List images,
      bool termsCheck,
      bool dataCheck,

      ) async {
    try {
      // if (images[0].path.isNotEmpty){
      //   String media = "data:${lookupMimeType(images[0].path)};base64," +
      //       base64Encode(images[0].readAsBytesSync());
      //   files.add(media);
      // }
      var param = FormData.fromMap({
        'username': username,
        'email': email,
        'about' : about,
        // 'country_code': country_code,
        'phone_no': phone_no,
        'gender': gender,
        'address': address,
        'dob': DOB,
        'relation_ship': relationship,
        'latitude' : latitude,
        'longitude' : longitude,
        'favorite_alcohol_drinks': selectedDrinkList,
        'favorite_musics': selectedClubList,
        'favorite_party_vacation': selectedVacationList,
        'role': "1",
        if (images[0] is File && (images[0] as File).path.isNotEmpty)
          "profile_picture": await MultipartFile.fromFile(
            (images[0] as File).path,
          ),
        if (images[1] is File && (images[1] as File).path.isNotEmpty)
          "catalogue_image1": await MultipartFile.fromFile(
            (images[1] as File).path,
          ),
        if (images[2] is File && (images[2] as File).path.isNotEmpty)
          "catalogue_image2": await MultipartFile.fromFile(
            (images[2] as File).path,
          ),
        if (images[3] is File && (images[3] as File).path.isNotEmpty)
          "catalogue_image3": await MultipartFile.fromFile(
            (images[3] as File).path,
          ),
        if (images[4] is File && (images[4] as File).path.isNotEmpty)
          "catalogue_image4": await MultipartFile.fromFile(
            (images[4] as File).path,
          ),
        if (images[5] is File && (images[5] as File).path.isNotEmpty)
          "catalogue_image5": await MultipartFile.fromFile(
            (images[5] as File).path,
          ),
        'terms_conditions': termsCheck,
        'data_protection': dataCheck,

      });
      var response = await dio.post(Constants.BaseUrlPro + Constants.googleSignupCustomer, data: param);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // user found

        var userData = UserModel.fromJson(response.data);
        return userData;
      }
      //user not found
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
            MyErrorWidget(error: "User name already exist"));
        //return (e).error.toString();
      }
      //dynamic exception = e;
      //return (e as DioError).response!.data["message"].toString();
    }
  }
}
