import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/favorites_model.dart';
import 'package:sauftrag/services/addFavorites.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:sauftrag/widgets/back_arrow_with_container.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

import '../../models/user_models.dart';
import '../../services/request.dart';
import '../../utils/dialog_utils.dart';
import '../../widgets/error_widget.dart';
import '../UserFriendList/message_screen_for_user.dart';

class Profile extends StatefulWidget {
  int height;
  List<String> images;
  String? name;
  String? address;
  List alcoholDrink;
  List nightClub;
  List partyVacation;
  dynamic id;
  int distance;
  List? drinking_motivation;
  UserModel user;

  Profile({
    Key? key,
    required this.height,
    required this.images,
    required this.name,
    required this.address,
    required this.alcoholDrink,
    required this.nightClub,
    required this.partyVacation,
    required this.id,
    required this.distance,
    required this.drinking_motivation,
    required this.user

  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentPageNotifier = ValueNotifier<int>(0);

 // double? distanceInMeters;

  late PageController controller;

  @override
  void initState() {
    super.initState();

    controller = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      //onModelReady: (data) => data.initializeLoginModel(),
      onModelReady: (model) async {
        if (model.drinkList.isEmpty){
          // model.drinkList =
          // await Addfavorites().GetFavoritesDrink();
          // model.clubList =
          // await Addfavorites().GetFavoritesClub();
          // model.vacationList =
          // await Addfavorites().GetFavoritesPartyVacation();
          // setState(() {
          //
          // });
        }
        print(model.drinkList);
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: model.acceptMatchesLoader ? Center(child: AllPageLoader()) :
          SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
                backgroundColor: ColorUtils.white,
                body: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //SizedBox(height: 4.3.h),
                          Container(
                            height: 53.5.h,
                            //color: Colors.red,
                            child: SafeArea(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 45.h,
                                    child: Stack(
                                      children: [
                                        PageView.builder(
                                          itemBuilder: (context, position) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                //borderRadius: BorderRadius.all(Radius.circular(20)),
                                                image: DecorationImage(
                                                    alignment: Alignment.center,
                                                    image: NetworkImage(
                                                        widget.images[position]),
                                                    fit: BoxFit.contain),
                                              ),
                                              alignment: Alignment.center,
                                            );
                                          },
                                          itemCount: widget.images.length,
                                          controller: controller,
                                          onPageChanged: (int index) {
                                            currentPageNotifier.value = index;
                                          }, // Can be null
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.w, vertical: 1.5.h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15)),
                                              color: ColorUtils.white
                                                  .withOpacity(0.6),
                                            ),
                                            child: SmoothPageIndicator(
                                                controller:
                                                controller, // PageController
                                                count: widget.images.length,
                                                effect: WormEffect(
                                                    spacing: 10,
                                                    dotWidth: 5,
                                                    dotHeight: 5,
                                                    dotColor: ColorUtils.white
                                                        .withOpacity(0.5),
                                                    activeDotColor:
                                                    ColorUtils.white),
                                                axisDirection: Axis.horizontal,
                                                onDotClicked: (index) {}),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Positioned(
                                  //     bottom: -2.2.h,
                                  //     right: 3.w,
                                  //     child: GestureDetector(
                                  //       onTap: (){
                                  //         model.navigateToMatchScreen();
                                  //       },
                                  //       child: Container(
                                  //         width: 12.w,
                                  //         height: 12.h,
                                  //         decoration: BoxDecoration(shape: BoxShape.circle, color: ColorUtils.red_color,),
                                  //         child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white,)
                                  //       ),
                                  //     )),
                                  Positioned(
                                      top: 5.h,
                                      left: 5.w,
                                      child: Container(
                                          width: 10.w,
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: BackArrowContainer())),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   height: 60.h,
                          //   color: Colors.red,
                          //   child: SizedBox(
                          //       height: MediaQuery.of(context).size.height * 0.45,
                          //       child: Stack(
                          //         children: [
                          //           PageView.builder(
                          //             itemBuilder: (context, position) {
                          //               return Container(
                          //                 decoration: BoxDecoration(
                          //                   //borderRadius: BorderRadius.all(Radius.circular(20)),
                          //                   image: DecorationImage(
                          //                       image: AssetImage(
                          //                           widget.images[position]),
                          //                       fit: BoxFit.cover),
                          //                 ),
                          //                 alignment: Alignment.center,
                          //               );
                          //             },
                          //             itemCount: widget.images.length,
                          //             controller: controller,
                          //             onPageChanged: (int index) {
                          //               currentPageNotifier.value = index;
                          //             }, // Can be null
                          //           ),
                          //           Align(
                          //             alignment: Alignment.bottomCenter,
                          //             child: Container(
                          //               padding: EdgeInsets.symmetric(
                          //                   horizontal: 3.w, vertical: 1.5.h),
                          //               decoration: BoxDecoration(
                          //                 borderRadius: BorderRadius.only(
                          //                     topLeft: Radius.circular(15),
                          //                     topRight: Radius.circular(15)),
                          //                 color: ColorUtils.white.withOpacity(0.6),
                          //               ),
                          //               child: SmoothPageIndicator(
                          //                   controller: controller, // PageController
                          //                   count: widget.images.length,
                          //                   effect: WormEffect(
                          //                       spacing: 10,
                          //                       dotWidth: 5,
                          //                       dotHeight: 5,
                          //                       dotColor:
                          //                           ColorUtils.white.withOpacity(0.5),
                          //                       activeDotColor: ColorUtils.white),
                          //                   axisDirection: Axis.horizontal,
                          //                   onDotClicked: (index) {}),
                          //             ),
                          //           ),
                          //
                          //           // Align(
                          //           //   child: Container(
                          //           //     child:  CirclePageIndicator(
                          //           //       size: 5.0,
                          //           //       selectedSize: 7.0,
                          //           //       itemCount: 5,
                          //           //       dotColor: ColorUtils.white.withOpacity(0.5),
                          //           //       selectedDotColor: ColorUtils.white,
                          //           //       dotSpacing: 3.w,
                          //           //       currentPageNotifier: currentPageNotifier,
                          //           //     ),
                          //           //   ),
                          //           // )
                          //         ],
                          //       )),
                          // ),
                          //SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.name!,
                                    style: TextStyle(
                                      color: ColorUtils.black,
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 2.6.t,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: ()async{
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
                                    await  model.UserMatches(context,widget.id!,widget.user,img: widget.images);
                                    widget.user.is_follow = 1;
                                    model.navigateBack();
                                    model.navigateBack();
                                    model.notifyListeners();
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
                                            child:  widget.user.is_follow == null?

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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_pin,
                                        color: ColorUtils.text_dark),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.address!,
                                            style: TextStyle(
                                              color: ColorUtils.text_dark,
                                              fontFamily: FontUtils.modernistRegular,
                                              fontSize: 1.8.t,
                                            ),
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Text(
                                            widget.distance.toString() + " km",
                                            style: TextStyle(
                                              color: ColorUtils.text_dark,
                                              fontFamily: FontUtils.modernistRegular,
                                              fontSize: 1.8.t,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                if (widget.drinking_motivation!=null)Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.w,right: 2.w),
                                      child: SvgPicture.asset(
                                        ImageUtils.bottleSelected,
                                        height: 3.5.h,
                                      ),
                                    ),
                                    SizedBox(width: 0.5.w),
                                    Text(
                                      widget.drinking_motivation!=null?"${widget.drinking_motivation![1]} ":"",
                                      style: TextStyle(
                                        color: ColorUtils.text_dark,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.8.t,
                                      ),
                                    ),
                                    SizedBox(width: 0.5.w),
                                    Text(
                                      widget.drinking_motivation!=null?"${widget.drinking_motivation![0]}":"",
                                      style: TextStyle(
                                        color: ColorUtils.text_dark,
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 1.8.t,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          Divider(
                            color: ColorUtils.divider,
                            thickness: 1,
                          ),

                          ///-------Favorite Alcoholic Drink------------------////
                          SizedBox(height: 2.5.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Text(
                              "Lieblingsalkoholisches Getränk",
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.5.t,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Wrap(
                          //   spacing: 2.5.w,
                          //   runSpacing: 1.5.h,
                          //   direction: Axis.horizontal,
                          //   children: model.userModel!.favorite_alcohol_drinks!
                          //       .map((element) => ElevatedButton(
                          //     onPressed: () {
                          //       // if(model.selectedDrinkList.contains(element.id)){
                          //       //   model.selectedDrinkList.remove(element.id);
                          //       // }
                          //       // else{
                          //       //   // if(element == "Radler"){
                          //       //   //   showDialog(
                          //       //   //       context: context,
                          //       //   //       builder: (BuildContext context){
                          //       //   //         return RadlerDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                          //       //   //       }
                          //       //   //   );
                          //       //   // }
                          //       //   model.selectedDrinkList.add(element.id);
                          //       // }
                          //       // model.notifyListeners();
                          //     },
                          //     child: Text((model.drinkList.where((drink)
                          //     => drink.id==element).first as FavoritesModel).name ?? ""),
                          //     style: ElevatedButton.styleFrom(
                          //       primary:   ColorUtils.red_color,
                          //       onPrimary:  ColorUtils.white,
                          //       padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 9.w),
                          //       elevation:  5 ,
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                          //           side: BorderSide(
                          //               color:  ColorUtils.text_red,
                          //               width: 1
                          //           )
                          //       ),
                          //       textStyle: TextStyle(
                          //         //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                          //         fontFamily:FontUtils.modernistBold ,
                          //         fontSize: 1.8.t,
                          //         //height: 0
                          //       ),
                          //     ),
                          //   )).toList(),
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: widget.alcoholDrink
                                  .map((element) => ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                    "${(model.drinkList.where((drink)
                                    => element==drink.id).first as FavoritesModel).name}"),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.white,
                                  onPrimary: ColorUtils.text_red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.8.h, horizontal: 5.w),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.roundCorner),
                                      side: BorderSide(
                                          color: ColorUtils.text_red,
                                          width: 1)),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily:
                                    FontUtils.modernistRegular,
                                    fontSize: 1.7.t,
                                    //height: 0
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                          ),

                          ///-----------Favorite Night Club---------------------///
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Text(
                              "Leiblingsmusik",
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.5.t,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: widget.nightClub
                                  .map((element) => ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                    "${(model.clubList.where((drink)
                                    => element==drink.id).first as FavoritesModel).name}"),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.white,
                                  onPrimary: ColorUtils.text_red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.8.h, horizontal: 5.w),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.roundCorner),
                                      side: BorderSide(
                                          color: ColorUtils.text_red,
                                          width: 1)),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily:
                                    FontUtils.modernistRegular,
                                    fontSize: 1.7.t,
                                    //height: 0
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                          ),

                          ///---------------Favorite Party Vacation --------------///
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Text(
                              "Lieblingsurlaub",
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.5.t,
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding),
                            child: Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: widget.partyVacation
                                  .map((element) => ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                    "${(model.vacationList.where((drink)
                                    => element==drink.id).first as FavoritesModel).name}"),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.white,
                                  onPrimary: ColorUtils.text_red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.8.h, horizontal: 5.w),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.roundCorner),
                                      side: BorderSide(
                                          color: ColorUtils.text_red,
                                          width: 1)),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily:
                                    FontUtils.modernistRegular,
                                    fontSize: 1.7.t,
                                    //height: 0
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                          ),

                          ///-------- Like & Dislike ---------///
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  model.navigateBack();
                                  model.catalogImages.remove(widget.images);

                                  model.notifyListeners();
                                },
                                child: SvgPicture.asset(ImageUtils.dislikeIcon),
                                style: ElevatedButton.styleFrom(
                                  shadowColor: ColorUtils.red_color,
                                  primary: ColorUtils.red_color.withOpacity(0.9),
                                  onPrimary: ColorUtils.white,
                                  //padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding),
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                    //side: BorderSide(color: ColorUtils.divider, width: 1)
                                  ),
                                  textStyle: TextStyle(
                                    color: ColorUtils.white,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  controller.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                                },
                                child: SvgPicture.asset(ImageUtils.repeatIcon),
                                backgroundColor: ColorUtils.white,
                              ),
                              ElevatedButton(
                                onPressed: ()async {
                                  if(model.userMatchLoader){

                                  }else{
                                    await  model.UserMatches(context,widget.id!,widget.user,img: widget.images);
                                    //model.navigateToMatchScreen();
                                  }
                                },
                                child: SvgPicture.asset(ImageUtils.likeIcon),
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.green,
                                  primary: Colors.green.withOpacity(0.9),
                                  onPrimary: ColorUtils.white,
                                  //padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding),
                                  padding: EdgeInsets.symmetric(horizontal: 0),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                    //side: BorderSide(color: ColorUtils.divider, width: 1)
                                  ),
                                  textStyle: TextStyle(
                                    color: ColorUtils.white,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }
}
