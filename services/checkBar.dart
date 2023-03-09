import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sauftrag/models/bar_model.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/views/Auth/signup.dart';

class Checkbar {
  //var _dioService = DioService.getInstance();

  Dio dio = Dio();

  Future CheckBar(

      String email,
      String role,

      ) async {
    try {
      /// just login user through phoneNumber and password

      var param = FormData.fromMap({

        'email': email,
        'role' : role,

      });

      var response = await dio.post(Constants.BaseUrlPro+Constants.CheckUser, data: param);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // user found
        // if (response.data["status"] == 200) {
        //   var userData = UserModel.fromJson(response.data['data']);
        //   return userData;
        // }

        // allUsers = (response.data["users"] as List).map((e) => UserModel.fromJson(e)).toList();


        var userData = NewBarModel.fromJson(response.data);
        return userData;
      }
      //user not found
      else {
        return response.data['message'];
      }

    } catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }
}
