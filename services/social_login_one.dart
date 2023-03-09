import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/dialog_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/views/Auth/signup.dart';
import 'package:sauftrag/widgets/error_widget.dart';

import '../main.dart';

class SocialLoginUserOne {
  var navigationService = navigationViewModel;

  //var _dioService = DioService.getInstance();

  Dio dio = Dio();
  bool? signInUserOne = false;

  Future SocialLogInUserOne(
      // String username,
      String email,
      String role,
      ) async {
    try {
      var param = FormData.fromMap({
        // 'username': username,
        'username': email,
        'role': role,
        'profile_picture': ''
        // 'password': password,
        // 'role': role,
        // 'profile_picture': ''


      });

      var response = await dio.post(Constants.BaseUrlPro + Constants.googleSignupCustomerOne, data: param);
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        signInUserOne = true;
        var user;
        if (response.data["user"]["bar_name"] != null) {
          user = NewBarModel.fromJson(response.data["user"]);
          (user as NewBarModel).token = response.data["token"];
        } else {
          user = UserModel.fromJson(response.data["user"]);
          user.token = response.data["token"];
        }

        return user;
      }
      //user not found
      else {
        return response.data['message'];
      }
    }
    on DioError catch (e) {
      // if (e.response!=null){
      //   if(e.response!.statusCode == 500) {
      //     navigationService.navigateToServerErrorPage();
      //   }
      //
      //   if ((e as DioError).response!.data is Map &&
      //       (e).response!.data["detail"] != null) {
      //     DialogUtils().showDialog(
      //         MyErrorWidget(error: (e).response!.data["detail"].toString()));
      //   } else  {
      //     DialogUtils().showDialog(
      //         MyErrorWidget(error: "Unable to login with provided credentials"));
      //     //return (e).error.toString();
      //   }
      // }
      print(e);
      //return (e as DioError).response!.data["detail"];
      // dynamic exception = e;
      // return exception.message;
    }
  }

}