import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:sauftrag/widgets/rating_dialog_box.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/app_localization.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model){
        //model.getNotification(context);
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return model.notificationLoader?Loader(): SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: Dimensions.topMargin),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            model.navigateBack();
                          },
                          iconSize: 18.0,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: ColorUtils.black,
                            size: 4.5.i,
                          )),
                      SizedBox(width: 2.w),
                      Text(
                        AppLocalizations.of(
                            context)!
                            .translate('report_txt_1')!,
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 3.t,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 5,),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          //print(model.notificationModel?.data?[index].id??'');
                          //model.readNotification(context,model.notificationModel?.data?[index].id??'');
                        },
                        child: GestureDetector(
                          onTap: (){
                            model.selectedReport = model.allReports[index];
                            showDialog(context: context, builder: (context){
                              return ShowReportDialogBox(id: model.allReports[index].body!.split(":")[1],email: model.allReports[index].user_id!.email,name: model.allReports[index].user_id!.username,body: model.allReports[index].body,);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig
                                .widthMultiplier * 4,),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorUtils.black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 5), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                border: Border.all(color: ColorUtils.text_red),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      model.allReports[index].user_id!.profile_picture!,
                                      width: 12.i,
                                      height: 12.i,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 2.w,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(model.allReports[index].user_id!.username!,
                                          style: TextStyle(
                                              fontFamily: FontUtils.modernistBold,
                                              fontSize: 2.t,
                                              color: ColorUtils.black
                                          ),
                                        ),
                                        SizedBox(height: 1.h,),
                                        Text(model.allReports[index].body!.split(":").last,
                                          style: TextStyle(
                                              fontFamily: FontUtils
                                                  .modernistRegular,
                                              fontSize: 1.7.t,
                                              color: ColorUtils.black
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 2.w,),
                                  Text(
                                    model.allReports[index].created_at!,
                                    style: TextStyle(
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.7.t,
                                        color: ColorUtils.text_dark
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConfig.heightMultiplier * 2.5,);
                    },
                    itemCount: model.allReports.length,
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
