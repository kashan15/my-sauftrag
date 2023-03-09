import 'package:flutter/material.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class UserNotifications extends StatefulWidget {
  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {

  bool _isSwitch =false;
  bool _isSwitch1 =false;
  bool _isSwitch2 =false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(
          //   leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   title: Container(
          //     child: Text(
          //       "Notifications",
          //       style: TextStyle(
          //           color: Colors.black, fontSize: 2.5.t, fontFamily: FontUtils.modernistBold),
          //     ),
          //   ),
          // ),
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding,),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.topMargin),
                  Container(
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: Dimensions.horizontalPadding,
                    // ),
                    child:  Row(
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
                  SizedBox(height: 6.h),
                  Row(
                    children: [

                      Text(
                        AppLocalizations.of(
                            context)!
                            .translate('notification_text_2')!,

                        style:
                        TextStyle(fontSize: 2.t, fontFamily: FontUtils.modernistBold),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),
                    width: 350.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorUtils.red_color),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        model.userModel!=null?Text( model.userModel!.push_notificaiton == false ?
                          // "Off" : "On",
                        AppLocalizations.of(
                            context)!
                            .translate('notification_text_3')! :
                        AppLocalizations.of(
                            context)!
                            .translate('notification_text_4')!,
                          style: TextStyle(
                              color: ColorUtils.red_color,fontFamily: FontUtils.modernistBold),
                        )
                        :
                        Text( model.barModel!.push_notificaiton == false ?
                        "Off" : "On",
                          style: TextStyle(
                              color: ColorUtils.red_color,fontFamily: FontUtils.modernistBold),
                        ),
                        Switch(
                          value: model.userModel!=null?model.userModel!.push_notificaiton!=null?model.userModel!.push_notificaiton!:false:model.barModel!.push_notificaiton!=null?model.barModel!.push_notificaiton!:false,
                          onChanged: (value) {
                            setState(() {
                              if (model.userModel!=null) {
                                model.userModel!.push_notificaiton = value;
                                model.prefrencesViewModel.saveUser(
                                    model.userModel!);
                              }
                              else {
                                model.barModel!.push_notificaiton = value;
                                model.prefrencesViewModel.saveBarUser(
                                    model.barModel!);
                              }
                            });
                          },
                          activeTrackColor:ColorUtils.red_color,
                          activeColor: ColorUtils.red_color,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),
                    height: 15.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorUtils.red_color),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                  context)!
                                  .translate('notification_text_5')!,
                              style: TextStyle(color: ColorUtils.red_color,fontFamily: FontUtils.modernistBold),),
                            Switch(
                              value: model.userModel!=null?model.userModel!.receiving_messages!=null?model.userModel!.receiving_messages!:false:model.barModel!.receiving_messages!=null?model.barModel!.receiving_messages!:false,
                              onChanged: (value) {
                                setState(() {
                                  if (model.userModel != null) {
                                    model.userModel!.receiving_messages = value;
                                    model.prefrencesViewModel.saveUser(
                                        model.userModel!);
                                  }
                                  else {
                                    model.barModel!.receiving_messages = value;
                                    model.prefrencesViewModel.saveBarUser(
                                        model.barModel!);
                                  }
                                });
                              },
                              activeTrackColor:ColorUtils.red_color,
                              activeColor: ColorUtils.red_color,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(
                                  context)!
                                  .translate('notification_text_6')!,
                              style: TextStyle(color: ColorUtils.red_color,fontFamily: FontUtils.modernistBold),),
                            Switch(
                              value: model.userModel!=null?model.userModel!.new_friend_request!=null?model.userModel!.new_friend_request!:false:model.barModel!.new_friend_request!=null?model.barModel!.new_friend_request!:false,
                              onChanged: (value) {
                                setState(() {
                                  if (model.userModel!=null) {
                                    model.userModel!.new_friend_request = value;
                                    model.prefrencesViewModel.saveUser(
                                        model.userModel!);
                                  }
                                  else {
                                    model.barModel!.new_friend_request = value;
                                    model.prefrencesViewModel.saveBarUser(
                                        model.barModel!);
                                  }
                                });
                              },
                              activeTrackColor:ColorUtils.red_color,
                              activeColor: ColorUtils.red_color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
