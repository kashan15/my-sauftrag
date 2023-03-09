import 'package:dio/dio.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';

import '../app/locator.dart';
import '../models/listOfFollowing_Bars.dart';
import '../modules/dio_services.dart';
import '../utils/constants.dart';
import '../utils/common_functions.dart';

class AdminService{
  var _dioService = DioService.getInstance();
  Future changeUserStatus(String userID,bool status)async{
    try{
      var response = await _dioService.post(Constants.changeUserStatus,data: FormData.fromMap({
        "user_id" : userID,
        "is_active" : status.toString().capitalize(),
      }),options: Options(
        headers: {
          "Authorization" : "Token ${locator<MainViewModel>().userModel!.token}"
        },
        contentType: Headers.formUrlEncodedContentType
      ));

      if (response.statusCode==200 || response.statusCode == 201){
        locator<MainViewModel>().navigateBack();
        return status;
      }
      else {
        locator<MainViewModel>().navigateBack();
        return  ("some thing went wrong");
      }
    }
    catch(e){
      dynamic exception = e;
      locator<MainViewModel>().navigateBack();
      return exception.message;
    }
  }

  Future adminGetBarProfile(
      barId

      ) async {
    try {

      var response = await _dioService.get(Constants.BaseUrlPro+Constants.getAnotherBarProfile+"${barId}",
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${locator<MainViewModel>().userModel!.token}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        // var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        ListOfBarsModel bar = ListOfBarsModel.fromJson((response.data as List).first);
        return bar;
      }

      //user not founds
      else {
        return response.data['message'];
      }

    }
    catch (e) {
      dynamic exception = e;
      return exception.message;
    }
  }

  Future warnUser(String userId)async{
    try{
      var response = await _dioService.post(Constants.AdminWarn,data: {
        "user_id" : userId,
      },options: Options(
          headers: {
            "Authorization" : "Token ${locator<MainViewModel>().userModel!.token}"
          }
      ));

      if (response.statusCode==200 || response.statusCode == 201){
        locator<MainViewModel>().navigateBack();
        return 0;
      }
      else {
        locator<MainViewModel>().navigateBack();
        return  ("some thing went wrong");
      }
    }
    catch(e){
      dynamic exception = e;
      locator<MainViewModel>().navigateBack();
      return exception.message;
    }
  }
}