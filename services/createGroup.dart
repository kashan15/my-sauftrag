import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/bar_group_chat.dart';
import 'package:sauftrag/models/create_group_chat.dart';
import 'package:sauftrag/models/get_bar_upcoming_event.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/views/Auth/signup.dart';
import 'package:sauftrag/views/UserFriendList/create_group.dart';

import '../utils/dialog_utils.dart';
import '../widgets/error_widget.dart';

class Creategroup {
  //var _dioService = DioService.getInstance();

  Dio dio = Dio();

  Future CreateGroup(

      String name,
      List listOfUsers,
      int? privacy,
      String? image

      ) async {
    try {
      /// just login user through phoneNumber and password

      var param = FormData.fromMap({

        'name' : name,
        'users' : listOfUsers,
        'privacy' : privacy,
         if(image!= null)'image' : image,

      });

      UserModel? userModel = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.post(Constants.BaseUrlPro+Constants.createGroup,
          data: param,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${userModel!.token!}"
              }
          )
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // user found
        /* if (response.data["status"] == 200) {
          var userData = UserModel.fromJson(response.data['data']);
          return userData;
        }*/
        List<BarGroupChat> getEventByFilter =(response.data as List).map((e) =>
            BarGroupChat.fromJson(e)).toList();
        return getEventByFilter;
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

  Future CreateGroupBar(

      String name,
      List listOfUsers,
      int? privacy,
      String? image

      ) async {
    try {
      /// just login user through phoneNumber and password

      var param = FormData.fromMap({

        'name' : name,
        'users' : listOfUsers,
        'privacy' : privacy,
        if(image!= null)'image' : image,

      });

      NewBarModel? userModel = (await locator<PrefrencesViewModel>().getBarUser());
      var response = await dio.post(Constants.BaseUrlPro+Constants.createGroup,
          data: param,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${userModel!.token!}"
              }
          )
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // user found
        /* if (response.data["status"] == 200) {
          var userData = UserModel.fromJson(response.data['data']);
          return userData;
        }*/
        List<BarGroupChat> getEventByFilter =(response.data as List).map((e) =>
            BarGroupChat.fromJson(e)).toList();
        return getEventByFilter;
      }
      //user not found
      else {
        return response.data['message'];
      }

    } catch (e) {
      dynamic exception = e;
      if ((e as DioError).response!.data is Map &&
          (e).response!.data["detail"] != null) {
        await DialogUtils().showDialog(
            MyErrorWidget(error: (e).response!.data["detail"].toString()));
      } else  {
        await DialogUtils().showDialog(
            MyErrorWidget(error: "Group with this name already exists"));
        //return (e).error.toString();
      }
      return exception.message;
    }
  }

  Future UpdateGroupUsers(

      String name,
      List users,
      String id,

      ) async {
    try {
      /// just login user through phoneNumber and password

      var param = {

        'name' : name,
        'users' : users,

      };

      UserModel? userModel = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.patch(Constants.BaseUrlPro+Constants.createGroup + id +"/",
          data: param,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${userModel!.token!}"
              }
          )
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // user found
        /* if (response.data["status"] == 200) {
          var userData = UserModel.fromJson(response.data['data']);
          return userData;
        }*/
        //BarGroupChat updateParticipants = BarGroupChat.fromJson(response.data);
        return response.data;
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
