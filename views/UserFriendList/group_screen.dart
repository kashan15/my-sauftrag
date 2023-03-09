import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:better_player/better_player.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pubnub/pubnub.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/widgets/back_arrow_with_container.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:audioplayers/audioplayers.dart'as ap;
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../utils/app_localization.dart';
import '../../widgets/view_video.dart';
import 'group_detail_screen.dart';

class GroupScreen extends StatefulWidget {

  int? id;
  String? username;
  User? originator;
  int? userLength;
  String? groupImg;
  List<User>? groupUser;

  GroupScreen({Key? key, this.id, this.username,  this.userLength, this.groupUser, this.groupImg, this.originator}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  ScrollController? chatScroll;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController!.dispose();
    locator<MainViewModel>().subscription!.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model) async {
        //model.initUserGrpPubNub();
        // Subscribe to a channel
        model.chats.clear();
        chatScroll = ScrollController();
        animationController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        );
        animation = CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeIn,
        );
        model.subscription = model.pubnub!.subscribe(channels: {widget.username!});

        model.channel = model.pubnub!.channel(widget.username!);
        var chat = await model.channel!.messages();
        var data = await chat.count();
        await chat.fetch().whenComplete(() {
          print(chat.messages.length);
          for (var data in chat.messages) {
            model.chats.add(data.content);
          }
          model.notifyListeners();
          // SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
          //   chatScroll!.jumpTo(chatScroll!.position.maxScrollExtent);
          // });


        });

        //print("Testing");
        // Print every message
        model.subscription!.messages.listen((message) async {
          model.chats.add(message.content);
          model.notifyListeners();
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            chatScroll!.jumpTo(chatScroll!.position.minScrollExtent);
          });
        });
      },
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: ()async{
            if (model.isMenuOpen){
              if (animationController!.status == AnimationStatus.forward ||
                  animationController!.status == AnimationStatus.completed) {
                animationController!.reverse();
                model.isMenuOpen = false;
              } else {
                animationController!.forward();
                model.isMenuOpen = true;
              }
            }
            return true;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              model.groupScreenEmojiSelected = false;
              model.groupScreenEmojiShowing = false;
              model.notifyListeners();
            },
            child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: true,
                body: GestureDetector(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    if (model.isMenuOpen){
                      if (animationController!.status == AnimationStatus.forward ||
                          animationController!.status == AnimationStatus.completed) {
                        animationController!.reverse();
                        model.isMenuOpen = false;
                      } else {
                        animationController!.forward();
                        model.isMenuOpen = true;
                      }
                    }
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      AbsorbPointer(
                        absorbing: model.isMenuOpen,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.horizontalPadding,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: Dimensions.topMargin),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                model.navigateToFriendListScreen();
                                              },
                                              iconSize: 18.0,
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              icon: Icon(
                                                Icons.arrow_back_ios,
                                                color: ColorUtils.black,
                                                size: 4.5.i,
                                              )),
                                          SizedBox(
                                            width: 2.5.w,
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                  context ,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                      Group_Details(
                                                          id: model.selectedGroup!.id!,
                                                          username: model.selectedGroup!.name,
                                                          originator: model.selectedGroup!.originator,
                                                          userLength: model.selectedGroup!.users!.length,
                                                          groupImg : model.selectedGroup!.image,
                                                          groupUser: model.selectedGroup!.users
                                                      )
                                                  )
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Stack(
                                                  alignment: Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      height: 6.7.h,
                                                      width: 14.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(80),
                                                        child: model.selectedGroup!.image == null ?
                                                        SvgPicture.asset(ImageUtils.profile) :
                                                        Image.network(model.selectedGroup!.image!,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          model.selectedGroup!.name!,
                                                          style: TextStyle(
                                                              fontFamily:
                                                              FontUtils.modernistBold,
                                                              fontSize: 1.9.t,
                                                              color:
                                                              ColorUtils.text_dark),
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        model.selectedGroup!.privacy=="Private"
                                                            ?
                                                        SvgPicture.asset(
                                                            ImageUtils.groupLock)
                                                            :
                                                        SvgPicture.asset(
                                                          ImageUtils.publicIcon,
                                                          color: ColorUtils.black,),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 0.8.h,
                                                    ),
                                                    Text(
                                                      model.selectedGroup!.users!.length.toString() +
                                                          // " Members" ,
                                                          AppLocalizations.of(context)!
                                                              .translate('msg_screen_text_3')!,
                                                      style: TextStyle(
                                                          fontFamily:
                                                          FontUtils.modernistBold,
                                                          fontSize: 1.5.t,
                                                          color: ColorUtils.activeColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      //SvgPicture.asset(ImageUtils.chatMenuIcon),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(top: 3.h, left: 3.w, right: 3.w),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  controller: chatScroll,
                                  physics: BouncingScrollPhysics(),
                                  child: ListView.separated(
                                      padding: EdgeInsets.only(bottom: 12.h),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      cacheExtent: 500.h,
                                      itemBuilder: (context, index) {

                                        if(model.chats[index]["file"] != null)
                                        {
                                          if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("document") || model.chats[index]["message"]["type"]!=null && model.chats[index]["message"]["type"]=="file")
                                          {
                                            return ChatFileWidget(index: index, id: widget.id.toString(),name: widget.username);
                                          }
                                          else if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("audio")) {
                                            return ChatAudioWidget(index: index, id: widget.id.toString(), name: widget.username);
                                          }
                                          else if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("video"))
                                          {
                                            return GestureDetector(
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
                                                Uri uri = await model.pubnub!.files.getFileUrl(
                                                  widget.username!,
                                                  model.chats[index]["file"]["id"],
                                                  model.chats[index]["file"]["name"],

                                                );
                                                model.navigationService.navigationKey.currentState!.pop();
                                                Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: ViewVideo(url: uri.toString(),)));
                                              },
                                                child: ChatVideoWidget(index: index, id: widget.id.toString(), name: widget.username)
                                            );
                                          }
                                          else {
                                            return ChatImageWidget(index: index, id: widget.id.toString(), name:widget.username);
                                          }
                                        }
                                        else
                                        {
                                          return ChatTextWidget(index : index);
                                        }
                                      },
                                      separatorBuilder: (context, index) => SizedBox(
                                        height: 5.h,
                                      ),
                                      itemCount: model.chats.length),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          GestureDetector(
                            onTap: (){
                              if (model.isMenuOpen){
                                if (animationController!.status == AnimationStatus.forward ||
                                    animationController!.status == AnimationStatus.completed) {
                                  animationController!.reverse();
                                  model.isMenuOpen = false;
                                } else {
                                  animationController!.forward();
                                  model.isMenuOpen = true;
                                }
                              }
                              setState(() {});
                            },
                            child: AbsorbPointer(
                              absorbing: model.isMenuOpen,
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.3.w,
                                            vertical: Dimensions.verticalPadding),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                //width: 200.0,
                                                margin: EdgeInsets.only(

                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                    border:
                                                    Border.all(color: ColorUtils.text_red)),
                                                child: Container(
                                                  //color: Colors.amber,
                                                  // margin:
                                                  // EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 3,),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: 2.2.h, horizontal: 1.7.w),
                                                        child: ExpandTapWidget(
                                                            onTap: () {
                                                              //model.sendImageMessageGrpUser(widget.id!, widget.username!);
                                                              if (animationController!.status == AnimationStatus.forward ||
                                                                  animationController!.status == AnimationStatus.completed) {
                                                                animationController!.reverse();
                                                                model.isMenuOpen = false;
                                                              } else {
                                                                animationController!.forward();
                                                                model.isMenuOpen = true;
                                                              }
                                                              setState(() {

                                                              });
                                                              // model.getImagE();
                                                              // setState(() {});
                                                            },
                                                            tapPadding: EdgeInsets.all(4.i),
                                                            child: model.recordPressed == false ?
                                                            SvgPicture.asset(
                                                                ImageUtils
                                                                    .plusIcon)
                                                                : Text("")
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: SizeConfig.widthMultiplier *
                                                                  3,
                                                              right:
                                                              SizeConfig.widthMultiplier *
                                                                  3),
                                                          child: SingleChildScrollView(
                                                            child: Container(
                                                              constraints: BoxConstraints(
                                                                  maxHeight: 100),
                                                              child: model.recordPressed == true ?
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 15.0),
                                                                child: Text(
                                                                  // "Recording....." ,
                                                                  AppLocalizations.of(context)!
                                                                      .translate('msg_screen_text_2')!,
                                                                  style: TextStyle(
                                                                      fontSize: 2.2.t,
                                                                      fontWeight: FontWeight.bold ,
                                                                      color: ColorUtils.red_color),),
                                                              ) :
                                                              TextField(
                                                                onTap: () {},
                                                                onChanged: (value){
                                                                  model.notifyListeners();
                                                                },
                                                                // enabled: true,
                                                                //readOnly: true,
                                                                //focusNode: model.searchFocus,
                                                                controller: model
                                                                    .groupScreenChatController,
                                                                decoration: InputDecoration(
                                                                  counterText: '',
                                                                  hintText:
                                                                  // "Type your message...",

                                                                  AppLocalizations.of(context)!
                                                                      .translate('msg_screen_text_1')!,
                                                                  hintStyle: TextStyle(
                                                                    //fontFamily: FontUtils.proximaNovaRegular,
                                                                    //color: ColorUtils.silverColor,
                                                                    fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                        1.9,

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
                                                              ) ,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: 1.5.h, horizontal: 1.5.w),
                                                        decoration: BoxDecoration(
                                                          //color: ColorUtils.text_red,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(15)),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                          children: [
                                                            // ExpandTapWidget(
                                                            //   onTap: () {
                                                            //     model.getImage();
                                                            //     setState(() {
                                                            //     });
                                                            //   },
                                                            //   tapPadding: EdgeInsets.all(4.i),
                                                            //   child: SvgPicture.asset(ImageUtils.plusIcon),
                                                            // ),
                                                            // GestureDetector(
                                                            //   onTap: (){
                                                            //     model.getImage();
                                                            //   },
                                                            //     child: SvgPicture.asset(ImageUtils.plusIcon),
                                                            // ),
                                                            // SizedBox(width: 3.w,),
                                                            ExpandTapWidget(
                                                              onTap: () async {
                                                                // final cameras = await availableCameras();
                                                                // final firstCamera = cameras.first;
                                                                //model.navigationService.navigateTo(to: TakePictureScreen(camera: firstCamera,));
                                                                await model.openCameraGrp(widget.id!, widget.username!);
                                                                model.updateGroup();
                                                              },
                                                              tapPadding: EdgeInsets.all(25.0),
                                                              child: model.recordPressed == false ? SvgPicture.asset(
                                                                ImageUtils.photoCamera,
                                                                color: ColorUtils.text_red,
                                                              ) : Text(""),
                                                            ),
                                                            SizedBox(
                                                              width: 3.w,
                                                            ),
                                                            ExpandTapWidget(
                                                              onTap: () async{
                                                                if(model.recordPressed == false){
                                                                  model.recordPressed = true;
                                                                  model.notifyListeners();
                                                                  print("record started");
                                                                  model.startGroupVoice();
                                                                }
                                                                else if(model.recordPressed == true){
                                                                  model.recordPressed = false;
                                                                  model.notifyListeners();
                                                                  print("recording stopped");
                                                                  await model.stopGroupVoice(widget.id!, widget.username!);
                                                                  model.updateGroup();
                                                                }
                                                                //model.isRecording ? model.stop() : model.start();
                                                                //model.getImage();
                                                                setState(() {});
                                                              },
                                                              tapPadding:
                                                              EdgeInsets.all(
                                                                  0.i),
                                                              child:
                                                              model.recordPressed == false ?
                                                              SvgPicture.asset(
                                                                ImageUtils
                                                                    .voiceRecorder,
                                                                color: ColorUtils
                                                                    .red_color,
                                                                height: 5.5.i,
                                                              ) :
                                                              Container(
                                                                // padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                                // height: 2.h,
                                                                // width: 5.w,
                                                                //color: ColorUtils.transparent,
                                                                child: SvgPicture.asset(
                                                                  ImageUtils
                                                                      .voiceRecord,
                                                                  //color: ColorUtils.white,
                                                                  height: 7.5.i,
                                                                ),
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              width: 1.5.w,
                                                            ),
                                                            // GestureDetector(
                                                            //   onTap: (){
                                                            //   },
                                                            //   child: SvgPicture.asset(ImageUtils.photoCamera)
                                                            // ),
                                                          ],
                                                        ),
                                                      )
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
                                            ),
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //     shape: BoxShape.circle,
                                            //     color: ColorUtils.text_red,
                                            //   ),
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.all(15.0),
                                            //     child: SvgPicture.asset(ImageUtils.voiceRecorder,
                                            //       //color: ColorUtils.blueColor,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    model.groupScreenChatController.text.isEmpty && model.recordPressed == false ?

                                    Container(
                                      margin: EdgeInsets.only(bottom: 2.2.h),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorUtils.icon_color,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: SvgPicture.asset(
                                          ImageUtils.sendIcon1,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ):
                                    InkWell(
                                      onTap: () async {
                                        NewBarModel barUser =
                                        (await locator<PrefrencesViewModel>()
                                            .getBarUser())!;
                                        UserModel user =
                                        (await locator<PrefrencesViewModel>().getUser())!;
                                        // model.chat();

                                        model.pubnub!.publish(widget.username!, {
                                          "content": model.groupScreenChatController.text,
                                          "userID": user.id!,
                                          "time":DateTime.now().toString(),
                                          "name": user.username
                                        });
                                        model.groupScreenChatController.clear();
                                        model.updateGroup();
                                        // Future.delayed(Duration(seconds: 2), () {
                                        //   model.scrollDown();
                                        // });
                                        // model.notifyListeners();
                                      },
                                      child:
                                      model.recordPressed == false ?
                                      Container(
                                        margin: EdgeInsets.only(bottom: 2.2.h),
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
                                      ) : Text(""),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          CircularRevealAnimation(
                              centerAlignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.3.w,
                                    vertical: Dimensions.verticalPadding),
                                child: Container(
                                  height: 10*SizeConfig.heightMultiplier,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color : ColorUtils.red_color)
                                  ),
                                  margin: EdgeInsets.only(bottom: 9*SizeConfig.heightMultiplier),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 2*SizeConfig.widthMultiplier),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: ColorUtils.red_color,
                                                  borderRadius: BorderRadius.circular(50)
                                              ),
                                              child: Icon(Icons.attach_file,color: ColorUtils.white,),
                                            ),
                                            Positioned.fill(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(50),
                                                    splashColor: Colors.white.withOpacity(0.5),
                                                    highlightColor: Colors.white.withOpacity(0.5),
                                                    onTap: ()async{
                                                      await model.sendFileMessageGroupUser(widget.id!, widget.username!);
                                                      model.updateGroup();
                                                    },
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 2*SizeConfig.widthMultiplier),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: ColorUtils.red_color,
                                                  borderRadius: BorderRadius.circular(50)
                                              ),
                                              child: Icon(Icons.image,color: ColorUtils.white,),
                                            ),
                                            Positioned.fill(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(50),
                                                    splashColor: Colors.white.withOpacity(0.5),
                                                    highlightColor: Colors.white.withOpacity(0.5),
                                                    onTap: ()async{
                                                      await model.sendImageMessageGrpUser(widget.id!, widget.username!);
                                                      model.updateGroup();
                                                    },
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ), animation: animation!)
                        ],
                      ),
                    ],
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
///----------------------Chat Image-------------------------------///

class ChatImageWidget extends StatefulWidget {
  int? index;
  String? id;
  String? name;
  ChatImageWidget({Key? key, this.index, this.id, this.name}) : super(key: key);

  @override
  _ChatImageWidgetState createState() => _ChatImageWidgetState();
}

class _ChatImageWidgetState extends State<ChatImageWidget> {

  Uri? uri;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=> locator<MainViewModel>(),
      onModelReady: (model) {
        getFileUrl(model, widget.name!);
      },
      builder: (context, model,child){
        return Align(
          alignment: model.chats[widget.index!]["message"]["userID"] !=
              model.userModel!.id!
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            width:
            MediaQuery.of(context).size.width /
                1.7,
            decoration: BoxDecoration(
              color: model.chats[widget.index!]["message"]["userID"] !=
                  model.userModel!.id!?ColorUtils.messageChat:ColorUtils.red_color.withOpacity(0.5),
              borderRadius: model.chats[widget.index!]["message"]
              ["userID"] !=
                  model.userModel!.id!
                  ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft:
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: model.chats[widget.index!]["message"]
              ["userID"] !=
                  model.userModel!.id!
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      model.chats[widget.index!]["message"]["name"] != null ?
                      Text(model.chats[widget.index!]["message"]["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: model.chats[widget.index!]["message"]["userID"] ==
                        model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark,
                        ),) : Text(""),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 3.w,
                      right: 3.w,
                      top: 1.5.h),
                  child: uri!=null
                      ?
                  Image.network(
                    uri.toString(),
                    // height: 30.h,
                    // width: 50.w,
                    fit: BoxFit.cover,
                  )
                  :
                  Container(),
                ),
                //SizedBox(height: 1.h,),

                Align(
                  alignment: model.chats[widget.index!]["message"]
                  ["userID"] !=
                      model.userModel!.id!
                      ? Alignment.centerRight
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat("hh:mm").format(DateTime.parse(model.chats[widget.index!]["message"]["time"])),
                      style: TextStyle(
                        //fontFamily: FontUtils.avertaDemoRegular,
                          fontSize: 1.5.t,
                          color: model.chats[widget.index!]["message"]["userID"] ==
                              model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      disposeViewModel: false,
    );
  }
  void getFileUrl (MainViewModel model, String name)async{
    print(model.chats[widget.index!]);

    uri = await model.pubnub!.files.getFileUrl(
      name,
      model.chats[widget.index!]["file"]["id"],
      model.chats[widget.index!]["file"]["name"],
    );
    print(uri);
    setState(() {
    });
  }
}

///-------------------Chat Text ---------------------------///

class ChatTextWidget extends StatefulWidget {
  int? index;

  ChatTextWidget({Key? key, this.index}) : super(key: key);

  @override
  _ChatTextWidgetState createState() => _ChatTextWidgetState();
}

class _ChatTextWidgetState extends State<ChatTextWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=> locator<MainViewModel>(),
      onModelReady: (model) {
        //getFileUrl(model);
      },
      builder: (context, model,child){
        return Align(
          alignment: model.chats[widget.index!]["userID"] ==
              model.userModel!.id!
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width:
            MediaQuery.of(context).size.width /
                1.7,
            decoration: BoxDecoration(
              color: model.chats[widget.index!]["userID"] ==
                  model.userModel!.id!?ColorUtils.red_color.withOpacity(0.5):ColorUtils.messageChat,
              borderRadius: model.chats[widget.index!]
              ["userID"] !=
                  model.userModel!.id!
                  ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft:
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: model.chats[widget.index!]
              ["userID"] !=
                  model.userModel!.id!
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //       horizontal: 3.w,
                //       vertical: 1.5.h),
                //   child: Image.asset(
                //     ImageUtils.drinkImage,
                //   ),
                // ),
                // model.groupChatUser!.users!.first.username !=null?
                // Text(model.groupChatUser!.users!.first.username!) : Text(""),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      model.chats[widget.index!]["name"] != null ?
                      Text(model.chats[widget.index!]["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: model.chats[widget.index!]["userID"] ==
                                model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark
                        ),) : Text(""),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 3.w,
                        right: 3.w,
                        top: 1.5.h),
                    child: Text(
                      model.chats[widget.index!]["content"].toString(),
                      style: TextStyle(
                        //fontFamily: FontUtils.avertaDemoRegular,
                          fontSize: 1.8.t,
                          color:
                          model.chats[widget.index!]["userID"] ==
                              model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark),
                    )
                ),
                //SizedBox(height: 1.h,),

                Align(
                  alignment: model.chats[widget.index!]
                  ["userID"] !=
                      model.userModel!.id!
                      ? Alignment.centerRight
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat("hh:mm").format(DateTime.parse(model.chats[widget.index!]["time"])),
                      //model.chats[widget.index!]["createdAt"].toString(),
                      style: TextStyle(
                        //fontFamily: FontUtils.avertaDemoRegular,
                          fontSize: 1.5.t,
                          color: model.chats[widget.index!]["userID"] ==
                              model.userModel!.id!?ColorUtils.white:ColorUtils.icon_color),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      disposeViewModel: false,
    );
  }
}

///------------------ Chat Video---------------------------------///

class ChatVideoWidget extends StatefulWidget {
  int? index;
  String? id;
  String? name;

  ChatVideoWidget({Key? key, this.index, this.id,  this.name}) : super(key: key);

  @override
  _ChatVideoWidgetState createState() => _ChatVideoWidgetState();
}

class _ChatVideoWidgetState extends State<ChatVideoWidget> {

  Uri? uri;
  Uint8List? image;
  BetterPlayerController? _betterPlayerController;
  BetterPlayerDataSource? _betterPlayerDataSource;


  @override
  void dispose() {

    super.dispose();
  }

  @override
  void initState() {

    super.initState();
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=> locator<MainViewModel>(),
      onModelReady: (model) {
        getFileUrl(model, widget.name);
      },
      builder: (context, model,child){
        return Align(
          alignment: model.chats[widget.index!]["message"]["userID"] !=
              model.userModel!.id!
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            height: MediaQuery.of(context).size.height/4.5,
            width:
            MediaQuery.of(context).size.width /
                1.7,
            decoration: BoxDecoration(
              color: model.chats[widget.index!]["message"]["userID"] ==
                  model.userModel!.id!?ColorUtils.red_color.withOpacity(0.5):ColorUtils.messageChat,
              borderRadius: model.chats[widget.index!]["message"]
              ["userID"] !=
                  model.userModel!.id!
                  ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: image==null
                      ?
                  Loader()
                      :
                  Image.memory(image!),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: model.chats[widget.index!]["message"]
                    ["userID"] !=
                        model.userModel!.id!
                        ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                        : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: model.chats[widget.index!]["message"]
                  ["userID"] !=
                      model.userModel!.id!
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.play_arrow, color: Colors.red, size: 28),
                      ),
                    ),


                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat("hh:mm").format(DateTime.parse(model.chats[widget.index!]["message"]["time"])),
                      style: TextStyle(
                        //fontFamily: FontUtils.avertaDemoRegular,
                          fontSize: 1.5.t,
                          color: model.chats[widget.index!]["message"]["userID"] ==
                              model.userModel!.id!?ColorUtils.white:ColorUtils.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      disposeViewModel: false,
    );
  }
  void getFileUrl (MainViewModel model, name)async{
    print(model.chats[widget.index!]);
    //var fileInfo = widget.ImageData;
    uri = await model.pubnub!.files.getFileUrl(

      name,
      model.chats[widget.index!]["file"]["id"],
      model.chats[widget.index!]["file"]["name"],

    );
    image = await VideoThumbnail.thumbnailData(video: uri.toString(),imageFormat: ImageFormat.JPEG);
    setState(() {

    });

  }

}


///------------ Chat Audio ----------------------///
class ChatAudioWidget extends StatefulWidget {
  int? index;
  String? id;
  String? name;

  ChatAudioWidget({Key? key, this.index, this.id, this.name}) : super(key: key);

  @override
  _ChatAudioWidgetState createState() => _ChatAudioWidgetState();
}

class _ChatAudioWidgetState extends State<ChatAudioWidget> {

  Uri? uri;

  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerCompletion.listen((state) async {
          await stop();
          setState(() {});
        });
    _positionChangedSubscription = _audioPlayer.onAudioPositionChanged.listen(
          (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
          (duration) => setState(() {
        _duration = duration;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=>locator<MainViewModel>(),
      builder: (context, model, child) {
        return Align(
            alignment: model.chats[widget.index!]["message"]["userID"] !=
                model.userModel!.id!
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  padding: EdgeInsets.only(top: 0.6.h, bottom: 0.6.h, left: 0.6.h),
                  width:
                  MediaQuery.of(context).size.width /
                      1.2,
                  decoration: BoxDecoration(
                    color: model.chats[widget.index!]["message"]["userID"] ==
                        model.userModel!.id!?ColorUtils.red_color.withOpacity(0.5):ColorUtils.messageChat,
                    borderRadius: model.chats[widget.index!]["message"]
                    ["userID"] !=
                        model.userModel!.id!
                        ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                        : BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),

                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            model.chats[widget.index!]["message"]["name"] != null ?
                            Text(model.chats[widget.index!]["message"]["name"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: model.chats[widget.index!]["message"]["userID"] ==
                                      model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark
                              ),) : Text(""),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildControl(),
                          _buildSlider(constraints.maxWidth),
                          // IconButton(
                          //   icon: const Icon(Icons.delete,
                          //       color: Color(0xFF73748D), size: _deleteBtnSize),
                          //   onPressed: () {
                          //     stop().then((value) => widget.onDelete());
                          //   },
                          // ),
                        ],
                      ),
                      Align(
                        alignment: model.chats[widget.index!]["message"]
                        ["userID"] !=
                            model.userModel!.id!
                            ? Alignment.centerRight
                            : Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.0,left: 8.0,right:8.0),
                          child: Text(
                            DateFormat("hh:mm").format(DateTime.parse(model.chats[widget.index!]["message"]["time"])),
                            style: TextStyle(
                              //fontFamily: FontUtils.avertaDemoRegular,
                                fontSize: 1.5.t,
                                color: model.chats[widget.index!]["message"]["userID"] ==
                                    model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark),
                          ),
                        ),
                      ),
                    ],
                  )
                );
              },
            )
        );
      },
      onModelReady: (model){
        getFileUrl(model, widget.name!);
      },
      disposeViewModel: false,
    );
  }
  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.PLAYING) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 28);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: Colors.red, size: 28);
      color = theme.scaffoldBackgroundColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
          SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.PLAYING) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      //height: 0.2.h,
      width: width,
      child: Slider(
        activeColor: Theme.of(context).errorColor,
        inactiveColor: Theme.of(context).colorScheme.onError,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() {
    return _audioPlayer.play(
      uri.toString(),
      //ap.AudioPlayer(widget.source);
      //DeviceFileSource(widget.source),
    );
  }
  // void getFileUrl (MainViewModel model)async{
  //   print(model.chats[widget.index!]);
  //   //var fileInfo = widget.ImageData;
  //   uri = await model.pubnub!.files.getFileUrl(
  //     model.getConversationID(
  //         model.userModel!.id.toString(),
  //         widget.id.toString()
  //     ),
  //     model.chats[widget.index!]["file"]["id"],
  //     model.chats[widget.index!]["file"]["name"],
  //   );
  //   print(uri);
  //   setState(() {
  //
  //   });
  //
  // }

  void getFileUrl (MainViewModel model, String name)async{
    print(model.chats[widget.index!]);

    uri = await model.pubnub!.files.getFileUrl(
      name,
      model.chats[widget.index!]["file"]["id"],
      model.chats[widget.index!]["file"]["name"],
    );
    print(uri);
    setState(() {
    });
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}

///--------------------- Chat File ----------------------///

class ChatFileWidget extends StatefulWidget {
  int? index;
  String? id;
  String? name;

  ChatFileWidget({Key? key, this.index, this.id,this.name}) : super(key: key);

  @override
  _ChatFileWidgetState createState() => _ChatFileWidgetState();
}

class _ChatFileWidgetState extends State<ChatFileWidget> {

  Uri? uri;

  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer();
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    // _playerStateChangedSubscription =
    //     _audioPlayer.onPlayerCompletion.listen((state) async {
    //       await stop();
    //       setState(() {});
    //     });
    // _positionChangedSubscription = _audioPlayer.onAudioPositionChanged.listen(
    //       (position) => setState(() {
    //     _position = position;
    //   }),
    // );
    // _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
    //       (duration) => setState(() {
    //     _duration = duration;
    //   }),
    // );

    super.initState();
  }

  @override
  void dispose() {
    // _playerStateChangedSubscription.cancel();
    // _positionChangedSubscription.cancel();
    // _durationChangedSubscription.cancel();
    // _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: ()=>locator<MainViewModel>(),
      builder: (context, model, child) {
        return Align(
            alignment: model.chats[widget.index!]["message"]["userID"] !=
                model.userModel!.id!
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0.6.h, bottom: 0.6.h, left: 0.6.h),
                      width:
                      MediaQuery.of(context).size.width /
                          1.7,
                      decoration: BoxDecoration(
                        color: model.chats[widget.index!]["message"]["userID"] ==
                            model.userModel!.id!?ColorUtils.red_color.withOpacity(0.5):ColorUtils.messageChat,
                        borderRadius: model.chats[widget.index!]["message"]
                        ["userID"] !=
                            model.userModel!.id!
                            ? BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )
                            : BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                model.chats[widget.index!]["message"]["name"] != null ?
                                Text(model.chats[widget.index!]["message"]["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: model.chats[widget.index!]["message"]["userID"] ==
                                          model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark
                                  ),) : Text(""),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1*SizeConfig.heightMultiplier),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Icon(Icons.insert_drive_file_rounded,size: 6*SizeConfig.heightMultiplier,),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 1*SizeConfig.heightMultiplier),
                                      child: Text((model.chats[widget.index!]["file"]["name"].split(".").last.toUpperCase() as String).length>4
                                          ?
                                      (model.chats[widget.index!]["file"]["name"].split(".").last.toUpperCase() as String).substring(0,3)+".."
                                          :
                                      (model.chats[widget.index!]["file"]["name"].split(".").last.toUpperCase() as String),style: TextStyle(
                                          fontSize: 1*SizeConfig.textMultiplier,
                                          color: Colors.white
                                      ),),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Text(model.chats[widget.index!]["file"]["name"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily:
                                        FontUtils.modernistBold,
                                        fontSize: 1.5.t,
                                        color:model.chats[widget.index!]["message"]["userID"] ==
                                            model.userModel!.id!?ColorUtils.white:ColorUtils.black),),
                                )
                                // _buildControl(),
                                // _buildSlider(constraints.maxWidth),
                                // // IconButton(
                                // //   icon: const Icon(Icons.delete,
                                // //       color: Color(0xFF73748D), size: _deleteBtnSize),
                                // //   onPressed: () {
                                // //     stop().then((value) => widget.onDelete());
                                // //   },
                                // // ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: model.chats[widget.index!]["message"]
                            ["userID"] !=
                                model.userModel!.id!
                                ? Alignment.centerRight
                                : Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat("hh:mm").format(DateTime.parse(model.chats[widget.index!]["message"]["time"])),
                                style: TextStyle(
                                  //fontFamily: FontUtils.avertaDemoRegular,
                                    fontSize: 1.5.t,
                                    color: model.chats[widget.index!]["message"]["userID"] ==
                                        model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: model.chats[widget.index!]["message"]
                            ["userID"] ==
                                model.userModel!.id!.toString()
                                ? BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            )
                                : BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            onTap: ()async{
                              if (uri!=null){
                                model.openFile(uri!.toString(),model.chats[widget.index!]["file"]["name"]);
                              }
                            },
                          ),
                        ))
                  ],
                );
              },
            )
        );
      },
      onModelReady: (model){
        getFileUrl(model,widget.name!);
      },
      disposeViewModel: false,
    );
  }
  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.PLAYING) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 28);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: Colors.red, size: 28);
      color = theme.scaffoldBackgroundColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
          SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.PLAYING) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      //height: 0.2.h,
      width: width,
      child: Slider(
        activeColor: Theme.of(context).errorColor,
        inactiveColor: Theme.of(context).colorScheme.onError,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() {
    return _audioPlayer.play(
      uri.toString(),
      //ap.AudioPlayer(widget.source);
      //DeviceFileSource(widget.source),
    );
  }
  void getFileUrl (MainViewModel model, String name)async{
    print(model.chats[widget.index!]);

    uri = await model.pubnub!.files.getFileUrl(
      name,
      model.chats[widget.index!]["file"]["id"],
      model.chats[widget.index!]["file"]["name"],
    );
    print(uri);
    setState(() {
    });
  }

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();


}
