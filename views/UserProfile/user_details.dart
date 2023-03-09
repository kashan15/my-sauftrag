import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/models/favorites_model.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:sauftrag/widgets/favorite_club.dart';
import 'package:sauftrag/widgets/favorite_drink.dart';
import 'package:sauftrag/widgets/favorite_vacation.dart';
import 'package:sauftrag/widgets/loader.dart';
import 'package:stacked/stacked.dart';

import '../../utils/app_localization.dart';
import '../../widgets/dialog_event.dart';
import '../../widgets/dialog_event_user.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (model) {
        model.usersDetails();
        // model.isUserProfile = false;
        // model.notifyListeners();
      },
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: model.isUserProfile == true
              ? AllPageLoader()
              : SafeArea(
              top: true,
              bottom: false,
              child: AbsorbPointer(
                absorbing: model.editProfile,
                child: Scaffold(
                    backgroundColor: ColorUtils.white,
                    body: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.horizontalPadding,
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
                                  model.userModel!.username!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 3.t,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 4.h),

                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: 6,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisCount: 3,
                                  mainAxisSpacing:
                                  1.5 * SizeConfig.heightMultiplier,
                                  //childAspectRatio: 1,
                                  crossAxisSpacing:
                                  2 * SizeConfig.widthMultiplier),
                              itemBuilder: (context, index) {
                                if (model.imageFiles[index] is File)
                                  return Container(
                                      padding: EdgeInsets.all(4.0),
                                      //height: 20.h,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          3.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        image: model.imageFiles[index].path.isEmpty
                                            ? null
                                            : DecorationImage(
                                            image: FileImage(model
                                                .imageFiles[index]),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Stack(
                                        children: [
                                          model.imageFiles[index].path
                                              .isEmpty
                                              ? InkWell(
                                              onTap: () {
                                                if (index != 0) {
                                                  if (model.imageFiles[index - 1]is String ||
                                                      (model.imageFiles[index - 1] as File)
                                                          .path.isNotEmpty)
                                                  {
                                                    model.getImage(index);
                                                    model.notifyListeners();
                                                  }
                                                } else {
                                                  model.getImage(index);
                                                  model.notifyListeners();
                                                }
                                              },
                                              child: DottedBorder(
                                                  color: index != 0
                                                      ? model.imageFiles[index - 1]is File
                                                      ? (model.imageFiles[index - 1] as File)
                                                      .path.isNotEmpty
                                                      ? ColorUtils
                                                      .text_red
                                                      : ColorUtils
                                                      .text_grey
                                                      : ColorUtils
                                                      .text_red
                                                      : ColorUtils
                                                      .text_red,
                                                  strokeWidth: 1.5,
                                                  borderType:
                                                  BorderType.RRect,
                                                  radius: const Radius
                                                      .circular(15),
                                                  dashPattern: [8],
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.add_rounded,
                                                      color: index != 0
                                                          ? model.imageFiles[index - 1]is File
                                                          ? (model.imageFiles[index - 1] as File).path.isNotEmpty
                                                          ? ColorUtils.text_red
                                                          : ColorUtils.text_grey
                                                          : ColorUtils.text_red
                                                          : ColorUtils.text_red,
                                                      size: 8.i,
                                                    ),
                                                  )))
                                              : Container(),
                                          model.imageFiles[index].path.isEmpty
                                              ? Container()
                                              : Align(
                                            alignment:
                                            Alignment.bottomRight,
                                            child: IconButton(
                                              onPressed: () {
                                                model.imageFiles.removeAt(index);
                                                model.imageFiles.add(File(""));
                                                model.notifyListeners();
                                              },
                                              icon: SvgPicture.asset(
                                                  ImageUtils
                                                      .cancelIcon),
                                              //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                                              padding:
                                              EdgeInsets.zero,
                                              constraints:
                                              BoxConstraints(),
                                              color: ColorUtils.white,
                                              highlightColor:
                                              ColorUtils.white,
                                            ),
                                          ),
                                        ],
                                      ));
                                else {
                                  return

                                    Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            3.4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  model.imageFiles[index]),
                                              fit: BoxFit.cover),
                                        ),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment:
                                              Alignment.bottomRight,
                                              child: IconButton(
                                                onPressed: () {
                                                  model.imageFiles
                                                      .removeAt(index);
                                                  model.imageFiles
                                                      .add(File(""));
                                                  model.notifyListeners();
                                                },
                                                icon: SvgPicture.asset(
                                                    ImageUtils.cancelIcon),
                                                //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                                                padding: EdgeInsets.zero,
                                                constraints: BoxConstraints(),
                                                color: ColorUtils.white,
                                                highlightColor:
                                                ColorUtils.white,
                                              ),
                                            ),
                                          ],
                                        ));
                                }
                              },
                            ),

                            // GridView.builder(
                            //   padding: EdgeInsets.zero,
                            //   shrinkWrap: true,
                            //   itemCount: 5,
                            //   gridDelegate:
                            //   SliverGridDelegateWithFixedCrossAxisCount(
                            //       childAspectRatio: 0.7,
                            //       crossAxisCount: 3,
                            //       mainAxisSpacing: 1.5*SizeConfig.widthMultiplier,
                            //       //childAspectRatio: 1,
                            //       crossAxisSpacing: 1*SizeConfig.widthMultiplier),
                            //   itemBuilder: (context, index) {
                            //     if (model.imageFiles[index] is File)
                            //       return Container(
                            //           padding: EdgeInsets.all(4.0),
                            //           //height: 20.h,
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image:
                            //             model.imageFiles[index].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[index]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               model.imageFiles[index].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     if (index != 0) {
                            //                       if (model.imageFiles[index -1] is String ||
                            //                           (model.imageFiles[index -1] as File)
                            //                               .path.isNotEmpty) {
                            //                         model.getImage(index);
                            //                         model.notifyListeners();
                            //                       }
                            //                     }
                            //                     else {
                            //                       model.getImage(index);
                            //                       model.notifyListeners();
                            //                     }
                            //                   },
                            //                   child:
                            //                   DottedBorder(
                            //                       color: index != 0 ?
                            //                       model.imageFiles[index -1] is File ?
                            //                       (model.imageFiles[index -1] as File).path.isNotEmpty
                            //                           ? ColorUtils.text_red
                            //                           : ColorUtils.text_grey
                            //                           :ColorUtils.text_red
                            //                           :ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child:
                            //                         Icon(
                            //                           Icons.add_rounded,
                            //                           color: index != 0 ?
                            //                           model.imageFiles[index -1] is File ?
                            //                           (model.imageFiles[index -1] as File)
                            //                               .path.isNotEmpty
                            //                               ?ColorUtils.text_red
                            //                               :ColorUtils.text_grey
                            //                               :ColorUtils.text_red
                            //                               : ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               model.imageFiles[index].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(index);
                            //                     model.imageFiles.add(File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ));
                            //     else {
                            //       return
                            //         Container(
                            //             width:
                            //             MediaQuery.of(context).size.width / 3.4,
                            //             child: DottedBorder(
                            //                 color: index != 0 ?
                            //                 model.imageFiles[index -1] is File ?
                            //                 (model.imageFiles[index -1] as File).path.isNotEmpty
                            //                     ? ColorUtils.text_red
                            //                     : ColorUtils.text_grey
                            //                     :ColorUtils.text_red
                            //                     :ColorUtils.text_red,
                            //                 strokeWidth: 1.5,
                            //                 borderType: BorderType.RRect,
                            //                 radius:
                            //                 const Radius.circular(15),
                            //                 dashPattern: [8],
                            //                 child: Center(
                            //                   child:
                            //                   Icon(
                            //                     Icons.add_rounded,
                            //                     color: index != 0 ?
                            //                     model.imageFiles[index -1] is File ?
                            //                     (model.imageFiles[index -1] as File)
                            //                         .path.isNotEmpty
                            //                         ?ColorUtils.text_red
                            //                         :ColorUtils.text_grey
                            //                         :ColorUtils.text_red
                            //                         : ColorUtils.text_red,
                            //                     size: 8.i,
                            //                   ),
                            //                 ))
                            //         );
                            //       // child: Stack(
                            //       //   children: [
                            //       //     Align(
                            //       //       alignment: Alignment.bottomRight,
                            //       //       child: IconButton(
                            //       //         onPressed: () {
                            //       //           model.imageFiles.removeAt(index);
                            //       //           model.imageFiles.add(File(""));
                            //       //           model.notifyListeners();
                            //       //         },
                            //       //         icon: SvgPicture.asset(
                            //       //             ImageUtils.cancelIcon),
                            //       //         //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //       //         padding: EdgeInsets.zero,
                            //       //         constraints: BoxConstraints(),
                            //       //         color: ColorUtils.white,
                            //       //         highlightColor:
                            //       //         ColorUtils.white,
                            //       //       ),
                            //       //     ),
                            //       //   ],
                            //       // ));
                            //
                            //
                            //       // Container(
                            //       //   width:
                            //       //   MediaQuery.of(context).size.width / 3.4,
                            //       //   decoration: BoxDecoration(
                            //       //     borderRadius:
                            //       //     BorderRadius.all(Radius.circular(20)),
                            //       //     image: DecorationImage(
                            //       //         image:
                            //       //         NetworkImage(model.imageFiles[index]),
                            //       //         fit: BoxFit.cover),
                            //       //   ),
                            //       //   child: Stack(
                            //       //     children: [
                            //       //       Align(
                            //       //         alignment: Alignment.bottomRight,
                            //       //         child: IconButton(
                            //       //           onPressed: () {
                            //       //             model.imageFiles.removeAt(index);
                            //       //             model.imageFiles.add(File(""));
                            //       //             model.notifyListeners();
                            //       //           },
                            //       //           icon: SvgPicture.asset(
                            //       //               ImageUtils.cancelIcon),
                            //       //           //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //       //           padding: EdgeInsets.zero,
                            //       //           constraints: BoxConstraints(),
                            //       //           color: ColorUtils.white,
                            //       //           highlightColor:
                            //       //           ColorUtils.white,
                            //       //         ),
                            //       //       ),
                            //       //     ],
                            //       //   ));
                            //     }
                            //
                            //   },),

                            //Images
                            // SizedBox(
                            //   height: 17.h,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //
                            //
                            //       //Image 1
                            //       model.imageFiles[0] is File
                            //           ?
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: (model.imageFiles[0] is String &&
                            //                 (model.imageFiles[0] as String).isEmpty) ||
                            //                 model.imageFiles[0].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[0]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               (model.imageFiles[0] is String &&
                            //                   (model.imageFiles[0] as String).isEmpty) ||
                            //                   model.imageFiles[0].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     model.getImage(0);
                            //                     model.notifyListeners();
                            //                   },
                            //                   child: DottedBorder(
                            //                       color: ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child: Icon(
                            //                           Icons.add_rounded,
                            //                           color:
                            //                           ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               (model.imageFiles[0] is String &&
                            //                   (model.imageFiles[0] as String).isEmpty) ||
                            //                   model.imageFiles[0].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(0);
                            //                     model.imageFiles.insert(0, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ))
                            //           :
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: DecorationImage(
                            //                 image:
                            //                 NetworkImage(model.userModel!.profile_picture!),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(0);
                            //                     model.imageFiles.insert(0, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           )),
                            //
                            //       //Image 2
                            //       model.imageFiles[1] is File
                            //           ?
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: (model.imageFiles[1] is String &&
                            //                 (model.imageFiles[1] as String).isEmpty) ||
                            //                 model.imageFiles[1].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[1]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               (model.imageFiles[1] is String &&
                            //                   (model.imageFiles[1] as String).isEmpty) ||
                            //                   model.imageFiles[1].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     model.getImage(1);
                            //                     model.notifyListeners();
                            //                   },
                            //                   child: DottedBorder(
                            //                       color: ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child: Icon(
                            //                           Icons.add_rounded,
                            //                           color:
                            //                           ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               (model.imageFiles[1] is String &&
                            //                   (model.imageFiles[1] as String).isEmpty) ||
                            //                   model.imageFiles[1].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(1);
                            //                     model.imageFiles.insert(1, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ))
                            //           :
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: DecorationImage(
                            //                 image:
                            //                 NetworkImage(model.imageFiles[1]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(1);
                            //                     model.imageFiles.insert(1, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           )),
                            //
                            //       //Image 3
                            //       model.imageFiles[2] is File
                            //           ?
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: (model.imageFiles[2] is String &&
                            //                 (model.imageFiles[2] as String).isEmpty) ||
                            //                 model.imageFiles[2].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[2]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               (model.imageFiles[2] is String &&
                            //                   (model.imageFiles[2] as String).isEmpty) ||
                            //                   model.imageFiles[2].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     model.getImage(2);
                            //                     model.notifyListeners();
                            //                   },
                            //                   child: DottedBorder(
                            //                       color: ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child: Icon(
                            //                           Icons.add_rounded,
                            //                           color:
                            //                           ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               (model.imageFiles[2] is String &&
                            //                   (model.imageFiles[2] as String).isEmpty) ||
                            //                   model.imageFiles[2].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(2);
                            //                     model.imageFiles.insert(2, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ))
                            //           :
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: DecorationImage(
                            //                 image:
                            //                 NetworkImage(model.imageFiles[2]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(2);
                            //                     model.imageFiles.insert(2, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           )),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: 3.h),
                            //
                            // //Images
                            // SizedBox(
                            //   height: 17.h,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       //Image 4
                            //       model.imageFiles[3] is File
                            //           ?
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: (model.imageFiles[3] is String &&
                            //                 (model.imageFiles[3] as String).isEmpty) ||
                            //                 model.imageFiles[3].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[3]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               (model.imageFiles[3] is String &&
                            //                   (model.imageFiles[3] as String).isEmpty) ||
                            //                   model.imageFiles[3].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     model.getImage(3);
                            //                     model.notifyListeners();
                            //                   },
                            //                   child: DottedBorder(
                            //                       color: ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child: Icon(
                            //                           Icons.add_rounded,
                            //                           color:
                            //                           ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               (model.imageFiles[3] is String &&
                            //                   (model.imageFiles[3] as String).isEmpty) ||
                            //                   model.imageFiles[3].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(3);
                            //                     model.imageFiles.insert(3, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ))
                            //           :
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: DecorationImage(
                            //                 image:
                            //                 NetworkImage(model.imageFiles[3]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(3);
                            //                     model.imageFiles.insert(3, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           )),
                            //
                            //       //Image 5
                            //       model.imageFiles[4] is File
                            //           ?
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: (model.imageFiles[4] is String &&
                            //                 (model.imageFiles[4] as String).isEmpty) ||
                            //                 model.imageFiles[4].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[4]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               (model.imageFiles[4] is String &&
                            //                   (model.imageFiles[4] as String).isEmpty) ||
                            //                   model.imageFiles[4].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     model.getImage(4);
                            //                     model.notifyListeners();
                            //                   },
                            //                   child: DottedBorder(
                            //                       color: ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child: Icon(
                            //                           Icons.add_rounded,
                            //                           color:
                            //                           ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               (model.imageFiles[4] is String &&
                            //                   (model.imageFiles[4] as String).isEmpty) ||
                            //                   model.imageFiles[4].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(4);
                            //                     model.imageFiles.insert(4, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ))
                            //           :
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: DecorationImage(
                            //                 image:
                            //                 NetworkImage(model.imageFiles[4]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(4);
                            //                     model.imageFiles.insert(4, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           )),
                            //
                            //       //Image 6
                            //       model.imageFiles[5] is File
                            //           ?
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: (model.imageFiles[5] is String &&
                            //                 (model.imageFiles[5] as String).isEmpty) ||
                            //                 model.imageFiles[5].path.isEmpty
                            //                 ? null
                            //                 : DecorationImage(
                            //                 image:
                            //                 FileImage(model.imageFiles[5]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               (model.imageFiles[5] is String &&
                            //                   (model.imageFiles[5] as String).isEmpty) ||
                            //                   model.imageFiles[5].path.isEmpty
                            //                   ? InkWell(
                            //                   onTap: () {
                            //                     model.getImage(5);
                            //                     model.notifyListeners();
                            //                   },
                            //                   child: DottedBorder(
                            //                       color: ColorUtils.text_red,
                            //                       strokeWidth: 1.5,
                            //                       borderType: BorderType.RRect,
                            //                       radius:
                            //                       const Radius.circular(15),
                            //                       dashPattern: [8],
                            //                       child: Center(
                            //                         child: Icon(
                            //                           Icons.add_rounded,
                            //                           color:
                            //                           ColorUtils.text_red,
                            //                           size: 8.i,
                            //                         ),
                            //                       )))
                            //                   : Container(),
                            //               (model.imageFiles[5] is String &&
                            //                   (model.imageFiles[5] as String).isEmpty) ||
                            //                   model.imageFiles[5].path.isEmpty
                            //                   ? Container()
                            //                   : Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(5);
                            //                     model.imageFiles.insert(5, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           ))
                            //           :
                            //       Container(
                            //           width:
                            //           MediaQuery.of(context).size.width / 3.4,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(Radius.circular(20)),
                            //             image: DecorationImage(
                            //                 image:
                            //                 NetworkImage(model.imageFiles[5]),
                            //                 fit: BoxFit.cover),
                            //           ),
                            //           child: Stack(
                            //             children: [
                            //               Align(
                            //                 alignment: Alignment.bottomRight,
                            //                 child: IconButton(
                            //                   onPressed: () {
                            //                     model.imageFiles.removeAt(5);
                            //                     model.imageFiles.insert(5, File(""));
                            //                     model.notifyListeners();
                            //                   },
                            //                   icon: SvgPicture.asset(
                            //                       ImageUtils.cancelIcon),
                            //                   //icon: Icon(Icons.cancel_outlined, color: ColorUtils.text_red,),
                            //                   padding: EdgeInsets.zero,
                            //                   constraints: BoxConstraints(),
                            //                   color: ColorUtils.white,
                            //                   highlightColor:
                            //                   ColorUtils.white,
                            //                 ),
                            //               ),
                            //             ],
                            //           )),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 4.h),

                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 2.w),
                            //   decoration: BoxDecoration(
                            //       color: ColorUtils.searchFieldColor,
                            //       borderRadius: BorderRadius.all(
                            //         Radius.circular(15.0),
                            //       ),
                            //       // border: Border.all(color: ColorUtils.icon_color)
                            //   ),
                            //
                            //   child: TextField(
                            //     onTap: () {},
                            //     enabled: true,
                            //     //readOnly: true,
                            //     //focusNode: model.searchFocus,
                            //     controller: model.myContactsSearchController,
                            //     decoration: InputDecoration(
                            //       hintText: "About Bar",
                            //       hintStyle: TextStyle(
                            //         fontFamily: FontUtils.modernistRegular,
                            //         color: ColorUtils.icon_color,
                            //         fontSize:
                            //         SizeConfig.textMultiplier * 1.9,
                            //       ),
                            //       border: InputBorder.none,
                            //       isDense: true,
                            //       contentPadding: EdgeInsets.symmetric(
                            //           vertical:
                            //           SizeConfig.heightMultiplier *
                            //               1.9),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: 2.h),
                            //Gender
                            Text(
                              // "Gender",
                              AppLocalizations.of(
                                  context)!
                                  .translate('user_dialog_text_3')!,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.2.t,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              height: 6.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: .8.h,
                                  horizontal: Dimensions
                                      .containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Dimensions.roundCorner)),
                                  border: Border.all(
                                      color: ColorUtils.red_color)),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: DropdownButton<String>(
                                        value: model.userGender,
                                        items: model.genderList.asMap()
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
                                                fontFamily:
                                                FontUtils.modernistRegular,
                                                color: ColorUtils.red_color,
                                                //height: 1.8
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (data) {
                                          setState(() {
                                            model.userGender = data as String;
                                            model.setValues();
                                            model.notifyListeners();

                                            model.genderValue = model.genderMap[
                                            model.genderValueStr] as int;

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
                                              color: ColorUtils.red_color,
                                            )),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              // "About",
                              AppLocalizations.of(
                                  context)!
                                  .translate('user_dialog_text_6')!,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.2.t,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              //height: 15.h,
                              constraints: BoxConstraints(maxHeight: 100),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                  Dimensions.containerVerticalPadding,
                                  horizontal: Dimensions
                                      .containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Dimensions.roundCorner)),
                                  border: Border.all(
                                      color: ColorUtils.divider)),
                              child: TextField(
                                //focusNode: model.signUpUserAboutFocus,
                                controller: model.updateUserAbout,
                                //obscureText: !model.signupEmailVisible,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                                style: TextStyle(
                                  color: ColorUtils.red_color,
                                  fontFamily: FontUtils.modernistRegular,
                                  fontSize: 1.9.t,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                ),
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              // "Relationship",
                              AppLocalizations.of(
                                  context)!
                                  .translate('user_dialog_text_7')!,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontFamily: FontUtils.modernistBold,
                                fontSize: 2.2.t,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              height: 6.h,
                              padding: EdgeInsets.symmetric(
                                  vertical: .8.h,
                                  horizontal: Dimensions
                                      .containerHorizontalPadding),
                              decoration: BoxDecoration(
                                  color: ColorUtils.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          Dimensions.roundCorner)),
                                  border: Border.all(
                                      color: ColorUtils.red_color)),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: DropdownButton<String>(
                                        value: model.currentRelation,
                                        items: model.relationshipList
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
                                                fontFamily:
                                                FontUtils.modernistRegular,
                                                color: ColorUtils.red_color,
                                                //height: 1.8
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (data) {
                                          setState(() {
                                            model.currentRelation =
                                            data as String;
                                            model.setValues();
                                            model.notifyListeners();
                                            model.relationValue = model
                                                .relationshipMap[
                                            model.relationValueStr] as int;
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
                                              color: ColorUtils.red_color,
                                            )),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),

                            //
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // "Lieblingsalkoholisches Getränk",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('user_dialog_text_16')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.2.t,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          model.selectedDrinkList.clear();
                                          model.selectedDrinkList.addAll(
                                              model.userModel!
                                                  .favorite_alcohol_drinks!);
                                          // model.selectedClubList = model.userModel!.favorite_night_club!;
                                          // model.selectedVacationList = model.userModel!.favorite_party_vacation!;
                                          return FavoriteDrinkList(
                                              title: "Add Favorite Drink",
                                              btnTxt: "Add Favorite Drink");
                                        });
                                  },
                                  child: Text(
                                    // "Edit",
                                    AppLocalizations.of(
                                        context)!
                                        .translate('user_dialog_text_13')!,
                                    style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily:
                                        FontUtils.modernistRegular,
                                        fontSize: 1.8.t,
                                        decoration:
                                        TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),

                            //Drink
                            Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children:
                              // model.userModel!.favorite_alcohol_drinks!
                              model.userModel!.favorite_alcohol_drinks!
                                  .map((element) => ElevatedButton(
                                onPressed: () {
                                  // if(model.selectedDrinkList.contains(element.id)){
                                  //   model.selectedDrinkList.remove(element.id);
                                  // }
                                  // else{
                                  //   // if(element == "Radler"){
                                  //   //   showDialog(
                                  //   //       context: context,
                                  //   //       builder: (BuildContext context){
                                  //   //         return RadlerDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                  //   //       }
                                  //   //   );
                                  //   // }
                                  //   model.selectedDrinkList.add(element.id);
                                  // }
                                  // model.notifyListeners();
                                },
                                child: (model.drinkList.where((drink) => drink.id == element).first as FavoritesModel).name  == null ?
                                Text("sauftrag drink",

                                ) :
                                Text((model.drinkList.where((drink) => drink.id == element).first as FavoritesModel).name ??
                                    ""),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.red_color,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.8.h,
                                      horizontal: 9.w),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Dimensions
                                              .roundCorner),
                                      side: BorderSide(
                                          color: ColorUtils
                                              .text_red,
                                          width: 1)),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily:
                                    FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                            SizedBox(height: 3.h),

                            //Favorite Night Club
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // "Leiblingsmusik",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('user_dialog_text_17')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.2.t,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          model.selectedClubList.clear();
                                          model.selectedClubList.addAll(
                                              model.userModel!
                                                  .favorite_musics!);
                                          // model.selectedClubList = model.userModel!.favorite_night_club!;
                                          // model.selectedVacationList = model.userModel!.favorite_party_vacation!;
                                          return FavoriteClub(
                                              title: "Add Favorite Drink",
                                              btnTxt: "Add Favorite Drink");
                                        });
                                  },
                                  child: Text(
                                    // "Edit",
                                    AppLocalizations.of(
                                        context)!
                                        .translate('user_dialog_text_14')!,
                                    style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily:
                                        FontUtils.modernistRegular,
                                        fontSize: 1.8.t,
                                        decoration:
                                        TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),

                            //Night Club
                            Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children: model.userModel!.favorite_musics!
                                  .map((element) => ElevatedButton(
                                onPressed: () {
                                  // if(model.selectedDrinkList.contains(element.id)){
                                  //   model.selectedDrinkList.remove(element.id);
                                  // }
                                  // else{
                                  //   // if(element == "Radler"){
                                  //   //   showDialog(
                                  //   //       context: context,
                                  //   //       builder: (BuildContext context){
                                  //   //         return RadlerDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                  //   //       }
                                  //   //   );
                                  //   // }
                                  //   model.selectedDrinkList.add(element.id);
                                  // }
                                  // model.notifyListeners();
                                },
                                child: Text((model.clubList
                                    .where((drink) => drink.id == element).first as FavoritesModel).name ??
                                    ""),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.red_color,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.8.h,
                                      horizontal: 9.w),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Dimensions
                                              .roundCorner),
                                      side: BorderSide(
                                          color:
                                          ColorUtils.text_red,
                                          width: 1)),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily:
                                    FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                            SizedBox(height: 3.h),

                            //Favorite Party Vacation
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // "Lieblingsurlaub",
                                  AppLocalizations.of(
                                      context)!
                                      .translate('user_dialog_text_18')!,
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontFamily: FontUtils.modernistBold,
                                    fontSize: 2.2.t,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          model.selectedVacationList.clear();
                                          model.selectedVacationList.addAll(
                                              model.userModel!
                                                  .favorite_party_vacation!);
                                          // model.selectedClubList = model.userModel!.favorite_night_club!;
                                          // model.selectedVacationList = model.userModel!.favorite_party_vacation!;
                                          return FavoriteVacation(
                                              title:
                                              "Add Favorite Vacations",
                                              btnTxt:
                                              "Add Favorite Vacations");
                                        });
                                  },
                                  child: Text(
                                    // "Edit",
                                    AppLocalizations.of(
                                        context)!
                                        .translate('user_dialog_text_15')!,
                                    style: TextStyle(
                                        color: ColorUtils.red_color,
                                        fontFamily:
                                        FontUtils.modernistRegular,
                                        fontSize: 1.8.t,
                                        decoration:
                                        TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),

                            //Party Vacation
                            Wrap(
                              spacing: 2.5.w,
                              runSpacing: 1.5.h,
                              direction: Axis.horizontal,
                              children:
                              model.userModel!.favorite_party_vacation!
                                  .map((element) => ElevatedButton(
                                onPressed: () {
                                  // if(model.selectedDrinkList.contains(element.id)){
                                  //   model.selectedDrinkList.remove(element.id);
                                  // }
                                  // else{
                                  //   // if(element == "Radler"){
                                  //   //   showDialog(
                                  //   //       context: context,
                                  //   //       builder: (BuildContext context){
                                  //   //         return RadlerDialogBox(title: "Add New Location", btnTxt: "Add Location", icon: ImageUtils.addLocationIcon);
                                  //   //       }
                                  //   //   );
                                  //   // }
                                  //   model.selectedDrinkList.add(element.id);
                                  // }
                                  // model.notifyListeners();
                                },
                                child: Text((model.vacationList
                                    .where((drink) => drink.id == element).first as FavoritesModel).name ??
                                    ""),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.red_color,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.8.h,
                                      horizontal: 9.w),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          Dimensions
                                              .roundCorner),
                                      side: BorderSide(
                                          color: ColorUtils
                                              .text_red,
                                          width: 1)),
                                  textStyle: TextStyle(
                                    //color: model.role == Constants.user ? ColorUtils.white: ColorUtils.text_red,
                                    fontFamily:
                                    FontUtils.modernistBold,
                                    fontSize: 1.8.t,
                                    //height: 0
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                            SizedBox(height: 2.h),

                            SizedBox(height: 4.h),
                            SizedBox(
                              width: double.infinity,
                              //margin: EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 2, horizontal: SizeConfig.widthMultiplier * 4),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(model.imageFiles.first is File){
                                    if (model.imageFiles.first.path ==""){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogEventUser(
                                                title: "Add New Location",
                                                btnTxt: "Add Location",
                                                icon: ImageUtils.addLocationIcon);
                                          });
                                    }else{
                                      await model.updatingUser();
                                    }
                                  } else{
                                    await model.updatingUser();
                                  }

                                  // if(model.imageFiles.first == ''){
                                  //
                                  // }
                                  //   // else if(model.imageFiles.first.path.isNotEmpty){
                                  //   //   await model.updatingUser();
                                  //   //   //model.navigateBack();
                                  //   // }


                                },
                                child: model.editProfile == false
                                    ? Text(
                                  // "Save"
                                  AppLocalizations.of(
                                      context)!
                                      .translate('user_dialog_text_19')!,
                                )
                                    : Loader(),
                                style: ElevatedButton.styleFrom(
                                  primary: ColorUtils.text_red,
                                  onPrimary: ColorUtils.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions
                                          .containerVerticalPadding),
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
                      ),
                    )),
              )),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }
}
