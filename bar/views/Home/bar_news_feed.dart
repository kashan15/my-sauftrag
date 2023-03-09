import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/extra/dimen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/bar/widgets/my_side_menu.dart';
import 'package:sauftrag/main.dart';
import 'package:sauftrag/models/create_bar_post.dart';
import 'package:sauftrag/models/create_bar_post.dart';
import 'package:sauftrag/models/create_bar_post.dart';
import 'package:sauftrag/models/create_bar_post.dart';
import 'package:sauftrag/models/create_bar_post.dart';
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
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:sauftrag/widgets/dialog_event.dart';
import 'package:sauftrag/widgets/drink_status_dialog_box.dart';
import 'package:sauftrag/bar/widgets/message_dialog.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:sauftrag/widgets/zoom_drawer.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:stacked/stacked.dart';
import 'package:sauftrag/models/create_bar_post.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'dart:math' as math;

import '../../../models/get_comments_bar.dart';
import '../../../utils/app_localization.dart';
import '../../../widgets/loader_black.dart';

class BarNewsFeed extends StatefulWidget {
  const BarNewsFeed({
    Key? key,
  }) : super(key: key);

  @override
  _BarNewsFeedState createState() => _BarNewsFeedState();
}

class _BarNewsFeedState extends State<BarNewsFeed> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];
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

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double initialBottom = 15.0;
    double backCardWidth = 0.0;
    var drawerController;

    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (data) {
        data.getBarPost();
        data.rating();
        data.getEvent(context);
        data.getNotification(context);

        //data.updateCurrentLocationBar();
        // data.buttonController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
        // data.initSwipe();
      },
      builder: (context, model, child) {
        return model.isPost == true
            ? AllPageLoader()
            : SafeArea(
                bottom: false,
                top: false,
                child: SideMenu(
                  key: model.sideMenuKey,
                  closeIcon: Icon(
                    Icons.remove,
                    color: Colors.transparent,
                  ),
                  type: SideMenuType.shrinkNSlide,
                  background: ColorUtils.text_red,
                  radius: BorderRadius.circular(30),
                  menu: MySideMenu(),
                  child: GestureDetector(
                    onTap: () {
                      final _state = model.sideMenuKey.currentState;
                      if (_state!.isOpened)
                        _state.closeSideMenu(); // close side menu
                    },
                    child: Scaffold(
                        key: _scaffoldKey,
                        backgroundColor: ColorUtils.white,
                        floatingActionButton: ExpandableFab(
                          distance: 120.0,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //model.navigateToCreateEventScreen();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DialogEvent(
                                              title: "Add New Location",
                                              btnTxt: "Add Location",
                                              icon: ImageUtils.addLocationIcon);
                                        });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorUtils.text_red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        //border: Border.all(color: ColorUtils.red_color),
                                      ),
                                      height: 5.5.h,
                                      width: 12.w,
                                      child: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: SvgPicture.asset(
                                          ImageUtils.calender,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.navigateToBarPostScreen();
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context){
                                    //       return MessageDialog(title: "Add New Location",
                                    //           btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                    //     }
                                    // );
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorUtils.text_red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        //border: Border.all(color: ColorUtils.red_color),
                                      ),
                                      height: 5.5.h,
                                      width: 12.w,
                                      child: Padding(
                                        padding: const EdgeInsets.all(11.0),
                                        child: SvgPicture.asset(
                                          ImageUtils.pen2,
                                        ),
                                      )),
                                ),
                              ],
                            )
                          ],
                          model: model,
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.endDocked,
                        body: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Dimensions.homeTopMargin),

                              //Top bar
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.horizontalPadding),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          final _state =
                                              model.sideMenuKey.currentState;
                                          if (_state!.isOpened)
                                            _state
                                                .closeSideMenu(); // close side menu
                                          else
                                            _state.openSideMenu();
                                        },
                                        child: SvgPicture.asset(
                                            ImageUtils.menuIcon),
                                        style: ElevatedButton.styleFrom(
                                          primary: ColorUtils.white,
                                          onPrimary: ColorUtils.white,
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .containerVerticalPadding),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.roundCorner),
                                              side: BorderSide(
                                                  color: ColorUtils.divider,
                                                  width: 1)),
                                          textStyle: TextStyle(
                                            color: ColorUtils.white,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 1.8.t,
                                            //height: 0
                                          ),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(
                                            context)!
                                            .translate('bar_news_feed_text_1')!,
                                        style: TextStyle(
                                          color: ColorUtils.black,
                                          fontFamily: FontUtils.modernistBold,
                                          fontSize: 3.t,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async{
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
                                          model.selectedBar = await model.getAnotherBarProfile(model.barModel!.id);
                                          model.navigationService.navigationKey.currentState!.pop();
                                          if (model.selectedBar!=null){
                                            model.navigateToBarProfile2();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            //color: ColorUtils.red_color,
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorUtils.black
                                                    .withOpacity(0.12),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(0,
                                                    5),
                                              ),
                                            ],
                                          ),
                                          child:
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: model.barModel?.profile_picture == null ?
                                                  SvgPicture.asset(ImageUtils.logo,
                                                    fit: BoxFit.fill,
                                                    height: 15.i,
                                                    width: 15.i,

                                                  )
                                              : Image(
                                                image: NetworkImage(model.barModel!.profile_picture!),
                                                fit: BoxFit.fill,
                                                height: 15.i,
                                                width: 15.i,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //SizedBox(height: 3.h),

                              SizedBox(
                                height: SizeConfig.heightMultiplier * 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return BarNewsFeedItem(index: index,);
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        //height: SizeConfig.heightMultiplier * 2.5,
                                      );
                                    },
                                    itemCount: model.posts.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }

  void add(context, MainViewModel mainModel) {
    final scrollController = ScrollController();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(top: Dimensions.homeTopMargin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            ImageUtils.johnImg,
                            width: 13.i,
                            height: 13.i,
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "John Milton",
                                style: TextStyle(
                                  fontFamily: FontUtils.modernistBold,
                                  fontSize: 1.9.t,
                                  color: ColorUtils.text_dark,
                                ),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Container(
                                height: 3.h,
                                width: 25.w,
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                decoration: BoxDecoration(
                                    color: ColorUtils.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.roundCorner)),
                                    border: Border.all(
                                        color: ColorUtils.red_color)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      ImageUtils.privateIcon,
                                      height: 1.6.h,
                                    ),
                                    SizedBox(
                                      width: 1.5.w,
                                    ),
                                    Expanded(
                                        child: DropdownButton<String>(
                                      value: mainModel.msgTypeValueStr,
                                      items: mainModel.msgTypeList
                                          .asMap()
                                          .values
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontSize: 1.6.t,
                                              fontFamily:
                                                  FontUtils.modernistRegular,
                                              color: ColorUtils.black,
                                              //height: 1.8
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (data) {
                                        setState(() {
                                          mainModel.msgTypeValueStr =
                                              data as String;
                                          mainModel.msgTypeValue = mainModel
                                                  .msgTypeMap[
                                              mainModel.msgTypeValueStr] as int;
                                        });
                                      },
                                      hint: Text(
                                        "Select an option",
                                        style: TextStyle(
                                          fontSize: 1.8.t,
                                          fontFamily:
                                              FontUtils.modernistRegular,
                                          color: ColorUtils.red_color,
                                        ),
                                      ),
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: ColorUtils.black,
                                            size: 4.2.i,
                                          )),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Sindh, Karachi",
                            style: TextStyle(
                              fontFamily: FontUtils.modernistBold,
                              fontSize: 1.8.t,
                              color: ColorUtils.text_dark,
                            ),
                          ),
                          SizedBox(width: 1.8.w),
                          SvgPicture.asset(
                            ImageUtils.locationIcon,
                            height: 8.i,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                //left: SizeConfig.widthMultiplier * 4.5,
                                //right: SizeConfig.widthMultiplier * 2,
                                //top: SizeConfig.heightMultiplier * 3,
                                ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                                border: Border.all(color: ColorUtils.text_red)),
                            child: Container(
                              //color: Colors.amber,

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ExpandTapWidget(
                                    onTap: () {
                                      mainModel.messageScreenEmojiShowing =
                                          !mainModel.messageScreenEmojiShowing;
                                      mainModel.messageScreenEmojiSelected =
                                          !mainModel.messageScreenEmojiSelected;
                                      SchedulerBinding.instance!
                                          .addPostFrameCallback((_) {
                                        scrollController.jumpTo(scrollController
                                            .position.maxScrollExtent);
                                      });
                                      setState(() {});
                                    },
                                    tapPadding: EdgeInsets.all(25.0),
                                    child:
                                        SvgPicture.asset(ImageUtils.smileyIcon),
                                  ),
                                  // GestureDetector(
                                  //   onTap: (){
                                  //     emojiShowing = !emojiShowing;
                                  //     emojiSelected = !emojiSelected;
                                  //     SchedulerBinding.instance!.addPostFrameCallback((_) {
                                  //       scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                  //     });
                                  //     setState(() {
                                  //     });
                                  //   },
                                  //   child: Container(
                                  //     child: SvgPicture.asset(ImageUtils.smileyIcon),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Container(
                                    width: 57.w,
                                    child: TextField(
                                      onTap: () {

                                      },
                                      enabled: true,
                                      //readOnly: true,
                                      //focusNode: model.searchFocus,
                                      controller:
                                          mainModel.messageScreenChatController,
                                      decoration: InputDecoration(
                                        hintText: "Type your message...",
                                        hintStyle: TextStyle(
                                          //fontFamily: FontUtils.proximaNovaRegular,
                                          //color: ColorUtils.silverColor,
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.9,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.heightMultiplier *
                                                    2),
                                      ),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      //color: ColorUtils.text_red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Row(
                                      children: [
                                        ExpandTapWidget(
                                          onTap: () {
                                            mainModel.getImagE();
                                            setState(() {});
                                          },
                                          tapPadding: EdgeInsets.all(50.0),
                                          child: SvgPicture.asset(
                                              ImageUtils.plusIcon),
                                        ),
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     model.getImage();
                                        //   },
                                        //     child: SvgPicture.asset(ImageUtils.plusIcon),
                                        // ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        ExpandTapWidget(
                                            onTap: () async {
                                              // final cameras = await availableCameras();
                                              // final firstCamera = cameras.first;
                                              //model.navigationService.navigateTo(to: TakePictureScreen(camera: firstCamera,));
                                              mainModel.openCamera();
                                            },
                                            tapPadding: EdgeInsets.all(25.0),
                                            child: SvgPicture.asset(
                                              ImageUtils.photoCamera,
                                              color: ColorUtils.red_color,
                                            )),
                                        // GestureDetector(
                                        //   onTap: (){
                                        //   },
                                        //   child: SvgPicture.asset(ImageUtils.photoCamera)
                                        // ),
                                      ],
                                    ),
                                  ),
                                  // Text(searchHere,
                                  //   style: TextStyle(
                                  //     fontFamily: FontUtils.gibsonRegular,
                                  //     fontWeight: FontWeight.w400,
                                  //     fontSize: SizeConfig.textMultiplier * 1.8,
                                  //     color: ColorUtils.searchFieldText,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     color: ColorUtils.text_red,
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(15.0),
                          //     child: SvgPicture.asset(ImageUtils.voiceRecorder,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      if (mainModel.messageScreenEmojiSelected == true)
                        Container(
                          height: 30.h,
                          child: Offstage(
                            offstage: !mainModel.messageScreenEmojiShowing,
                            child: EmojiPicker(
                                onEmojiSelected:
                                    (Category category, Emoji emoji) {
                                  mainModel.messageEmojiSelected(emoji);
                                },
                                onBackspacePressed:
                                    mainModel.messageScreenBackspacePressed(),
                                config: Config(
                                    columns: 7,
                                    // Issue: https://github.com/flutter/flutter/issues/28894
                                    emojiSizeMax:
                                        32 * (Platform.isIOS ? 1.30 : 1.0),
                                    verticalSpacing: 0,
                                    horizontalSpacing: 0,
                                    initCategory: Category.RECENT,
                                    bgColor: const Color(0xFFF2F2F2),
                                    indicatorColor: Colors.blue,
                                    iconColor: Colors.grey,
                                    iconColorSelected: Colors.blue,
                                    progressIndicatorColor: Colors.blue,
                                    backspaceColor: Colors.blue,
                                    showRecentsTab: true,
                                    recentsLimit: 28,
                                    // noRecentsText: 'No Recents',
                                    // noRecentsStyle: const TextStyle(
                                    //     fontSize: 20, color: Colors.black26),
                                    tabIndicatorAnimDuration:
                                        kTabScrollDuration,
                                    categoryIcons: const CategoryIcons(),
                                    buttonMode: ButtonMode.MATERIAL)),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.2.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: ColorUtils.text_red),
                          color: ColorUtils.text_red),
                      child: Text(
                        "Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontUtils.modernistRegular,
                          fontSize: 1.8.t,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
    required this.model,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final MainViewModel model;

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
          _buildTapToCloseFab(widget.model),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(widget.model),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab(MainViewModel model) {
    return SizedBox(
      width: 55.0,
      height: 116.0,
      child: Center(
        child: Material(
          color: ColorUtils.text_red,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Visibility(
            visible: model.tap,
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

  Widget _buildTapToOpenFab(MainViewModel model) {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
            opacity: _open ? 0.0 : 0.9,
            curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
            duration: const Duration(milliseconds: 250),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 3.9.h),
              child: Visibility(
                visible: model.tap,

                child: FloatingActionButton(
                    backgroundColor: ColorUtils.text_red,
                    onPressed: _toggle,
                    child: SvgPicture.asset(
                      ImageUtils.pen,
                      height: 2.8.h,
                      width: 0.w,
                    )),
              ),
            )),
      ),
    );
  }
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


class BarNewsFeedItem extends StatefulWidget {
  int? index;
  int? id;
  BarNewsFeedItem({Key? key,this.index, this.id}) : super(key: key);

  @override
  _BarNewsFeedItemState createState() => _BarNewsFeedItemState();
}

class _BarNewsFeedItemState extends State<BarNewsFeedItem> {
  final expandableController = ExpandableController();
  List<GetNewsfeedCommentsBar> comments = [];
  int comments_count = 0;
  bool isLoadingComments = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=>locator<MainViewModel>(),
      onModelReady: (model) async {
        NewBarModel barUser =
        (await locator<PrefrencesViewModel>().getBarUser())!;
        var channel =
          model.pubnub!.channel(model.posts[widget.index!].id.toString());
        var chat = await channel.messages();
        await chat.fetch();
        comments_count = await chat.count();
        model.notifyListeners();
        //var   data = await chat.count();
      },
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.5.w,
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: 3.5.h),
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
                  color: ColorUtils.text_grey
                      .withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w,
                      vertical: 1.h),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap:()async{
                          if(!model.busy("gettingProfile")){
                            showGeneralDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.white.withOpacity(0.6),
                                pageBuilder: (context,animation1,animation2){
                              return Container(
                                child: Center(
                                  child: RedLoader(),
                                ),
                              );
                            });
                            model.setBusyForObject("gettingProfile",true);
                            if (model.posts[widget.index!].user_id!.role==1){
                              model.matchedImage.clear();
                              //model.getMatchedUserData = (model.acceptMatchedtModel[index]);
                              if (model.posts[widget.index!].user_id!.profile_picture != null &&
                                  model.posts[widget.index!].user_id!.profile_picture!.isNotEmpty) {
                                model.matchedImage.add(model.posts[widget.index!].user_id!.profile_picture);
                              }
                              if (model.posts[widget.index!].user_id!.catalogue_image1 != null &&
                                  model.posts[widget.index!].user_id!.catalogue_image1!.isNotEmpty) {
                                model.matchedImage.add(model.posts[widget.index!].user_id!.catalogue_image1);
                              }
                              if (model.posts[widget.index!].user_id!.catalogue_image2 != null &&
                                  model.posts[widget.index!].user_id!.catalogue_image2!.isNotEmpty) {
                                model.matchedImage.add(model.posts[widget.index!].user_id!.catalogue_image2);
                              }
                              if (model.posts[widget.index!].user_id!.catalogue_image3 != null &&
                                  model.posts[widget.index!].user_id!.catalogue_image3!.isNotEmpty) {
                                model.matchedImage.add(model.posts[widget.index!].user_id!.catalogue_image3);
                              }
                              if (model.posts[widget.index!].user_id!.catalogue_image4 != null &&
                                  model.posts[widget.index!].user_id!.catalogue_image4!.isNotEmpty) {
                                model.matchedImage.add(model.posts[widget.index!].user_id!.catalogue_image4);
                              }
                              if (model.posts[widget.index!].user_id!.catalogue_image5 != null &&
                                  model.posts[widget.index!].user_id!.catalogue_image5!.isNotEmpty) {
                                model.matchedImage.add(model.posts[widget.index!].user_id!.catalogue_image5);
                              }
                              // model.notifyListeners();
                              await model.barGetAnotherUserInfo(model.posts[widget.index!].user_id!.id.toString());
                              model.setBusyForObject("gettingProfile",false);
                              model.navigateBack();
                              model.navigateToMatchedProfileUser();
                            }
                            else{
                              model.selectedBar = await model.getAnotherBarProfile(model.posts[widget.index!].user_id!.id);
                              if (model.selectedBar!=null){
                                model.setBusyForObject("gettingProfile",false);
                                model.navigateBack();
                                model.navigateToBarProfile();
                              }
                            }
                          }

                          //print("yo");




                        },
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius
                                  .circular(10),
                              child: Image.network(
                                model
                                    .posts[widget.index!]
                                    .user_id!
                                    .profile_picture!,
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
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
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
                                          FontUtils
                                              .modernistBold,
                                          fontSize:
                                          2.2.t,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color: ColorUtils
                                              .black),
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
                                  model.posts[widget.index!]
                                      .post_location!,
                                  //newsEvents[index]["barOwnerName"],
                                  style: TextStyle(
                                      fontFamily:
                                      FontUtils
                                          .modernistRegular,
                                      fontSize: 1.7.t,
                                      //fontWeight: FontWeight.bold,
                                      color:
                                      ColorUtils
                                          .black),
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
                              model.posts[widget.index!]
                                  .post_content!,
                              //newsEvents[index]["para"],
                              style: TextStyle(
                                  fontFamily: FontUtils
                                      .modernistRegular,
                                  fontSize: 1.8.t,
                                  color: ColorUtils
                                      .black),
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
                                            model.selectedPost = model.posts[widget.index!];
                                            model.postLikeNewsFeed(widget.index!);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              ImageUtils.matchedIcon,
                                              color:
                                              model.posts[widget.index!].is_like != null ? model.posts[widget.index!].is_like! ? ColorUtils.red_color : ColorUtils.icon_color : ColorUtils.icon_color
                                            ),
                                            SizedBox(
                                              width: 1.5.w,
                                            ),
                                            Text(
                                              model.posts[widget.index!].likes_count.toString(),
                                              style: TextStyle(
                                                  fontFamily: FontUtils
                                                      .modernistRegular,
                                                  fontSize: 1.5.t,
                                                  color:
                                                  model.posts[widget.index!].is_like != null ? model.posts[widget.index!].is_like! ? ColorUtils.red_color : ColorUtils.icon_color: ColorUtils.icon_color ),
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
                                            model.selectedCommentId = model
                                                .posts[widget.index!].id!;
                                            isLoadingComments = true;
                                            model.notifyListeners();
                                            comments = await model.gettingCommentsBars();
                                            isLoadingComments = false;
                                            expandableController.toggle();
                                            model.notifyListeners();
                                          }
                                          else {

                                            model.tap = true;
                                            model.notifyListeners();

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
                                              model.posts[widget.index!]
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
                                        // ClipRRect(
                                        //   borderRadius: BorderRadius.circular(30),
                                        //   child: Image.network(model.barModel!.profile_picture!,
                                        //     width: 10.i,
                                        //     height: 10.i,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(50),
                                            child: model.barModel?.profile_picture == null ?
                                            SvgPicture.asset(ImageUtils.logo,
                                              fit: BoxFit.fill,
                                              height: 10.i,
                                              width: 10.i,

                                            )
                                                : Image(
                                              image: NetworkImage(model.barModel!.profile_picture!),
                                              fit: BoxFit.fill,
                                              height: 10.i,
                                              width: 10.i,
                                            )),
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
                                                // "Type your message...",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_news_feed_text_6')!,
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
                                            // NewBarModel barUser =
                                            // (await locator<PrefrencesViewModel>()
                                            //     .getBarUser())!;
                                            // UserModel user =
                                            // (await locator<PrefrencesViewModel>().getUser())!;
                                            // // model.chat();
                                            // var comment = {
                                            //   "content": model.postCommentController.text,
                                            //   "userID": barUser.id!.toString(),
                                            //   "time":DateTime.now().toString()
                                            // };
                                            // await model.pubnub!.publish(model
                                            //     .posts[widget.index!]
                                            //     .id.toString(), comment);
                                            // comments.add(comment);
                                            // model.postCommentController.clear();
                                            // SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                                            //   model.scrollDown();
                                            // });
                                            // model.notifyListeners();

                                            await model
                                                .postingCommentsBar();
                                            model
                                                .getCommentNewsFeedBar(
                                                widget.index!);
                                            model
                                                .postCommentController
                                                .clear();
                                            expandableController
                                                .toggle();
                                            model.tap = true;
                                            model.notifyListeners();
                                            comments = model.gettingCommentsBars();


                                            model.notifyListeners();

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
                ),
              ],
            ),
          ),
        );
    },
    disposeViewModel: false,);
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

