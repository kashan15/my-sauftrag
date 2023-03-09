import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/widgets/loader_black.dart';
import 'package:stacked/stacked.dart';

import '../app/locator.dart';
import '../bar/views/Home/bar_news_feed.dart';
import '../utils/app_localization.dart';
import '../utils/color_utils.dart';
import '../utils/font_utils.dart';
import '../utils/image_utils.dart';
import '../utils/size_config.dart';
import '../viewModels/main_view_model.dart';



class ViewProfile extends StatefulWidget {
  int? index;
  int? id;



  ViewProfile({Key? key,
    this.index,
    this.id}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  ExpandableController expandableController = ExpandableController();
  // List<GetNewsfeedComments> comments = [];
  // int comments_count = 0;
  bool isLoadingComments = false;

  List reportList = [
      {
  'name': "John",
  'message': "How are you",
  'time': "Today",
  'address': "New york",
  'image': ImageUtils.logo,
  'online': true,
},
    ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) async {

      },
      builder: (context, model, child,) {
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

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                  SvgPicture.asset(reportList[widget.index!]["image"],
                                    // child: model.listOfAllBarsRequest[index].profile_picture == null ?
                                    // ,SvgPicture.asset(ImageUtils.logo)
                                    //     : Image.network(model.listOfAllBarsRequest[index].profile_picture!,
                                    width: 15.i,
                                    height: 15.i,
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
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       //reportList[widget.index!]["image"]
                                    // true
                                    //           ?
                                    //       reportList[widget.index!]["image"]
                                    //           :
                                    //        reportList[widget.index!]["image"],
                                    //       //newsEvents[index]["barOwnerName"],
                                    //       style: TextStyle(
                                    //           fontFamily:
                                    //           FontUtils.modernistBold,
                                    //           fontSize: 2.2.t,
                                    //           fontWeight: FontWeight.bold,
                                    //           color: ColorUtils.black),
                                    //     ),
                                    //     // if (model.posts[index].post_type! == '1')
                                    //     //   {
                                    //     //     Text("Abc")
                                    //     //   }
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Text('',
                                      //model.posts[widget.index!].post_location!,
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


                                                });

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
                                                        child:
                                                        SvgPicture.asset(reportList[index]["image"],
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
                                                            reportList[index]["name"],
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
                                                                    reportList[index]["name"],
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
                                                            reportList[index]["name"],
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
                                              itemCount: reportList.length,
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