import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/bar_model.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/newsfeed_post_id.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/views/Auth/signup.dart';

class Dataprotection {
  //var _dioService = DioService.getInstance();

  Dio dio = Dio();

  Future GetDataProtection(

      ) async {
    try {

      NewBarModel? barModel = (await locator<PrefrencesViewModel>().getBarUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.GetDataProtection,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${barModel!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

        var dataprotection = (response.data);
        String dataProtection = dataprotection[0]['data_protection'];
        //print();

        // List<NewsfeedPostId> getBarPost = (response.data as List).map((e) =>
        //     NewsfeedPostId.fromJson(e)).toList();

        //print(termsOfservices);
        return dataProtection;
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
