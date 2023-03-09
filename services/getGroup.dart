import 'package:dio/dio.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/bar_group_chat.dart';
import 'package:sauftrag/models/create_group_chat.dart';
import 'package:sauftrag/models/faqs_questions.dart';
import 'package:sauftrag/models/get_bar_followers.dart';
import 'package:sauftrag/models/get_bar_upcoming_event.dart';
import 'package:sauftrag/models/listOfFollowing_Bars.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';

import '../models/get_bar_follower_list.dart';

class GetGroup {
  //var _dioService = DioService.getInstance();

  Dio dio = Dio();

  Future GetGroups(


      ) async {
    try {

      UserModel? user = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.GetGroup,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        //print("jhjg");
        List<BarGroupChat> getListGroup = (response.data as List).map((e) =>
            BarGroupChat.fromJson(e)).toList();

        getListGroup.sort((a,b){
          return DateTime.parse(b.updated_at!).compareTo(DateTime.parse(a.updated_at!));
        });
        // getbarfollowers.removeWhere((element) => element.role==2);
        return getListGroup;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future GetUsers(


      ) async {
    try {

      UserModel? user = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.userSearchUsers,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        List users = [];
        users.addAll((response.data["users"] as List).map((e) => UserModel.fromJson(e)).toList());
        users.addAll((response.data["bars"] as List).map((e) => ListOfBarsModel.fromJson(e)).toList());
        return users;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future GetBarGroups(


      ) async {
    try {

      NewBarModel? user = (await locator<PrefrencesViewModel>().getBarUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.GetGroup,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        //print("jhjg");
        List<BarGroupChat> getListGroup = (response.data as List).map((e) =>
            BarGroupChat.fromJson(e)).toList();

        getListGroup.sort((a,b){
          return DateTime.parse(b.updated_at!).compareTo(DateTime.parse(a.updated_at!));
        });
        // getbarfollowers.removeWhere((element) => element.role==2);
        return getListGroup;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future SearchUsers(
      userName
      )async{
    try {

      UserModel? user = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.userSearchUsers+userName,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        // var faqs = (response.data);
        List users = [];
        users.addAll((response.data["users"] as List).map((e) => UserModel.fromJson(e)).toList());
        users.addAll((response.data["bars"] as List).map((e) => ListOfBarsModel.fromJson(e)).toList());
        users.removeWhere((element) => element.id==user.id);
        return users;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future SearchUsersBars(
      userName
      )async{
    try {

      UserModel? user = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.followersList+
          "?search=${userName}",
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        //print("jhjg");
        List<GetBarFollowersList> getListGroup = (response.data as List).map((e) =>
            GetBarFollowersList.fromJson(e)).toList();
        // getbarfollowers.removeWhere((element) => element.role==2);
        return getListGroup;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future SearchGroup(
      groupName
      )async{
    try {

      UserModel? user = (await locator<PrefrencesViewModel>().getUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.userSearchGroup+groupName,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        //print("jhjg");
        List<BarGroupChat> getListGroup = (response.data as List).map((e) =>
            BarGroupChat.fromJson(e)).toList();
        // getbarfollowers.removeWhere((element) => element.role==2);
        return getListGroup;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future BarSearchGroup(
      groupName
      )async{
    try {

      NewBarModel? user = (await locator<PrefrencesViewModel>().getBarUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.userSearchGroup+groupName,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${user!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        //print("jhjg");
        List<BarGroupChat> getListGroup = (response.data as List).map((e) =>
            BarGroupChat.fromJson(e)).toList();
        // getbarfollowers.removeWhere((element) => element.role==2);
        return getListGroup;
      }

      //user not found
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }
}