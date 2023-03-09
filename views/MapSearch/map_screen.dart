import 'dart:io';
import 'dart:math';

import 'package:another_xlider/another_xlider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List places = [
    {
      'image': ImageUtils.place1,
      'eventName': 'Trivia Nights',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
    },
    {
      'image': ImageUtils.place2,
      'eventName': 'Bar Crawl Stop',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
    },
    {
      'image': ImageUtils.place3,
      'eventName': 'Singles Night',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
    },
    {
      'image': ImageUtils.place4,
      'eventName': 'Bar Olympics',
      'date': '1st  May- Sat -2:00 PM',
      'location': 'Lot 13 • Oakland, CA',
    },
  ];

  List filterPlaces = [
    {
      'image': ImageUtils.discoBall,
      'text': "filter_text_1",

    },
    {
      'image': ImageUtils.musicIcon,
      'text': "filter_text_2",
    },
    {
      'image': ImageUtils.chaimpaineGlass,
      'text': "filter_text_3",
    },
    {
      'image': ImageUtils.calenderFilter,
      'text': "filter_text_4",
    },
    {
      'image': ImageUtils.knife,
      'text': "filter_text_5",
    },
  ];

  // List time = [
  //   "Today",
  //   "Tomorrow",
  //   "This week",
  // ];

  List time = [
    "time_text_1",
    "time_text_2",
    "time_text_3",
  ];

  List<String> location = [
    'Karachi, Pakistan',
    'Lahore, Pakistan',
    'Islamabad, Pakistan',
  ];

  String? selectedLocation;

  @override
  void initState() {
    // TODO: implement initState
    selectedLocation = 'Karachi, Pakistan';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => locator<MainViewModel>(),
      onModelReady: (model) async {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Running on ${androidInfo.model}');
        dynamic token =  await model.prefs?.getString('FCM');

        if(Platform.isAndroid){
          model.deviceRegistration(context,androidInfo.model);
        }else{
          model.deviceRegistrationIOS(context,androidInfo.model);
        }

        print('home screen');


        await model.getAllUserForMap();
        model.setMarkers();

        //model.getListOfUpcomingEvents();
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: GestureDetector(
            onTap: (){
              context.unFocus();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Container(
                    child: GoogleMap(
                      markers: Set<Marker>.of(model.markers),

                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      // myLocationButtonEnabled: true,
                      myLocationButtonEnabled: false,
                      initialCameraPosition: model.kGooglePlex,
                      //circles: model.mCircles ?? {},
                      //model.circles ?? {},
                      mapType: MapType.normal,
                      compassEnabled: true,

                      onTap: (value){
                        context.unFocus();
                      },

                      onMapCreated: (GoogleMapController controller) async {
                        if (!model.controller.isCompleted){
                          model.controller.complete(controller);
                        }
                        var position = await model.determinePosition();
                        if (position!=null){
                          model.kGooglePlex = CameraPosition(
                            target: LatLng(position.latitude, position.longitude),
                            zoom: 14.4746,
                          );
                          controller.animateCamera(CameraUpdate.newCameraPosition(model.kGooglePlex));
                        }
                        //model.getAddress();
                      },
                      //markers: model.markers!,
                      //polylines: Set<Polyline>.of(model.polylines.values),
                      //markers: model.markers!,
                      //Set<Marker>.of(model.newMarkers.values),
                      //markers: model.markers!,
                    ),
                  ),
                  Container(
                    //width: 200.0,
                    margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 4.5,
                        right: SizeConfig.widthMultiplier * 5,
                        top: SizeConfig.heightMultiplier * 8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: ColorUtils.shadowColor.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                      color: ColorUtils.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Container(
                      //color: Colors.amber,
                      margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 3,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: SvgPicture.asset(ImageUtils.searchIcon),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.widthMultiplier * 3,
                                  right: SizeConfig.widthMultiplier * 3),
                              child: GestureDetector(
                                onTap: (){
                                  context.unFocus();
                                },
                                child: TextField(
                                  onTap: () {
                                    // FocusScopeNode currentFocus = FocusScope.of(context);
                                    //
                                    // if (!currentFocus.hasPrimaryFocus) {
                                    //   currentFocus.unfocus();
                                    // }

                                  },

                                  enabled: true,
                                  //readOnly: true,
                                  focusNode: model.searchFocus,
                                  controller: model.mapSearchController,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(
                                        context)!
                                        .translate('map_screen_text_1')!,
                                    hintStyle: TextStyle(
                                      //fontFamily: FontUtils.proximaNovaRegular,
                                      color: ColorUtils.icon_color,
                                      fontSize: SizeConfig.textMultiplier * 1.9,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.heightMultiplier * 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                                filter(context, model);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorUtils.text_red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    decoration:
                                        BoxDecoration(shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          SvgPicture.asset(ImageUtils.filterIcon),
                                    ),
                                  ),
                                  // Text(
                                  //   "Filters",
                                  //   style: TextStyle(
                                  //       fontFamily: FontUtils.avertaDemo,
                                  //       fontSize: 1.8.t,
                                  //       color: ColorUtils.filterText),
                                  // ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate(
                                        'map_screen_text_2')!,
                                    style: TextStyle(
                                      fontFamily: FontUtils.avertaDemo,
                                      fontSize: 1.8.t,
                                        color: ColorUtils.filterText
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                ],
                              ),
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
                  ///get current loaction
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: SizeConfig.widthMultiplier * 4.5,
                          right: SizeConfig.widthMultiplier * 5,
                          top: SizeConfig.heightMultiplier * 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Container(
                          //   width: 11.w,
                          //   height: 5.5.h,
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.rectangle,
                          //     borderRadius: BorderRadius.all(Radius.circular(15)),
                          //     color: ColorUtils.text_red
                          //   ),
                          //   child: Center(child: SvgPicture.asset(ImageUtils.sendIcon)),
                          // ),
                          SizedBox(
                            height: 2.5.h,
                          ),
                          InkWell(
                            onTap: ()async{
                              //print('lul');
                              var position = await model.determinePosition();
                              if (position!=null){
                                GoogleMapController controller = await model.controller.future;
                                await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(position.latitude, position.longitude),
                                    // tilt: 59.440717697143555,
                                    zoom: 19.151926040649414)));
                              }
                            },
                            child: Container(
                              width: 11.w,
                              height: 5.5.h,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Colors.white
                              ),
                              child: Center(child: SvgPicture.asset(ImageUtils.targetIcon)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///----- NEAR EVENTS------////

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.symmetric(
                  //           horizontal: SizeConfig.widthMultiplier * 4,
                  //         ),
                  //         child: Text("Near Events",
                  //         style: TextStyle(
                  //           fontFamily: FontUtils.modernistBold,
                  //           fontSize: 2.t,
                  //           color: Colors.black,
                  //             shadows: [
                  //               Shadow(
                  //                   color: Colors.black.withOpacity(0.5),
                  //                   offset: const Offset(5, 5),
                  //                   blurRadius: 15),
                  //             ]
                  //         ),
                  //         ),
                  //       ),
                  //
                  //       Container(
                  //         margin: EdgeInsets.only(bottom: 5.h),
                  //         height: 14.8.h,
                  //         child: ListView.separated(
                  //           padding: EdgeInsets.zero,
                  //           scrollDirection: Axis.horizontal,
                  //           physics: const AlwaysScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           itemBuilder: (context, index) {
                  //             return Padding(
                  //               padding: EdgeInsets.symmetric(
                  //                 horizontal: SizeConfig.widthMultiplier * 2,
                  //                 vertical: SizeConfig.widthMultiplier * 3
                  //               ),
                  //               child: GestureDetector(
                  //                 onTap: () {
                  //                   model.selectedUpcomingEvents = (model.listOfUpcomingEvents[index]);
                  //                   // model.selectedBar = (model.listOfBar[index]);
                  //                   model.navigateToUpcomingBarEventDetails();
                  //                 },
                  //                 child: Container(
                  //                   //height: 12.h,
                  //                   width: MediaQuery.of(context).size.width / 1.2,
                  //                   decoration: BoxDecoration(
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                         color: ColorUtils.black
                  //                             .withOpacity(0.2),
                  //                         spreadRadius: 0,
                  //                         blurRadius: 10,
                  //                         offset: Offset(0,
                  //                             5), // changes position of shadow
                  //                       ),
                  //                     ],
                  //                     color: Colors.white.withOpacity(0.8),
                  //                     borderRadius:
                  //                         BorderRadius.all(Radius.circular(18)),
                  //                     border: Border.all(color: ColorUtils.red_color),
                  //                   ),
                  //                   child: Column(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       Padding(
                  //                         padding: EdgeInsets.symmetric(
                  //                             horizontal: 2.w, vertical: 1.5.h),
                  //                         child: Row(
                  //                           children: [
                  //                             ClipRRect(
                  //                               borderRadius: BorderRadius.circular(10),
                  //                               child: Image.network(
                  //                                 model.listOfUpcomingEvents[index].media![0].media,
                  //                                 width: 18.i,
                  //                                 height: 18.i,
                  //                                 fit: BoxFit.fill,
                  //                               ),
                  //                             ),
                  //                             SizedBox(
                  //                               width: 3.w,
                  //                             ),
                  //                             Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Text(
                  //                                   model.listOfUpcomingEvents[index].event_date!,
                  //                                   style: TextStyle(
                  //                                       fontFamily:
                  //                                           FontUtils.modernistRegular,
                  //                                       fontSize: 1.7.t,
                  //                                       color: ColorUtils.text_red),
                  //                                 ),
                  //                                 SizedBox(
                  //                                   height: 1.h,
                  //                                 ),
                  //                                 Text(
                  //                                   model.listOfUpcomingEvents[index].name!,
                  //                                   style: TextStyle(
                  //                                       fontFamily:
                  //                                           FontUtils.modernistBold,
                  //                                       fontSize: 2.2.t,
                  //                                       color: ColorUtils.blackText),
                  //                                 ),
                  //                                 SizedBox(
                  //                                   height: 1.h,
                  //                                 ),
                  //                                 Container(
                  //                                   width: 55.w,
                  //                                   child: Text(
                  //                                     model.listOfUpcomingEvents[index].location!,
                  //                                     style: TextStyle(
                  //                                         fontFamily:
                  //                                             FontUtils.modernistRegular,
                  //                                         fontSize: 1.7.t,
                  //                                         color: ColorUtils.text_dark),
                  //                                       maxLines: 1,
                  //                                       overflow: TextOverflow.ellipsis,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //           separatorBuilder: (context, index) {
                  //             return SizedBox(
                  //               width: SizeConfig.widthMultiplier * 0,
                  //             );
                  //           },
                  //           itemCount: model.listOfUpcomingEvents.length,
                  //         ),
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void filter(context, MainViewModel mainModel) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft:  Radius.circular(25) ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return ViewModelBuilder.reactive(
            disposeViewModel: false,
            viewModelBuilder: () => locator<MainViewModel>(),
            builder: (context, model, child) {
              return Container(
               // height: 200.h,
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(50),
                //         topLeft: Radius.circular(50))
                // ),
                child: ListView(

                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 3.h, left: 4.w, right: 4.w),
                      child: Text(
                        "Filter",
                        style: TextStyle(
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 3.0.t,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 15.h,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              mainModel.eventSelected = true;
                              mainModel.currentEventSelected = index;
                              mainModel.notifyListeners();
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 4.w,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          if(mainModel.eventSelected ==
                                              true &&
                                              index ==
                                                  mainModel
                                                      .currentEventSelected)
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 0,
                                            blurRadius: 10,
                                            offset: Offset(0, 5), // changes position of shadow
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        color: mainModel.eventSelected ==
                                                    true &&
                                                index ==
                                                    mainModel
                                                        .currentEventSelected
                                            ? ColorUtils.text_red
                                            : Colors.white,
                                        border: Border.all(
                                          color: mainModel.eventSelected ==
                                                      true &&
                                                  index ==
                                                      mainModel
                                                          .currentEventSelected
                                              ? ColorUtils.text_red
                                              : ColorUtils.borderColor,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          filterPlaces[index]["image"],
                                          color: mainModel.eventSelected ==
                                                      true &&
                                                  index ==
                                                      mainModel
                                                          .currentEventSelected
                                              ? Colors.white
                                              : ColorUtils.icon_color,
                                          width: 10.i,
                                          height: 10.i,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.5.h,
                                  ),
                                  Text(
                                    // filterPlaces[index]["text"],
                                    AppLocalizations.of(context)!
                                        .translate(filterPlaces[index]["text"])!,
                                  style: TextStyle(
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.7.t,
                                    color: ColorUtils.text_dark
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 0.5.w,
                          );
                        },
                        itemCount: filterPlaces.length,
                      ),
                    ),
                    //SizedBox(height: 0.5.h,),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: Text(
                        // "Time & Date",
                        AppLocalizations.of(context)!
                            .translate(
                            'map_screen_text_3')!,
                        style: TextStyle(
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 2.2.t,
                          color: ColorUtils.blackText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(

                     // margin: EdgeInsets.symmetric(horizontal: 5.w),
                      height: 5.5.h,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              mainModel.timeSelected = true;
                              mainModel.timeValue = index;
                              mainModel.notifyListeners();
                              // mainModel.currentEventSelected = index;
                            //  mainModel.notifyListeners();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: mainModel.timeSelected == true &&
                                          index == mainModel.timeValue
                                      ? ColorUtils.text_red
                                      : Colors.white,
                                  border: Border.all(
                                    color: mainModel.timeSelected == true &&
                                            index == mainModel.timeValue
                                        ? ColorUtils.text_red
                                        : ColorUtils.borderColor,
                                  )),
                              child: Padding(
                                padding: EdgeInsets.all(3.i),
                                child: Text(
                                  // time[index],
                                  AppLocalizations.of(context)!
                                      .translate(time[index])!,
                                  style: TextStyle(
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 1.9.t,
                                    color: mainModel.timeSelected == true &&
                                            index == mainModel.timeValue
                                        ? Colors.white
                                        : ColorUtils.icon_color,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 6.w,
                          );
                        },
                        itemCount: time.length,
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: Text(
                        // "Location",
                        AppLocalizations.of(context)!
                            .translate(
                            'map_screen_text_4')!,
                        style: TextStyle(
                          fontFamily: FontUtils.modernistBold,
                          fontSize: 2.2.t,
                          color: ColorUtils.blackText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 7.h,
                      margin: EdgeInsets.symmetric(horizontal: 3.w ),
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.containerVerticalPadding,
                          horizontal:
                          Dimensions.containerHorizontalPadding),
                      decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(Dimensions.roundCorner)),
                          border:
                          Border.all(color: ColorUtils.divider)),
                      child: GestureDetector(
                        onTap: () async {
                          mainModel.navigateToFilterEventScreen();
                          var position = await mainModel.determinePositionFilters();
                          mainModel.latitude = position.latitude;
                          mainModel.latitude = position.longitude;
                        },
                        child: Row(
                          children: [
                            Container(child: SvgPicture.asset(ImageUtils.locationIcon),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: TextField(
                                focusNode: mainModel.filtersMapFocus,
                                controller: mainModel.filtersMapController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                  color: ColorUtils.red_color,
                                  fontFamily: FontUtils.modernistRegular,
                                  fontSize: 1.9.t,
                                ),
                                decoration:  InputDecoration(
                                  hintText:
                                  // "Enter location",
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'map_screen_text_5')!,
                                  hintStyle: TextStyle(
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.t,
                                    color: ColorUtils.text_grey,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // "Select Range",
                            AppLocalizations.of(context)!
                                .translate(
                                'map_screen_text_6')!,
                            style: TextStyle(
                              fontFamily: FontUtils.modernistBold,
                              fontSize: 2.2.t,
                              color: ColorUtils.blackText,
                            ),
                          ),
                          Text(
                              mainModel.lowValue! +"km" + "-" + mainModel.highValue!+"km",
                            style: TextStyle(
                              fontFamily: FontUtils.modernistRegular,
                              fontSize: 2.0.t,
                              color: ColorUtils.text_red
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlutterSlider(
                      onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                        handlerIndex = 0;

                        mainModel.lowerValue = lowerValue;
                        mainModel.upperValue = upperValue;
                        // print(_upperValue);
                        // print(_lowerValue);
                        setState(() {

                        });
                      },
                      trackBar: FlutterSliderTrackBar(
                        activeTrackBar: BoxDecoration(
                          color: ColorUtils.text_red,
                        ),
                        inactiveTrackBar: BoxDecoration(
                          color: ColorUtils.text_red.withOpacity(0.2),
                        ),
                      ),
                      // handlerHeight: 0.0,
                      // handlerWidth: 0.0,
                      handler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            // image: DecorationImage(
                            //   image:AssetImage(ImageUtils.doubleArrow),
                            // ),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: ColorUtils.text_red)),
                        child: Image.asset(
                          ImageUtils.doubleArrow,
                          height: 5.i,
                          width: 5.i,
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(
                            // image: DecorationImage(
                            //   image:AssetImage(ImageUtils.doubleArrow),
                            // ),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            border: Border.all(color: ColorUtils.text_red)),
                        child: Image.asset(
                          ImageUtils.doubleArrow,
                          height: 5.i,
                          width: 5.i,
                        ),
                      ),
                      values: [mainModel.lowerValue, mainModel.upperValue],
                      rangeSlider: true,
                      max: 50,
                      min: 0,
                      onDragging: (handlerIndex, lowerValue, upperValue) {
                        mainModel.lowerValue = lowerValue;
                        mainModel.upperValue = upperValue;
                        mainModel.lowValue = mainModel.lowerValue.toStringAsFixed(0);
                        mainModel.highValue =  mainModel.upperValue.toStringAsFixed(0);
                        mainModel.notifyListeners();
                      },
                    ),
                    SizedBox(height: 3.h,),
                    Container(
                      margin: EdgeInsets.only(left: 4.w, right: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                mainModel.eventSelected = false;
                                mainModel.currentEventSelected = null;
                                mainModel.timeSelected = false;
                                mainModel.timeValue = null;
                                mainModel.lowerValue = 5;
                                mainModel.upperValue = 15;
                                selectedLocation = 'Karachi, Pakistan';
                                mainModel.notifyListeners();
                              },
                              child: Text(
                                  // "RESET"
                                AppLocalizations.of(context)!
                                    .translate(
                                    'map_screen_text_7')!,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: ColorUtils.white,
                                onPrimary: ColorUtils.text_red,
                                padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                    side: BorderSide(
                                        color: ColorUtils.text_red,
                                        width: 1
                                    )
                                ),
                                textStyle: TextStyle(
                                  //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                  fontFamily: FontUtils.modernistBold,
                                  fontSize: 1.8.t,
                                  //height: 0
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 5.w,),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                mainModel.addEventFilters();
                                //mainModel.navigateToMapSearchScreen();
                              },
                              child: Text(
                                  // "APPLY"
                                AppLocalizations.of(context)!
                                    .translate(
                                    'map_screen_text_8')!,
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: ColorUtils.text_red,
                                onPrimary: ColorUtils.white,
                                padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 5.w),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                    side: BorderSide(
                                        color: ColorUtils.text_red,
                                        width: 1
                                    )
                                ),
                                textStyle: TextStyle(
                                  //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                  fontFamily: FontUtils.modernistBold,
                                  fontSize: 1.8.t,
                                  //height: 0
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 2.h,),
                  ],
                ),
              );
            },
          );
        });
  }
}

