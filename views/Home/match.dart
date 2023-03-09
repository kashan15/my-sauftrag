import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/round_image.dart';
import 'package:stacked/stacked.dart';

import '../../models/user_models.dart';
import '../../utils/app_localization.dart';
import '../UserFriendList/message_screen_for_user.dart';

class Match extends StatefulWidget {
  dynamic index;
  dynamic data;
  UserModel user;
  bool fromProfie;

  // const Match({Key? key, this.index}) : super(key: key);
   Match({
     this.index,
     required this.user,
     this.data,
     required this.fromProfie,
     Key? key, }) : super(key: key);

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {


  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<MainViewModel>.reactive(
      //onModelReady: (data) => data.initializeLoginModel(),
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: WillPopScope(
            onWillPop: ()async{
              model.navigateToSwipeScreen();
              return true;
            },
            child: Scaffold(
                backgroundColor: ColorUtils.white,
                body: Stack(
                  children: [

                    //SvgPicture.asset(ImageUtils.matchBg),

                    Image.asset(ImageUtils.matchBgPng),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding, vertical: Dimensions.verticalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // SvgPicture.asset(ImageUtils.congratzPic),
                          // SizedBox(height: 5.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Container(
                                width: 28.i,
                                height: 28.i,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorUtils.text_grey.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: Offset(0,5)
                                    ),
                                  ],
                                ),
                                child: Container(
                                  //width: 23.i,
                                  //height: 23.i,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(model.userModel!.profile_picture!), fit: BoxFit.cover),
                                      shape: BoxShape.circle
                                  ),
                                ),
                              ),

                              SvgPicture.asset(ImageUtils.matchIcon),

                              Container(
                                width: 28.i,
                                height: 28.i,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorUtils.text_grey.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: Offset(0,5)
                                    ),
                                  ],
                                ),
                                child: Container(
                                  //width: 23.i,
                                  //height: 23.i,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(widget.user.profile_picture!), fit: BoxFit.cover),
                                      shape: BoxShape.circle
                                  ),
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 5.h),


                          // Text(
                          //   // "Request has been send",
                          //   "Congratulations\nIt's a Match",
                          //   style: TextStyle(
                          //     color: ColorUtils.black,
                          //     fontFamily: FontUtils.modernistBold,
                          //     fontSize: 2.4.t,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          RichText(
                            textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "${widget.data[
                                  // "phrase"
                                AppLocalizations.of(context)!
                                    .translate('match_text_1')!
                                ]}",
                                style: TextStyle(
                                      color: ColorUtils.black,
                                      fontFamily: FontUtils.modernistBold,
                                      // fontSize: 2.4.t,
                                  fontSize: 2.6.t,
                                    ),
                              ),
                          ),
                          SizedBox(height: 5.h),

                          //Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              // Expanded(
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       // model.navigateToMessageScreen();
                              //     },
                              //     child: Text("Say Hi"),
                              //     style: ElevatedButton.styleFrom(
                              //       primary: ColorUtils.text_red,
                              //       onPrimary: ColorUtils.white,
                              //       padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                              //       elevation: 0,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                              //           side: BorderSide(
                              //               color: ColorUtils.text_red,
                              //               width: 1
                              //           )
                              //       ),
                              //       textStyle: TextStyle(
                              //         //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                              //         fontFamily: FontUtils.modernistBold,
                              //         fontSize: 1.8.t,
                              //         //height: 0
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              //
                              // SizedBox(width: 5.w,),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {

                                    model.navigateToSwipeScreen();
                                  },
                                  child: Text(
                                      // "Keep Swiping"
                                      AppLocalizations.of(context)!
                                          .translate('match_text_2')!
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: ColorUtils.white,
                                    onPrimary: ColorUtils.text_red,
                                    padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.text_red,
                                            width: 1
                                        )
                                    ),
                                    textStyle: TextStyle(
                                      //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 1.8.t,
                                      //height: 0
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(width: 3.w,),
                              // Expanded(
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       if(model.userModel!.role == 1){
                              //         Navigator.push(
                              //             context,
                              //             PageTransition(
                              //                 type: PageTransitionType
                              //                     .fade,
                              //                 child:
                              //                 // MessageScreenForUser(
                              //                 MessageScreenForUser(
                              //                   id: model.matchedUsers[widget.index].id,
                              //                   username: model.matchedUsers[widget.index].username,
                              //                   profilePic: model.matchedUsers[widget.index].profile_picture,
                              //                   fromUser: true,
                              //                   user: model.matchedUsers[widget.index],
                              //                   email: model.matchedUsers[widget.index].email,
                              //                 )));
                              //       }
                              //     },
                              //     child: Text("Keep Messaging"),
                              //     style: ElevatedButton.styleFrom(
                              //       primary: ColorUtils.white,
                              //       onPrimary: ColorUtils.text_red,
                              //       padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                              //       elevation: 0,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                              //           side: BorderSide(
                              //               color: ColorUtils.text_red,
                              //               width: 1
                              //           )
                              //       ),
                              //       textStyle: TextStyle(
                              //         //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                              //         fontFamily: FontUtils.modernistBold,
                              //         fontSize: 1.8.t,
                              //         //height: 0
                              //       ),
                              //     ),
                              //   ),
                              // )

                            ],
                          ),


                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }
}
