import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/favorites_model.dart';
import 'package:sauftrag/services/addFavorites.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/constants.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';
import 'package:sauftrag/widgets/add_dialog_box_clubs.dart';
import 'package:sauftrag/widgets/add_dialog_box_drinks.dart';
import 'package:sauftrag/widgets/add_dialog_box_partyLocations.dart';
import 'package:sauftrag/widgets/back_arrow_with_container.dart';
import 'package:sauftrag/widgets/radler_dialog_box.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';

class Favorite extends StatefulWidget {

  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<RegistrationViewModel>.reactive(
      onModelReady: (model) async{
        model.drinkList = await  Addfavorites().GetFavoritesDrink();
        model.clubList = await  Addfavorites().GetFavoritesClub();
        model.vacationList = await  Addfavorites().GetFavoritesPartyVacation();
        model.notifyListeners();
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
                backgroundColor: ColorUtils.white,
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontalPadding, ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        SizedBox(height: Dimensions.topMargin),

                        //Favorite Alcoholic Drink
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
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

                                Expanded(
                                  child: Text(
                                    "Beliebtestes alkoholisches Getränk",
                                    style: TextStyle(
                                      color: ColorUtils.black,
                                      fontFamily: FontUtils.modernistBold,
                                      fontSize: 3.t,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),

                            Text(
                              "Das alkoholische Lieblingsgetränk macht es einfacher zu finden, wer Ihre Interessen teilt. Fügen Sie Ihrem Profil bis zu 5 Getränke hinzu, um bessere Verbindungen herzustellen. ",
                              style: TextStyle(
                                color: ColorUtils.text_dark,
                                fontFamily: FontUtils.modernistRegular,
                                fontSize: 1.8.t,
                              ),
                            ),
                            SizedBox(height: 3.h),

                            Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: model.drinkList
                                  .map((element) => ElevatedButton(
                                onPressed: () {
                                  if(model.selectedDrinkList.contains(element.id)){
                                    model.selectedDrinkList.remove(element.id);
                                  }
                                  else{
                                    if((element as FavoritesModel).name == "Radler"){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return RadlerDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                          }
                                      );
                                      return;
                                    }
                                    else{
                                      model.selectedDrinkList.add(element.id!);
                                    }
                                  }
                                  model.notifyListeners();
                                },
                                child: Text((model.drinkList[model.drinkList.indexOf(element)] as FavoritesModel).name ?? ""),
                                style: ElevatedButton.styleFrom(
                                  primary: model.selectedDrinkList.contains(element.id) ? ColorUtils.text_red : ColorUtils.white,
                                  onPrimary: model.selectedDrinkList.contains(element.id) ? ColorUtils.white : ColorUtils.text_dark,
                                  padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 9.w),
                                  elevation: model.selectedDrinkList.contains(element.id) ? 5 : 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                      side: BorderSide(
                                          color: model.selectedDrinkList.contains(element.id) ? ColorUtils.text_red : ColorUtils.divider,
                                          width: 1
                                      )
                                  ),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily: model.selectedDrinkList.contains(element.id) ? FontUtils.modernistBold : FontUtils.modernistRegular,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              )).toList(),
                            ),
                            SizedBox(height: 2.h),
                            // Wrap(
                            //   spacing: 2.5.w,
                            //   runSpacing: 1.5.h,
                            //   direction: Axis.horizontal,
                            //   children: model.addDrinkList
                            //       .map((element) => ElevatedButton(
                            //     onPressed: () {
                            //       if(model.addDrinkList.contains(model.addDrinkList.indexOf(element))){
                            //         model.addDrinkList.remove(model.addDrinkList.indexOf(element));
                            //       }
                            //       else{
                            //           model.addDrinkList.add(FavoritesModel[]);
                            //       }
                            //       model.notifyListeners();
                            //     },
                            //     child: Text(model.addDrinkList.toString()),
                            //     style: ElevatedButton.styleFrom(
                            //       primary: model.addDrinkList.contains(model.addDrinkList.indexOf(element)) ? ColorUtils.text_red : ColorUtils.white,
                            //       onPrimary: model.addDrinkList.contains(model.addDrinkList.indexOf(element)) ? ColorUtils.white : ColorUtils.text_dark,
                            //       padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 9.w),
                            //       elevation: model.addDrinkList.contains(model.addDrinkList.indexOf(element)) ? 5 : 0,
                            //       shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                            //           side: BorderSide(
                            //               color: model.addDrinkList.contains(model.addDrinkList.indexOf(element)) ? ColorUtils.text_red : ColorUtils.divider,
                            //               width: 1
                            //           )
                            //       ),
                            //       textStyle: TextStyle(
                            //         //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                            //         fontFamily: model.addDrinkList.contains(model.addDrinkList.indexOf(element)) ? FontUtils.modernistBold : FontUtils.modernistRegular,
                            //         fontSize: 1.8.t,
                            //         //height: 0
                            //       ),
                            //     ),
                            //   )).toList(),
                            // ),

                            // ElevatedButton(
                            //   onPressed: () {
                            //     showDialog(
                            //         context: context,
                            //         builder: (BuildContext context){
                            //           return AddDialogBox(title: "Add New Drink", btnTxt: "Add Drink", icon: ImageUtils.addDrinkIcon);
                            //         }
                            //     );
                            //   },
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //
                            //       SvgPicture.asset(ImageUtils.addDrinkIcon),
                            //
                            //       SizedBox(width: 10),
                            //
                            //       Text("Getränk hinzufügen")
                            //     ],
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //     primary: ColorUtils.white,
                            //     onPrimary: ColorUtils.text_red,
                            //     padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                            //     elevation: 0,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                            //         side: BorderSide(
                            //             color: ColorUtils.text_red,
                            //             width: 1
                            //         )
                            //     ),
                            //     textStyle: TextStyle(
                            //       fontFamily: FontUtils.modernistRegular,
                            //       fontSize: 1.8.t,
                            //       //height: 0
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        //Favorite Night Clubs
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Lieblingsmusik",
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 3.t,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            Text(
                              "Was sind Ihre Lieblings-Nachtclubs und -bars? Fügen Sie Ihrem Profil einen Standort hinzu, um bessere Verbindungen herzustellen.",
                              style: TextStyle(
                                color: ColorUtils.text_dark,
                                fontFamily: FontUtils.modernistRegular,
                                fontSize: 1.8.t,
                              ),
                            ),
                            SizedBox(height: 3.h),

                            // MediaQuery.removePadding(
                            //   removeTop: true,
                            //   removeBottom: true,
                            //   context: context,
                            //   child: GridView.builder(
                            //     itemCount: model.clubList.length,
                            //     scrollDirection: Axis.vertical,
                            //     physics: BouncingScrollPhysics(),
                            //     shrinkWrap: true,
                            //     primary: false,
                            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //         childAspectRatio: 3.5,
                            //         crossAxisCount: 2,
                            //         crossAxisSpacing: 15,
                            //         mainAxisSpacing: 15
                            //     ),
                            //     itemBuilder: (BuildContext context, int index){
                            //       return ElevatedButton(
                            //         onPressed: () {
                            //           if(model.selectedClubList.contains((model.clubList[index] as FavoritesModel).id)){
                            //             model.selectedClubList.remove((model.clubList[index] as FavoritesModel).id);
                            //           }
                            //           else{
                            //             model.selectedClubList.add((model.clubList[index] as FavoritesModel).id!);
                            //           }
                            //           model.notifyListeners();
                            //         },
                            //         child:  Text((model.clubList[index] as FavoritesModel).name ?? ""),
                            //         //Text(model.clubList[index]),
                            //         style: ElevatedButton.styleFrom(
                            //           primary: model.selectedClubList.contains((model.clubList[index] as FavoritesModel).id) ? ColorUtils.text_red : ColorUtils.white,
                            //           onPrimary: model.selectedClubList.contains((model.clubList[index] as FavoritesModel).id) ? ColorUtils.white : ColorUtils.text_dark,
                            //           padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                            //           elevation: model.selectedClubList.contains((model.clubList[index] as FavoritesModel).id) ? 5 : 0,
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                            //               side: BorderSide(
                            //                   color: model.selectedClubList.contains((model.clubList[index] as FavoritesModel).id) ? ColorUtils.text_red : ColorUtils.divider,
                            //                   width: 1
                            //               )
                            //           ),
                            //           textStyle: TextStyle(
                            //             //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                            //             fontFamily: model.selectedClubList.contains((model.clubList[index] as FavoritesModel).id) ? FontUtils.modernistBold : FontUtils.modernistRegular,
                            //             fontSize: 1.8.t,
                            //             //height: 0
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(height: 2.h),
                            Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: model.clubList
                                  .map((element) =>
                                  ElevatedButton(
                                    onPressed: () {
                                      if(model.selectedClubList.contains(element.id)){
                                        model.selectedClubList.remove((element.id));
                                      }
                                      else{
                                        model.selectedClubList.add((element.id));
                                      }
                                      model.notifyListeners();
                                    },
                                child:  Text((model.clubList[model.clubList.indexOf(element)] as FavoritesModel).name ?? ""),
                                    //Text(model.clubList[index]),
                                    style: ElevatedButton.styleFrom(
                                      primary: model.selectedClubList.contains(element.id) ? ColorUtils.text_red : ColorUtils.white,
                                      onPrimary: model.selectedClubList.contains(element.id) ? ColorUtils.white : ColorUtils.text_dark,
                                      padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 9.w),
                                      elevation: model.selectedClubList.contains(element.id) ? 5 : 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                          side: BorderSide(
                                              color: model.selectedClubList.contains(element.id) ? ColorUtils.text_red : ColorUtils.divider,
                                              width: 1
                                          )
                                      ),
                                      textStyle: TextStyle(
                                        //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                        fontFamily: model.selectedClubList.contains(element.id) ? FontUtils.modernistBold : FontUtils.modernistRegular,
                                        fontSize: 1.8.t,
                                        //height: 0
                                      ),
                                    ),
                              )).toList(),
                            ),

                            // ElevatedButton(
                            //   onPressed: () {
                            //     showDialog(
                            //         context: context,
                            //         builder: (BuildCon`text context){
                            //           return AddDialogBoxClubs(title: "Add New Club", btnTxt: "Add Club", icon: ImageUtils.addClubIcon);
                            //         }
                            //     );
                            //   },
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //
                            //       SvgPicture.asset(ImageUtils.addClubIcon),
                            //
                            //       SizedBox(width: 10),
                            //
                            //       Text("Verein hinzufügen")
                            //     ],
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //     primary: ColorUtils.white,
                            //     onPrimary: ColorUtils.text_red,
                            //     padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                            //     elevation: 0,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                            //         side: BorderSide(
                            //             color: ColorUtils.text_red,
                            //             width: 1
                            //         )
                            //     ),
                            //     textStyle: TextStyle(
                            //       fontFamily: FontUtils.modernistRegular,
                            //       fontSize: 1.8.t,
                            //       //height: 0
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        //Favorite Party Vacation
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Lieblingsurlaub",
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 3.t,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            Text(
                              "Wo macht ihr gerne Partyurlaub. Fügen Sie Ihrem Profil einen Standort hinzu, um bessere Verbindungen herzustellen.",
                              style: TextStyle(
                                color: ColorUtils.text_dark,
                                fontFamily: FontUtils.modernistRegular,
                                fontSize: 1.8.t,
                              ),
                            ),
                            SizedBox(height: 3.h),

                            Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: model.vacationList
                                  .map((element) => ElevatedButton(
                                onPressed: () {
                                  if(model.selectedVacationList.contains(element.id)){
                                    model.selectedVacationList.remove(element.id);
                                  }
                                  else{
                                    model.selectedVacationList.add(element.id);
                                  }
                                  model.notifyListeners();
                                },
                                child: Text((element as FavoritesModel).name ?? ""),
                                //Text(model.vacationList[model.vacationList.indexOf(element)]),
                                style: ElevatedButton.styleFrom(
                                  primary: model.selectedVacationList.contains(element.id) ? ColorUtils.text_red : ColorUtils.white,
                                  onPrimary: model.selectedVacationList.contains(element.id) ? ColorUtils.white : ColorUtils.text_dark,
                                  padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 9.w),
                                  elevation: model.selectedVacationList.contains(element.id) ? 5 : 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                                      side: BorderSide(
                                          color: model.selectedVacationList.contains(element.id) ? ColorUtils.text_red : ColorUtils.divider,
                                          width: 1
                                      )
                                  ),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily: model.selectedVacationList.contains(element.id) ? FontUtils.modernistBold : FontUtils.modernistRegular,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              )).toList(),
                            ),
                            SizedBox(height: 2.h),

                            // ElevatedButton(
                            //   onPressed: () {
                            //     showDialog(
                            //         context: context,
                            //         builder: (BuildContext context){
                            //           return AddDialogBoxPartyLocation(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                            //         }
                            //     );
                            //   },
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //
                            //       SvgPicture.asset(ImageUtils.addLocationIcon),
                            //
                            //       SizedBox(width: 10),
                            //
                            //       Text("Ort hinzufügen")
                            //     ],
                            //   ),
                            //   style: ElevatedButton.styleFrom(
                            //     primary: ColorUtils.white,
                            //     onPrimary: ColorUtils.text_red,
                            //     padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                            //     elevation: 0,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(Dimensions.roundCorner),
                            //         side: BorderSide(
                            //             color: ColorUtils.text_red,
                            //             width: 1
                            //         )
                            //     ),
                            //     textStyle: TextStyle(
                            //       fontFamily: FontUtils.modernistRegular,
                            //       fontSize: 1.8.t,
                            //       //height: 0
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 5.h),

                        //Next Button
                        SizedBox(
                          width: double.infinity,
                          //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                          child: ElevatedButton(
                            onPressed: () {
                              model.favorites();
                              //model.navigateToMediaScreen();
                            },
                            child:
                            // const
                            Text(
                                // "Next"
                              AppLocalizations.of(context)!
                                  .translate('favorite_1')!,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorUtils.text_red  ,
                              onPrimary: ColorUtils.white,
                              padding: EdgeInsets.symmetric(vertical: Dimensions.containerVerticalPadding),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.roundCorner)
                              ),
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
                  ),
                )
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<RegistrationViewModel>(),
      disposeViewModel: false,
    );
  }
}
