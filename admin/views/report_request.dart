import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:stacked/stacked.dart';

import '../../app/locator.dart';
import '../../utils/color_utils.dart';
import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';
import '../../utils/image_utils.dart';
import '../../utils/size_config.dart';
import '../../viewModels/main_view_model.dart';
import '../../widgets/all_page_loader.dart';
import '../../widgets/rating_dialog_box.dart';

class ReportRequests extends StatefulWidget {
  String? username;
  String? email;

  ReportRequests({Key? key, this.username, this.email}) : super(key: key);

  @override
  _ReportRequestsState createState() => _ReportRequestsState();
}

class _ReportRequestsState extends State<ReportRequests> {

  List reportList = [
  {
  'name': "John",
  'message': "How are you",
  'time': "Today",
    'address': "New york",
  'image': ImageUtils.logo,
  'online': true,
},
    {
      'name': "John",
      'message': "How are you",
      'time': "Today",
      'address': "New york",
      'image': ImageUtils.logo,
      'online': true,
    },

    {
      'name': "John",
      'message': "How are you",
      'time': "Today",
      'address': "New york",
      'image': ImageUtils.logo,
      'online': true,
    },
    {
      'name': "John",
      'message': "How are you",
      'time': "Today",
      'address': "New york",
      'image': ImageUtils.logo,
      'online': true,
    },

    {
      'name': "John",
      'message': "How are you",
      'time': "Today",
      'address': "New york",
      'image': ImageUtils.logo,
      'online': true,
    },
    {
      'name': "John",
      'message': "How are you",
      'time': "Today",
      'address': "New york",
      'image': ImageUtils.logo,
      'online': true,
    },
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
      onModelReady: (model) {
        //model.followers();
        model.barModel;
        model.isFaqs=false;
        // model.getAllUserForChat();
        // model.getListOfAllBars();
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return model.isFaqs ? AllPageLoader()
            : SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: Dimensions.topMargin),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding),

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
                        "Report Requests",
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 3.t,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h,),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal:SizeConfig.widthMultiplier * 4,),
                        child: GestureDetector(
                          onTap: (){
                            // model.barId = model.listOfBar[index].id;
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder:
                                    (BuildContext context) {
                                  return ReportChatDialogBox(
                                    // name: widget.username,email: widget.email,
                                    name: reportList[index]["name"], email: reportList[index]["address"],
                                  );
                                });
                            model.selectedBar = (model.listOfAllBarsRequest[index]);
                            model.barIndex = index;
                            model.notifyListeners();
                            model.navigateToBarProfileTwo();
                            // model.navigateToBarProfile();
                            //model.myNavigationService.navigateTo(to: Barprofile());
                            //model.navigationService.navigateToBarProfile();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric( horizontal: 2.5.w, vertical: 1.5.h),
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
                              border: Border.all(color: ColorUtils.text_red),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                  SvgPicture.asset(reportList[index]["image"],
                                  // child: model.listOfAllBarsRequest[index].profile_picture == null ?
                                  // ,SvgPicture.asset(ImageUtils.logo)
                                  //     : Image.network(model.listOfAllBarsRequest[index].profile_picture!,
                                    width: 15.i,
                                    height: 15.i,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 2.w,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            // model.listOfAllBarsRequest[index].bar_name!,
                                            reportList[index]["name"],
                                            // model.barsList[index].bar_name!,
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistBold,
                                                fontSize: 1.9.t,
                                                color: ColorUtils.black
                                            ),
                                          ),
                                          SizedBox(width: 1.w,),
                                          // Text(model.listOfBar[index].bar_kind!.toString(),
                                          //   style: TextStyle(
                                          //       fontFamily: FontUtils.modernistRegular,
                                          //       fontSize: 1.6.t,
                                          //       color: ColorUtils.red_color
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      SizedBox(height: 0.8.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(ImageUtils.locationPin,),
                                          SizedBox(width: 1.5.w,),
                                          Container(
                                            width: 50.w,
                                            child: Text(
                                              // model.listOfAllBarsRequest[index].address!,
                                              reportList[index]["address"],
                                              // model.barsList[index].address!,
                                              style: TextStyle(
                                                fontFamily: FontUtils.modernistRegular,
                                                fontSize: 1.6.t,
                                                color: ColorUtils.text_grey,
                                              ),

                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 0.8.h,),
                                      // RatingBar.builder(
                                      //   tapOnlyMode: false,
                                      //   ignoreGestures: true,
                                      //   initialRating:
                                      //   model.listOfAllBars[index].total_ratings ?? 0.0,
                                      //   // model.barsList[index].total_ratings ?? 0.0,
                                      //   // minRating: 1,
                                      //   direction: Axis.horizontal,
                                      //   allowHalfRating: true,
                                      //   itemCount: 5,
                                      //   itemSize: 4.5.i,
                                      //   itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                      //   itemBuilder: (context, _) => Icon(
                                      //     Icons.star_rounded,
                                      //     color: ColorUtils.red_color,
                                      //   ),
                                      //   onRatingUpdate: (rating) {
                                      //     print(rating);
                                      //   },
                                      // ),
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
                      return SizedBox(height:  SizeConfig.heightMultiplier * 2.5,);
                    },
                    // itemCount: model.listOfAllBarsRequest.length,
                    itemCount: reportList.length,
                    // itemCount: model.barsList.length,
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
