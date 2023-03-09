import 'package:expand_tap_area/expand_tap_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/admin/views/report_request.dart';
import 'package:sauftrag/bar/views/Auth/signUp.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/widgets/my_side_menu_admin.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:stacked/stacked.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:get_it/get_it_impl.dart';


import '../../app/locator.dart';
import '../../bar/widgets/my_side_menu.dart';
import '../../models/listOfFollowing_Bars.dart';
import '../../utils/app_language.dart';
import '../../utils/app_localization.dart';
import '../../utils/color_utils.dart';
import '../../utils/dimensions.dart';
import '../../utils/font_utils.dart';
import '../../utils/image_utils.dart';
import '../../viewModels/main_view_model.dart';
import '../../widgets/all_page_loader.dart';
import '../../widgets/dialog_event.dart';
import '../Home/match _one.dart';
import '../Home/widget_two.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
NavigationViewModel mymodel = locator<NavigationViewModel>();

  @override
  Widget build(BuildContext context) {
    // final locator = GetIt.instance;
    // locator<ListOfBarsModel>();
    // locator<PrefrencesViewModel>();
    return ViewModelBuilder<MainViewModel>.reactive(
        viewModelBuilder: () => locator<MainViewModel>(),

        disposeViewModel: false,
        //fireOnModelReadyOnce: true,
        onModelReady: (model) async {

          model.getUserData();
          //model.getDrinkStatus();
          //model.getListOfAllBars();
          await model.getAllUserForChat();
          model.getAllReports();
          model.listOfAllBarsRequest.clear();
          model.listOfAllBarsRequest.addAll(model.listOfAllBars.where((element) => element.is_active==null || !element.is_active!));
          model.listOfAllBars.removeWhere((element) => element.is_active==null || !element.is_active!);
         await model.getNotification(context);

          model.notifyListeners();
          // model.prefrencesViewModel.getUser();
          // model.usersList.length.toString();
        },


        builder: (context, model, child) {
          return model.isPost == true
              ? AllPageLoader()
            :
          SafeArea(
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
          menu: MySideMenuAdmin(),
          child: GestureDetector(
          onTap: () {
          final _state = model.sideMenuKey.currentState;
          if (_state!.isOpened)
          _state.closeSideMenu(); // close side menu
          },
              child: Scaffold(
                key: _scaffoldKey,
                body: Material(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.h,
                      ),

                      Container(
                        margin: EdgeInsets.only(
                            left: 1.5.w, right: 4.w),
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        final _state = model
                                            .sideMenuKey
                                            .currentState;
                                        if (_state!.isOpened)
                                          _state
                                              .closeSideMenu(); // close side menu
                                        else
                                          _state.openSideMenu();
                                      },
                                      child: SvgPicture.asset(
                                          ImageUtils.menuIcon),
                                      style: ElevatedButton
                                          .styleFrom(
                                        primary: ColorUtils.white,
                                        onPrimary: ColorUtils.white,
                                        padding: EdgeInsets
                                            .symmetric(
                                            vertical:
                                            Dimensions
                                                .containerVerticalPadding),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(
                                                Dimensions
                                                    .roundCorner),
                                            side: BorderSide(
                                                color: ColorUtils
                                                    .divider,
                                                width: 1)),
                                        textStyle: TextStyle(
                                          color: ColorUtils.white,
                                          fontFamily: FontUtils
                                              .modernistBold,
                                          fontSize: 1.8.t,
                                          //height: 0
                                        ),
                                      ),
                                    ),

                                    // Text(
                                    //   "Dashboard",
                                    //   style: TextStyle(
                                    //       color: ColorUtils.black,
                                    //       fontFamily: FontUtils.modernistBold,
                                    //       fontSize: 2.5.t),
                                    // )


                                  ]),
                              IconButton(
                                onPressed: () {
                                  model.getAllUserForChat();
                                },
                                icon: SvgPicture.asset(
                                  ImageUtils.notification,
                                  color: Colors.blue,
                                ),
                              ),

                            ]),


                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 4.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    SizedBox(
                                      height: 1.5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          "Dashboard",
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FontUtils
                                                .modernistBold,
                                            fontSize: 4.t,
                                            color: ColorUtils
                                                .red_color,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3.h,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              // model.getAllUserForChat();
                                              model.navigateToDashboardExpandUserScreen();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorUtils
                                                    .users,
                                                shape: BoxShape
                                                    .rectangle,
                                                borderRadius: const BorderRadius
                                                    .all(Radius
                                                    .circular(6)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets
                                                    .only(top: 2.5
                                                    .h, bottom: 2.5
                                                    .h),
                                                child: Column(
                                                  children: [
                                                    SvgPicture
                                                        .asset(
                                                        ImageUtils
                                                            .matchIcon),
                                                    SizedBox(
                                                      height: 3.h,),
                                                    Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 3
                                                                .w),
                                                        child: Text(
                                                          "Total Users",
                                                          style: TextStyle(
                                                            fontFamily: FontUtils
                                                                .modernistBold,
                                                            // color: ColorUtils.icon_color,
                                                            color: ColorUtils
                                                                .red_color,
                                                            // fontSize: 1.6.t,
                                                            fontSize: 2
                                                                .t,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.5
                                                          .h,),

                                                    Padding(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 3
                                                              .w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text(

                                                            // model.totalUsers![0],
                                                            // "45",
                                                            // '${model.userForChats.length}',
                                                            model.usersList.length.toString(),
                                                            // model.usersList.length.toString(),

                                                            style: TextStyle(
                                                              fontFamily: FontUtils
                                                                  .modernistBold,
                                                              color: ColorUtils
                                                                  .blackText,
                                                              fontSize: 3.0
                                                                  .t,
                                                            ),
                                                          ),
                                                          // Text("90%",
                                                          //   style: TextStyle(
                                                          //     fontFamily: FontUtils.avertaDemoRegular,
                                                          //     color: ColorUtils.upward,
                                                          //     fontSize: 1.6.t,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 4.w,),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              //model.navigateToDashboardExpandScreen();
                                              model.navigateToDashboardExpandBarScreen();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorUtils.bars,
                                                shape: BoxShape
                                                    .rectangle,
                                                borderRadius: const BorderRadius
                                                    .all(Radius
                                                    .circular(6)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets
                                                    .only(top: 2.5
                                                    .h, bottom: 2.5
                                                    .h),
                                                child: Column(
                                                  children: [
                                                    SvgPicture
                                                        .asset(
                                                        ImageUtils
                                                            .matchIcon),
                                                    SizedBox(
                                                      height: 3.h,),
                                                    Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 3
                                                                .w),
                                                        child: Text(
                                                          "Total Bars",
                                                          style: TextStyle(
                                                            fontFamily: FontUtils
                                                                .modernistBold,
                                                            // color: ColorUtils.icon_color,
                                                            color: ColorUtils
                                                                .red_color,
                                                            // fontSize: 1.6.t,
                                                            fontSize: 2
                                                                .t,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.5
                                                          .h,),
                                                    Align(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left: 3
                                                                .w),
                                                        child: Text(
                                                          // model.totalSurveys![0],
                                                          // "14",
                                                          //model.barsList.length.toString(),
                                                          model.listOfAllBars.length.toString(),

                                                          style: TextStyle(
                                                            fontFamily: FontUtils
                                                                .modernistBold,
                                                            color: ColorUtils
                                                                .blackText,
                                                            fontSize: 3.0
                                                                .t,
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
                                    SizedBox(height: 4.h,),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.w),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              "Bar Requests",
                                              style: TextStyle(
                                                fontFamily: FontUtils
                                                    .modernistBold,
                                                color: ColorUtils
                                                    .red_color,
                                                fontSize: 3.0.t,
                                              ),
                                            ),
                                            ExpandTapWidget(
                                              onTap: () {
                                                // model.navigateToDashboardExpandBarScreen();
                                                model.navigateToDashboardRequestBarScreen();

                                              },
                                              tapPadding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 2.w,
                                                  vertical: 2.h),
                                              child: Text(
                                                "see all",
                                                style: TextStyle(
                                                  shadows: [
                                                    Shadow(
                                                        color: ColorUtils
                                                            .red_color,
                                                        offset: Offset(
                                                            0, -1))
                                                  ],
                                                  color: Colors
                                                      .transparent,
                                                  decoration:
                                                  TextDecoration
                                                      .underline,
                                                  decorationColor: ColorUtils
                                                      .red_color,
                                                  //decorationThickness: 4,
                                                ),
                                              ),
                                            )
                                          ]
                                      ),
                                    ),
                                    SizedBox(height: 2.h,),
                                    GestureDetector(
                                      onTap: (){
                                        model.navigateToDashboardRequestBarScreen();
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 1,
                                        decoration: BoxDecoration(
                                            color: ColorUtils.provinceColor,
                                            shape: BoxShape.rectangle,
                                            borderRadius: const BorderRadius
                                                .all(
                                                Radius.circular(6)),
                                            boxShadow: [
                                              // BoxShadow(
                                              // color: Colors.grey.withOpacity(0.5),
                                              // spreadRadius: 3,
                                              // blurRadius: 5,
                                              // offset: Offset(0, 3),
                                              // ),
                                            ]),
                                        child: Padding(
                                          padding: EdgeInsets
                                              .symmetric(
                                              vertical: 2.5.h),
                                          child:
                                          Column(
                                            children: [
                                              //   SvgPicture.asset(
                                              // ImageUtils.notification),
                                              //   SizedBox(height: 3.h,),
                                              Padding(
                                                padding: EdgeInsets
                                                    .only(left: 3.w),
                                                child: Center(
                                                  child: Text(
                                                    // "39",
                                                    model.listOfAllBarsRequest.length.toString(),
                                                    style: TextStyle(
                                                      fontFamily: FontUtils
                                                          .modernistBold
                                                      ,
                                                      color: ColorUtils.black,
                                                      fontSize: 3.t,
                                                    ),
                                                    // textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 4.h,),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.w),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Report Requests",
                                              style: TextStyle(
                                                fontFamily: FontUtils
                                                    .modernistBold,
                                                color: ColorUtils
                                                    .red_color,
                                                fontSize: 3.0.t,
                                              ),
                                            ),
                                            ExpandTapWidget(
                                              onTap: () {
                                                model.navigateToDashboardAllReportsScreen();
                                                //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportRequests(
                                                //  )));
                                                //model.navigateToDashboardRequestScreen();
                                              },
                                              tapPadding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 2.w,
                                                  vertical: 2.h),
                                              child: Text(
                                                "see all",
                                                style: TextStyle(
                                                  shadows: [
                                                    Shadow(
                                                        color: ColorUtils
                                                            .red_color,
                                                        offset: Offset(
                                                            0, -1))
                                                  ],
                                                  color: Colors
                                                      .transparent,
                                                  decoration:
                                                  TextDecoration
                                                      .underline,
                                                  decorationColor: ColorUtils
                                                      .red_color,
                                                  //decorationThickness: 4,
                                                ),
                                              ),
                                            )
                                          ]),
                                    ),

                                    SizedBox(height: 2.h,),
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1,
                                      decoration: BoxDecoration(
                                          color: ColorUtils
                                              .provinceColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius
                                              .all(
                                              Radius.circular(6)),
                                          boxShadow: [
                                            // BoxShadow(
                                            // color: Colors.grey.withOpacity(0.5),
                                            // spreadRadius: 3,
                                            // blurRadius: 5,
                                            // offset: Offset(0, 3),
                                            // ),
                                          ]),
                                      child: Padding(
                                        padding: EdgeInsets
                                            .symmetric(
                                            vertical: 2.5.h),
                                        child:
                                        Column(
                                          children: [
                                            //   SvgPicture.asset(
                                            // ImageUtils.notification),
                                            //   SizedBox(height: 3.h,),
                                            Padding(
                                              padding: EdgeInsets
                                                  .only(left: 3.w),
                                              child: Center(
                                                child: Text("${model.allReports.length}",
                                                  style: TextStyle(
                                                    fontFamily: FontUtils
                                                        .modernistBold
                                                    ,
                                                    color: ColorUtils.black,
                                                    fontSize: 3.t,
                                                  ),
                                                  // textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3.h,),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text("Donation",
                                    //       style: TextStyle(
                                    //         fontFamily: FontUtils.avertaBold,
                                    //         color: ColorUtils.darkText,
                                    //         fontSize: 2.7.t,
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       decoration: BoxDecoration(
                                    //         gradient: LinearGradient(
                                    //           colors:  [
                                    //             const Color(0xFF6182A5).withOpacity(0.6),
                                    //             ColorUtils.blueColor,
                                    //           ],
                                    //         ),
                                    //         shape: BoxShape.rectangle,
                                    //         borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    //       ),
                                    //       child: DropdownButtonHideUnderline (
                                    //         child: Padding(
                                    //           padding: EdgeInsets.only(left: 6.w,right: 4.w),
                                    //           child: DropdownButton<String>(
                                    //             dropdownColor: ColorUtils.blueColor,
                                    //             icon: const Icon(Icons.keyboard_arrow_down_outlined,
                                    //               color: Colors.white,
                                    //             ),
                                    //             // Not necessary for Option 1
                                    //             value: model.selectedCategory,
                                    //             style: TextStyle(
                                    //                 fontFamily: FontUtils.avertaDemoRegular,
                                    //                 fontSize: 1.56.t,
                                    //                 color: Colors.white
                                    //             ),
                                    //             onChanged: (value) {
                                    //               model.selectedCategory = value!;
                                    //               model.gettingDonations();
                                    //               model.notifyListeners();
                                    //             },
                                    //             items: categories.map((category) {
                                    //               return DropdownMenuItem(
                                    //                 child: Text(category!,
                                    //                   // style: TextStyle(
                                    //                   //   fontFamily: FontUtils.avertaDemoRegular,
                                    //                   //   fontSize: 1.56.t,
                                    //                   //     color: Colors.black
                                    //                   // ),
                                    //                 ),
                                    //                 value: category,
                                    //               );
                                    //             }).toList(),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(height: 3.h,),
                                    // if(model.selectedCategory == "Weekly")
                                    //   Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () async{
                                    //           model.weekDate = model.weekDate.subtract(Duration(days: 1));
                                    //           model.previousWeekDate = model.findFirstDateOfTheWeek(model.findFirstDateOfTheWeek(model.previousWeekDate).subtract(Duration(days: 1)));
                                    //           model.weekDate = model.findFirstDateOfTheWeek(model.weekDate);
                                    //           await model.gettingDonations();
                                    //           // model.stepSweekstoAdd = model.stepSweekstoAdd + 7;
                                    //           // model.stepSweekstoless = model.stepSweekstoless + 7;
                                    //           //model.getWeekData();
                                    //           model.notifyListeners();
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(8)),
                                    //             border: Border.all(color: ColorUtils.borderColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.9.h),
                                    //             child: SvgPicture.asset(ImageUtils.chevronLeft,
                                    //               width: 4.i,
                                    //               height: 4.i,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 2.5.w,),
                                    //       // Text("May 20-26, 2021",
                                    //       // style: TextStyle(
                                    //       //   fontFamily: FontUtils.avertaDemoRegular,
                                    //       //   color: ColorUtils.darkText,
                                    //       //   fontSize: SizeConfig.textMultiplier * 2,
                                    //       // ),
                                    //       // ),
                                    //       Text(DateFormat("MMMM d - ").
                                    //       format(model.findFirstDateOfTheWeek(model.weekDate))+
                                    //           DateFormat("MMMM d").
                                    //           format(model.findLastDateOfTheWeek(model.weekDate)),
                                    //         textAlign: TextAlign.start,style: TextStyle(
                                    //           color: ColorUtils.darkText,
                                    //           fontFamily: FontUtils.avertaDemoRegular,
                                    //           fontSize: SizeConfig.textMultiplier * 2,
                                    //         ),),
                                    //       SizedBox(width: 2.5.w,),
                                    //       InkWell(
                                    //         onTap: () async{
                                    //           if (model.findLastDateOfTheWeek(model.weekDate).isBefore(DateTime.now())) {
                                    //             model.weekDate =
                                    //                 model.findLastDateOfTheWeek(
                                    //                     model.weekDate);
                                    //             model.previousWeekDate =
                                    //                 model.findLastDateOfTheWeek(
                                    //                     model.findLastDateOfTheWeek(
                                    //                         model
                                    //                             .previousWeekDate)
                                    //                         .add(Duration(days: 1)));
                                    //             model.weekDate =
                                    //                 model.weekDate.add(
                                    //                     Duration(days: 1));
                                    //             await model.gettingDonations();
                                    //             // if (model.stepSweekstoAdd!=0){
                                    //             //   model.stepSweekstoAdd = model.stepSweekstoAdd - 7;
                                    //             // }
                                    //             // if(model.stepSweekstoless>7){
                                    //             //   model.stepSweekstoless = model.stepSweekstoless - 7;
                                    //             // }
                                    //             //model.getStepsWeekData();
                                    //             model.notifyListeners();
                                    //           }
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(8)),
                                    //             border: Border.all(color: ColorUtils.borderColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.9.h),
                                    //             child: SvgPicture.asset(ImageUtils.chevronRight,
                                    //               width: 4.i,
                                    //               height: 4.i,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //
                                    // if(model.selectedCategory == "monthly")
                                    //   Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: (){
                                    //           model.runningMonthName = model.months[model.months.indexOf(model.runningMonthName) - 1];
                                    //           model.runningMonth = model.months.indexOf(model.runningMonthName) + 1;
                                    //           model.runningMonthDate = Jiffy(model.runningMonthDate).subtract(months: 1).dateTime;
                                    //           model.gettingDonations();
                                    //           //model.getDataforMonth();
                                    //           model.notifyListeners();
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(8)),
                                    //             border: Border.all(color: ColorUtils.borderColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.9.h),
                                    //             child: SvgPicture.asset(ImageUtils.chevronLeft,
                                    //               width: 4.i,
                                    //               height: 4.i,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 2.5.w,),
                                    //       // Text("May 20-26, 2021",
                                    //       // style: TextStyle(
                                    //       //   fontFamily: FontUtils.avertaDemoRegular,
                                    //       //   color: ColorUtils.darkText,
                                    //       //   fontSize: SizeConfig.textMultiplier * 2,
                                    //       // ),
                                    //       // ),
                                    //       Text(
                                    //         DateFormat("MMMM").format(DateTime(DateTime.now().year,model.months.indexOf(model.runningMonthName) + 1))+" ${Utils.DateUtils.firstDayOfMonth(DateTime(DateTime.now().year,model.months.indexOf(model.runningMonthName) + 1)).day} - ${Utils.DateUtils.lastDayOfMonth(DateTime(DateTime.now().year,model.months.indexOf(model.runningMonthName) + 1)).day} ",
                                    //         textAlign: TextAlign.start,
                                    //         style: TextStyle(
                                    //             color: ColorUtils.darkText,
                                    //             fontFamily: FontUtils.avertaDemoRegular,
                                    //             fontSize: 13
                                    //         ),),
                                    //       SizedBox(width: 2.5.w,),
                                    //       InkWell(
                                    //         onTap: (){
                                    //           if (model.runningMonth != DateTime.now().month){
                                    //             model.runningMonthName = model.months[model.months.indexOf(model.runningMonthName)+1];
                                    //             model.runningMonth = model.months.indexOf(model.runningMonthName) + 1;
                                    //             model.runningMonthDate = Jiffy(model.runningMonthDate).add(months: 1).dateTime;
                                    //             model.gettingDonations();
                                    //             //model.getDataforMonth();
                                    //             model.notifyListeners();
                                    //           }
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(8)),
                                    //             border: Border.all(color: ColorUtils.borderColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.9.h),
                                    //             child: SvgPicture.asset(ImageUtils.chevronRight,
                                    //               width: 4.i,
                                    //               height: 4.i,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    //
                                    // if(model.selectedCategory == "yearly")
                                    //   Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: (){
                                    //           model.runningYear = model.runningYear -1;
                                    //           model.runningYearDate = Jiffy(model.runningYearDate).subtract(years: 1).dateTime;
                                    //           model.gettingDonations();
                                    //           //model.month = model.months.indexOf(model.selectedMonth)+1;
                                    //           //model.getDataforYear();
                                    //           model.notifyListeners();
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(8)),
                                    //             border: Border.all(color: ColorUtils.borderColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.9.h),
                                    //             child: SvgPicture.asset(ImageUtils.chevronLeft,
                                    //               width: 4.i,
                                    //               height: 4.i,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       SizedBox(width: 2.5.w,),
                                    //       // Text("May 20-26, 2021",
                                    //       // style: TextStyle(
                                    //       //   fontFamily: FontUtils.avertaDemoRegular,
                                    //       //   color: ColorUtils.darkText,
                                    //       //   fontSize: SizeConfig.textMultiplier * 2,
                                    //       // ),
                                    //       // ),
                                    //       Container(
                                    //         margin: EdgeInsets.only(left: 2*SizeConfig.heightMultiplier,top: 2*SizeConfig.heightMultiplier),
                                    //         child: Text(
                                    //           model.runningYear==DateTime.now().year?
                                    //           "january"+DateFormat("yyyy").format(DateTime(model.runningYear,DateTime.now().month))+" - "+DateFormat("MMMM yyyy").format(DateTime.now())
                                    //               :
                                    //           "january"+DateFormat("yyyy").format(DateTime(model.runningYear,DateTime.now().month))+" - ""december"+DateFormat("yyyy").format(DateTime(model.runningYear)),textAlign: TextAlign.start,style: TextStyle(
                                    //             color: ColorUtils.darkText,
                                    //             fontFamily: FontUtils.avertaDemoRegular,
                                    //             fontSize: 13
                                    //         ),),
                                    //       ),
                                    //       SizedBox(width: 2.5.w,),
                                    //       InkWell(
                                    //         onTap: (){
                                    //           if (model.runningYear != DateTime.now().year){
                                    //             model.runningYear = model.runningYear +1;
                                    //             model.runningYearDate  = Jiffy(model.runningYearDate).add(years: 1).dateTime;
                                    //             model.gettingDonations();
                                    //             //model.month = model.months.indexOf(model.selectedMonth)+1;
                                    //             //model.getDataforYear();
                                    //             model.notifyListeners();
                                    //           }
                                    //         },
                                    //         child: Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius: BorderRadius.all(Radius.circular(8)),
                                    //             border: Border.all(color: ColorUtils.borderColor),
                                    //           ),
                                    //           child: Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 1.9.h),
                                    //             child: SvgPicture.asset(ImageUtils.chevronRight,
                                    //               width: 4.i,
                                    //               height: 4.i,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // //SizedBox(height: 1.h,),
                                    // //SfDateRangePicker(),
                                    // SizedBox(height: 2.h,),
                                    // Center(
                                    //   child: Text(
                                    //     model.totalDonation !=null ?
                                    //     "\$"+ model.totalDonation!.toString() : "",
                                    //     style: TextStyle(
                                    //       fontFamily: FontUtils.avertaBold,
                                    //       color: ColorUtils.darkText,
                                    //       fontSize: 2.7.t,
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(height: 2.h,),
                                    // if(model.donations != [] && model.previousDonations !=[])
                                    //   Center(
                                    //     child : RichText(
                                    //       text: TextSpan(
                                    //         children: [
                                    //           TextSpan(
                                    //             text: model.overAllDonation!.toString() + "%",
                                    //             style: TextStyle(
                                    //               fontFamily: FontUtils.avertaBold,
                                    //               fontSize: 1.8.t,
                                    //               color: model.overAllDonation! > 0 ? Colors.green : Colors.red,
                                    //             ),
                                    //           ),
                                    //           TextSpan(
                                    //             text: model.overAllDonation! > 0 ? " increase" : " decrease" ,
                                    //             style: TextStyle(
                                    //               fontFamily: FontUtils.avertaBold,
                                    //               fontSize: 1.8.t,
                                    //               color: model.overAllDonation! > 0 ? Colors.green : Colors.red,
                                    //             ),
                                    //           ),
                                    //           TextSpan(
                                    //             text: model.selectedCategory == "Weekly" ?
                                    //             " compared to last week" : model.selectedCategory == "monthly" ?
                                    //             " compared to last month" :
                                    //             "compared to last year"
                                    //             ,
                                    //             style: TextStyle(
                                    //               fontFamily: FontUtils.avertaBold,
                                    //               fontSize: 1.8.t,
                                    //               color: model.overAllDonation! > 0 ? Colors.green : Colors.red,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     /*child: Text(
                                    //           model.totalPreviousDonation !=null ?
                                    //           model.overAllDonation! + "%" : "",
                                    //           style: TextStyle(
                                    //             fontFamily: FontUtils.avertaBold,
                                    //             color: ColorUtils.darkText,
                                    //             fontSize: 2.7.t,
                                    //           ),
                                    //         ),*/
                                    //   ),
                                    // SizedBox(height: 2.h,),
                                    // // Center(
                                    // //   child: Text("43% increase compared to last week",
                                    // //     style: TextStyle(
                                    // //       fontFamily: FontUtils.avertaDemoRegular,
                                    // //       color: ColorUtils.upward,
                                    // //       fontSize: 2.0.t,
                                    // //     ),
                                    // //   ),
                                    // // ),
                                    // SizedBox(height: 3.h,),
                                    // if(!model.graphLoading && model.selectedCategory == "Weekly")
                                    //   model.donateWeekDataGraph(),
                                    // if(!model.graphLoading && model.selectedCategory == "monthly")
                                    //   model.donateMonthDataGraph(),
                                    // if(!model.graphLoading && model.selectedCategory == "yearly")
                                    //   model.donateYearDataGraph(),
                                    // if(model.graphLoading)
                                    //   Container(
                                    //       height: 35.h,
                                    //       child: Loader2()
                                    //   ),
                                    // //SplineChart(),
                                    // SizedBox(height: 3.h,),
                                    // Text("Choose Date",
                                    //   style: TextStyle(
                                    //     fontFamily: FontUtils.avertaBold,
                                    //     color: ColorUtils.darkText,
                                    //     fontSize: 2.7.t,
                                    //   ),
                                    // ),
                                    // SizedBox(height: 3.h,),
                                    // SfDateRangePicker(
                                    //   onSelectionChanged: model.onSelectionChanged,
                                    //   headerStyle:
                                    //   DateRangePickerHeaderStyle(
                                    //       textAlign: TextAlign.center,
                                    //       textStyle: TextStyle(
                                    //         fontFamily: FontUtils.avertaSemiBold,
                                    //         fontSize: 2.2.t,
                                    //         color: Colors.black,
                                    //       )),
                                    //   selectionMode: DateRangePickerSelectionMode.single,
                                    //   showNavigationArrow: true,
                                    //   selectionColor: ColorUtils.blueColor,
                                    //   selectionShape: DateRangePickerSelectionShape.circle,
                                    // ),
                                    // SizedBox(height: 3.h,),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text("Events",
                                    //       style: TextStyle(
                                    //         fontFamily: FontUtils.avertaBold,
                                    //         color: ColorUtils.darkText,
                                    //         fontSize: 2.7.t,
                                    //       ),
                                    //     ),
                                    //     if(model.searchedDateEvents.isNotEmpty)
                                    //       GestureDetector(
                                    //         onTap: (){
                                    //           Navigator.push(context, PageTransition(child: SeeAllEvents(), type: PageTransitionType.fade));
                                    //         },
                                    //         child: Text(
                                    //           "See all",
                                    //           style: TextStyle(
                                    //             shadows: [
                                    //               Shadow(
                                    //                   color: ColorUtils.blueColor,
                                    //                   offset: Offset(0, -1))
                                    //             ],
                                    //             color: Colors.transparent,
                                    //             decoration:
                                    //             TextDecoration.underline,
                                    //             decorationColor: ColorUtils.blueColor,
                                    //             //decorationThickness: 4,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //   ],
                                    // ),
                                    // SizedBox(height: 2.h,),
                                    // model.dateEventsLoading == false?
                                    // model.searchedDateEvents.isNotEmpty ?
                                    // ListView.separated(
                                    //   //padding: EdgeInsets.zero,
                                    //   padding: EdgeInsets.zero,
                                    //   scrollDirection: Axis.vertical,
                                    //   physics: const BouncingScrollPhysics(),
                                    //   primary: false,
                                    //   shrinkWrap: true,
                                    //   itemBuilder: (context, index) {
                                    //     return Container(
                                    //       decoration: BoxDecoration(
                                    //         boxShadow: [
                                    //           BoxShadow(
                                    //             color: Colors.black.withOpacity(0.1),
                                    //             spreadRadius: 0,
                                    //             blurRadius: 10,
                                    //             offset: const Offset(0, 5), // changes position of shadow
                                    //           ),
                                    //         ],
                                    //         color: Colors.white,
                                    //         borderRadius: const BorderRadius.all(Radius.circular(18)),
                                    //         border: Border.all(color: ColorUtils.blueColor),
                                    //       ),
                                    //       child: Column(
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           Padding(
                                    //             padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.5.h),
                                    //             child: Row(
                                    //               children: [
                                    //                 ClipRRect(
                                    //                     borderRadius: BorderRadius.circular(10),
                                    //                     child: CachedNetworkImage(
                                    //                       imageUrl: model.searchedDateEvents[index].eventBanner!,
                                    //                       fit: BoxFit.cover,
                                    //                       width: 20.i,
                                    //                       height: 20.i,
                                    //                       //width: MediaQuery.of(context).size.width / 1,
                                    //                     )
                                    //                 ),
                                    //                 SizedBox(width: 3.w,),
                                    //                 Expanded(
                                    //                   child: Column(
                                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                                    //                     children: [
                                    //                       Text(
                                    //                         model.searchedDateEvents[index].eventDate!.substring(8,10)
                                    //                             +
                                    //                             " "
                                    //                             +
                                    //                             DateFormat('MMMM').format(DateTime(0, int.parse(model.searchedDateEvents[index].eventDate!.substring(5,7)))).toString()
                                    //                             +
                                    //                             "- "
                                    //                             +
                                    //                             DateFormat('EEEE').format(
                                    //                                 DateTime.parse(model.searchedDateEvents[index].eventDate!)
                                    //                             )
                                    //                             +
                                    //                             " -"
                                    //                             +
                                    //                             DateFormat.jm().format(DateTime.parse(model.searchedDateEvents[index].eventDate! + " " + model.searchedDateEvents[index].timeFrom!))
                                    //                         ,
                                    //                         style: TextStyle(
                                    //                             fontFamily: FontUtils.avertaDemoRegular,
                                    //                             fontSize: 1.7.t,
                                    //                             color: ColorUtils.redColor
                                    //                         ),
                                    //                       ),
                                    //                       SizedBox(height: 1.h,),
                                    //                       Text(
                                    //                         model.searchedDateEvents[index].eventName!,
                                    //                         style: TextStyle(
                                    //                           fontFamily: FontUtils.modernistBold,
                                    //                           fontSize: 2.2.t,
                                    //                           //color: ColorUtils.blackText
                                    //                         ),
                                    //                       ),
                                    //                       SizedBox(height: 1.h,),
                                    //                       Row(
                                    //                         children: [
                                    //                           SvgPicture.asset(ImageUtils.locationEvent),
                                    //                           SizedBox(width: 1.5.w,),
                                    //                           Expanded(
                                    //                             child: Text(
                                    //                               model.searchedDateEvents[index].location!,
                                    //                               style: TextStyle(
                                    //                                 fontFamily: FontUtils.modernistRegular,
                                    //                                 fontSize: 1.7.t,
                                    //                                 //color: ColorUtils.text_dark
                                    //                               ),
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     );
                                    //   },
                                    //   separatorBuilder: (context, index) {
                                    //     return SizedBox(height:2.5.h,);
                                    //   },
                                    //   itemCount: model.searchedDateEvents.length,
                                    // ):
                                    // Center(
                                    //   child: Text("No Event Found"),
                                    // ) : Loader2(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                      ),
              ),
              )),
            );
        });
  }
}
