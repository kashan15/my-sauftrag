import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/app_localization.dart';

class RatingList extends StatefulWidget {
  const RatingList({Key? key}) : super(key: key);

  @override
  _RatingListState createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      onModelReady: (model){
        model.getRankingList(context);
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics:  BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.topMargin),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                model.navigationService.navigateBack();
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
                            AppLocalizations.of(
                                context)!
                                .translate('ranking_list_text_1')!,
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontFamily: FontUtils.modernistBold,
                              fontSize: 3.t,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),

                      ///--------------Event Name--------------------///
                      Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 9.w),
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Column(
                                        children: [
                                          Text("2", style: TextStyle(
                                            color: ColorUtils.black,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 2.5.t,
                                          ),),
                                          SizedBox(height: 0.8.h,),
                                          Image.asset(ImageUtils.polygon, height: 1.2.h,),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1.w,color: ColorUtils.red_color),
                                                shape: BoxShape.circle
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(90),
                                                child: (model.rankingModel!.length)>=1?CachedNetworkImage(
                                                  height:11.h,
                                                  width: 24.w,
                                                  fit: BoxFit.cover,
                                                  imageUrl: model.rankingModel?[1].profilePicture,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      Image.asset(ImageUtils.dummyImage,  height:13.h,
                                                        width: 30.w,),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    ImageUtils.dummyImage,
                                                    height:13.h,
                                                    width: 30.w,
                                                  ),
                                                )
                                                    :
                                                Image.asset(ImageUtils.dummyImage,height:11.h,
                                                  width: 24.w,
                                                  fit: BoxFit.cover,)
                                            ),),
                                          Container(
                                            width: 13.w,
                                            child: Text((model.rankingModel!.length)>=2?"${model.rankingModel?[1].username}":"",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: ColorUtils.black,
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.8.t,
                                              ),),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text((model.rankingModel!.length)>=2?"${model.rankingModel?[1].points}":"", style: TextStyle(
                                                color: ColorUtils.red_color,
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.8.t,
                                              ),),
                                              SizedBox(width: 1.w,),
                                              if((model.rankingModel!.length)>=2)Image.asset(ImageUtils.coinImg)
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 8.h),
                                      child: Column(
                                        children: [
                                          Text("3", style: TextStyle(
                                            color: ColorUtils.black,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 2.5.t,
                                          ),),
                                          Image.asset(ImageUtils.polygon,height: 1.2.h, ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1.w,color: ColorUtils.red_color),
                                                shape: BoxShape.circle
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(90),
                                              child: (model.rankingModel!.length)>=3?CachedNetworkImage(
                                                height:11.h,
                                                width: 24.w,
                                                fit: BoxFit.cover,
                                                imageUrl: model.rankingModel?[2].profilePicture,
                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                    Image.asset(ImageUtils.dummyImage,  height:13.h,
                                                      width: 30.w,),
                                                errorWidget: (context, url, error) => Image.asset(
                                                  ImageUtils.dummyImage,
                                                  height:13.h,
                                                  width: 30.w,
                                                ),
                                              )
                                                  :
                                              Image.asset(ImageUtils.dummyImage,height:11.h,
                                                width: 24.w,
                                                fit: BoxFit.cover,),
                                            ),),
                                          Container(
                                            width: 13.w,
                                            child: Text((model.rankingModel!.length)>=3?"${model.rankingModel?[2].username}":"",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: ColorUtils.black,
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.8.t,
                                              ),),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("${(model.rankingModel!.length)>=3?model.rankingModel![2].points:""}", style: TextStyle(
                                                color: ColorUtils.red_color,
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.8.t,
                                              ),),
                                              SizedBox(width: 1.w,),
                                              if((model.rankingModel!.length)>=3)Image.asset(ImageUtils.coinImg)
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          // SizedBox(height: 2.8.h,),
                                          Text("1", style: TextStyle(
                                            color: ColorUtils.black,
                                            fontFamily: FontUtils.modernistBold,
                                            fontSize: 2.5.t,
                                          ),),
                                          // SizedBox(height: 1.h,),
                                          Image.asset(ImageUtils.bottleRank, height: 4.h,),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1.w,color: ColorUtils.red_color),
                                                shape: BoxShape.circle
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(90),
                                                child: (model.rankingModel!.length)>=1?CachedNetworkImage(
                                                  height:13.h,
                                                  width: 28.w,
                                                  fit: BoxFit.cover,
                                                  imageUrl: model.rankingModel?[0].profilePicture,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      Image.asset(ImageUtils.dummyImage, height:18.h,
                                                        width: 35.w,),
                                                  errorWidget: (context, url, error) => Image.asset(ImageUtils.dummyImage, height:18.h,
                                                    width: 35.w,),
                                                ):
                                                Image.asset(ImageUtils.dummyImage,height:13.h,
                                                  width: 28.w,
                                                  fit: BoxFit.cover,)
                                            ),),
                                          Container(
                                            width: 25.w,
                                            child: Center(
                                              child: Text("${(model.rankingModel!.length)>=1?model.rankingModel![0].username:""}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: ColorUtils.black,
                                                  fontFamily: FontUtils.modernistBold,
                                                  fontSize: 1.8.t,
                                                  overflow: TextOverflow.ellipsis
                                                ),),
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text((model.rankingModel!.length)>=1?"${model.rankingModel?[0].points}":"", style: TextStyle(
                                                color: ColorUtils.red_color,
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.8.t,
                                              ),),
                                              SizedBox(width: 1.w,),
                                              if((model.rankingModel!.length)>=1)Image.asset(ImageUtils.coinImg)
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 3.h,
                      ),

                      ///--------------Settings Options--------------------///

                      if((model.rankingModel!.length)>=4)ListView.separated(
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            // decoration: BoxDecoration(
                            //   boxShadow: [
                            //     BoxShadow(
                            //       color: ColorUtils.black.withOpacity(0.1),
                            //       spreadRadius: 0,
                            //       blurRadius: 10,
                            //       offset: Offset(0, 5), // changes position of shadow
                            //     ),
                            //   ],
                            //   color: Colors.white,
                            //   borderRadius: BorderRadius.all(Radius.circular(18)),
                            //   border: Border.all(color: ColorUtils.red_color),
                            // ),
                              child:  Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${index+4}',
                                    style: TextStyle(
                                        fontFamily: FontUtils.modernistRegular,
                                        fontSize: 2.t,
                                        color: ColorUtils.red_color),
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 5.w),
                                      decoration: BoxDecoration(
                                        color: ColorUtils.searchFieldColor,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(25),
                                                child: CachedNetworkImage(
                                                  width: 12.i,
                                                  height: 12.i,
                                                  fit: BoxFit.cover,
                                                  imageUrl: model.rankingModel?[index+3].profilePicture,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      Image.asset(ImageUtils.dummyImage, width: 12.i,
                                                        height: 12.i,),
                                                  errorWidget: (context, url, error) => Image.asset(ImageUtils.dummyImage, width: 12.i,
                                                    height: 12.i,),
                                                ),
                                              ),


                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Text(model.rankingModel?[index+3].username,
                                                style: TextStyle(
                                                    fontFamily: FontUtils.modernistBold,
                                                    fontSize: 2.t,
                                                    color: ColorUtils.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('${model.rankingModel?[index+3].points??'0'}',
                                                style: TextStyle(
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 2.t,
                                                    color: ColorUtils.red_color),
                                              ),
                                              SizedBox(width: 1.w,),
                                              Image.asset(ImageUtils.coinImg)
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height:  SizeConfig.heightMultiplier * 2.5,);
                        },
                        itemCount: (model.rankingModel?.length)! -3,
                      ),
                      SizedBox(
                        height: 3.h,
                      ),



                    ],
                  ),
                ),
              )
            ),
          ),
        );
      },
    );
  }
}
