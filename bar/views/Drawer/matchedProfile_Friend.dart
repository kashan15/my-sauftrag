import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_picker_timeline/extra/dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/favorites_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/services/addFavorites.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/user_matched.dart';
import '../../../services/request.dart';
import '../../../utils/dialog_utils.dart';
import '../../../views/UserFriendList/message_screen_for_user.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loader.dart';

class MatchedProfileFriend extends StatefulWidget {
  List? images = [];
  UserModel? getMatchedUserData;
  MatchedProfileFriend({Key? key,this.images,this.getMatchedUserData})
      : super(key: key);

  @override
  _MatchedProfileFriendState createState() => _MatchedProfileFriendState();
}

class _MatchedProfileFriendState extends State<MatchedProfileFriend> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // List followerImg = [
  //   {'image': ImageUtils.followerImg1},
  //   {'image': ImageUtils.followerImg2},
  //   {'image': ImageUtils.followerImg3},
  //   {'image': ImageUtils.followerImg4},
  //   {'image': ImageUtils.followerImg5},
  // ];
  //
  // List friendsList = [
  //   {'image': ImageUtils.friends1, 'title': 'Dominic Gray'},
  //   {'image': ImageUtils.friends2, 'title': 'Glen Romero'},
  //   {'image': ImageUtils.friends3, 'title': 'Raul Pope'},
  //   {'image': ImageUtils.friends4, 'title': 'Lance Hernandez'},
  // ];

  List mutualFriendList = [
    {'image': ImageUtils.mutualfrnd1, 'title': 'Tony Walton'},
    {'image': ImageUtils.mutualfrnd2, 'title': 'Mario Reyes'},
    {'image': ImageUtils.mutualfrnd3, 'title': 'Jana Romero'},
    {'image': ImageUtils.mutualfrnd4, 'title': 'Patrick Oliver'},
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) async {

        // model.acceptMatched(context);
        model.drinkList =
        await Addfavorites().GetFavoritesDrink();
        model.clubList =
        await Addfavorites().GetFavoritesClub();
        model.vacationList =
        await Addfavorites().GetFavoritesPartyVacation();
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return model.isLoading == true ? AllPageLoader() :
        SafeArea(
          top: false,
          bottom: false,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                key: _scaffoldKey,
                body: Container(
                  padding: EdgeInsets.only(top: Dimensions.homeTopMargin),
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leading: GestureDetector(
                          onTap: () {
                            model.navigateBack();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 1.7.w, vertical: 1.1.h),
                            padding: EdgeInsets.all(13),
                            //height: 10.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: SvgPicture.asset(ImageUtils.backArrow),
                            height: 5.i,
                          ),
                        ),
                        actions: [
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.more_vert_rounded,
                          //       color: ColorUtils.transparent,
                          //     ))
                        ],
                        floating: true,
                        pinned: false,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        expandedHeight: 280,
                        flexibleSpace: FlexibleSpaceBar(
                          background:
                          Image.network(
                            widget.getMatchedUserData!.profile_picture!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.verticalPadding,
                                horizontal: Dimensions.horizontalPadding),
                            decoration: BoxDecoration(
                              color: ColorUtils.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(1),
                                  //color of shadow
                                  spreadRadius: 5,
                                  //spread radius
                                  blurRadius: 5,
                                  // blur radius
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.getMatchedUserData!.username!,
                                          style: TextStyle(
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 2.5.t,
                                            color: ColorUtils.black,
                                            overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      ),
                                      if (model.userModel!=null)widget.getMatchedUserData!.is_follow!=2
                                          ?
                                      GestureDetector(
                                        onTap: ()async{

                                          if (widget.getMatchedUserData!.is_follow==0){
                                            showGeneralDialog(
                                                context: model.navigationService.navigationKey.currentState!.context,
                                                barrierDismissible: false,
                                                barrierColor: Colors.white.withOpacity(0.6),
                                                pageBuilder: (context,animation1,animation2){
                                                  return Container(
                                                    child: Center(
                                                      child: RedLoader(),
                                                    ),
                                                  );
                                                });
                                            var request = await SendRequest().sendingRequest(
                                                context,
                                                widget.getMatchedUserData!.id!,
                                              widget.getMatchedUserData!
                                            );
                                            if (request is String){
                                              await DialogUtils().showDialog(MyErrorWidget(
                                                  error: request));
                                            }
                                            else{
                                              widget.getMatchedUserData!.is_follow = request;
                                            }
                                            model.notifyListeners();
                                          }

                                        },
                                        child: Container(
                                            height: 4.5.h,
                                            decoration: BoxDecoration(
                                                color: ColorUtils.red_color,
                                                borderRadius: BorderRadius.circular(18)),

                                            child: Padding(
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 30),

                                              child: Center(
                                                // child: model.matchedUser!.is_follow == null?
                                                  child: widget.getMatchedUserData!.is_follow == 0?

                                                  // model.matchedUser!.id != null ?
                                                  // Text(
                                                  //   "Requested",
                                                  //   style: TextStyle(
                                                  //       color: ColorUtils.white,
                                                  //       fontSize: 2.t,
                                                  //       fontFamily: FontUtils.modernistBold),
                                                  //
                                                  // ) :
                                                  // model.matchedUser!.is_follow! ?

                                                  Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                        color: ColorUtils.white,
                                                        fontSize: 2.t,
                                                        fontFamily: FontUtils.modernistBold),
                                                  ):
                                                  // model.matchedUser!.is_follow!?
                                                  Text(
                                                    "Requested",
                                                    style: TextStyle(
                                                        color: ColorUtils.white,
                                                        fontSize: 2.t,
                                                        fontFamily: FontUtils.modernistBold),
                                                  )
                                                // :
                                                // Text(
                                                //   "Follow",
                                                //   style: TextStyle(
                                                //       color: ColorUtils.white,
                                                //       fontSize: 2.t,
                                                //       fontFamily: FontUtils.modernistBold),
                                                // )

                                              ),

                                            )
                                        ),
                                      )
                                      :
                                      InkWell(
                                          onTap: (){
                                            if(model.userModel!.role == 1){
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                      MessageScreenForUser(
                                                        id: widget.getMatchedUserData!
                                                            .id,
                                                        username: widget.getMatchedUserData!
                                                            .username,
                                                        profilePic: widget.getMatchedUserData!
                                                            .profile_picture,
                                                        email: widget.getMatchedUserData!
                                                            .email,
                                                      )));
                                            }
                                            else{
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     PageTransition(
                                              //         type: PageTransitionType
                                              //             .fade,
                                              //         child:
                                              //         MessageScreenForUser(
                                              //           id: model
                                              //               .barsList[index]
                                              //               .id,
                                              //           username: model
                                              //               .barsList[index]
                                              //               .username,
                                              //           profilePic: model
                                              //               .barsList[index]
                                              //               .profile_picture,
                                              //         )));
                                            }
                                          },
                                          child: SvgPicture.asset(ImageUtils.chatIcon,color: ColorUtils.red_color,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(ImageUtils.location_icon),
                                      SizedBox(width: 2.w),
                                      Flexible(
                                        child: Text(
                                          widget.getMatchedUserData!.address??'',
                                          style: TextStyle(
                                            fontFamily: FontUtils.modernistRegular,
                                            fontSize: 1.8.t,
                                            color: ColorUtils.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "About",
                                    style: TextStyle(
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 2.3.t,
                                      color: ColorUtils.black,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  widget.getMatchedUserData!.about != null ?
                                  Text(
                                    widget.getMatchedUserData!.about!,
                                    style: TextStyle(
                                      fontFamily: FontUtils.modernistRegular,
                                      fontSize: 1.8.t,
                                      color: ColorUtils.black,
                                    ),
                                  ) : Text(""),
                                  SizedBox(height: 3.h),

                                  //Interest
                                  Text(
                                    "Interest",
                                    style: TextStyle(
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 2.3.t,
                                      color: ColorUtils.black,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),

                                  //Favorite Drink
                                  Text(
                                    "Lieblingsalkoholisches Getränk",
                                    style: TextStyle(
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 2.t,
                                      color: ColorUtils.black,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Wrap(
                                    spacing: 2.5.w,
                                    runSpacing: 1.5.h,
                                    direction: Axis.horizontal,
                                    children: widget.getMatchedUserData!.favorite_alcohol_drinks!
                                        .map((element) => ElevatedButton(
                                      onPressed: () {
                                        // if (model.selectedInterestList
                                        //     .contains(model.interestList
                                        //         .indexOf(element))) {
                                        //   model.selectedInterestList.remove(
                                        //       model.interestList
                                        //           .indexOf(element));
                                        // } else {
                                        //   //model.selectedInterestList.add(model.interestList.indexOf(element));
                                        // }
                                        // model.notifyListeners();
                                      },
                                      child: Text( "${(model.drinkList.where((drink)
                                      => element==drink.id).first as FavoritesModel).name}"),
                                      style: ElevatedButton.styleFrom(
                                        primary:  ColorUtils.white,
                                        onPrimary: ColorUtils.red_color,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.8.h,
                                            horizontal: 9.w),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.roundCorner),
                                            side: BorderSide(
                                                color: ColorUtils.text_red,
                                                width: 1)),
                                        textStyle: TextStyle(
                                          //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                          fontFamily:
                                          FontUtils.modernistBold,

                                          fontSize: 1.5.t,
                                          //height: 0
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                  SizedBox(height: 3.h),

                                  //Favorite Night Club
                                  Text(
                                    "Leiblingsmusik",
                                    style: TextStyle(
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 2.t,
                                      color: ColorUtils.black,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Wrap(
                                    spacing: 2.5.w,
                                    runSpacing: 1.5.h,
                                    direction: Axis.horizontal,
                                    children: widget.getMatchedUserData!.favorite_musics!
                                        .map((element) => ElevatedButton(
                                      onPressed: () {

                                      },
                                      child: Text( "${(model.clubList.where((drink)
                                      => element==drink.id).first as FavoritesModel).name}"),
                                      style: ElevatedButton.styleFrom(
                                        primary:  ColorUtils.white,
                                        onPrimary: ColorUtils.red_color,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.8.h,
                                            horizontal: 9.w),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.roundCorner),
                                            side: BorderSide(
                                                color: ColorUtils.text_red,
                                                width: 1)),
                                        textStyle: TextStyle(
                                          //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                          fontFamily:
                                          FontUtils.modernistBold,

                                          fontSize: 1.5.t,
                                          //height: 0
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                  SizedBox(height: 3.h),

                                  //Favorite Party Vacation
                                  Text(
                                    "Lieblingsurlaub",
                                    style: TextStyle(
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 2.t,
                                      color: ColorUtils.black,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Wrap(
                                    spacing: 2.5.w,
                                    runSpacing: 1.5.h,
                                    direction: Axis.horizontal,
                                    children: widget.getMatchedUserData!.favorite_party_vacation!
                                        .map((element) => ElevatedButton(
                                      onPressed: () {
                                        // if (model.selectedInterestList
                                        //     .contains(model.interestList
                                        //         .indexOf(element))) {
                                        //   model.selectedInterestList.remove(
                                        //       model.interestList
                                        //           .indexOf(element));
                                        // } else {
                                        //   //model.selectedInterestList.add(model.interestList.indexOf(element));
                                        // }
                                        // model.notifyListeners();
                                      },
                                      child: Text( "${(model.vacationList.where((drink)
                                      => element==drink.id).first as FavoritesModel).name}"),
                                      style: ElevatedButton.styleFrom(
                                        primary:  ColorUtils.white,
                                        onPrimary: ColorUtils.red_color,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.8.h,
                                            horizontal: 9.w),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.roundCorner),
                                            side: BorderSide(
                                                color: ColorUtils.text_red,
                                                width: 1)),
                                        textStyle: TextStyle(
                                          //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                          fontFamily:
                                          FontUtils.modernistBold,

                                          fontSize: 1.5.t,
                                          //height: 0
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                  ),
                                  SizedBox(height: 3.h),
                                  if(model.userModel!=null)
                                    if (widget.getMatchedUserData!.is_follow==2)
                                      Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Image",
                                            style: TextStyle(
                                              fontFamily: FontUtils.modernistBold,
                                              fontSize: 2.3.t,
                                              color: ColorUtils.black,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          // Text(
                                          //   "See all",
                                          //   style: TextStyle(
                                          //       fontFamily: FontUtils.modernistRegular,
                                          //       fontSize: 1.8.t,
                                          //       color: ColorUtils.red_color,
                                          //       decoration: TextDecoration.underline),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),

                                      GridView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: widget.images!.length,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.7,
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 1.5*SizeConfig.widthMultiplier,
                                            //childAspectRatio: 1,
                                            crossAxisSpacing: 1*SizeConfig.widthMultiplier),
                                        itemBuilder: (context,  index) {
                                          return GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, PageTransition(child: ViewZoomedImage(index: index,images: widget.images,), type: PageTransitionType.fade));
                                            },
                                            child: Container(
                                              //padding: EdgeInsets.all(4.0),
                                              //height: 20.h,
                                                height: MediaQuery.of(context).size.width / 3.4,
                                                width:
                                                MediaQuery.of(context).size.width / 3.4,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image:
                                                      NetworkImage(widget.images![index]),
                                                      fit: BoxFit.contain),
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: Container()
                                            ),
                                          );

                                        },),

                                      SizedBox(height: 3.h),

                                      if (widget.getMatchedUserData!.is_follow==2)Column(
                                        children: [
                                          SizedBox(height: 3.h),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Friends",
                                                style: TextStyle(
                                                  fontFamily: FontUtils.modernistBold,
                                                  fontSize: 2.3.t,
                                                  color: ColorUtils.black,
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              /*Text(
                                                "See all",
                                                style: TextStyle(
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 1.8.t,
                                                    color: ColorUtils.red_color,
                                                    decoration: TextDecoration.underline),
                                              ),*/
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Container(
                                            child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: widget.getMatchedUserData!.friends!.length,
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 25,
                                                  crossAxisSpacing: 15),
                                              itemBuilder: (context, index) {
                                                return Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: Image.network(widget.getMatchedUserData!.friends![index].user!.profilePicture!,
                                                          width: 15.i,
                                                          height: 15.i,
                                                          fit: BoxFit.cover,

                                                        ),
                                                      ),
                                                      // Image.network(
                                                      //   model.matchedUser!.friends![index].user!.profilePicture!,
                                                      //   height: 15.i,
                                                      // ),
                                                      Expanded(
                                                          child: Text(
                                                            (widget.getMatchedUserData!.friends![index].user!.username),
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                FontUtils.modernistBold,
                                                                fontSize: 1.7.t),
                                                            textAlign: TextAlign.center,
                                                          ))
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 3.h),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Mutual Friends",
                                                style: TextStyle(
                                                  fontFamily: FontUtils.modernistBold,
                                                  fontSize: 2.3.t,
                                                  color: ColorUtils.black,
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              /*Text(
                                                "See all",
                                                style: TextStyle(
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 1.8.t,
                                                    color: ColorUtils.red_color,
                                                    decoration: TextDecoration.underline),
                                              ),*/
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Container(
                                            child: GridView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: widget.getMatchedUserData!.mutual_friends!.length,
                                              gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 25,
                                                  crossAxisSpacing: 15),
                                              itemBuilder: (context, index) {
                                                return Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: Image.network(widget.getMatchedUserData!.mutual_friends![index].user!.profilePicture!,
                                                          width: 15.i,
                                                          height: 15.i,
                                                          fit: BoxFit.cover,

                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                            (widget.getMatchedUserData!.mutual_friends![index].user!.username),
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                FontUtils.modernistBold,
                                                                fontSize: 1.7.t),
                                                            textAlign: TextAlign.center,
                                                          ))
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 0.h),
                                        ],
                                      ),
                                    ],
                                  )
                                  else
                                    Container(),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
          ),
        );

      },
    );
  }
}

class ViewZoomedImage extends StatefulWidget {
  final int? index;
  final List? images;
  const ViewZoomedImage({Key? key,this.index,this.images}):super(key:key);
  @override
  _ViewZoomedImageState createState() => _ViewZoomedImageState();
}

class _ViewZoomedImageState extends State<ViewZoomedImage> {

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    model.navigateBack();
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 1.7.w, top: 3.h),
                    padding: EdgeInsets.all(13),
                    //height: 10.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SvgPicture.asset(ImageUtils.backArrow),
                    height: 10.i,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      child: PhotoViewGallery.builder(
                        itemCount: widget.images!.length,
                        pageController: pageController,
                        builder: (context, index) {
                          return  PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(widget.images![index]),
                            initialScale: PhotoViewComputedScale.contained * 1,
                            //heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model){
        Future.delayed(Duration(milliseconds: 100)).then((value)async{
          pageController.jumpToPage(widget.index!);
        });
      },
      disposeViewModel: false,
    );
  }
}
