import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/get_comments_user.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/views/NewsFeed/events.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:sauftrag/widgets/dialog_event.dart';
import 'package:sauftrag/widgets/my_side_menu.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:stacked/stacked.dart';
import 'dart:math' as math;

import '../../utils/app_localization.dart';
import '../../widgets/loader.dart';
import '../../widgets/loader_black.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  TabController? tabController;
  List newsEvents = [
    {
      'image': ImageUtils.person_1,
      'barOwnerName': 'Nellie Mendez',
      'para':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.',
      'image2': ImageUtils.feedImg,
      'imgPre': false,
      'comment': '68',
      'commentIon': ImageUtils.msgIcon,
      'likes': '53.5 k',
      'likesIcon': ImageUtils.matchedIcon,
    },
    {
      'image': ImageUtils.person_2,
      'barOwnerName': 'Ron Wright',
      'para':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.',
      'image2': ImageUtils.feedImg,
      'imgPre': true,
      'commentIon': ImageUtils.msgIcon,
      'comment': '68',
      'likesIcon': ImageUtils.matchedIcon,
      'likes': '53.5 k',
    },
    {
      'image': ImageUtils.person_1,
      'barOwnerName': 'Nellie Mendez',
      'para':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer pulvinar blandit magna.',
      'image2': ImageUtils.feedImg,
      'imgPre': false,
      'commentIon': ImageUtils.msgIcon,
      'comment': '68',
      'likesIcon': ImageUtils.matchedIcon,
      'likes': '53.5 k',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) {
        model.getNotification(context);

        //model.gettingComments();
        tabController = TabController(length: 2, vsync: this);
        //model.userNewsFeed = true;
        // model.getEvent(context);
      },
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: ()async{
            print('back');
            // FocusScope.of(context).requestFocus(FocusNode());
            return true;


          },
          child:
          SideMenu(
            key: model.sideMenuKey,
            closeIcon: Icon(
              Icons.remove,
              color: Colors.transparent,
            ),
            type: SideMenuType.shrinkNSlide,
            background: ColorUtils.text_red,
            radius: BorderRadius.circular(30),
            menu:
            MySideMenu(),
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                context.unFocus();
                model.openGroupMenu = false;
                model.notifyListeners();
              },
              child: DefaultTabController(
                length: 2,
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: GestureDetector(
                    onTap: () {
                      final _state = model.sideMenuKey.currentState;
                      if (_state!.isOpened)
                        _state.closeSideMenu(); // close side menu
                    },
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      floatingActionButton: Visibility(
                        visible: model.tap,
                      child: FloatingActionButton(
                        onPressed: (){
                          model.navigateToUserPostScreen();
                        },
                        backgroundColor: ColorUtils.red_color,
                        child: SvgPicture.asset(
                                  ImageUtils.pen2,
                                ),
                      ),
                      ),

                        // child: Column(
                        //   children: [
                        //     // GestureDetector(
                        //     //   onTap: () {
                        //     //     //model.navigateToCreateEventScreen();
                        //     //     showDialog(s
                        //     //         context: context,
                        //     //         builder: (BuildContext context) {
                        //     //           return DialogEvent(
                        //     //               title: "Add New Location",
                        //     //               btnTxt: "Add Location",
                        //     //               icon: ImageUtils.addLocationIcon);
                        //     //         });
                        //     //   },
                        //     //   child: Container(
                        //     //       decoration: BoxDecoration(
                        //     //         color: ColorUtils.text_red,
                        //     //         borderRadius: BorderRadius.all(
                        //     //             Radius.circular(25)),
                        //     //         //border: Border.all(color: ColorUtils.red_color),
                        //     //       ),
                        //     //       height: 5.5.h,
                        //     //       width: 12.w,
                        //     //       child: Padding(
                        //     //         padding: const EdgeInsets.all(11.0),
                        //     //         child: SvgPicture.asset(
                        //     //           ImageUtils.calender,
                        //     //         ),
                        //     //       )),
                        //     // ),
                        //     // SizedBox(
                        //     //   height: 2.h,
                        //     // ),
                        //     // GestureDetector(
                        //     //   onTap: () {
                        //     //     model.navigateToUserPostScreen();
                        //     //   },
                        //     //   child: Container(
                        //     //       decoration: BoxDecoration(
                        //     //         color: ColorUtils.text_red,
                        //     //         borderRadius: BorderRadius.all(
                        //     //             Radius.circular(25)),
                        //     //         //border: Border.all(color: ColorUtils.red_color),
                        //     //       ),
                        //     //       height: 5.5.h,
                        //     //       width: 12.w,
                        //     //
                        //     //       child: Padding(
                        //     //         padding: const EdgeInsets.all(11.0),
                        //     //         // child: SvgPicture.asset(
                        //     //         //   ImageUtils.pen2,
                        //     //         // ),
                        //     //       )),
                        //     // ),
                        //   ],
                        // ),

                      // floatingActionButtonLocation:
                      // FloatingActionButtonLocation.endDocked,
                      body: Container(
                        padding: EdgeInsets.only(
                            //horizontal: Dimensions.horizontalPadding,
                            top: Dimensions.verticalPadding),
                        child: Column(
                          children: [
                            SizedBox(height: Dimensions.homeTopMargin),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.horizontalPadding),
                                child:
                                ElevatedButton(
                                  onPressed: () {
                                    final _state = model.sideMenuKey.currentState;
                                    if (_state!.isOpened)
                                      _state.closeSideMenu(); // close side menu
                                    else
                                      _state.openSideMenu();
                                  },
                                  child: SvgPicture.asset(ImageUtils.menuIcon),
                                  style: ElevatedButton.styleFrom(
                                    primary: ColorUtils.white,
                                    onPrimary: ColorUtils.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.containerVerticalPadding),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.divider, width: 1)),
                                    textStyle: TextStyle(
                                      color: ColorUtils.white,
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 1.8.t,
                                      //height: 0
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            TabBar(
                              indicatorColor: ColorUtils.text_red,
                              labelColor: ColorUtils.text_red,
                              labelStyle: TextStyle(
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.2.t,
                              ),
                              controller: tabController,
                              unselectedLabelStyle: TextStyle(
                                fontFamily: FontUtils.modernistRegular,
                                fontSize: 2.2.t,
                              ),
                              unselectedLabelColor: ColorUtils.icon_color,
                              tabs: [
                                Tab(
                                  text: AppLocalizations.of(
                                      context)!
                                      .translate('news_feed_text_1')!,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogEvent(
                                              title: "Add New Location",
                                              btnTxt: "Add Location",
                                              icon: ImageUtils.addLocationIcon);
                                        });
                                  },
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: Tab(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(ImageUtils.greyLock),
                                          SizedBox(
                                            width: 1.5.w,
                                          ),
                                          Text(
                                            AppLocalizations.of(
                                                context)!
                                                .translate('news_feed_text_2')!,
                                            style: TextStyle(
                                                color: ColorUtils.text_grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onTap: (value) {
                                if (value == 1) {
                                  // model.getBarPost();
                                  // model.rating();
                                  // model.getEvent(context);
                                  tabController!.animateTo(0,duration: Duration(milliseconds: 250),curve: Curves.easeIn);
                                  model.notifyListeners();
                                }
                                else{

                                }
                              },
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  // first tab bar view widget
                                  NewsFeedScreen(),
                                  Container()

                                  // second tab bar viiew widget
                                  // Events(),
                                  // Container(
                                  //   child:   showDialog(
                                  //       context: context,
                                  //       builder: (BuildContext context){
                                  //         return DialogEvent(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                  //       }
                                  //   )
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) {
        model.getBarPost();
        model.rating();
        //model.getEvent(context);
      },
      builder: (context, model, child) {
        return model.isPost == true
            ? AllPageLoader()
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.5.h),
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return UserNewsFeed(index: index);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                                // height: SizeConfig.heightMultiplier * 2.5,
                                );
                          },
                          itemCount: model.posts.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
      disposeViewModel: false,
    );
  }
}

class UserNewsFeed extends StatefulWidget {
  int? index;
  int? id;



  UserNewsFeed({Key? key, this.index, this.id}) : super(key: key);

  @override
  _UserNewsFeedState createState() => _UserNewsFeedState();
}

class _UserNewsFeedState extends State<UserNewsFeed> {
  ExpandableController expandableController = ExpandableController();
  List<GetNewsfeedComments> comments = [];
  int comments_count = 0;
  bool isLoadingComments = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) async {
        /*UserModel user =
          (await locator<PrefrencesViewModel>().getUser())!;
          var channel =
          model.pubnub!.channel(model.posts[widget.index!].id.toString());
          var chat = await channel.messages();
          await chat.fetch();
          comments_count = await chat.count();
          model.notifyListeners();*/
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 3.2.h),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 3.5.w,
                //vertical: 3.h
              ),
              child: Container(
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
                  border:
                      Border.all(color: ColorUtils.text_grey.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.5.w, vertical: 1.h),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: ()async {
                              if(!model.busy("gettingProfile")) {
                                showGeneralDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: Colors.white.withOpacity(0.6),
                                    pageBuilder: (context, animation1, animation2) {
                                      return Container(
                                        child: Center(
                                          child: RedLoader(),
                                        ),
                                      );
                                    });
                                model.setBusyForObject("gettingProfile", true);
                                if (model.posts[widget.index!].user_id!.role == 1) {
                                  model.matchedImage.clear();
                                  //model.getMatchedUserData = (model.acceptMatchedtModel[index]);
                                  if (model.posts[widget.index!].user_id!.profile_picture != null &&
                                      model.posts[widget.index!].user_id!.profile_picture!.isNotEmpty) {
                                    model.matchedImage.add(
                                        model.posts[widget.index!].user_id!.profile_picture);
                                  }
                                  if (model.posts[widget.index!].user_id!.catalogue_image1 != null &&
                                      model.posts[widget.index!].user_id!.catalogue_image1!.isNotEmpty) {
                                    model.matchedImage.add(
                                        model.posts[widget.index!].user_id!.catalogue_image1);
                                  }
                                  if (model.posts[widget.index!].user_id!.catalogue_image2 != null &&
                                      model.posts[widget.index!].user_id!.catalogue_image2!.isNotEmpty) {
                                    model.matchedImage.add(
                                        model.posts[widget.index!].user_id!.catalogue_image2);
                                  }
                                  if (model.posts[widget.index!].user_id!.catalogue_image3 != null &&
                                      model.posts[widget.index!].user_id!.catalogue_image3!.isNotEmpty) {
                                    model.matchedImage.add(
                                        model.posts[widget.index!].user_id!.catalogue_image3);
                                  }
                                  if (model.posts[widget.index!].user_id!.catalogue_image4 != null &&
                                      model.posts[widget.index!].user_id!.catalogue_image4!.isNotEmpty) {
                                    model.matchedImage.add(
                                        model.posts[widget.index!].user_id!.catalogue_image4);
                                  }
                                  if (model.posts[widget.index!].user_id!.catalogue_image5 != null &&
                                      model.posts[widget.index!].user_id!.catalogue_image5!.isNotEmpty) {
                                    model.matchedImage.add(
                                        model.posts[widget.index!].user_id!.catalogue_image5);
                                  }
                                  model.notifyListeners();

                                  await model.userGetAnotherUserInfo(
                                      model.posts[widget.index!].user_id!.id.toString());
                                  model.setBusyForObject("gettingProfile",false);
                                  model.navigateBack();
                                  model.navigateToMatchedProfileUser();
                                }
                                else {

                                  model.selectedBar = await model.userGetBarInfo(model.posts[widget.index!].user_id!.id.toString());
                                  model.setBusyForObject("gettingProfile",false);
                                  model.navigateBack();
                                  //print("yo");
                                  model.navigateToBarProfile();
                                }
                              }

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    model.posts[widget.index!].user_id!.profile_picture!,
                                    //newsEvents[index]["image"],
                                    width: 10.i,
                                    height: 10.i,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          model.posts[widget.index!].user_id!.role==1
                                              ?
                                          model.posts[widget.index!].user_id!
                                              .username!
                                              :
                                          model.posts[widget.index!].user_id!
                                              .bar_name!,
                                          //newsEvents[index]["barOwnerName"],
                                          style: TextStyle(
                                              fontFamily:
                                                  FontUtils.modernistBold,
                                              fontSize: 2.2.t,
                                              fontWeight: FontWeight.bold,
                                              color: ColorUtils.black),
                                        ),
                                        // if (model.posts[index].post_type! == '1')
                                        //   {
                                        //     Text("Abc")
                                        //   }
                                      ],
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Text(
                                      model.posts[widget.index!].post_location!,
                                      //newsEvents[index]["barOwnerName"],
                                      style: TextStyle(
                                          fontFamily:
                                              FontUtils.modernistRegular,
                                          fontSize: 1.7.t,
                                          //fontWeight: FontWeight.bold,
                                          color: ColorUtils.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  model.posts[widget.index!].post_content!,
                                  //newsEvents[index]["para"],
                                  style: TextStyle(
                                      fontFamily: FontUtils.modernistRegular,
                                      fontSize: 1.8.t,
                                      color: ColorUtils.black),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          if (model.posts[widget.index!].media != null &&
                              model.posts[widget.index!].media!.length > 0)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return DetailScreen(
                                    imageUrl: model.posts[widget.index!].media![0].media!,
                                  );
                                }));
                              },
                              child: Container(
                                  child:
                                  CachedNetworkImage(
                                imageUrl: model.posts[widget.index!].media![0].media!,
                                //width: 100.i,
                                height: 40.i,
                                fit: BoxFit.cover,
                              )),
                            ),
                          Divider(),

                          ///LIKE AND COMMENT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ExpandableTheme(
                                  data: ExpandableThemeData(
                                      headerAlignment:
                                          ExpandablePanelHeaderAlignment.top,
                                      alignment: Alignment.centerLeft,
                                      iconPadding: EdgeInsets.zero,
                                      iconSize: 0,
                                      tapHeaderToExpand: false),
                                  child: ExpandablePanel(
                                      controller: expandableController,
                                      header: Container(
                                        padding: EdgeInsets.only(top: 0.7.h),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if(!model.isLikeNewsFeed)
                                                {
                                                  model.selectedPost = model.posts[widget.index!];
                                                  model.postLikeNewsFeed(widget.index!);
                                                }
                                                //expandableController == false ;
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImageUtils.matchedIcon,
                                                    color:
                                                    model.posts[widget.index!].is_like != null ? model.posts[widget.index!].is_like! ? ColorUtils.text_red : ColorUtils.icon_color : ColorUtils.icon_color,
                                                  ),
                                                  SizedBox(
                                                    width: 1.5.w,
                                                  ),
                                                  //if(model.posts[widget.index!].likes != null)
                                                  Text(
                                                    model.posts[widget.index!].likes_count == null
                                                        ? 0.toString()
                                                        : model.posts[widget.index!].likes_count.toString(),
                                                    style: TextStyle(
                                                        fontFamily: FontUtils
                                                            .modernistRegular,
                                                        fontSize: 1.5.t,
                                                        color: model.posts[widget.index!].is_like != null ? model.posts[widget.index!].is_like! ? ColorUtils.text_red : ColorUtils.icon_color : ColorUtils.icon_color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 7.w),
                                            GestureDetector(
                                              onTap: () async {
                                                model.tap;
                                                setState(() {
                                                  if(model.tap == true){
                                                    model.tap = false;
                                                    model.notifyListeners();
                                                  }

                                                });
                                                if (!expandableController.expanded){

                                                  //
                                                  model.selectedCommentId = model
                                                      .posts[widget.index!].id!;
                                                  isLoadingComments = true;
                                                  model.notifyListeners();
                                                  comments = await model.gettingComments();
                                                  isLoadingComments = false;
                                                  expandableController.toggle();
                                                  model.notifyListeners();
                                                }
                                                else {

                                                  //
                                                  model.tap = true;
                                                  model.notifyListeners();

                                                  expandableController.toggle();
                                                  model.notifyListeners();
                                                }

                                              },
                                              child: isLoadingComments
                                                  ?
                                              LoaderBlack()
                                                  :
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImageUtils.msgIcon,
                                                    color: ColorUtils.icon_color,
                                                  ),
                                                  SizedBox(
                                                    width: 1.5.w,
                                                  ),
                                                  Text(
                                                    //model.userComments!.isEmpty ? 0.toString() : model.userComments!.length.toString(),
                                                    model.posts[widget.index!]
                                                        .comments_count
                                                        .toString(),
                                                    //comments_count.toString(),
                                                    style: TextStyle(
                                                        fontFamily: FontUtils
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
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.black),
                                        child: Container(),
                                      ),
                                      expanded:
                                          // expandableController == true ?
                                          Column(
                                        children: [
                                          Divider(),
                                          // GestureDetector(
                                          //   onTap: (){
                                          //     model.navigateToAlCommentsUserScreen();
                                          //   },
                                          //   child: Align(
                                          //     alignment:  Alignment.topRight,
                                          //     child: Padding(
                                          //       padding: EdgeInsets.only(top: 0.0, left: 1.w),
                                          //       child: Text("See All",
                                          //         style: TextStyle(
                                          //           color: ColorUtils.red_color,
                                          //           fontFamily: FontUtils
                                          //               .modernistRegular,
                                          //           fontSize: 1.7.t,
                                          //           decoration: TextDecoration
                                          //               .underline,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
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
                                                        borderRadius: BorderRadius.circular(30),
                                                        child: Image.network(
                                                          comments[index].user_id!.profile_picture!,
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
                                                            comments[index].user_id!.username!,
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
                                                                    comments[index].text!,
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
                                                            comments[index].created_at!
                                                                .substring(11, 16),
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
                                          SizedBox(
                                            height: 1.5.h,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: model.userModel!.profile_picture == null?
                                                    SvgPicture.asset(ImageUtils.logo,
                                                      width: 10.i,
                                                      height: 10.i,
                                                      fit: BoxFit.cover,
                                                    ):
                                                Image.network(
                                                  model.userModel!.profile_picture!,
                                                  width: 10.i,
                                                  height: 10.i,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 3.w),
                                                  // margin: EdgeInsets.only(top: 1.5.h),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: ColorUtils
                                                          .icon_color
                                                          .withOpacity(0.2)),
                                                  // padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),

                                                  width: double.maxFinite,
                                                  //height: 40.h,
                                                  child: TextField(

                                                    onTap: () {
                                                      print('hhh');
                                                      model.tap;
                                                      setState(() {
                                                        if(model.tap == true){
                                                          model.tap = false;
                                                          model.notifyListeners();
                                                        }
                                                      });

                                                    },
                                                    onChanged: (value) {
                                                      model.notifyListeners();
                                                    },
                                                    // enabled: true,
                                                    //readOnly: true,
                                                    //focusNode: model.searchFocus,
                                                    controller: model.postCommentController,
                                                    decoration: InputDecoration(
                                                      counterText: '',
                                                      hintText: AppLocalizations.of(
                                                          context)!
                                                          .translate('comment_text_1')!,
                                                          // "Type your message...",

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
                                              model.postCommentController.text
                                                          .length <=
                                                      0
                                                  ? Container(
                                                      //margin: EdgeInsets.only(bottom: 2.2.h),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: ColorUtils
                                                            .text_grey,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: SvgPicture.asset(
                                                          ImageUtils.sendIcon1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () async {
                                                        /*NewBarModel barUser =
                                                        (await locator<PrefrencesViewModel>()
                                                            .getBarUser())!;
                                                        UserModel user =
                                                        (await locator<PrefrencesViewModel>().getUser())!;
                                                        // model.chat();
                                                        var comment = {
                                                          "content": model.postCommentController.text,
                                                          "userID": user.id!.toString(),
                                                          "time":DateTime.now().toString()
                                                        };
                                                        await model.pubnub!.publish(model
                                                            .posts[widget.index!]
                                                            .id.toString(), comment);
                                                        comments.add(comment);
                                                        model.postCommentController.clear();
                                                        SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                                                          model.scrollDown();
                                                        });
                                                        model.notifyListeners();*/
                                                        await model
                                                            .postingComments();
                                                        model
                                                            .getCommentNewsFeed(
                                                                widget.index!);
                                                        model
                                                            .postCommentController
                                                            .clear();
                                                        expandableController
                                                            .toggle();
                                                        model.gettingComments();

                                                        model.tap = true;
                                                        model.notifyListeners();
                                                      },
                                                      child: Container(
                                                        //margin: EdgeInsets.only(bottom: 2.2.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: ColorUtils
                                                              .text_red,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            ImageUtils
                                                                .sendIcon1,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ) /*: Container(),*/
                                      ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      disposeViewModel: false,
    );
  }
}

class DetailScreen extends StatefulWidget {
  String? imageUrl;

  DetailScreen({this.imageUrl, Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child:
        Hero(
          tag: 'imageHero',
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl!,
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 1,
            fit: BoxFit.fitWidth,
            // placeholder: new CircularProgressIndicator(),
            // errorWidget: new Icon(Icons.error),
          ),
        ),
        onTap: () {
          // Navigator.pop(context);
          Navigator.pop(context);

        },
      ),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          // _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 55.0,
      height: 116.0,
      child: Center(
        child: Material(
          color: ColorUtils.text_red,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:  Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 7.i,
                )
              // SvgPicture.asset(
              //   ImageUtils.pen,
              //   height: 3.h,
              //   width: 2.w,
              // )
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  // Widget _buildTapToOpenFab() {
  //   return IgnorePointer(
  //     ignoring: _open,
  //     child: AnimatedContainer(
  //       transformAlignment: Alignment.center,
  //       transform: Matrix4.diagonal3Values(
  //         _open ? 0.7 : 1.0,
  //         _open ? 0.7 : 1.0,
  //         1.0,
  //       ),
  //       duration: const Duration(milliseconds: 250),
  //       curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
  //       child: AnimatedOpacity(
  //           opacity: _open ? 0.0 : 0.9,
  //           curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
  //           duration: const Duration(milliseconds: 250),
  //           child: Container(
  //             margin: EdgeInsets.symmetric(vertical: 3.9.h),
  //             child: FloatingActionButton(
  //                 backgroundColor: ColorUtils.text_red,
  //                 onPressed: _toggle,
  //                 child: SvgPicture.asset(
  //                   ImageUtils.pen,
  //                   height: 2.8.h,
  //                   width: 0.w,
  //                 )),
  //           )),
  //     ),
  //   );
  // }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: -112.0 + offset.dx,
          bottom: 105.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.accentColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key? key,
    required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
