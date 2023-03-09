import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/bar_model.dart';
import 'package:sauftrag/models/faqs_questions.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/newsfeed_post_id.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/modules/dio_services.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/convertAssetToFile.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/views/Auth/signup.dart';

class Faqs {
  //var _dioService = DioService.getInstance();

  Dio dio = Dio();

  Future GetFaqs(


      ) async {
    try {

      NewBarModel? barModel = (await locator<PrefrencesViewModel>().getBarUser());
      var response = await dio.get(Constants.BaseUrlPro+Constants.GetFaqs,
          options: Options(
            // contentType: Headers.formUrlEncodedContentType,
              headers: {
                "Authorization": "Token ${barModel!.token!}"
              }
          ));
      if (response.statusCode == 200 || response.statusCode == 201) {

       // var faqs = (response.data);
        //List<FaqsModel> Faq = faqs[1]['question'];
        List<FaqsModel> Faq = (response.data as List).map((e) =>
            FaqsModel.fromJson(e)).toList();
        return Faq;
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
