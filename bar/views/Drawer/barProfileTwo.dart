import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/dimen.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/listOfFollowing_Bars.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/back_arrow_with_container.dart';
import 'package:sauftrag/widgets/rating_dialog_box.dart';
import 'package:stacked/stacked.dart';

import '../../../models/get_comments_bar.dart';
import '../../../services/admin_service.dart';
import '../../../utils/dialog_utils.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/loader_black.dart';

class Barprofiletwo extends StatefulWidget {

  //int? index;

  Barprofiletwo({Key? key}) : super(key: key);

  @override
  _BarprofiletwoState createState() => _BarprofiletwoState();
}

class _BarprofiletwoState extends State<Barprofiletwo> with SingleTickerProviderStateMixin{
  TabController? tabController;
  int currentIndex = 0;
  String dropdownValue = 'Status';
  List people = [
    {
      'name': "Nellie Mendez",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.Nil,
    },
    {
      'name': "Ron Wright",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.ron
    },
    {
      'name': "Nellie Mendez",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.Nil,
    },
    {
      'name': "Ron Wright",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.ron
    }
  ];

  List ratingDialog = [
    {
      'name': "Nick Walker",
      'date': "10 December, 2020",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.ron,
    },
    {
      'name': "Nick Walker",
      'date': "10 December, 2020",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.ron
    },
    {
      'name': "Nick Walker",
      'date': "10 December, 2020",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.ron,
    },
    {
      'name': "Nick Walker",
      'date': "10 December, 2020",
      'detail':
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.",
      'image': ImageUtils.ron
    }
  ];

  List places = [
    {
      'image': ImageUtils.place1,
      'eventName': 'Trivia Nights',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
      'locationIcon': ImageUtils.locationPin
    },
    {
      'image': ImageUtils.place2,
      'eventName': 'Bar Crawl Stop',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
      'locationIcon': ImageUtils.locationPin
    },
    {
      'image': ImageUtils.place3,
      'eventName': 'Singles Night',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
      'locationIcon': ImageUtils.locationPin
    },
    {
      'image': ImageUtils.place4,
      'eventName': 'Bar Olympics',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
      'locationIcon': ImageUtils.locationPin
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
        onModelReady: (model) {
          tabController = TabController(length: 3,vsync: this);
          //model.selectedBar = model.listOfBar[index];
          model.getEvent(context);
          //model.rating();
        },
        viewModelBuilder: () => locator<MainViewModel>(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(children: [
                Container(
                  height: 44.h,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        if(model.selectedBar!.catalogue_image1 != null)
                          Container(
                              width: 370.w,
                              height: 35.h,
                              child: Image.network(model.selectedBar!.catalogue_image1! /*?? "Not Found"*/,
                                fit: BoxFit.fill,
                              )),
                        Positioned(
                            top: 5.h,
                            left: 5.w,
                            child: Container(
                                width: 10.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: BackArrowContainer())),
                        Positioned(
                            top: 30.h,
                            left: 3.w,
                            child: Container(
                                width: 16.w,
                                height: 7.5.h,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: ColorUtils.white),
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                    child: Image.network(model.selectedBar!.profile_picture!,fit: BoxFit.fill,
                                    ))))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.horizontalPadding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                model.selectedBar!.bar_name!,
                                style: TextStyle(
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //
                              //
                              //     // if(!model.isFollowBar) {
                              //     //   model.postBarFollow();
                              //     //   //model.getListOfAllBars();
                              //     // }
                              //   },
                              //   child: Container(
                              //     height: 4.5.h,
                              //     decoration: BoxDecoration(
                              //         color: ColorUtils.red_color,
                              //         borderRadius: BorderRadius.circular(18)),
                              //     child: Padding(
                              //       padding:
                              //       EdgeInsets.symmetric(horizontal: 30),
                              //       child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children:[
                              //
                              //           // Text(
                              //           //   "Accept",
                              //           //   style: TextStyle(
                              //           //       color: ColorUtils.white,
                              //           //       fontSize: 2.t,
                              //           //       fontFamily: FontUtils.modernistBold),
                              //           // ),
                              //           //
                              //           // Icon(
                              //           //   Icons.keyboard_arrow_right_rounded,
                              //           //   size: 25,
                              //           //   color: Colors.black,
                              //           // )
                              //            DropdownButton<String>(
                              //             value: dropdownValue,
                              //            alignment: Alignment.center,
                              //
                              //            icon: Icon(
                              //              Icons.keyboard_arrow_down,
                              //              size: 25,
                              //              color: Colors.white,
                              //            ),
                              //            onChanged: (String? newValue) {
                              //              setState(() {
                              //                dropdownValue = newValue!;
                              //              });
                              //            },
                              //               items:  <String>
                              //               ['Status', 'Accepted', 'Rejected']
                              //            .map<DropdownMenuItem<String>>((String value) {
                              //            return DropdownMenuItem<String>(
                              //
                              //             value: value,
                              //
                              //              child: Text(value,
                              //                style: TextStyle(
                              //                      color: ColorUtils.black,
                              //                      fontSize: 2.t,
                              //                      fontFamily: FontUtils.modernistBold),
                              //              ),
                              //              );
                              //                }
                              //                ).toList(),
                              //
                              //           )]),
                              //     ),
                              //   ),
                              // )

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
                                  var request = await AdminService().changeUserStatus(model.selectedBar!.id.toString(), model.selectedBar!.is_active!=null?!model.selectedBar!.is_active!:true);
                                  if (request is String){
                                    await DialogUtils().showDialog(MyErrorWidget(
                                        error: request));
                                  }
                                  else{
                                    if (request){
                                      model.listOfAllBarsRequest.remove(model.selectedBar);
                                      model.selectedBar!.is_active = request;
                                      if (model.listOfAllBars.isNotEmpty){
                                        model.listOfAllBars.insert(0,model.selectedBar!);
                                      }
                                      else {
                                        model.listOfAllBars.add(model.selectedBar!);
                                      }
                                      model.navigateBack();
                                    }
                                  }
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
                                          child: model.selectedBar!.is_active !=null && model.selectedBar!.is_active!?

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
                                            "De-activate",
                                            style: TextStyle(
                                                color: ColorUtils.white,
                                                fontSize: 2.t,
                                                fontFamily: FontUtils.modernistBold),
                                          ):
                                          // model.matchedUser!.is_follow!?
                                          Text(
                                            "Activate",
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
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  /*if(model.selectedBar!.is_follow!)
                                  Text(
                                    (model.selectedBar!.total_followers! + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 2.5.t,
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistBold),
                                  ),*/
                                  Text(
                                    model.selectedBar!.total_followers!.toString(),
                                    style: TextStyle(
                                        fontSize: 2.5.t,
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistBold),
                                  ),
                                  SizedBox(
                                    height: 0.8.h,
                                  ),
                                  Text(
                                    "Followers",
                                    style: TextStyle(fontSize: 1.7.t),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6.h,
                                child: VerticalDivider(
                                  color: Colors.grey[400],
                                ),
                              ),
                              // Column(
                              //   children: [
                              //     Text(
                              //       "50",
                              //       style: TextStyle(
                              //           fontSize: 2.5.t,
                              //           color: ColorUtils.red_color,
                              //           fontFamily: FontUtils.modernistBold),
                              //     ),
                              //     SizedBox(
                              //       height: 1.5.h,
                              //     ),
                              //     Text(
                              //       "Following",
                              //       style: TextStyle(fontSize: 1.7.t),
                              //     )
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 6.h,
                              //   child: VerticalDivider(
                              //     color: Colors.grey[300],
                              //   ),
                              // ),
                              Column(
                                children: [
                                  Text(
                                    model.selectedBar!.total_posts!.toString(),
                                    style: TextStyle(
                                        fontSize: 2.5.t,
                                        color: ColorUtils.red_color,
                                        fontFamily: FontUtils.modernistBold),
                                  ),
                                  SizedBox(
                                    height: 0.8.h,
                                  ),
                                  Text(
                                    "Posts",
                                    style: TextStyle(fontSize: 1.7.t),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              model.selectedBar!.about!,
                              style: TextStyle(
                                  fontFamily: FontUtils.modernistRegular,
                                  fontSize: 1.8.t),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          TabBar(
                            controller: tabController,
                            indicatorColor: ColorUtils.text_red,
                            labelColor: ColorUtils.text_red,
                            labelStyle: TextStyle(
                              fontFamily: FontUtils.modernistBold,
                              fontSize: 1.8.t,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontFamily: FontUtils.modernistRegular,
                              fontSize: 1.8.t,
                            ),
                            onTap: (index){
                              if (index==2){
                                tabController!.animateTo(currentIndex);
                              }
                              else {
                                currentIndex = index;
                              }
                            },
                            unselectedLabelColor: ColorUtils.icon_color,
                            tabs: [
                              Tab(
                                text: "News Feed",
                              ),
                              Tab(
                                text: "Ratings",
                              ),
                              Tab(
                                text: "Events",
                              ),
                            ],
                          ),
                          Container(
                            height: 32.h,
                            //padding: EdgeInsets.only(bottom: 5.h),
                            child: TabBarView(
                                controller: tabController,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  ///----New Feed Tab----///
                                  Container(
                                    child: ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.zero,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: model.selectedBar!.posts!.length,
                                      itemBuilder: (context, index) {
                                        return NewsFeedItem(index: index,);
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: SizeConfig.heightMultiplier * 1.5,
                                        );
                                      },
                                    ),
                                  ),

                                  ///----Rating Tab----///
                                  Container(
                                    margin: EdgeInsets.only(top: 1.h),
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 2.5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Customer Rating",
                                                style: TextStyle(
                                                    fontFamily:
                                                    FontUtils.modernistBold,
                                                    fontSize: 2.2.t),
                                              ),
                                              if (model.userModel!=null)GestureDetector(
                                                  onTap: () {
                                                    model.barGiveRating.clear();
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return RatingDialogBox(
                                                              title:
                                                              "Add New Location",
                                                              btnTxt:
                                                              "Add Location",
                                                              icon: ImageUtils
                                                                  .addLocationIcon);
                                                        });
                                                  },
                                                  child:
                                                  model.selectedBar!.is_rate == true ?
                                                  Text("") : Text(
                                                    "Give Rating",
                                                    style: TextStyle(
                                                      color: ColorUtils.red_color,
                                                      fontFamily: FontUtils
                                                          .modernistRegular,
                                                      fontSize: 1.7.t,
                                                      decoration:
                                                      TextDecoration.underline,
                                                    ),
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2.5.h,
                                          ),
                                          Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.5.h,
                                                  horizontal: 3.w),
                                              decoration: BoxDecoration(
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: ColorUtils.black.withOpacity(0.1),
                                                //     spreadRadius: 0,
                                                //     blurRadius: 10,
                                                //     offset: Offset(0, 5), // changes position of shadow
                                                //   ),
                                                // ],
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(18)),
                                                border: Border.all(
                                                    color: ColorUtils.text_red),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  RatingBar.builder(
                                                    ignoreGestures: true,
                                                    initialRating: model.selectedBar!.total_ratings ?? 0.0,
                                                    // initialRating: model
                                                    //         .ratingKaData!
                                                    //         .total_rating ??
                                                    //     0,
                                                    minRating: 0,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 10.i,
                                                    itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 3.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                          Icons.star_rounded,
                                                          color: ColorUtils.red_color,
                                                        ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                  Text(
                                                    "${model.selectedBar!.total_ratings/*.toString().substring(0,5)*/ } out of 5",
                                                    style: TextStyle(
                                                      color: ColorUtils.red_color,
                                                      fontFamily: FontUtils
                                                          .modernistRegular,
                                                      fontSize: 1.7.t,
                                                    ),
                                                  )
                                                ],
                                              )),
                                          SizedBox(
                                            height: 2.5.h,
                                          ),
                                          Container(
                                            //height: 50.h,
                                            child: ListView.separated(
                                              padding: EdgeInsets.zero,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                              model.selectedBar!.ratings!.length,
                                              itemBuilder: (context, index) {
                                                dynamic time = model.selectedBar!.ratings![index].created_at!.substring(11,16);
                                                time = time.toString().split(':00');
                                                return Container(

                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.5.h,
                                                      horizontal: 2.5.w),
                                                  //width: 6.h,
                                                  //height: 30.h,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: ColorUtils.black
                                                            .withOpacity(0.1),
                                                        spreadRadius: 0,
                                                        blurRadius: 10,
                                                        offset: Offset(0,
                                                            5), // changes position of shadow
                                                      ),
                                                    ],
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(18)),
                                                    //border: Border.all(color: ColorUtils.red_color),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Image.network(
                                                                model.selectedBar!.ratings![index].user!.profile_picture!,
                                                                // model
                                                                //     .ratingKaData!
                                                                //     .data![index]
                                                                //     .user!
                                                                //     .profile_picture
                                                                //     .toString(),
                                                                height: 10.i,
                                                              ),
                                                              SizedBox(
                                                                width: 4.w,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    model.selectedBar!.ratings![index].user!.username!.toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 2.h,
                                                                      fontFamily:
                                                                      FontUtils
                                                                          .modernistBold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 0.5.h,
                                                                  ),
                                                                  Text(
                                                                    model.selectedBar!.ratings![index].created_at!.substring(0,10)  +' , '+time[0],
                                                                    style: TextStyle(
                                                                        color: ColorUtils
                                                                            .text_grey,
                                                                        fontFamily:
                                                                        FontUtils
                                                                            .modernistRegular,
                                                                        fontSize:
                                                                        1.3.h),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          RatingBar.builder(
                                                            ignoreGestures: true,
                                                            initialRating: model.selectedBar!.ratings![index].rate ?? 0.0,
                                                            minRating: 1,
                                                            direction:
                                                            Axis.horizontal,
                                                            allowHalfRating: true,
                                                            itemCount: 5,
                                                            itemSize: 4.5.i,
                                                            itemPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 3.0),
                                                            itemBuilder:
                                                                (context, _) => Icon(
                                                              Icons.star_rounded,
                                                              color: ColorUtils
                                                                  .red_color,
                                                            ),
                                                            onRatingUpdate: (rating) {
                                                              print(rating);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2.h),
                                                      Text(
                                                        model.selectedBar!.ratings![index].comments!,
                                                        style: TextStyle(
                                                            fontFamily: FontUtils
                                                                .modernistRegular,
                                                            fontSize: 1.7.t),
                                                      ),
                                                      Divider(
                                                        height: 2.5.h,
                                                      ),
                                                      // Row(
                                                      //   children: [
                                                      //     Image.asset(
                                                      //       ImageUtils.comment,
                                                      //       scale: 5,
                                                      //     ),
                                                      //     SizedBox(
                                                      //       width: 2.w,
                                                      //     ),
                                                      //     Text(
                                                      //       "68",
                                                      //       style: TextStyle(
                                                      //           color: Colors.grey[400],
                                                      //           fontFamily: FontUtils
                                                      //               .modernistRegular),
                                                      //     ),
                                                      //     SizedBox(
                                                      //       width: 8.w,
                                                      //     ),
                                                      //     Image.asset(
                                                      //       ImageUtils.like,
                                                      //       scale: 5,
                                                      //     ),
                                                      //     SizedBox(
                                                      //       width: 2.w,
                                                      //     ),
                                                      //     Text(
                                                      //       "53.5 k",
                                                      //       style: TextStyle(
                                                      //           color: Colors.grey[400],
                                                      //           fontFamily: FontUtils
                                                      //               .modernistRegular),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              separatorBuilder: (context, index) {
                                                return SizedBox(
                                                  height:
                                                  SizeConfig.heightMultiplier *
                                                      1.5,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 2.5.h),
                                          // Container(
                                          //   //width: 200.0,
                                          //   padding:
                                          //       EdgeInsets.symmetric(horizontal: 2.w),
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.white,
                                          //       borderRadius: BorderRadius.all(
                                          //         Radius.circular(15.0),
                                          //       ),
                                          //       border: Border.all(
                                          //           color: ColorUtils.icon_color)),
                                          //   child: TextField(
                                          //     onTap: () {},
                                          //     enabled: true,
                                          //     //readOnly: true,
                                          //     //focusNode: model.searchFocus,
                                          //     //controller: model.groupScreenChatController,
                                          //     decoration: InputDecoration(
                                          //       hintText: "Write your comment",
                                          //       hintStyle: TextStyle(
                                          //         //fontFamily: FontUtils.proximaNovaRegular,
                                          //         color: ColorUtils.icon_color,
                                          //         fontSize:
                                          //             SizeConfig.textMultiplier * 1.9,
                                          //       ),
                                          //       border: InputBorder.none,
                                          //       isDense: true,
                                          //       contentPadding: EdgeInsets.symmetric(
                                          //           vertical:
                                          //               SizeConfig.heightMultiplier *
                                          //                   1.8),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///----Event Tab----///
                                  Container(
                                    margin: EdgeInsets.only(top: 3.h),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        dynamic time = model.selectedBar!.events![index].startTime;
                                        time = time.toString().split(':00');
                                        return Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorUtils.black
                                                    .withOpacity(0.1),
                                                spreadRadius: 0,
                                                blurRadius: 10,
                                                offset: Offset(0,
                                                    5), // changes position of shadow
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18)),
                                            border: Border.all(
                                                color: ColorUtils.red_color),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w, vertical: 2.h),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      child: Image.network(
                                                        model.selectedBar!.events![index].media?[0].media,
                                                        width: 20.i,
                                                        height: 20.i,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          model.selectedBar!.events![index].eventDate +' , '+time[0],
                                                          style: TextStyle(
                                                              fontFamily: FontUtils
                                                                  .modernistRegular,
                                                              fontSize: 1.7.t,
                                                              color: ColorUtils
                                                                  .text_red),
                                                        ),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        Text(
                                                          model.selectedBar!.events![index].name,
                                                          style: TextStyle(
                                                              fontFamily: FontUtils
                                                                  .modernistBold,
                                                              fontSize: 2.2.t,
                                                              color:
                                                              ColorUtils.black),
                                                        ),
                                                        SizedBox(
                                                          height: 1.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(places[
                                                            index]
                                                            ['locationIcon']),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            Text(
                                                              model.selectedBar!.events![index].location,
                                                              style: TextStyle(
                                                                  fontFamily: FontUtils
                                                                      .modernistRegular,
                                                                  fontSize: 1.7.t,
                                                                  color: ColorUtils
                                                                      .text_dark),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: SizeConfig.heightMultiplier * 2,
                                        );
                                      },
                                      itemCount: model.selectedBar!.events!.length,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }
}


class NewsFeedItem extends StatefulWidget {
  int? index;
  NewsFeedItem({Key? key,this.index}) : super(key: key);

  @override
  _NewsFeedItemState createState() => _NewsFeedItemState();
}

class _NewsFeedItemState extends State<NewsFeedItem> {
  final expandableController = ExpandableController();
  List<GetNewsfeedCommentsBar> comments = [];
  int comments_count = 0;
  bool isLoadingComments = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=>locator<MainViewModel>(),
      builder: (context,model,child){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          padding: EdgeInsets.symmetric(
              vertical: 1.5.h,
              horizontal: 2.w),
          //width: 6.h,
          //height: 30.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ColorUtils.black
                    .withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0,
                    5), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(18)),
            //border: Border.all(color: ColorUtils.red_color),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Image.network(
                        model.selectedBar!.posts![widget.index!].user_id!.profile_picture!,
                        height: 10.i,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.selectedBar!.posts![widget.index!].user_id!.bar_name!,
                            style: TextStyle(
                                fontFamily: FontUtils
                                    .modernistBold),
                          ),
                          SizedBox(height: 0.5.h,),
                          Container(
                            width: 50.w,
                            child: Text(
                              model.selectedBar!.posts![widget.index!].user_id!.address!,
                              style: TextStyle(
                                  fontSize: 1.5.t,
                                  fontFamily: FontUtils
                                      .modernistRegular),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis ,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                model.selectedBar!.posts![widget.index!].post_content!,
                style: TextStyle(
                    fontFamily:
                    FontUtils.modernistRegular,
                    fontSize: 1.7.t),
              ),
              SizedBox(
                height: 1.h,
              ),
              if (model.selectedBar!.posts![widget.index!]
                  .media !=
                  null &&
                  model.selectedBar!.posts![widget.index!].media!
                      .length >
                      0)
                Container(
                    child:
                    CachedNetworkImage(
                      imageUrl: model.selectedBar!
                          .posts![widget.index!]
                          .media![0]
                          .media!,
                      //width: 100.i,
                      height: 40.i,
                      fit: BoxFit.cover,
                    )),
              Divider(
                height: 2.5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: ExpandableTheme(
                      data: ExpandableThemeData(

                          headerAlignment:
                          ExpandablePanelHeaderAlignment.top,
                          alignment:
                          Alignment.centerLeft,
                          iconPadding:
                          EdgeInsets.zero,
                          iconSize: 0,
                          tapHeaderToExpand: false
                      ),
                      child: ExpandablePanel(

                        controller: expandableController,
                        header: Container(
                          padding: EdgeInsets.only(top: 0.7.h),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: (){

                                  if(!model.isLikeNewsFeed) {
                                    model.selectedPost = model.selectedBar!.posts![widget.index!];
                                    model.postLikeNewsFeedProfile(widget.index!);
                                  }
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        ImageUtils.matchedIcon,
                                        color:
                                        model.selectedBar!.posts![widget.index!].is_like != null ? model.selectedBar!.posts![widget.index!].is_like! ? ColorUtils.red_color : ColorUtils.icon_color : ColorUtils.icon_color
                                    ),
                                    SizedBox(
                                      width: 1.5.w,
                                    ),
                                    Text(
                                      model.selectedBar!.posts![widget.index!].likes_count.toString(),
                                      style: TextStyle(
                                          fontFamily: FontUtils
                                              .modernistRegular,
                                          fontSize: 1.5.t,
                                          color:
                                          model.selectedBar!.posts![widget.index!].is_like != null ? model.selectedBar!.posts![widget.index!].is_like! ? ColorUtils.red_color : ColorUtils.icon_color: ColorUtils.icon_color ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 7.w),
                              GestureDetector(
                                onTap: () async {
                                  if (!expandableController.expanded){
                                    model.selectedCommentId = model.selectedBar!.posts![widget.index!].id!;
                                    isLoadingComments = true;
                                    model.notifyListeners();
                                    comments = await model.gettingCommentsBars();
                                    isLoadingComments = false;
                                    expandableController.toggle();
                                    model.notifyListeners();
                                  }
                                  else {
                                    expandableController.toggle();
                                    model.notifyListeners();
                                  }
                                },
                                child:isLoadingComments
                                    ?
                                LoaderBlack()
                                    : Row(
                                  children: [
                                    SvgPicture.asset(
                                      ImageUtils.msgIcon,
                                      color: ColorUtils
                                          .icon_color,
                                    ),
                                    SizedBox(
                                      width: 1.5.w,
                                    ),
                                    Text(
                                      model.selectedBar!.posts![widget.index!]
                                          .comments_count
                                          .toString(),
                                      //comments_count.toString(),
                                      style: TextStyle(
                                          fontFamily:
                                          FontUtils
                                              .modernistRegular,
                                          fontSize: 1.5.t,
                                          color: ColorUtils
                                              .icon_color),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        collapsed: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape
                                  .rectangle,
                              borderRadius:
                              BorderRadius
                                  .all(Radius
                                  .circular(
                                  10)),
                              color:
                              Colors.black),
                          child: Container(),
                        ),
                        expanded:

                        Column(
                          children: [
                            Container(
                              //height: 10.h,
                              // margin: EdgeInsets.only(top: 1.5.h),

                              width: double.maxFinite,
                              //height: 40.h,
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics:
                                NeverScrollableScrollPhysics(),
                                controller: model.chatScroll,
                                itemBuilder: (context, index) {
                                  return Align(
                                    //alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius
                                              .circular(30),
                                          child: Image.network(
                                            comments[
                                            index]
                                                .user_id!
                                                .profile_picture!,
                                            width: 10.i,
                                            height: 10.i,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              comments[
                                              index]
                                                  .user_id!
                                                  .username!,
                                              //model.userModel!.username!,
                                              style: TextStyle(
                                                  fontFamily:
                                                  FontUtils
                                                      .modernistBold,
                                                  fontSize: 1.8.t,
                                                  color: ColorUtils
                                                      .text_dark),
                                            ),
                                            SizedBox(
                                              height: 1.h,
                                            ),
                                            Container(
                                              width: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width /
                                                  1.7,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape
                                                      .rectangle,
                                                  borderRadius: BorderRadius
                                                      .all(Radius
                                                      .circular(
                                                      10)),
                                                  color: ColorUtils
                                                      .icon_color
                                                      .withOpacity(
                                                      0.2)),
                                              padding: EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  2.w,
                                                  vertical:
                                                  1.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  // Padding(
                                                  //   padding: EdgeInsets.symmetric(
                                                  //       horizontal: 3.w,
                                                  //       vertical: 1.5.h),
                                                  //   child: Image.asset(
                                                  //     ImageUtils.drinkImage,
                                                  //   ),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .only(
                                                      left: 3.w,
                                                      right: 3.w,
                                                    ),
                                                    child: Text(
                                                      comments[
                                                      index]
                                                          .text!,
                                                      style: TextStyle(
                                                        //fontFamily: FontUtils.avertaDemoRegular,
                                                          fontSize: 1.8.t,
                                                          color: ColorUtils.text_dark),
                                                    ),
                                                  ),

                                                  //SizedBox(height: 1.h,),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          //alignment:  Alignment.bottomRight,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(
                                                top: 0.0,
                                                left: 0.w),
                                            child: Text(
                                              comments[
                                              index]
                                                  .created_at!
                                                  .substring(
                                                  11, 16),
                                              //comments[index]["time"].toString().substring(11,16),
                                              style: TextStyle(
                                                //fontFamily: FontUtils.avertaDemoRegular,
                                                  fontSize: 1.5.t,
                                                  color: ColorUtils
                                                      .icon_color),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (context, index) => SizedBox(
                                  height: 3.h,
                                ),
                                itemCount: comments.length,
                                //comments.length>2?2:comments.length
                              ),
                            ),
                            SizedBox(height: 1.5.h,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect
                                  (
                                  borderRadius: BorderRadius.circular(30),
                                  child: model.barModel!.profile_picture == null ?
                                  SvgPicture.asset(ImageUtils.logo,
                                    width: 10.i,
                                    height: 10.i,
                                    fit: BoxFit.cover,
                                  )
                                      :
                                  Image.network(model.barModel!.profile_picture!,
                                    width: 10.i,
                                    height: 10.i,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 2.w,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    // margin: EdgeInsets.only(top: 1.5.h),
                                    decoration:
                                    BoxDecoration(
                                        shape: BoxShape
                                            .rectangle,
                                        borderRadius:
                                        BorderRadius
                                            .all(Radius
                                            .circular(
                                            10)),
                                        color:
                                        ColorUtils.icon_color.withOpacity(0.2)),
                                    // padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),

                                    width: double.maxFinite,
                                    //height: 40.h,
                                    child: TextField(
                                      onTap: () {},
                                      onChanged: (value){
                                        model.notifyListeners();
                                      },
                                      // enabled: true,
                                      //readOnly: true,
                                      //focusNode: model.searchFocus,
                                      controller: model
                                          .postCommentController,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        hintText:
                                        "Type your message...",
                                        hintStyle: TextStyle(
                                          //fontFamily: FontUtils.proximaNovaRegular,
                                          //color: ColorUtils.silverColor,
                                          fontSize: SizeConfig
                                              .textMultiplier *
                                              1.8,
                                        ),
                                        border: InputBorder.none,
                                        // isDense: true,
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                            vertical: SizeConfig
                                                .heightMultiplier *
                                                2),
                                      ),
                                      keyboardType:
                                      TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                model.postCommentController.text.length <=0 ?
                                Container(
                                  //margin: EdgeInsets.only(bottom: 2.2.h),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorUtils.text_grey,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SvgPicture.asset(
                                      ImageUtils.sendIcon1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ) :
                                InkWell(
                                  onTap: () async {
                                    await model
                                        .postingCommentsBar();
                                    model
                                        .getCommentNewsFeedBarProfile(
                                        widget.index!);
                                    model
                                        .postCommentController
                                        .clear();
                                    expandableController
                                        .toggle();
                                    model.gettingCommentsBars();
                                  },
                                  child: Container(
                                    //margin: EdgeInsets.only(bottom: 2.2.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorUtils.text_red,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SvgPicture.asset(
                                        ImageUtils.sendIcon1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
      disposeViewModel: false,
    );
  }
}

// class ViewZoomedImage extends StatefulWidget {
//   final int? index;
//   const ViewZoomedImage({Key? key,this.index}):super(key:key);
//   @override
//   _ViewZoomedImageState createState() => _ViewZoomedImageState();
// }
//
// class _ViewZoomedImageState extends State<ViewZoomedImage> {
//   PageController pageController = PageController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<MainViewModel>.reactive(
//       builder: (context, model, child) {
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     model.navigateBack();
//                   },
//                   child: Container(
//                     margin: EdgeInsets.only(
//                         left: 1.7.w, top: 3.h),
//                     padding: EdgeInsets.all(13),
//                     //height: 10.h,
//                     decoration: BoxDecoration(
//                       color: ColorUtils.white,
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                     ),
//                     child: SvgPicture.asset(ImageUtils.backArrow),
//                     height: 10.i,
//                   ),
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Container(
//                       width: double.infinity,
//                       child: PhotoViewGallery.builder(
//                         itemCount: model.matchedImage.length,
//                         pageController: pageController,
//                         builder: (context, index) {
//                           return  PhotoViewGalleryPageOptions(
//                             imageProvider: NetworkImage(model.matchedImage[index]),
//                             initialScale: PhotoViewComputedScale.contained * 1,
//                             //heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       viewModelBuilder: () => locator<MainViewModel>(),
//       onModelReady: (model){
//         Future.delayed(Duration(milliseconds: 100)).then((value)async{
//           pageController.jumpToPage(widget.index!);
//         });
//       },
//       disposeViewModel: false,
//     );
//   }
// }

