
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sauftrag/bar/views/Drawer/matched_screen.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/app_language.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/views/Home/match.dart';
import 'package:sauftrag/views/Home/profie_match.dart';
import 'package:stacked/stacked.dart';

import '../app/locator.dart';
import '../models/user_models.dart';
import '../utils/image_utils.dart';
import '../viewModels/prefrences_view_model.dart';
import '../widgets/dialog_event.dart';

class SendRequest extends RegistrationViewModel{
  var _dioService = DioService.getInstance();
  // bool userMatchLoader = false;


    Future sendingRequest(BuildContext context, int id,UserModel user2) async

    {


      UserModel? user = await locator<PrefrencesViewModel>().getUser();

      // Future sendingRequest(int id,) async {

      try {
        // userMatchLoader = true;

        var matchParams = FormData.fromMap({
          'customer2': id
        });
        print(matchParams);

        var response = await _dioService.post(
            "${Constants.matchUser}", data: matchParams,
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: {"Authorization": "Token ${user!.token}"})
        );

        print(response);
        navigateBack();
        if (response.statusCode == 200) {
          // if (response.data["status"] == 200) {
          //   return true;
          // }
          // //user not found
          // else {
          //   return response.data['message'];
          // }
          navigationService.navigationKey.currentState!.push(PageTransition(child: ProfieMatch(user : user2,data: response.data,fromProfie: true,), type: PageTransitionType.rightToLeftWithFade));
          return 2;
          // Navigator.push(context,MaterialPageRoute(builder: (context) => na()));
        }
        else if(response.statusCode == 201){
            return 1;
        }
        else {
          return ("some thing went wrong");
        }
      }

      catch (e) {
        dynamic exception = e;
        return exception.message;

      }

    }

    Future disolveFriend(BuildContext context, int id,UserModel user2) async

    {


    UserModel? user = await locator<PrefrencesViewModel>().getUser();

    // Future sendingRequest(int id,) async {

    try {
      // userMatchLoader = true;

      var matchParams = FormData.fromMap({
        'id': id
      });
      print(matchParams);

      var response = await _dioService.delete(
          "${Constants.deleteMatch}", data: matchParams,
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {"Authorization": "Token ${user!.token}"})
      );

      print(response);
      navigateBack();
      if (response.statusCode == 200) {
        // if (response.data["status"] == 200) {
        //   return true;
        // }
        // //user not found
        // else {
        //   return response.data['message'];
        // }
        navigationService.navigationKey.currentState!.pop();
        //navigationService.navigationKey.currentState!.push(PageTransition(child: ProfieMatch(user : user2,data: response.data,fromProfie: true,), type: PageTransitionType.rightToLeftWithFade));
        return 0;
        // Navigator.push(context,MaterialPageRoute(builder: (context) => na()));
      }
      else if(response.statusCode == 201){
        return 1;
      }
      else {
        return ("some thing went wrong");
      }
    }

    catch (e) {
      dynamic exception = e;
      return exception.message;

    }

  }


}