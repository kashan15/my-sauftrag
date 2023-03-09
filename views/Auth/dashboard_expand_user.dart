import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/locator.dart';
import '../../bar/views/Drawer/barProfile.dart';
import '../../models/user_models.dart';
import '../../services/addFavorites.dart';
import '../../utils/color_utils.dart';
import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';
import '../../utils/image_utils.dart';
import '../../utils/size_config.dart';
import '../../viewModels/main_view_model.dart';
import '../../viewModels/prefrences_view_model.dart';
import '../../widgets/all_page_loader.dart';
import '../../widgets/loader.dart';

class DashboardExpandUser extends StatefulWidget {

  // int? id;
  // String? username;
  // String? profilePic;
  // bool? fromUser;
  // UserModel? user;
  // String? email;
  int? index;
  int? id;

   DashboardExpandUser({Key? key, this.index, this.id }) : super(key: key);



  @override
  _DashboardExpandUserState createState() => _DashboardExpandUserState();
}

class _DashboardExpandUserState extends State<DashboardExpandUser> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) async {
        // model.allUsers;
        // model.userModel;
        // model.usersList;
        model.getBarPost();
        model.getUserData();
        model.getAllUserForChat();



        // model.userGetAnotherUserInfo();
        // model.gettingComments();


      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return
          // model.isFaqs == true ? AllPageLoader():
          model.isFaqs == true ? AllPageLoader():
             SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: Dimensions.topMargin),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),

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
                        "Total Users",
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 3.t,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h,),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal:SizeConfig.widthMultiplier * 4,),
                        child: GestureDetector(
                          onTap: () async{
        // model.barId = model.listOfBar[index].id;
        // model.selectedBar = (model.listOfAllBars[index]);
        // model.barIndex = index;
        // model.notifyListeners();
        // model.navigateToBarProfile();
        //model.myNavigationService.navigateTo(to: Barprofile());
        //model.navigationService.navigateToBarProfile();
                            showGeneralDialog(
                                context: model.navigationService.navigationKey.currentState!.context,
                                barrierDismissible: false,
                                barrierColor: Colors.white.withOpacity(0.6),
                                pageBuilder: (context, animation1, animation2) {
                                  return Container(
                                    child: Center(
                                      child: RedLoader(),
                                    ),
                                  );
                                });
                               var request = await model.userGetAnotherUserInfo(
                                   model.usersList[index].id.toString());
                              //model.setBusyForObject("gettingProfile",false);
                              if (request is UserModel){
                                model.navigateBack();
                                model.navigateToProfileUser();
                              }
                              else {
                                model.navigateBack();
                              }



                          },
                          child: Container(
                            padding: EdgeInsets.symmetric( horizontal: 2.5.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorUtils.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(0, 5), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                              border: Border.all(color: ColorUtils.text_red),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: model.usersList[index].profile_picture! == null ?
                                  SvgPicture.asset(ImageUtils.logo,
                                    width: 15.i,
                                    height: 15.i,
                                    fit: BoxFit.cover,
                                  ):
                                  Image.network(
                                    // model.listOfAllBars[index].profile_picture!,
                                    // model.allUsers[index].profile_picture!,
                                    model.usersList[index].profile_picture!,
                                    width: 15.i,
                                    height: 15.i,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 2.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          model.usersList[index].username == null ?
                                          Text(
                                            "sauftrag",
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.9.t,
                                                color: ColorUtils.black
                                            ),
                                          )
                                          : Text(
                                            // model.listOfAllBars[index].bar_name!,
                                            // model.allUsers[index].username!,
                                            model.usersList[index].username!,
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.9.t,
                                                color: ColorUtils.black
                                            ),
                                          ),
                                          SizedBox(width: 1.w,),
                                          // Text(model.listOfBar[index].bar_kind!.toString(),
                                          //   style: TextStyle(
                                          //       fontFamily: FontUtils.modernistRegular,
                                          //       fontSize: 1.6.t,
                                          //       color: ColorUtils.red_color
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      SizedBox(height: 0.8.h,),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     SvgPicture.asset(ImageUtils.locationPin,),
                                      //     SizedBox(width: 1.5.w,),
                                      //     Container(
                                      //       width: 50.w,
                                      //       child: Text(model.listOfAllBars[index].address!,
                                      //         style: TextStyle(
                                      //           fontFamily: FontUtils.modernistRegular,
                                      //           fontSize: 1.6.t,
                                      //           color: ColorUtils.text_grey,
                                      //         ),
                                      //
                                      //         maxLines: 1,
                                      //         overflow: TextOverflow.ellipsis,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(height: 0.8.h,),
                                      // RatingBar.builder(
                                      //   tapOnlyMode: false,
                                      //   ignoreGestures: true,
                                      //   initialRating: model.listOfAllBars[index].total_ratings ?? 0.0,
                                      //   // minRating: 1,
                                      //   direction: Axis.horizontal,
                                      //   allowHalfRating: true,
                                      //   itemCount: 5,
                                      //   itemSize: 4.5.i,
                                      //   itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                      //   itemBuilder: (context, _) => Icon(
                                      //     Icons.star_rounded,
                                      //     color: ColorUtils.red_color,
                                      //   ),
                                      //   onRatingUpdate: (rating) {
                                      //     print(rating);
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height:  SizeConfig.heightMultiplier * 2.5,);
                    },
                    // itemCount: model.allUsers.length,
                    itemCount: model.usersList.length,
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
