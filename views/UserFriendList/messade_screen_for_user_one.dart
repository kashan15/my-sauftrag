import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pubnub/core.dart';
import 'package:pubnub/pubnub.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/bar_model.dart';
import 'package:sauftrag/models/listOfFollowing_Bars.dart';
import 'package:sauftrag/models/new_bar_model.dart';
import 'package:sauftrag/models/user_models.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/views/UserFriendList/chat_input.dart';
import 'package:sauftrag/views/UserFriendList/chat_list_widget.dart';
import 'package:sauftrag/views/UserFriendList/my_class.dart';
import 'package:sauftrag/widgets/back_arrow_with_container.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:sauftrag/widgets/loader_black.dart';
import 'package:sauftrag/widgets/view_video.dart';
import 'package:sendbird_sdk/core/channel/base/base_channel.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';
import 'package:sendbird_sdk/core/channel/open/open_channel.dart';
import 'package:sendbird_sdk/handlers/channel_event_handler.dart';
import 'package:sendbird_sdk/params/group_channel_params.dart';
import 'package:sendbird_sdk/params/user_message_params.dart';
import 'package:sendbird_sdk/query/channel_list/group_channel_list_query.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'package:stacked/stacked.dart';
import 'package:audioplayers/audioplayers.dart'as ap;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../models/user_matched.dart';
import '../../widgets/rating_dialog_box.dart';



class MessageScreenForUserOne extends StatefulWidget {
  int? id;
  String? username;
  String? profilePic;
  bool? fromUser;
  UserModel? user;
  String? email;
  // late GroupChannel channel;

  // final appId = 'DA12362A-D7A9-47B1-A3B2-AA892FDCE6A2';
  // final userId = 'KAshan';
  // final otherUserId = 'Ali';
  //
  // late GroupChannel _channel;

  // late GroupChannel channel;


  MessageScreenForUserOne({Key? key, this.id, this.username, this.profilePic, this.fromUser,this.user,this.email,

  })
      : super(key: key);

  @override
  _MessageScreenForUserOneState createState() => _MessageScreenForUserOneState();
}

class _MessageScreenForUserOneState extends State<MessageScreenForUserOne> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  ScrollController? chatScroll;

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    MainViewModel model = locator<MainViewModel>();
    model.subscription?.pause();
    animationController!.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) async {
        //model.initUserGrpPubNub();
        // model.chat();
        // model.getAllUserForChat();
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


        // Subscribe to a channel
        // try {
        //   UserModel User = (await locator<PrefrencesViewModel>().getUser())!;
        //   model.sendbird!.connect("${User.id}");
        // }
        // catch (e) {
        //   // Handle error.
        // }



        try {
          final channel = await OpenChannel.getChannel('sendbird_open_channel_37097_6a5e83a7fc6cfeb07ae7b8dc3170507b0f967c02');
          await channel.enter();
          // The current user successfully enters the open channel.
        } catch (e) {
          // Handle error.
        }

        try {
          final channel = await OpenChannel.getChannel('sendbird_open_channel_37097_6a5e83a7fc6cfeb07ae7b8dc3170507b0f967c02');
          await channel.exit();
          // The current user successfully exits the open channel.
        } catch (e) {
          // Handle error.
        }

        try {
          final openChannel = await OpenChannel.getChannel('sendbird_open_channel_37097_6a5e83a7fc6cfeb07ae7b8dc3170507b0f967c02');
          // Call the instance method of the result object in the "openChannel" parameter of the callback method.
          await openChannel.enter();
          // The current user successfully enters the open channel as a participant,
          // and can chat with other users in the channel by using APIs.
        } catch (e) {
          // Handle error.
        }

        try {
          UserModel User = (await locator<PrefrencesViewModel>().getUser())!;
          final params = GroupChannelParams()
            ..userIds= User as List<String>?;
          final channel = await GroupChannel.createChannel(params);
          // Now you can work with the channel object.
        } catch (e) {
          // Handle error.
        }



        // try {
        //   String? DATA;
        //   var message_id;
        //   final params = UserMessageParams(message: MESSAGE)
        //     ..data = DATA;
        //
        //   final preMessage = .sendUserMessage(params, onCompleted: (msg, error) {
        //     // The message is successfully sent to the channel.
        //     // The current user can receive messages from other users through the onMessageReceived() method of an event handler.
        //   });
        // } catch (e) {
        //   // Handle error.
        // }

        ///Channel MetaData
        await model.pubnub!.objects.getChannelMetadata(model.channel!.name,includeCustomFields: true)
            .then((value){
          //print(value.metadata);
          model.channelMetaDataDetails = value.metadata;
          model.notifyListeners();
          //print();


        })
            .catchError((error){
          print(error);
          var data = {
            model.userModel!.id.toString() : false,
            widget.id.toString() : false
          };
          if(error.message == '404 error: Requested object was not found.'){
            model.pubnub!.objects.setChannelMetadata(model.channel!.name, ChannelMetadataInput(custom: {
              "block" : jsonEncode(data)
            }),includeCustomFields: true)
                .then((value){
              model.channelMetaDataDetails = value.metadata;
              model.notifyListeners();
            })
                .catchError((error){
              print(error);
            });
          }
        });


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
          //
          // });
          // SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
          //   chatScroll!.jumpTo(chatScroll!.position.minScrollExtent);
          // });
        });


        model.subscription!.messages.listen((message) async {
          model.chats.add(message.content);
          model.notifyListeners();
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            chatScroll!.jumpTo(chatScroll!.position.minScrollExtent);
          });
        });



        // Send a message every second for 5 seconds

        // Unsubscribe and quit
        // await subscription.dispose();
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: ()async{
            model.channelMetaDataDetails = null;
            return true;
          },
          child: GestureDetector(
            onTap: () {
              context.unFocus();
              model.messageScreenEmojiSelected = false;
              model.messageScreenEmojiSelected = false;
              if (model.openBurgerMenu){
                model.openBurgerMenu =! model.openBurgerMenu;
              }
              model.notifyListeners();
            },
            child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding,
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(

                          children: [

                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  context.unFocus();
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
                                  if (model.openBurgerMenu ==
                                      true) {
                                    model.openBurgerMenu = false;
                                    model.notifyListeners();
                                  }
                                  // if (model.openBurgerMenu){
                                  //   model.openBurgerMenu =! model.openBurgerMenu;
                                  // }
                                  setState(() {});
                                },
                                child: AbsorbPointer(
                                  absorbing: model.isMenuOpen,
                                  child: Column(
                                    children: [
                                      SizedBox(height: Dimensions.topMargin),
                                      Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  model.navigateToFollowerList();
                                                },
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          model.navigateBack();
                                                          model.channelMetaDataDetails = null;
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
                                                      onTap: () async {
                                                        // await model.getAnitherUserInfo(widget.id.toString());
                                                        // model.navigateToMatchedProfileUser();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap : ()async{
                                                              if (!model.busy("isLoadingProfile")){
                                                                model.setBusyForObject("isLoadingProfile", true);
                                                                if (widget.fromUser!) {
                                                                  model.matchedImage.clear();
                                                                  //model.getMatchedUserData = (model.acceptMatchedtModel[index]);
                                                                  if (widget.user!.profile_picture != null &&
                                                                      widget.user!.profile_picture!.isNotEmpty) {
                                                                    model.matchedImage.add(widget.user!.profile_picture);
                                                                  }
                                                                  if (widget.user!.catalogue_image1 != null &&
                                                                      widget.user!.catalogue_image1!.isNotEmpty) {
                                                                    model.matchedImage.add(widget.user!.catalogue_image1);
                                                                  }
                                                                  if (widget.user!.catalogue_image2 != null &&
                                                                      widget.user!.catalogue_image2!.isNotEmpty) {
                                                                    model.matchedImage.add(widget.user!.catalogue_image2);
                                                                  }
                                                                  if (widget.user!.catalogue_image3 != null &&
                                                                      widget.user!.catalogue_image3!.isNotEmpty) {
                                                                    model.matchedImage.add(widget.user!.catalogue_image3);
                                                                  }
                                                                  if (widget.user!.catalogue_image4 != null &&
                                                                      widget.user!.catalogue_image4!.isNotEmpty) {
                                                                    model.matchedImage.add(widget.user!.catalogue_image4);
                                                                  }
                                                                  if (widget.user!.catalogue_image5 != null &&
                                                                      widget.user!.catalogue_image5!.isNotEmpty) {
                                                                    model.matchedImage.add(widget.user!.catalogue_image5);
                                                                  }
                                                                  model.notifyListeners();
                                                                  await model.userGetAnotherUserInfo(widget.user!.id.toString());
                                                                  model.setBusyForObject("isLoadingProfile", false);
                                                                  model.navigateToMatchedProfileUser();
                                                                }
                                                                else {
                                                                  model.setBusyForObject("isLoadingProfile", false);
                                                                  model.navigateToBarProfile();
                                                                }
                                                              }
                                                            },
                                                            child: Stack(
                                                              alignment: Alignment.topCenter,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 26.0,
                                                                  backgroundImage: NetworkImage(
                                                                      widget.profilePic ??
                                                                          "https://tse2.mm.bing.net/th?id=OIP.4gcGG1F0z6LjVlJjYWGGcgHaHa&pid=Api&P=0&w=164&h=164"),
                                                                  backgroundColor:
                                                                  Colors.transparent,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 3.w,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                widget.username.toString(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    FontUtils.modernistBold,
                                                                    fontSize: 1.9.t,
                                                                    color:
                                                                    ColorUtils.text_dark),
                                                              ),
                                                              SizedBox(
                                                                height: 0.5.h,
                                                              ),
                                                              Text(
                                                                "Active",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                    FontUtils.modernistBold,
                                                                    fontSize: 1.5.t,
                                                                    color:
                                                                    ColorUtils.activeColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (model.openBurgerMenu == false) {
                                                    model.openBurgerMenu = true;
                                                    model.notifyListeners();
                                                  } else if (model.openBurgerMenu ==
                                                      true) {
                                                    model.openBurgerMenu = false;
                                                    model.notifyListeners();
                                                  }
                                                },
                                                icon: SvgPicture.asset(
                                                    ImageUtils.chatMenuIcon),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 0.h, top: 3.h),
                                          child: SingleChildScrollView(
                                            reverse: true,
                                            controller: chatScroll!,
                                            physics: BouncingScrollPhysics(),
                                            child: ListView.separated(
                                                physics: NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.only(bottom: 12.h),
                                                cacheExtent: 500.h,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  if(model.chats[index]["file"] != null)
                                                  {

                                                    if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("document") || model.chats[index]["message"]["type"]!=null && model.chats[index]["message"]["type"]=="file")
                                                    {
                                                      return ChatFileWidget(index: index, id: widget.id.toString());
                                                    }
                                                    else if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("audio")) {
                                                      return ChatAudioWidget(index: index, id: widget.id.toString());
                                                    }
                                                    else if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("video")){
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
                                                            model.getConversationID(
                                                                model.userModel!.id.toString(),
                                                                widget.id.toString()
                                                            ),
                                                            model.chats[index]["file"]["id"],
                                                            model.chats[index]["file"]["name"],

                                                          );
                                                          model.navigationService.navigationKey.currentState!.pop();
                                                          Navigator.push(context, PageTransition(type: PageTransitionType.fade,child: ViewVideo(url: uri.toString(),)));
                                                        },
                                                        child: ChatVideoWidget(index: index, id: widget.id.toString()),
                                                      );
                                                    }
                                                    else {
                                                      return ChatImageWidget(index: index, id: widget.id.toString());
                                                    }
                                                  }
                                                  else
                                                  {
                                                    return ChatTextWidget(index : index);
                                                  }
                                                },
                                                separatorBuilder: (context, index) =>
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                itemCount: model.chats.length
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            AbsorbPointer(
                              absorbing: model.channelMetaDataDetails!=null
                                  ?
                              jsonDecode(model.channelMetaDataDetails!.custom!["block"])[widget.id.toString()] || jsonDecode(model.channelMetaDataDetails!.custom!["block"])[model.userModel!.id.toString()]
                                  :
                              false,
                              child: GestureDetector(
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
                                                                      child: Text("Recording....." ,
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
                                                                        model.channelMetaDataDetails!=null
                                                                            ?
                                                                        jsonDecode(model.channelMetaDataDetails!.custom!["block"])[widget.id.toString()]
                                                                            ?
                                                                        "User is blocked"
                                                                            :
                                                                        jsonDecode(model.channelMetaDataDetails!.custom!["block"])[model.userModel!.id.toString()]
                                                                            ?
                                                                        "you have been blocked"
                                                                            :
                                                                        "Type your message..."
                                                                            :
                                                                        "Type your message...",
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
                                                                      model.openCameraUser(widget.id!);
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
                                                                    onTap: () {
                                                                      if(model.recordPressed == false){
                                                                        model.recordPressed = true;
                                                                        model.notifyListeners();
                                                                        print("record started");
                                                                        model.start();
                                                                      }
                                                                      else if(model.recordPressed == true){
                                                                        model.recordPressed = false;
                                                                        model.notifyListeners();
                                                                        print("recording stopped");
                                                                        model.stop(widget.id!);
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
                                          // InkWell(
                                          //   onTap: () async {
                                          //     UserModel barUser = (await locator<
                                          //         PrefrencesViewModel>()
                                          //         .getUser())!;
                                          //
                                          //     model.sendbirdone.connect('${barUser.id}',
                                          //       nickname: "Jonny",
                                          //       accessToken: "77e008e76df7a354a870139cb9b2e95903f1cfc0",
                                          //     );
                                          //     //model.sbChannel;
                                          //     // model.sendbirdone.messageReceiveStream();
                                          //     widget.id.toString();
                                          //     model.sendbirdone.deliveryStream();
                                          //
                                          //
                                          //     // barUser.id.toString();
                                          //     // widget.id.toString();
                                          //     model.groupScreenChatController.clear();
                                          //     model.notifyListeners();
                                          //   },
                                          //   child:
                                          //   model.recordPressed == false ?
                                          //   Container(
                                          //     margin: EdgeInsets.only(bottom: 2.2.h),
                                          //     decoration: BoxDecoration(
                                          //       shape: BoxShape.circle,
                                          //       color: ColorUtils.text_red,
                                          //     ),
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.all(15.0),
                                          //       child: SvgPicture.asset(
                                          //         ImageUtils.sendIcon1,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //   ) : Text(""),
                                          // ),

                                          InkWell(
                                            onTap: () async {
                                                try {
                                                  UserModel User = (await locator<PrefrencesViewModel>().getUser())!;

                                                  final sendbirdone = SendbirdSdk(appId: model.appId);
                                                      sendbirdone.connect('${User.id}',
                                                      nickname: '${User.username}'
                                                  );


                                                  final query = GroupChannelListQuery()
                                                    ..userIdsExactlyIn = (model.otherUserId) as List<String>;

                                                  final channels = await query.loadNext();
                                                  if (channels.length == 0) {
                                                    model.channelone = await GroupChannel.createChannel(
                                                        GroupChannelParams()
                                                          ..userIds = (User.id) as List<String>?
                                                    );
                                                  }
                                                  model.channelone = await GroupChannel.getChannel(model.channelone.channelUrl);

                                                  model.channelone = channels[0];
                                                  // final onMessageReceived = ChannelEventHandler();

                                                  // sendbirdone!.messageReceiveStream(
                                                  //   channelUrl: model.channelone.channelUrl);

                                                }
                                                catch (e) {

                                                }

                                              print(widget.id.toString());
                                              model.groupScreenChatController.clear();
                                              model.notifyListeners();

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
                                    )
                                ),
                              ),
                            ),
                            CircularRevealAnimation(
                                centerAlignment: Alignment.bottomLeft,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color : ColorUtils.red_color)
                                  ),
                                  margin: EdgeInsets.only(bottom: 12*SizeConfig.heightMultiplier),
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
                                                    onTap: (){
                                                      model.sendFileMessageUser(widget.id!);
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
                                                    onTap: (){
                                                      model.sendImageMessageUser(widget.id!);
                                                    },
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ), animation: animation!),

                          ],
                        ),
                        if (model.openBurgerMenu == true)
                          Positioned(
                            right: 2.5.w,
                            top: 12.5.h,
                            child: GestureDetector(
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
                                  //width: 28.w,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () {

                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ReportChatDialogBox(name: widget.username!,email: widget.email!,user: widget.user!.role==1?"User" : "Bar",);
                                                  });
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child:model.addDrink == false ? Text(
                                                  "Report Chat",
                                                  style: TextStyle(
                                                      fontFamily:
                                                      FontUtils.modernistRegular,
                                                      fontSize: 1.9.t,
                                                      color: ColorUtils.text_dark),
                                                ) : LoaderBlack()
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: ()async{
                                            if (model
                                                .channelMetaDataDetails!
                                                .custom != null) {
                                              model.setBusyForObject(
                                                  "blocking", true);
                                              var data = jsonDecode(
                                                  model
                                                      .channelMetaDataDetails!
                                                      .custom!["block"]);
                                              data[widget.id
                                                  .toString()] =
                                              !data[widget.id
                                                  .toString()];
                                              await model.pubnub!
                                                  .objects
                                                  .setChannelMetadata(
                                                  model.channel!.name,
                                                  ChannelMetadataInput(
                                                      custom: {
                                                        "block": jsonEncode(
                                                            data)
                                                      }
                                                  ),
                                                  includeCustomFields: true)
                                                  .then((value) {
                                                model
                                                    .channelMetaDataDetails =
                                                    value.metadata;
                                                model
                                                    .setBusyForObject(
                                                    "blocking",
                                                    false);
                                              })
                                                  .catchError((
                                                  error) {
                                                model
                                                    .setBusyForObject(
                                                    "blocking",
                                                    false);
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: model.busy("blocking")
                                                ?
                                            LoaderBlack()
                                                :
                                            model.channelMetaDataDetails!=null
                                                ?
                                            jsonDecode(model.channelMetaDataDetails!.custom!["block"])[widget.id.toString()]
                                                ?
                                            Text(
                                              "Unblock",
                                              style: TextStyle(
                                                  fontFamily:
                                                  FontUtils.modernistRegular,
                                                  fontSize: 1.9.t,
                                                  color: ColorUtils.text_dark),
                                            )
                                                :
                                            Text(
                                              "Block",
                                              style: TextStyle(
                                                  fontFamily:
                                                  FontUtils.modernistRegular,
                                                  fontSize: 1.9.t,
                                                  color: ColorUtils.text_dark),
                                            )
                                                :
                                            Text(
                                              "Block",
                                              style: TextStyle(
                                                  fontFamily:
                                                  FontUtils.modernistRegular,
                                                  fontSize: 1.9.t,
                                                  color: ColorUtils.text_dark),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                      ],
                    ),
                    // child: Column(
                    //   children: [
                    //     Stack(
                    //       children: [
                    //         SizedBox(height: Dimensions.topMargin),
                    //         Stack(
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     model.navigateToFollowerList();
                    //                   },
                    //                   child: Row(
                    //                     children: [
                    //                       IconButton(
                    //                           onPressed: () {
                    //                             model.navigateBack();
                    //                           },
                    //                           iconSize: 18.0,
                    //                           padding: EdgeInsets.zero,
                    //                           constraints: BoxConstraints(),
                    //                           icon: Icon(
                    //                             Icons.arrow_back_ios,
                    //                             color: ColorUtils.black,
                    //                             size: 4.5.i,
                    //                           )),
                    //                       SizedBox(
                    //                         width: 2.5.w,
                    //                       ),
                    //                       Stack(
                    //                         alignment: Alignment.topCenter,
                    //                         children: [
                    //                           CircleAvatar(
                    //                             radius: 26.0,
                    //                             backgroundImage: NetworkImage(
                    //                                 widget.profilePic ??
                    //                                     "https://tse2.mm.bing.net/th?id=OIP.4gcGG1F0z6LjVlJjYWGGcgHaHa&pid=Api&P=0&w=164&h=164"),
                    //                             backgroundColor:
                    //                                 Colors.transparent,
                    //                           ),
                    //                         ],
                    //
                    //                       ),
                    //                       SizedBox(
                    //                         width: 3.w,
                    //                       ),
                    //                       Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             widget.username.toString(),
                    //                             style: TextStyle(
                    //                                 fontFamily:
                    //                                     FontUtils.modernistBold,
                    //                                 fontSize: 1.9.t,
                    //                                 color:
                    //                                     ColorUtils.text_dark),
                    //                           ),
                    //                           SizedBox(
                    //                             height: 0.5.h,
                    //                           ),
                    //                           Text(
                    //                             "Active",
                    //                             style: TextStyle(
                    //                                 fontFamily:
                    //                                     FontUtils.modernistBold,
                    //                                 fontSize: 1.5.t,
                    //                                 color:
                    //                                     ColorUtils.activeColor),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 IconButton(
                    //                   onPressed: () {
                    //                     if (model.openBurgerMenu == false) {
                    //                       model.openBurgerMenu = true;
                    //                       model.notifyListeners();
                    //                     } else if (model.openBurgerMenu ==
                    //                         true) {
                    //                       model.openBurgerMenu = false;
                    //                       model.notifyListeners();
                    //                     }
                    //                   },
                    //                   icon: SvgPicture.asset(
                    //                       ImageUtils.chatMenuIcon),
                    //                 )
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 1.h,
                    //         ),
                    //         Container(
                    //           padding: EdgeInsets.only(bottom: 2.h, top: 3.h),
                    //           height: 75.h,
                    //           child: ListView.separated(
                    //               physics: BouncingScrollPhysics(),
                    //               controller: model.chatScroll,
                    //               itemBuilder: (context, index) {
                    //                 if(model.chats[index]["file"] != null)
                    //                 {
                    //
                    //                   if(lookupMimeType(model.chats[index]["file"]["name"])!.contains("video"))
                    //                   {
                    //                     return ChatVideoWidget(index: index, id: widget.id.toString());
                    //                   }
                    //                   else {
                    //                     return ChatImageWidget(index: index, id: widget.id.toString());
                    //                   }
                    //                 }
                    //                 else
                    //                 {
                    //                   return ChatTextWidget(index : index);
                    //                 }
                    //               },
                    //               separatorBuilder: (context, index) =>
                    //                   SizedBox(
                    //                     height: 5.h,
                    //                   ),
                    //               itemCount: model.chats.length),
                    //         ),
                    //         Container(
                    //           // padding: EdgeInsets.symmetric(vertical: 1.h),
                    //           color: Colors.white,
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             crossAxisAlignment: CrossAxisAlignment.end,
                    //             children: [
                    //               Expanded(
                    //                 child: Container(
                    //                   // margin: EdgeInsets.only(left: 2.w),
                    //                   padding: EdgeInsets.symmetric(
                    //                     horizontal: 1.3.w,
                    //                     //vertical: Dimensions.verticalPadding
                    //                   ),
                    //                   child: Row(
                    //                     children: [
                    //                       Expanded(
                    //                         child: Container(
                    //                           //width: 200.0,
                    //                           margin: EdgeInsets.only(
                    //                               //left: SizeConfig.widthMultiplier * 4.5,
                    //                               //right: SizeConfig.widthMultiplier * 2,
                    //                               //top: SizeConfig.heightMultiplier * 3,
                    //                               ),
                    //                           decoration: BoxDecoration(
                    //                               color: Colors.white,
                    //                               borderRadius:
                    //                                   BorderRadius.all(
                    //                                 Radius.circular(15.0),
                    //                               ),
                    //                               border: Border.all(
                    //                                   color:
                    //                                       ColorUtils.text_red)),
                    //                           child: Container(
                    //                             //color: Colors.amber,
                    //                             // margin:
                    //                             // EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 3,),
                    //                             child: Row(
                    //                               crossAxisAlignment:
                    //                                   CrossAxisAlignment.end,
                    //                               mainAxisAlignment:
                    //                                   MainAxisAlignment.end,
                    //                               children: [
                    //                                 Container(
                    //                                   padding:
                    //                                       EdgeInsets.symmetric(
                    //                                           vertical: 2.2.h,
                    //                                           horizontal:
                    //                                               1.7.w),
                    //                                   child: ExpandTapWidget(
                    //                                     onTap: () {
                    //                                       model.sendImageMessageUser(widget.id!);
                    //                                       // model.getImagE();
                    //                                       // setState(() {});
                    //                                     },
                    //                                     tapPadding:
                    //                                         EdgeInsets.all(4.i),
                    //                                     child: SvgPicture.asset(
                    //                                         ImageUtils
                    //                                             .plusIcon),
                    //                                   ),
                    //                                 ),
                    //
                    //                                 Expanded(
                    //                                   child: Container(
                    //                                     margin: EdgeInsets.only(
                    //                                         left: SizeConfig
                    //                                                 .widthMultiplier *
                    //                                             3,
                    //                                         right: SizeConfig
                    //                                                 .widthMultiplier *
                    //                                             3),
                    //                                     child: Container(
                    //                                       constraints:
                    //                                           BoxConstraints(
                    //                                               maxHeight:
                    //                                                   100),
                    //                                       child: TextField(
                    //                                         onTap: () {},
                    //                                         onChanged: (value){
                    //                                           model.notifyListeners();
                    //                                         },
                    //                                         // enabled: true,
                    //                                         //readOnly: true,
                    //                                         //focusNode: model.searchFocus,
                    //                                         controller: model
                    //                                             .groupScreenChatController,
                    //                                         decoration:
                    //                                             InputDecoration(
                    //                                           counterText: '',
                    //                                           hintText:
                    //                                               "Type your message...",
                    //                                           hintStyle:
                    //                                               TextStyle(
                    //                                             //fontFamily: FontUtils.proximaNovaRegular,
                    //                                             //color: ColorUtils.silverColor,
                    //                                             fontSize: SizeConfig
                    //                                                     .textMultiplier *
                    //                                                 1.9,
                    //                                           ),
                    //                                           border:
                    //                                               InputBorder
                    //                                                   .none,
                    //                                           // isDense: true,
                    //                                           contentPadding:
                    //                                               EdgeInsets.symmetric(
                    //                                                   vertical:
                    //                                                       SizeConfig.heightMultiplier *
                    //                                                           2),
                    //                                         ),
                    //                                         keyboardType:
                    //                                             TextInputType
                    //                                                 .multiline,
                    //                                         maxLines: null,
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                                 Container(
                    //                                   padding:
                    //                                       EdgeInsets.symmetric(
                    //                                           vertical: 1.5.h,
                    //                                           horizontal:
                    //                                               1.5.w),
                    //                                   decoration: BoxDecoration(
                    //                                     //color: ColorUtils.text_red,
                    //                                     borderRadius:
                    //                                         BorderRadius.all(
                    //                                             Radius.circular(
                    //                                                 15)),
                    //                                   ),
                    //                                   child: Row(
                    //                                     mainAxisAlignment:
                    //                                         MainAxisAlignment
                    //                                             .end,
                    //                                     children: [
                    //                                       // ExpandTapWidget(
                    //                                       //   onTap: () {
                    //                                       //     model.getImage();
                    //                                       //     setState(() {
                    //                                       //     });
                    //                                       //   },
                    //                                       //   tapPadding: EdgeInsets.all(4.i),
                    //                                       //   child: SvgPicture.asset(ImageUtils.plusIcon),
                    //                                       // ),
                    //                                       // GestureDetector(
                    //                                       //   onTap: (){
                    //                                       //     model.getImage();
                    //                                       //   },
                    //                                       //     child: SvgPicture.asset(ImageUtils.plusIcon),
                    //                                       // ),
                    //                                       // SizedBox(width: 3.w,),
                    //                                       ExpandTapWidget(
                    //                                         onTap: () async {
                    //                                           // final cameras = await availableCameras();
                    //                                           // final firstCamera = cameras.first;
                    //                                           //model.navigationService.navigateTo(to: TakePictureScreen(camera: firstCamera,));
                    //                                           model.openCameraUser(widget.id!);
                    //                                         },
                    //                                         tapPadding:
                    //                                             EdgeInsets.all(
                    //                                                 25.0),
                    //                                         child: SvgPicture
                    //                                             .asset(
                    //                                           ImageUtils
                    //                                               .photoCamera,
                    //                                           color: ColorUtils
                    //                                               .text_red,
                    //                                         ),
                    //                                       ),
                    //                                       SizedBox(
                    //                                         width: 3.w,
                    //                                       ),
                    //                                       ExpandTapWidget(
                    //                                         onTap: () {
                    //                                           //model.getImage();
                    //                                           setState(() {});
                    //                                         },
                    //                                         tapPadding:
                    //                                             EdgeInsets.all(
                    //                                                 0.i),
                    //                                         child: SvgPicture
                    //                                             .asset(
                    //                                           ImageUtils
                    //                                               .voiceRecorder,
                    //                                           color: ColorUtils
                    //                                               .red_color,
                    //                                           height: 5.5.i,
                    //                                         ),
                    //                                       ),
                    //
                    //                                       SizedBox(
                    //                                         width: 1.5.w,
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 )
                    //                   // child: Padding(
                    //                   //   padding: const EdgeInsets.all(8.0),
                    //                   //   child: Column(
                    //                   //     mainAxisAlignment:
                    //                   //         MainAxisAlignment.start,
                    //                   //     crossAxisAlignment:
                    //                   //         CrossAxisAlignment.start,
                    //                   //     children: [
                    //                   //       Text(
                    //                   //         "Report Chat",
                    //                   //         style: TextStyle(
                    //                   //             fontFamily:
                    //                   //                 FontUtils.modernistRegular,
                    //                   //             fontSize: 1.9.t,
                    //                   //             color: ColorUtils.text_dark),
                    //                   //       ),
                    //                   //       SizedBox(
                    //                   //         height: 1.h,
                    //                   //       ),
                    //                   //       Text(
                    //                   //         "Block",
                    //                   //         style: TextStyle(
                    //                   //             fontFamily:
                    //                   //                 FontUtils.modernistRegular,
                    //                   //             fontSize: 1.9.t,
                    //                   //             color: ColorUtils.text_dark),
                    //                   //       ),
                    //                   //     ],
                    //                   //   ),
                    //                   // ),
                    //                 ])
                    //               )),
                    //         Column(
                    //           children: [
                    //             SizedBox(height: Dimensions.topMargin),
                    //             Stack(
                    //               children: [
                    //                 Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     GestureDetector(
                    //                       onTap: () {
                    //                         model.navigateToFollowerList();
                    //                       },
                    //                       child: Row(
                    //                         children: [
                    //                           IconButton(
                    //                               onPressed: () {
                    //                                 model.navigateBack();
                    //                               },
                    //                               iconSize: 18.0,
                    //                               padding: EdgeInsets.zero,
                    //                               constraints: BoxConstraints(),
                    //                               icon: Icon(
                    //                                 Icons.arrow_back_ios,
                    //                                 color: ColorUtils.black,
                    //                                 size: 4.5.i,
                    //                               )),
                    //                           SizedBox(
                    //                             width: 2.5.w,
                    //                           ),
                    //                           GestureDetector(
                    //                             onTap: () async{
                    //                               //model.getMatchedUserData = (model.acceptMatchedtModel[index]);
                    //                               if(widget.fromUser == true){
                    //                                 await model.getAnitherUserInfo(widget.id.toString());
                    //                                 model.navigateToMatchedProfileUser();
                    //                               }
                    //                               else if(widget.fromUser == false){
                    //                                 List myBars = [];
                    //                                 model.selectedBar = model.listOfAllBars.where((element) => element.id == widget.id).first;
                    //                                 //print(myBars);
                    //                                 //myBars.add(model.listOfAllBars.map((e) => e.id == widget.id));
                    //                                 // myBars.add(model.listOfAllBars.contains(widget.id));
                    //                                 print(myBars);
                    //                                 model.navigateToBarProfile();
                    //                               }
                    //                             },
                    //                             child: Stack(
                    //                               alignment: Alignment.topCenter,
                    //                               children: [
                    //                                 CircleAvatar(
                    //                                   radius: 26.0,
                    //                                   backgroundImage: NetworkImage(
                    //                                       widget.profilePic ??
                    //                                           "https://tse2.mm.bing.net/th?id=OIP.4gcGG1F0z6LjVlJjYWGGcgHaHa&pid=Api&P=0&w=164&h=164"),
                    //                                   backgroundColor:
                    //                                       Colors.transparent,
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ),
                    //                           SizedBox(
                    //                             width: 3.w,
                    //                           ),
                    //                           Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment.start,
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.start,
                    //                             children: [
                    //                               Text(
                    //                                 widget.username.toString(),
                    //                                 style: TextStyle(
                    //                                     fontFamily:
                    //                                         FontUtils.modernistBold,
                    //                                     fontSize: 1.9.t,
                    //                                     color:
                    //                                         ColorUtils.text_dark),
                    //                               ),
                    //                               SizedBox(
                    //                                 height: 0.5.h,
                    //                               ),
                    //                               Text(
                    //                                 "Active",
                    //                                 style: TextStyle(
                    //                                     fontFamily:
                    //                                         FontUtils.modernistBold,
                    //                                     fontSize: 1.5.t,
                    //                                     color:
                    //                                         ColorUtils.activeColor),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     IconButton(
                    //                       onPressed: () {
                    //                         if (model.openBurgerMenu == false) {
                    //                           model.openBurgerMenu = true;
                    //                           model.notifyListeners();
                    //                         } else if (model.openBurgerMenu ==
                    //                             true) {
                    //                           model.openBurgerMenu = false;
                    //                           model.notifyListeners();
                    //                         }
                    //                       },
                    //                       icon: SvgPicture.asset(
                    //                           ImageUtils.chatMenuIcon),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 1.h,
                    //             ),
                    //             Container(
                    //               padding: EdgeInsets.only(bottom: 2.h, top: 3.h),
                    //               height: 75.h,
                    //               child: ListView.separated(
                    //                   physics: BouncingScrollPhysics(),
                    //                   controller: model.chatScroll,
                    //                   itemBuilder: (context, index) {
                    //                     return Align(
                    //                       child: Container(
                    //                         width:
                    //                             MediaQuery.of(context).size.width /
                    //                                 1.7,
                    //                         decoration: BoxDecoration(
                    //                           color: ColorUtils.red_color.withOpacity(0.9),
                    //                           borderRadius: model.chats[index]
                    //                                       ["userID"] ==
                    //                                   model.barModel!.id!.toString()
                    //                               ? BorderRadius.only(
                    //                                   topLeft: Radius.circular(15),
                    //                                   topRight: Radius.circular(15),
                    //                                   bottomLeft:
                    //                                       Radius.circular(15),
                    //                                 )
                    //                               : BorderRadius.only(
                    //                                   topLeft: Radius.circular(15),
                    //                                   topRight: Radius.circular(15),
                    //                                   bottomRight:
                    //                                       Radius.circular(15),
                    //                                 ),
                    //                         ),
                    //                         child: Column(
                    //                           crossAxisAlignment: model.chats[index]
                    //                                       ["userID"] ==
                    //                                   model.barModel!.id!.toString()
                    //                               ? CrossAxisAlignment.end
                    //                               : CrossAxisAlignment.start,
                    //                           children: [
                    //                             // Padding(
                    //                             //   padding: EdgeInsets.symmetric(
                    //                             //       horizontal: 3.w,
                    //                             //       vertical: 1.5.h),
                    //                             //   child: Image.asset(
                    //                             //     ImageUtils.drinkImage,
                    //                             //   ),
                    //                             // ),
                    //                             Padding(
                    //                               padding: EdgeInsets.only(
                    //                                   left: 3.w,
                    //                                   right: 3.w,
                    //                                   top: 1.5.h),
                    //                               child: Text(
                    //                                 model.chats[index]["content"]
                    //                                     .toString(),
                    //                                 style: TextStyle(
                    //                                     //fontFamily: FontUtils.avertaDemoRegular,
                    //                                     fontSize: 1.8.t,
                    //                                     color:
                    //                                         ColorUtils.white),
                    //                               ),
                    //                             ),
                    //                             //SizedBox(height: 1.h,),
                    //                             Align(
                    //                               alignment: model.chats[index]
                    //                                           ["userID"] ==
                    //                                       model.barModel!.id!
                    //                                           .toString()
                    //                                   ? Alignment.centerLeft
                    //                                   : Alignment.centerRight,
                    //                               child: Padding(
                    //                                 padding: EdgeInsets.all(8.0),
                    //                                 child: Text(
                    //                                   model.chats[index]["time"].toString().substring(11,16),
                    //                                   style: TextStyle(
                    //                                       //fontFamily: FontUtils.avertaDemoRegular,
                    //                                       fontSize: 1.5.t,
                    //                                       color: ColorUtils
                    //                                           .icon_color),
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //
                    //               ]),
                    //
                    //
                    //              // : InkWell(
                    //              //    onTap: () async {
                    //              //      // NewBarModel barUser =
                    //              //      //     (await locator<PrefrencesViewModel>()
                    //              //      //         .getBarUser())!;
                    //              //      UserModel User =
                    //              //          (await locator<PrefrencesViewModel>()
                    //              //              .getUser())!;
                    //              //      // model.chat();
                    //              //      model.pubnub!.publish(
                    //              //          model.getConversationID(User.id.toString(), widget.id.toString()),
                    //              //          {
                    //              //            "content": model.groupScreenChatController.text,
                    //              //            "userID": User.id!.toString(),
                    //              //            "time": DateTime.now().toString()
                    //              //          });
                    //              //          // model.pubnub!.files.publishFileMessage(model.getConversationID(barUser.id.toString(), widget.id.toString()), FileMessage(file));
                    //              //      model.groupScreenChatController.clear();
                    //              //      model.notifyListeners();
                    //              //      Future.delayed(Duration(seconds: 2), () {
                    //              //      model.scrollDown();
                    //              //      });
                    //              //    },
                    //              //    child: Container(
                    //              //      //margin: EdgeInsets.only(bottom: 2.2.h),
                    //              //      decoration: BoxDecoration(
                    //              //        shape: BoxShape.circle,
                    //              //        color: ColorUtils.text_red,
                    //              //      ),
                    //              //      child: Padding(
                    //              //        padding: const EdgeInsets.all(15.0),
                    //              //        child: SvgPicture.asset(
                    //              //          ImageUtils.sendIcon1,
                    //              //          color: Colors.white,
                    //              //        ),
                    //              //      ),
                    //              //    ),
                    //              //  ),
                    //         ))],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //
                    //   ],
                    // ),
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

  ChatImageWidget({Key? key, this.index, this.id}) : super(key: key);

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
        getFileUrl(model);
      },
      builder: (context, model,child){
        return Align(
          alignment: model. chats[widget.index!]["message"]["userID"] !=
              model.userModel!.id!
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
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
                  padding: EdgeInsets.only(
                      left: 3.w,
                      right: 3.w,
                      top: 1.5.h),
                  child: Image.network(
                    uri.toString(),
                    // height: 30.h,
                    // width: 50.w,
                    fit: BoxFit.cover,
                  ),
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
  void getFileUrl (MainViewModel model)async{
    print(model.chats[widget.index!]);
    //var fileInfo = widget.ImageData;
    uri = await model.pubnub!.files.getFileUrl(
      model.getConversationID(
          model.userModel!.id.toString(),
          widget.id.toString()
      ),
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
        // model.userModel;
      },
      builder: (context, model,child){
        return Align(
          alignment: model.chats[widget.index!]["${model.userModel!.id}"] ==
              model.userModel!.id!
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width:
            MediaQuery.of(context).size.width /
                1.7,
            decoration: BoxDecoration(
              color: model.chats[widget.index!]["${model.userModel!.id}"] ==
                  model.userModel!.id!?ColorUtils.red_color.withOpacity(0.5):ColorUtils.messageChat,
              borderRadius: model.chats[widget.index!]
              ["${model.userModel!.id}"] ==
                  model.userModel!.id!
                  ? BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft:
                Radius.circular(15),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight:
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: model.chats[widget.index!]
              ["${model.userModel!.id}"] ==
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
                Padding(
                    padding: EdgeInsets.only(
                        left: 3.w,
                        right: 3.w,
                        top: 1.5.h),
                    child: Text(
                      model.chats[widget.index!]["content"]
                          .toString(),
                      style: TextStyle(
                        //fontFamily: FontUtils.avertaDemoRegular,
                          fontSize: 1.8.t,
                          color:
                          model.chats[widget.index!]["${model.userModel!.id}"] ==
                              model.userModel!.id!?ColorUtils.white:ColorUtils.text_dark),
                    )
                ),
                //SizedBox(height: 1.h,),

                Align(
                  alignment: model.chats[widget.index!]
                  ["${model.userModel!.id}"] ==
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
                          color: model.chats[widget.index!]["${model.userModel!.id}"] ==
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
}

///------------------ Chat Video---------------------------------///

class ChatVideoWidget extends StatefulWidget {
  int? index;
  String? id;

  ChatVideoWidget({Key? key, this.index, this.id}) : super(key: key);

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
    _betterPlayerController!.dispose();
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
        getFileUrl(model);
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
  void getFileUrl (MainViewModel model)async{
    print(model.chats[widget.index!]);
    //var fileInfo = widget.ImageData;
    uri = await model.pubnub!.files.getFileUrl(
      model.getConversationID(
          model.userModel!.id.toString(),
          widget.id.toString()
      ),
      model.chats[widget.index!]["file"]["id"],
      model.chats[widget.index!]["file"]["name"],

    );
    image  = await VideoThumbnail.thumbnailData(video: uri.toString(),imageFormat: ImageFormat.JPEG);
    setState(() {

    });
  }
}


///--------------------- Chat Audio ----------------------///

class ChatAudioWidget extends StatefulWidget {
  int? index;
  String? id;

  ChatAudioWidget({Key? key, this.index, this.id}) : super(key: key);

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
                      1.25,
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
                );
              },
            )
        );
      },
      onModelReady: (model){
        getFileUrl(model);
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
  void getFileUrl (MainViewModel model)async{
    print(model.chats[widget.index!]);
    //var fileInfo = widget.ImageData;
    uri = await model.pubnub!.files.getFileUrl(
      model.getConversationID(
          model.userModel!.id.toString(),
          widget.id.toString()
      ),
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

  ChatFileWidget({Key? key, this.index, this.id}) : super(key: key);

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
                          Row(
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
                                      color:
                                      model.chats[widget.index!]["message"]["userID"] ==
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
        getFileUrl(model);
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
  void getFileUrl (MainViewModel model)async{
    print(model.chats[widget.index!]);
    //var fileInfo = widget.ImageData;
    uri = await model.pubnub!.files.getFileUrl(
      model.getConversationID(
          model.userModel!.id.toString(),
          widget.id.toString()
      ),
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


