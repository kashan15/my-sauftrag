import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/bar/widgets/custom_date_picker.dart' as custom;
import 'package:sauftrag/models/day_week.dart';
import 'package:sauftrag/models/day_weekend.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/utils/common_functions.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:stacked/stacked.dart';

import '../../../models/new_bar_model.dart';
import '../../../utils/app_localization.dart';
import '../../../viewModels/prefrences_view_model.dart';
import '../../../widgets/loader.dart';

class BarAccount extends StatefulWidget {
  const BarAccount({Key? key}) : super(key: key);

  @override
  _BarAccountState createState() => _BarAccountState();
}

class _BarAccountState extends State<BarAccount> {


  DateTime _dateTime = DateTime.now();
  String? openingTimeFrom;
  String? openingTimeTo;
  String? breakTimeFrom;
  String? breakTimeTo;
  String? weekEndOpeningTimeFrom;
  String? weekEndOpeningTimeTo;
  String? weekEndBreakTimeFrom;
  String? weekEndBreakTimeTo;

  @override
  void didChangeDependencies() {

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
      onModelReady: (model)async{
        model.convert();
        NewBarModel? bar = await locator<PrefrencesViewModel>().getBarUser();
        if (bar!.week_days!.opening_time!=null){
          model.openingTimeFrom = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.week_days!.opening_time!)).to24hours();
        }
        if (bar.week_days!.closing_time!=null){
          model.openingTimeTo = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.week_days!.closing_time!)).to24hours();
        }
        if (bar.week_days!.break_opening_time!=null){
          model.breakTimeFrom = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.week_days!.break_opening_time!)).to24hours();
        }
        if (bar.week_days!.break_closing_time!=null){
          model.breakTimeTo = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.week_days!.break_closing_time!)).to24hours();
        }
        if (bar.weekend_days!.opening_time!=null){
          model.weekEndOpeningTimeFrom = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.weekend_days!.opening_time!)).to24hours();
        }
        if (bar.weekend_days!.closing_time!=null){
          model.weekEndOpeningTimeTo = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.weekend_days!.closing_time!)).to24hours();
        }
        if (bar.weekend_days!.break_opening_time!=null){
          model.weekEndBreakTimeFrom = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.weekend_days!.break_opening_time!)).to24hours();
        }
        if (bar.weekend_days!.break_closing_time!=null){
          model.weekEndBreakTimeTo = TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(bar.weekend_days!.break_closing_time!)).to24hours();
        }
        model.locationController.text = bar.address ?? "";
        model.selectedWeekendDays.clear();
        model.selectedWeekDays.clear();
        if (bar.weekend_days!.day!=null) {
          for (DayWeekendModel day in bar.weekend_days!.day!) {
            model.selectedWeekendDays.add(day.day__id!);
          }
        }
        if (bar.week_days!.day!=null) {
          for (DayWeekModel day in bar.week_days!.day!) {
            model.selectedWeekDays.add(day.day__id!);
          }
        }
        // model.openingTimeTo = TimeOfDay.now().format(context);
        // model.breakTimeFrom = TimeOfDay.now().format(context);
        // model.breakTimeTo = TimeOfDay.now().format(context);
        // model.weekEndOpeningTimeFrom = TimeOfDay.now().format(context);
        // model.weekEndOpeningTimeTo = TimeOfDay.now().format(context);
        // model.weekEndBreakTimeFrom = TimeOfDay.now().format(context);
        // model.weekEndBreakTimeTo = TimeOfDay.now().format(context);
        model.notifyListeners();
      },
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: ()async{
            model.openingTimeFrom = null;
            model.openingTimeTo = null;
            model.breakTimeTo = null;
            model.breakTimeFrom = null;
            model.weekEndOpeningTimeFrom = null;
            model.weekEndOpeningTimeTo = null;
            model.weekEndBreakTimeTo = null;
            model.weekEndBreakTimeFrom = null;
            return true;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              bottom: false,
              top: false,
              child: Scaffold(
                  backgroundColor: ColorUtils.white,
                  body: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.horizontalPadding,
                        //vertical: Dimensions.verticalPadding
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.topMargin),

                        //Add Images
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  model.openingTimeFrom = null;
                                  model.openingTimeTo = null;
                                  model.breakTimeTo = null;
                                  model.breakTimeFrom = null;
                                  model.weekEndOpeningTimeFrom = null;
                                  model.weekEndOpeningTimeTo = null;
                                  model.weekEndBreakTimeTo = null;
                                  model.weekEndBreakTimeFrom = null;
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
                              // "Account",
                              AppLocalizations.of(
                                  context)!
                                  .translate('bar_accounts_text_1')!,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 3.t,
                              ),
                            ),
                          ],
                        ),


                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6.w),
                                Text(
                                  // "Bar Timing",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_2')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t,
                                  ),
                                ),
                                SizedBox(height: 2.h),

                                Text(
                                  // "Please set your bar opening time",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_3')!,
                                  style: TextStyle(
                                    color: ColorUtils.text_dark,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 2.t,
                                  ),
                                ),
                                SizedBox(height: 3.h),

                                // Wrap(
                                //   spacing: 2.w,
                                //   //runSpacing: 1.5.h,
                                //   direction: Axis.horizontal,
                                //   children: model.weekDaysList
                                //       .map((element) =>
                                //       ElevatedButton(
                                //         onPressed: () {
                                //           if (model.selectedWeekDays.contains(model
                                //               .weekDaysList
                                //               .indexOf(element))) {
                                //             model.selectedWeekDays.remove(model
                                //                 .weekDaysList
                                //                 .indexOf(element));
                                //           } else {
                                //             /* if (element == "Radler") {
                                //                   showDialog(
                                //                       context: context,
                                //                       builder: (BuildContext context) {
                                //                         return RadlerDialogBox(
                                //                             title: "Add New Location",
                                //                             btnTxt: "Add Location",
                                //                             icon: ImageUtils
                                //                                 .addLocationIcon);
                                //                       });
                                //                 } */
                                //             /*  else {
                                //
                                //                 }*/
                                //             model.selectedWeekDays.add(model
                                //                 .weekDaysList
                                //                 .indexOf(element));
                                //           }
                                //           model.notifyListeners();
                                //         },
                                //         child: Text(model.weekDaysList[
                                //         model.weekDaysList.indexOf(element)]),
                                //         style: ElevatedButton.styleFrom(
                                //           primary: model.selectedWeekDays.contains(
                                //               model.weekDaysList
                                //                   .indexOf(element))
                                //               ? ColorUtils.text_red
                                //               : ColorUtils.white,
                                //           onPrimary: model.selectedWeekDays
                                //               .contains(model.weekDaysList
                                //               .indexOf(element))
                                //               ? ColorUtils.white
                                //               : ColorUtils.text_dark,
                                //           /* padding: EdgeInsets.symmetric(
                                //                   vertical: 1.8.h, horizontal: 9.w),*/
                                //           elevation: model.selectedWeekDays
                                //               .contains(model.weekDaysList
                                //               .indexOf(element))
                                //               ? 5
                                //               : 0,
                                //           shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(
                                //                   Dimensions.roundCorner),
                                //               side: BorderSide(
                                //                   color: model.selectedWeekDays
                                //                       .contains(model
                                //                       .weekDaysList
                                //                       .indexOf(element))
                                //                       ? ColorUtils.text_red
                                //                       : ColorUtils.divider,
                                //                   width: 1)),
                                //           textStyle: TextStyle(
                                //             //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                //             fontFamily: model.selectedWeekDays
                                //                 .contains(model.weekDaysList
                                //                 .indexOf(element))
                                //                 ? FontUtils.modernistBold
                                //                 : FontUtils.modernistRegular,
                                //             fontSize: 1.5.t,
                                //             //height: 0
                                //           ),
                                //         ),
                                //       ))
                                //       .toList(),
                                // ),
                                Wrap(
                                  spacing: 3.w,
                                  runSpacing: 1.5.h,
                                  direction: Axis.horizontal,
                                  children: model.weekDaysList
                                      .map((element) => GestureDetector(
                                    onTap: () {
                                      if (model.selectedWeekDays.contains(
                                          model.weekDaysList[model.weekDaysList.indexOf(element)].day__id)) {
                                        model.selectedWeekDays.remove(model.weekDaysList[model.weekDaysList.indexOf(element)].day__id);
                                      }
                                      else  {
                                        /* if (element == "Radler") {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return RadlerDialogBox(
                                                        title: "Add New Location",
                                                        btnTxt: "Add Location",
                                                        icon: ImageUtils
                                                            .addLocationIcon);
                                                  });
                                            } */
                                        /*  else {

                                            }*/
                                        model.selectedWeekDays.add(
                                            model.weekDaysList[model.weekDaysList.indexOf(element)].day__id!);
                                      }
                                      model.notifyListeners();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 5.w),
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: model.selectedWeekDays
                                        //     .contains(model.weekDaysList
                                        //     .indexOf(element))
                                        //     ? ColorUtils.text_red
                                        //     : ColorUtils.icon_color,),
                                        borderRadius: BorderRadius.circular(4),
                                        color: model.selectedWeekDays
                                            .contains(model.weekDaysList[model.weekDaysList.indexOf(element)].day__id)
                                            ? ColorUtils.text_red
                                            : ColorUtils.divider,
                                      ),
                                      child: Text(model.weekDaysList[
                                      model.weekDaysList.indexOf(element)].day__name!,
                                        style: TextStyle(
                                          color: model.selectedWeekDays
                                              .contains(model.weekDaysList[model.weekDaysList.indexOf(element)].day__id)
                                              ? ColorUtils.white
                                              : ColorUtils.icon_color,
                                          fontFamily: model.selectedWeekDays
                                              .contains(model.weekDaysList[model.weekDaysList.indexOf(element)].day__id)
                                              ? FontUtils.modernistBold
                                              : FontUtils.modernistRegular,
                                          fontSize: 1.8.t,
                                          //height: 0
                                        ),),

                                    ),
                                  ))
                                      .toList(),
                                ),

                                ///----Bar opening time-----///
                                SizedBox(height: 5.h),
                                Container(
                                  // margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      //From
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                custom.showCustomTimePicker(
                                                    initialTime: model.openingTimeFrom!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.openingTimeFrom!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode:
                                                    custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME")
                                                    .then((value) {
                                                  model.openingTimeFrom =
                                                      value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20)),
                                                    border: Border.all(
                                                        color: ColorUtils.divider)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        // model.startTime!.toString(),
                                                        model.openingTimeFrom!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.openingTimeFrom!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils
                                                              .modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    SvgPicture.asset(
                                                        ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "From",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_4')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily:
                                                    FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 20),

                                      //To
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                custom.showCustomTimePicker(
                                                    initialTime: model.openingTimeTo!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.openingTimeTo!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode:
                                                    custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME")
                                                    .then((value) {
                                                  model.openingTimeTo =
                                                      value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20)),
                                                    border: Border.all(
                                                        color: ColorUtils.divider)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        model.openingTimeTo!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.openingTimeTo!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils
                                                              .modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    SvgPicture.asset(
                                                        ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "To",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_5')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily:
                                                    FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                ///---Bar Break Time----///
                                SizedBox(height: 3.h),
                                Text(
                                  // "Please set your bar break time",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_6')!,
                                  style: TextStyle(
                                    color: ColorUtils.text_dark,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 2.t,
                                  ),
                                ),

                                SizedBox(height: 3.h),
                                Container(
                                  //margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [
                                      //From
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                custom.showCustomTimePicker(
                                                    initialTime: model.breakTimeFrom!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.breakTimeFrom!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode:
                                                    custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME")
                                                    .then((value) {
                                                  model.breakTimeFrom =
                                                      value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20)),
                                                    border: Border.all(
                                                        color: ColorUtils.divider)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                model.breakTimeFrom!=null
                                                    ?
                                                DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.breakTimeFrom!))
                                                        :
                                                DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils
                                                              .modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    SvgPicture.asset(
                                                        ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "From",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_7')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily:
                                                    FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 20),

                                      //To
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                custom.showCustomTimePicker(
                                                    initialTime: model.breakTimeFrom!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.breakTimeTo!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode:
                                                    custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME")
                                                    .then((value) {
                                                  model.breakTimeTo = value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20)),
                                                    border: Border.all(
                                                        color: ColorUtils.divider)),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        model.breakTimeTo!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.breakTimeTo!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils
                                                              .modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.w),
                                                    SvgPicture.asset(
                                                        ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding:
                                              EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "To",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_8')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily:
                                                    FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 4.h),
                                Text(
                                  // "Weekend Timings",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_9')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Wrap(
                                  spacing: 3.w,
                                  //runSpacing: 1.5.h,
                                  direction: Axis.horizontal,
                                  children: model.weekendDaysList
                                      .map((element) => GestureDetector(
                                    onTap: () {
                                      if (model.selectedWeekendDays.contains(
                                        //model.weekendDaysList.indexOf(element)
                                          element.day__id!
                                      )) {
                                        model.selectedWeekendDays.remove(
                                            element.day__id!);
                                      }
                                      else  {
                                        /* if (element == "Radler") {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return RadlerDialogBox(
                                                        title: "Add New Location",
                                                        btnTxt: "Add Location",
                                                        icon: ImageUtils
                                                            .addLocationIcon);
                                                  });
                                            } */
                                        /*  else {

                                            }*/
                                        model.selectedWeekendDays.add(
                                            element.day__id!
                                          // model.weekendDaysList.indexOf(element)
                                        );
                                      }
                                      model.notifyListeners();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 5.w),
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: model.selectedWeekendDays
                                        //     .contains(model.weekendDaysList
                                        //     .indexOf(element))
                                        //     ? ColorUtils.text_red
                                        //     : ColorUtils.icon_color,),
                                        borderRadius: BorderRadius.circular(4),
                                        color: model.selectedWeekendDays
                                            .contains(model.weekendDaysList[model.weekendDaysList
                                            .indexOf(element)].day__id)
                                            ? ColorUtils.text_red
                                            : ColorUtils.divider,
                                      ),
                                      child: Text(model.weekendDaysList[
                                      model.weekendDaysList.indexOf(element)].day__name!,
                                        style: TextStyle(
                                          color: model.selectedWeekendDays
                                              .contains(model.weekendDaysList[model.weekendDaysList
                                              .indexOf(element)].day__id)
                                              ? ColorUtils.white
                                              : ColorUtils.icon_color,
                                          fontFamily: model.selectedWeekendDays
                                              .contains(model.weekendDaysList[model.weekendDaysList
                                              .indexOf(element)].day__id)
                                              ? FontUtils.modernistBold
                                              : FontUtils.modernistRegular,
                                          fontSize: 1.8.t,
                                          //height: 0
                                        ),),

                                    ),
                                  ))
                                      .toList(),
                                ),

                                ///----Bar opening time-----///
                                SizedBox(height: 5.h),
                                Container(
                                  //margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [

                                      //From
                                      Expanded(
                                        child: Stack(
                                          children: [

                                            GestureDetector(
                                              onTap: (){
                                                custom.showCustomTimePicker(
                                                    initialTime: model.weekEndOpeningTimeFrom!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.weekEndOpeningTimeFrom!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode: custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME"
                                                ).then((value){
                                                  model.weekEndOpeningTimeFrom = value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child:  Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: ColorUtils.divider)
                                                ),
                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      child: Text(
                                                        model.weekEndOpeningTimeFrom!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.weekEndOpeningTimeFrom!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils.modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width: 4.w),

                                                    SvgPicture.asset(ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "From",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_10')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 20),

                                      //To
                                      Expanded(
                                        child: Stack(
                                          children: [

                                            GestureDetector(
                                              onTap: (){
                                                custom.showCustomTimePicker(
                                                    initialTime: model.weekEndOpeningTimeTo!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.weekEndOpeningTimeTo!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode: custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME"
                                                ).then((value){
                                                  model.weekEndOpeningTimeTo = value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: ColorUtils.divider)
                                                ),
                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      child: Text(
                                                        model.weekEndOpeningTimeTo!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.weekEndOpeningTimeTo!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils.modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width: 4.w),

                                                    SvgPicture.asset(ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "To",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_11')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   //padding: EdgeInsets.symmetric(horizontal: 1*SizeConfig.widthMultiplier),
                                //   child: Row(
                                //     children: [
                                //       Stack(
                                //         children: [
                                //           Container(
                                //               width: 45.w,
                                //               padding: EdgeInsets.symmetric(
                                //                   vertical:
                                //                   SizeConfig.heightMultiplier*2,
                                //                   horizontal: SizeConfig.widthMultiplier*1
                                //               ),
                                //               decoration: BoxDecoration(
                                //                   color: Colors.white,
                                //                   borderRadius: BorderRadius.all(
                                //                       Radius.circular(
                                //                           Dimensions.roundCorner)),
                                //                   border:
                                //                   Border.all(color: ColorUtils.divider)),
                                //               child: TimePickerSpinner(
                                //                 is24HourMode: false,
                                //                 normalTextStyle: TextStyle(
                                //                   fontSize: 14,
                                //                   //color: Colors.deepOrange
                                //                 ),
                                //                 highlightedTextStyle: TextStyle(
                                //                   fontSize: 14,
                                //                   //color: Colors.yellow
                                //                 ),
                                //                 spacing: 1,
                                //                 itemHeight: 15,
                                //                 //isForce2Digits: false,
                                //                 minutesInterval: 5,
                                //                 onTimeChange: (time) {
                                //                   setState(() {
                                //                     _dateTime = time;
                                //                   });
                                //                 },
                                //               )
                                //           ),
                                //           Container(
                                //             margin: EdgeInsets.only(left: 5.w),
                                //             //padding: EdgeInsets.symmetric(horizontal: 1.w),
                                //             color: ColorUtils.white,
                                //             child: Text(
                                //               "To",
                                //               textAlign: TextAlign.center,
                                //               style: TextStyle(
                                //                   color: ColorUtils.text_grey,
                                //                   fontFamily: FontUtils.modernistRegular,
                                //                   fontSize: 1.5.t,
                                //                   height: .4),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       Stack(
                                //         children: [
                                //           Container(
                                //             width: 45.w,
                                //             padding: EdgeInsets.symmetric(
                                //                 vertical:
                                //                 SizeConfig.heightMultiplier*2,
                                //                 /*horizontal:
                                //                 SizeConfig.widthMultiplier*1*/),
                                //             decoration: BoxDecoration(
                                //                 color: Colors.white,
                                //                 borderRadius: BorderRadius.all(
                                //                     Radius.circular(
                                //                         Dimensions.roundCorner)),
                                //                 border:
                                //                 Border.all(color: ColorUtils.divider)),
                                //             child: Row(
                                //               children: [
                                //                 TimePickerSpinner(
                                //                   is24HourMode: false,
                                //                   normalTextStyle: TextStyle(
                                //                     fontSize: 14,
                                //                     //color: Colors.deepOrange
                                //                   ),
                                //                   highlightedTextStyle: TextStyle(
                                //                     fontSize: 14,
                                //                     //color: Colors.yellow
                                //                   ),
                                //                   spacing: 1,
                                //                   itemHeight: 15,
                                //                   //isForce2Digits: false,
                                //                   minutesInterval: 5,
                                //                   onTimeChange: (time) {
                                //                     setState(() {
                                //                       _dateTime = time;
                                //                     });
                                //                   },
                                //                 )
                                //               ],
                                //             ),
                                //           ),
                                //           Container(
                                //             margin: EdgeInsets.only(left: 5.w),
                                //             padding: EdgeInsets.symmetric(horizontal: 1.w),
                                //             color: ColorUtils.white,
                                //             child: Text(
                                //               "To",
                                //               textAlign: TextAlign.center,
                                //               style: TextStyle(
                                //                   color: ColorUtils.text_grey,
                                //                   fontFamily: FontUtils.modernistRegular,
                                //                   fontSize: 1.5.t,
                                //                   height: .4),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                ///---Bar Break Time----///
                                SizedBox(height: 3.h),
                                Text(
                                  // "Please set your bar break time",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_12')!,
                                  style: TextStyle(
                                    color: ColorUtils.text_dark,
                                    fontFamily: FontUtils.modernistRegular,
                                    fontSize: 2.t,
                                  ),
                                ),

                                SizedBox(height: 3.h),
                                Container(
                                  //margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Row(
                                    children: [

                                      //From
                                      Expanded(
                                        child: Stack(
                                          children: [

                                            GestureDetector(
                                              onTap: (){
                                                custom.showCustomTimePicker(
                                                    initialTime: model.weekEndBreakTimeFrom!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.weekEndBreakTimeFrom!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode: custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME"
                                                ).then((value){
                                                  model.weekEndBreakTimeFrom = value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: ColorUtils.divider)
                                                ),
                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      child: Text(
                                                        model.weekEndBreakTimeFrom!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.weekEndBreakTimeFrom!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils.modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width: 4.w),

                                                    SvgPicture.asset(ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "From",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_13')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(width: 20),

                                      //To
                                      Expanded(
                                        child: Stack(
                                          children: [

                                            GestureDetector(
                                              onTap: (){
                                                custom.showCustomTimePicker(
                                                    initialTime: model.weekEndBreakTimeTo!=null
                                                        ?
                                                    TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(model.weekEndBreakTimeTo!))
                                                        :
                                                    TimeOfDay(
                                                        hour: TimeOfDay.now().hour,
                                                        minute: 0),
                                                    context: context,
                                                    initialEntryMode: custom.TimePickerEntryMode.dial,
                                                    confirmText: "CONFIRM",
                                                    cancelText: "NOT NOW",
                                                    helpText: "BOOKING TIME"
                                                ).then((value){
                                                  model.weekEndBreakTimeTo = value!.to24hours();
                                                  model.notifyListeners();
                                                });
                                              },
                                              child: Container(
                                                height: 6.h,
                                                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                    color: ColorUtils.white,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    border: Border.all(color: ColorUtils.divider)
                                                ),
                                                child: Row(
                                                  children: [

                                                    Expanded(
                                                      child: Text(
                                                        model.weekEndBreakTimeTo!=null
                                                            ?
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(model.weekEndBreakTimeTo!))
                                                            :
                                                        DateFormat("hh:mm a").format(DateFormat("HH:mm:ss").parse(TimeOfDay(hour: TimeOfDay.now().hour, minute: 0).to24hours())),
                                                        style: TextStyle(
                                                          color: ColorUtils.text_dark,
                                                          fontFamily: FontUtils.modernistRegular,
                                                          fontSize: 1.6.t,
                                                          //height: .4
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(width: 4.w),

                                                    SvgPicture.asset(ImageUtils.upDownArrow),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              margin: EdgeInsets.only(left: 3.w),
                                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                                              color: ColorUtils.white,
                                              child: Text(
                                                // "To",
                                                AppLocalizations.of(
                                                    context)!
                                                    .translate('bar_accounts_text_14')!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: ColorUtils.text_grey,
                                                    fontFamily: FontUtils.modernistRegular,
                                                    fontSize: 1.5.t,
                                                    height: .4
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ///----Location----///
                                SizedBox(height: 3.h),
                                Text(
                                  // "Location",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_15')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t,
                                  ),
                                ),
                                SizedBox(height: 2.h),

                                Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.2.h, horizontal: 4.w),
                                    // margin: EdgeInsets.symmetric(horizontal: Dimensions.containerHorizontalPadding),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.roundCorner),
                                        border: Border.all(
                                            color: model.LocationFocus.hasFocus ||
                                                model.LocationController.text
                                                    .length !=
                                                    0
                                                ? ColorUtils.red_color
                                                : ColorUtils.lightTextColor)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            focusNode: model.LocationFocus,
                                            keyboardType: TextInputType.emailAddress,
                                            textInputAction: TextInputAction.next,
                                            style: TextStyle(
                                                fontFamily: FontUtils.modernistRegular,
                                                fontSize: 2.2.t,
                                                color: ColorUtils.red_color),
                                            controller: model.LocationController,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              hintText:
                                              // "Enter Location",
                                              AppLocalizations.of(
                                                  context)!
                                                  .translate('bar_accounts_text_16')!,
                                              hintStyle: TextStyle(
                                                  fontFamily:
                                                  FontUtils.modernistRegular,
                                                  color: ColorUtils.lightTextColor),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 0),
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset(ImageUtils.locationIcon,
                                            color: model.LocationFocus.hasFocus ||
                                                model.LocationController.text
                                                    .length !=
                                                    0
                                                ? ColorUtils.red_color
                                                : ColorUtils.lightTextColor)
                                      ],
                                    )),
                                SizedBox(height: 3.h),

                                ///------------Kind Of Bar ---------------///
                                Text(
                                  // "Kind of Bar",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_17')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Container(
                                  height: 7.h,
                                  padding: EdgeInsets.symmetric(vertical: .8.h,
                                      horizontal: Dimensions
                                          .containerHorizontalPadding),
                                  decoration: BoxDecoration(
                                      color: ColorUtils.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(Dimensions.roundCorner)),
                                      border: Border.all(color: ColorUtils.red_color)
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: DropdownButton<String>(
                                            value: model.kindOfBarValueStr,
                                            items: model.kindOfBarList
                                                .asMap()
                                                .values
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  "${AppLocalizations.of(
                                                      context)!
                                                      .translate(value)}",
                                                  style: TextStyle(
                                                    fontSize: 1.8.t,
                                                    fontFamily: FontUtils
                                                        .modernistRegular,
                                                    color: ColorUtils.red_color,
                                                    //height: 1.8
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (data) {
                                              setState(() {
                                                model.kindOfBarValueStr =
                                                data as String;
                                                model.kindOfBarValue =
                                                model.kindOfBarMap[model
                                                    .kindOfBarValueStr] as int;
                                              });
                                            },
                                            hint: Text(
                                              "Select an option",
                                              style: TextStyle(
                                                fontSize: 1.8.t,
                                                fontFamily: FontUtils.modernistRegular,
                                                color: ColorUtils.red_color,
                                              ),
                                            ),
                                            isExpanded: true,
                                            underline: Container(
                                            ),
                                            icon: Align(
                                                alignment: Alignment.centerRight,
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  color: ColorUtils.red_color,)
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3.h),

                                ///------------Change Password ---------------///
                                Text(
                                  // "Password",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_18')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t,
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                MaterialButton(

                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.lightTextColor
                                        )
                                    ),
                                    onPressed: () {
                                      model.navigateToChangePassword();
                                    },

                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.2.h, horizontal: 4.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          // "Change Password",
                                          AppLocalizations.of(
                                              context)!
                                              .translate('bar_accounts_text_19')!,
                                          style: TextStyle(
                                          color: ColorUtils.black,

                                          fontFamily: FontUtils.modernistBold,
                                          fontSize: 2.t,
                                        ),),
                                        Icon(Icons.arrow_forward_ios_rounded, size: 4.i,color: Colors.black)
                                      ],
                                    )),

                                SizedBox(height: 3.h),

                                ///------------Account Ownership ---------------///

                                Text(
                                  // "Account Ownership",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('bar_accounts_text_20')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.5.t,
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                MaterialButton(

                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(
                                            Dimensions.roundCorner),
                                        side: BorderSide(
                                            color: ColorUtils.lightTextColor
                                        )
                                    ),
                                    onPressed: () {
                                      model.navigateToBarAccountOwnerShip();
                                    },

                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.2.h, horizontal: 4.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          // "Account Ownership & Control",
                                          AppLocalizations.of(
                                              context)!
                                              .translate('bar_accounts_text_21')!,
                                          style: TextStyle(
                                          color: ColorUtils.black,
                                          fontFamily: FontUtils.modernistBold,
                                          fontSize: 2.t,
                                        ),),
                                        Icon(Icons.arrow_forward_ios_rounded, size: 4.i, color: Colors.black,)
                                      ],
                                    )),
                                SizedBox(height: 6.h),
                              ],
                            ),
                          ),
                        ),


                        SizedBox(
                          width: double.infinity,
                          //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                          child: ElevatedButton(
                            onPressed: () {
                              //model.navigateToHomeBarScreen();
                              model.updateBarTimings();
                            },
                            child: model.busy("updatingBarTimings")?Loader():
                            // const
                            Text(
                                // "Save"
                              AppLocalizations.of(
                                  context)!
                                  .translate('bar_accounts_text_22')!,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorUtils.text_red,
                              onPrimary: ColorUtils.white,
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                  Dimensions.containerVerticalPadding),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.roundCorner)),
                              textStyle: TextStyle(
                                color: ColorUtils.white,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 1.8.t,
                                //height: 0
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  )),
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<RegistrationViewModel>(),
      disposeViewModel: false,
    );
  }
}
