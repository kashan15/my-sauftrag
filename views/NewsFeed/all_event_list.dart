import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:stacked/stacked.dart';

class AllEventList extends StatefulWidget {
  const AllEventList({Key? key}) : super(key: key);

  @override
  _AllEventListState createState() => _AllEventListState();
}

class _AllEventListState extends State<AllEventList> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: Dimensions.topMargin),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontalPadding),
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
                        "All Events",
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 3.t,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      dynamic time = model.barEventModel![index].startTime;
                      time = time.toString().split(':00');
                      print(time);
                      return GestureDetector(
                        onTap: () {
                          model.navigationService.navigateToEventDetailScreen(model.barEventModel?[index].media?[0].media ??'',model.barEventModel![index].name,model.barEventModel![index].eventDate,model.barEventModel![index].startTime,model.barEventModel![index].endTime,model.barEventModel![index].location,model.barEventModel![index].about,model.barEventModel![index]..userId!.username,model.barEventModel![index].userId!.profilePicture);

                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 4,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorUtils.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 5), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              border: Border.all(color: ColorUtils.red_color),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 2.h),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          model.barEventModel?[index].media?[0]
                                              .media,
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
                                            model.barEventModel![index]
                                                    .eventDate +
                                                ' -' +
                                                time[0],
                                            style: TextStyle(
                                                fontFamily:
                                                    FontUtils.modernistRegular,
                                                fontSize: 1.7.t,
                                                color: ColorUtils.text_red),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Text(
                                            model.barEventModel![index].name,
                                            style: TextStyle(
                                                fontFamily:
                                                    FontUtils.modernistBold,
                                                fontSize: 2.2.t,
                                                color: ColorUtils.black),
                                          ),
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                  ImageUtils.location_icon),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Container(
                                                width: 50.w,
                                                child: Text(
                                                  model.barEventModel![index]
                                                      .location,
                                                  style: TextStyle(
                                                      fontFamily: FontUtils
                                                          .modernistRegular,
                                                      fontSize: 1.7.t,
                                                      color:
                                                          ColorUtils.text_dark),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: SizeConfig.heightMultiplier * 2.5,
                      );
                    },
                    itemCount: model.barEventModel!.length,
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
