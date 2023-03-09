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

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {




  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model){
        model.getNotification(context);
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body:model.notificationLoader?Center(child: CircularProgressIndicator(color: ColorUtils.red_color,),):  Column(
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
                            .translate('notification_text_1')!,
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
                        onTap: ()async{
                          if(model.notificationModel?.data?[index].reviewed ==false){
                            print(model.notificationModel?.data?[index].id??'');
                            model.readNotification(model.navigationService.navigationKey.currentContext!,model.notificationModel?.data?[index].id??'',model.notificationModel?.data?[index].action,model.notificationModel?.data?[index].sender?.id.toString()??'0',model.notificationModel?.data?[index].sender?.profilePicture,model.notificationModel?.data?[index].sender?.catalogueImage1,model.notificationModel?.data?[index].sender?.catalogueImage2,model.notificationModel?.data?[index].sender?.catalogueImage3,model.notificationModel?.data?[index].sender?.catalogueImage4,model.notificationModel?.data?[index].sender?.catalogueImage5,model.notificationModel?.data?[index].sender?.username,model.notificationModel?.data?[index].sender?.email,model.notificationModel?.data?[index].body);
                          }else{
                            if(model.notificationModel?.data?[index].action =='newsfeed_detail_screen'){
                              model.navigationService.navigateBack();
                            }else if(model.notificationModel?.data?[index].action =='match_screen'){
                              model.matchedImage.clear();
//model.getMatchedUserData = (model.acceptMatchedtModel[index]);
                              if (model.notificationModel?.data?[index].sender?.profilePicture != null &&
                                  model.notificationModel?.data?[index].sender?.profilePicture.isNotEmpty) {
                                model.matchedImage.add(
                                    model.notificationModel?.data?[index].sender?.profilePicture);
                              }
                              if (model.notificationModel?.data?[index].sender?.catalogueImage1 != null &&
                                  model.notificationModel?.data?[index].sender?.catalogueImage1.isNotEmpty) {
                                model.matchedImage.add(
                                    model.notificationModel?.data?[index].sender?.catalogueImage1);
                              }
                              if (model.notificationModel?.data?[index].sender?.catalogueImage2 != null &&
                                  model.notificationModel?.data?[index].sender?.catalogueImage2.isNotEmpty) {
                                model.matchedImage.add(
                                    model.notificationModel?.data?[index].sender?.catalogueImage2);
                              }
                              if (model.notificationModel?.data?[index].sender?.catalogueImage3 != null &&
                                  model.notificationModel?.data?[index].sender?.catalogueImage3.isNotEmpty) {
                                model.matchedImage.add(
                                    model.notificationModel?.data?[index].sender?.catalogueImage3);
                              }
                              if (model.notificationModel?.data?[index].sender?.catalogueImage4 != null &&
                                  model.notificationModel?.data?[index].sender?.catalogueImage4.isNotEmpty) {
                                model.matchedImage.add(
                                    model.notificationModel?.data?[index].sender?.catalogueImage4);
                              }
                              if (model.notificationModel?.data?[index].sender?.catalogueImage5 != null &&
                                  model.notificationModel?.data?[index].sender?.catalogueImage5.isNotEmpty) {
                                model.matchedImage.add(
                                    model.notificationModel?.data?[index].sender?.catalogueImage5);
                              }
                              model.notifyListeners();

                              await model.userGetAnotherUserInfo(
                                  model.notificationModel?.data?[index].sender?.id.toString()??'0');
                              model.setBusyForObject("gettingProfile",false);
                              model.navigateBack();
                              model.navigateToMatchedProfileUser();
                            }else if(model.notificationModel?.data?[index].action =='report_screen'){
                              showDialog(context: context, builder: (context){
                                return ShowReportNotificationDialogBox(id: model.notificationModel?.data?[index].sender?.id,name: model.notificationModel?.data?[index].sender?.username,email:model.notificationModel?.data?[index].sender?.email,body: model.notificationModel?.data?[index].body,);
                              });
                            }else if(model.notificationModel?.data?[index].action =='approval_screen'){
                              model.selectedBar = await model
                                  .adminService.adminGetBarProfile(
                                  model.notificationModel?.data?[index].sender?.id.toString()??'0');
                              model.notifyListeners();
                              model.navigateToBarProfileOne();
                            }
                          }

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
                              border: Border.all(color:model.notificationModel?.data?[index].reviewed? ColorUtils.white:ColorUtils.red_color),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    model.notificationModel?.data?[index].sender?.profilePicture??'',
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
                                      Text(model.notificationModel?.data?[index].title??'',
                                        style: TextStyle(
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 2.t,
                                            color: ColorUtils.black,
                                        ),
                                      ),
                                      SizedBox(height: 1.h,),
                                      Text(model.notificationModel?.data?[index].body??'',
                                        style: TextStyle(
                                            fontFamily: FontUtils
                                                .modernistRegular,
                                            fontSize: 1.7.t,
                                            color: ColorUtils.black,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(width: 2.w,),
                                Text(
                                '${model.notificationModel?.data?[index].createdAt??''}',
                                  style: TextStyle(
                                      fontFamily: FontUtils.modernistRegular,
                                      fontSize: 1.7.t,
                                      color: ColorUtils.text_dark
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConfig.heightMultiplier * 2.5,);
                    },
                    itemCount: model.notificationModel?.data?.length??0,
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
