import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/services/addFavorites.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/views/Home/main_view.dart';
import 'package:sauftrag/widgets/all_page_loader.dart';
import 'package:sauftrag/widgets/drink_status_dialog_box.dart';
import 'package:sauftrag/widgets/drink_update_status_dialog_box.dart';
import 'package:sauftrag/widgets/my_side_menu.dart';
import 'package:sauftrag/widgets/swipe_card.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui' as ui;

import '../../utils/app_localization.dart';

class Swipe extends StatefulWidget {
  const Swipe({Key? key}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> with TickerProviderStateMixin {
  /*List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = [ImageUtils.girl1, ImageUtils.girl2, ImageUtils.girl1, ImageUtils.girl2, ImageUtils.girl1];
  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i], color: _colors[i]),
          likeAction: () {
          },
          nopeAction: () {
          },
          superlikeAction: () {
          }
          )
      );
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);

    super.initState();
  }*/

  late AnimationController _buttonController;
  late Animation<double> rotate;
  late Animation<double> right;
  late Animation<double> bottom;
  late Animation<double> width;

  late AnimationController _reverseButtonController;
  late Animation<double> undoRotate;
  late Animation<double> undoRight;
  late Animation<double> undoBottom;
  late Animation<double> undoWidth;
  int flag = 0;
  bool undoSwipe = false;
  List<String> welcomeImages = [
    ImageUtils.girl1,
    ImageUtils.girl2,
    ImageUtils.girl3,
    ImageUtils.girl4,
    ImageUtils.girl5,
    ImageUtils.girl6,
    ImageUtils.girl7,
    ImageUtils.girl8,
    ImageUtils.girl9,
    ImageUtils.girl10,
    ImageUtils.girl11,
    ImageUtils.girl12
  ];
  List<List<String>> data = [
    [
      ImageUtils.girl4,
      ImageUtils.girl5,
      ImageUtils.girl6,
    ],
    [
      ImageUtils.girl1,
      ImageUtils.girl2,
      ImageUtils.girl3,
    ],
    [
      ImageUtils.girl10,
      ImageUtils.girl11,
      ImageUtils.girl12,
      ImageUtils.girl13
    ],
    [
      ImageUtils.girl7,
      ImageUtils.girl8,
      ImageUtils.girl9,
    ],
    [
      ImageUtils.girl4,
      ImageUtils.girl5,
      ImageUtils.girl6,
    ],
    [
      ImageUtils.girl1,
      ImageUtils.girl2,
      ImageUtils.girl3,
    ],
  ];

  List selectedData = [];

  late PageController pageController;
  final currentPageNotifier = ValueNotifier<int>(0);

  void initState() {
    super.initState();
    MainViewModel model = locator<MainViewModel>();
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    pageController = PageController(initialPage: 0);
    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = model.catalogImages.removeLast();
          model.catalogImages.insert(0, i);
          _buttonController.reset();
        }
      });
    });
    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );


    _reverseButtonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);


    undoRotate = new Tween<double>(
      begin: -40.0,
      end: -0.0,
    ).animate(
      new CurvedAnimation(
        parent: _reverseButtonController,
        curve: Curves.ease,
      ),
    );
    undoRotate.addListener(() {
      setState(() {
        if (undoRotate.isCompleted) {
          // var i = model.catalogImages.removeLast();
          // model.catalogImages.insert(0, i);
          _reverseButtonController.reset();
        }
      });
    });
    undoRight = new Tween<double>(
      begin: 400.0,
      end: 0.0,
    ).animate(
      new CurvedAnimation(
        parent: _reverseButtonController,
        curve: Curves.ease,
      ),
    );
    undoBottom = new Tween<double>(
      begin: 100.0,
      end: 15.0,
    ).animate(
      new CurvedAnimation(
        parent: _reverseButtonController,
        curve: Curves.ease,
      ),
    );
    undoWidth = new Tween<double>(
      begin: 25.0,
      end: 20.0,
    ).animate(
      new CurvedAnimation(
        parent: _reverseButtonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  Future<Null> _reverseSwipeAnimation() async {
    try {
      await _reverseButtonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(List img, MainViewModel model) {
    if (model.catalogImages.indexOf(img) ==
        model.catalogImages.indexOf(model.catalogImages.first)) {
      model.getDiscover(context);
    }
    setState(() {
      model.removedImages.add(img);
      model.sentMatchRequests.add("");
      model.catalogImages.remove(img);
    });

    print(model.catalogImages.length);
  }

  addImg(List img, MainViewModel model) {
    setState(() {
      model.catalogImages.remove(img);
      selectedData.add(img);
    });
  }

 Future swipeRight() async{
    //model.
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    await _swipeAnimation();
  }

  Future swipeLeft() async{
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    await _swipeAnimation();
  }

  Future doUndoSwipe() async{
    undoSwipe = true;
    if (locator<MainViewModel>().sentMatchRequests.last is String)
      setState(() {
        flag = 0;
      });
    else{
      if (flag == 0)
        setState(() {
          flag = 1;
        });
    }
    await _reverseSwipeAnimation();
    undoSwipe = false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    double initialBottom = 15.0;
    var dataLength = data.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = 0.0;
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (data) async{
        data.drinkList =
            await Addfavorites().GetFavoritesDrink();
        data.clubList =
            await Addfavorites().GetFavoritesClub();
        data.vacationList =
            await Addfavorites().GetFavoritesPartyVacation();
        data.getDiscover(context);
      },
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: SideMenu(
            key: model.sideMenuKey,
            type: SideMenuType.shrinkNSlide,
            background: ColorUtils.text_red,
            radius: BorderRadius.circular(30),
            menu: MySideMenu(),
            child: Scaffold(
              backgroundColor: ColorUtils.white,
              body: InkWell(
                onTap: () {
                  final _state = model.sideMenuKey.currentState;
                  if (_state!.isOpened) _state.closeSideMenu();
                  model.notifyListeners();
                },

                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 0, vertical: Dimensions.verticalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.homeTopMargin),

                      //Top bar
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.horizontalPadding),
                        //margin: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final _state = model.sideMenuKey.currentState;
                                if (_state!.isOpened)
                                  _state.closeSideMenu(); // close side menu
                                else
                                  _state.openSideMenu();
                                model.notifyListeners();
                              },
                              child: SvgPicture.asset(ImageUtils.menuIcon),
                              style: ElevatedButton.styleFrom(
                                primary: ColorUtils.white,
                                onPrimary: ColorUtils.white,
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.containerVerticalPadding),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.roundCorner),
                                    side: BorderSide(
                                        color: ColorUtils.divider, width: 1)),
                                textStyle: TextStyle(
                                  color: ColorUtils.white,
                                  fontFamily: FontUtils.modernistBold,
                                  fontSize: 1.8.t,
                                  //height: 0
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                // Text(
                                //   "Discover",
                                //   style: TextStyle(
                                //     color: ColorUtils.black,
                                //     fontFamily: FontUtils.modernistBold,
                                //     fontSize: 3.t,
                                //   ),
                                // ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate(
                                      'swipe_screen_text_1')!,
                                  style: TextStyle(
                                    fontFamily:
                                    FontUtils.modernistBold,
                                    fontSize: 3.t,
                                  ),
                                ),
                                // Text(
                                //   "Chicago",
                                //   style: TextStyle(
                                //     color: ColorUtils.black,
                                //     fontFamily: FontUtils.modernistRegular,
                                //     fontSize: 1.7.t,
                                //   ),
                                // ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (model.getStatus != null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DrinkUpdateStatusDialogBox(
                                            title: "Add New Location",
                                            btnTxt: "Add Location",
                                            icon: ImageUtils.addLocationIcon);
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DrinkStatusDialogBox(
                                            title: "Add New Location",
                                            btnTxt: "Add Location",
                                            icon: ImageUtils.addLocationIcon);
                                      });
                                }
                              },
                              child: model.getStatus == null
                                  ? SvgPicture.asset(ImageUtils.beerMug)
                                  : Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageUtils.bottleSelected,
                                          height: 3.5.h,
                                        ),
                                        Text(
                                          "x${model.getStatus!.quantity}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 1.2.t,
                                              height: 0.5.h),
                                          textAlign: TextAlign.end,
                                        ),
                                        if(model.updatedrinkIndex == 1)
                                        Container(
                                          width: 15.w,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Gemütlich einen trinken",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: ColorUtils.text_red,
                                              fontFamily:
                                                  FontUtils.modernistBold,
                                              fontSize: 1.2.t,
                                            ),
                                          ),
                                        ),
                                        if(model.updatedrinkIndex == 2)
                                          Container(
                                            width: 15.w,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Motor anwärmen",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: ColorUtils.text_red,
                                                fontFamily:
                                                FontUtils.modernistBold,
                                                fontSize: 1.2.t,
                                              ),
                                            ),
                                          ),
                                        if(model.updatedrinkIndex == 3)
                                          Container(
                                            width: 15.w,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Schön einen reinorgeln",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: ColorUtils.text_red,
                                                fontFamily:
                                                FontUtils.modernistBold,
                                                fontSize: 1.2.t,
                                              ),
                                            ),
                                          ),
                                        if(model.updatedrinkIndex == 4)
                                          Container(
                                            width: 15.w,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Die Rüstung demolieren",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: ColorUtils.text_red,
                                                fontFamily:
                                                FontUtils.modernistBold,
                                                fontSize: 1.2.t,
                                              ),
                                            ),
                                          ),
                                        if(model.updatedrinkIndex == 5)
                                          Container(
                                            width: 15.w,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Sauftrag komplett erfüllen",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: ColorUtils.text_red,
                                                fontFamily:
                                                FontUtils.modernistBold,
                                                fontSize: 1.2.t,
                                              ),
                                            ),
                                          ),

                                      ],
                                    ),

                              style: ElevatedButton.styleFrom(
                                primary: ColorUtils.white,
                                //onPrimary: ColorUtils.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.5.h, horizontal: 3.3.w),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.roundCorner),
                                    side: BorderSide(
                                        color: ColorUtils.divider, width: 1)),
                                textStyle: TextStyle(
                                  color: ColorUtils.white,
                                  fontFamily: FontUtils.modernistBold,
                                  fontSize: 1.8.t,
                                  //height: 0
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //margin: EdgeInsets.symmetric(vertical: 2.h),
                          child: model.discoverLoader
                              ? AllPageLoader()
                              : model.catalogImages.isEmpty
                                  ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Image.asset(ImageUtils.UserNotFound),
                          )
                                  : AbsorbPointer(
                                      absorbing:
                                          model.sideMenuKey.currentState !=
                                                  null &&
                                              model.sideMenuKey.currentState!
                                                  .isOpened,
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: model.catalogImages.map((item) {
                                          return SwipeCard(
                                            user: model.discoverModel![model.catalogImages.indexOf(item)],
                                            name: model.discoverModel![model.catalogImages.indexOf(item)].username,
                                            img: item,
                                            cardWidth: backCardWidth + 0,
                                            rotation: undoSwipe?undoRotate.value:rotate.value,
                                            skew: undoSwipe?undoRotate.value > -10 ? 0.0 : 0.1:rotate.value < -10 ? 0.1 : 0.0,
                                            address: model.discoverModel![model.catalogImages.indexOf(item)].address,
                                            distance : model.discoverModel![model.catalogImages.indexOf(item)].distance!,
                                            drinking_motivation : model.discoverModel![model.catalogImages.indexOf(item)].drinking_motivation,
                                            details: ()async {
                                              if(model.catalogImages.isNotEmpty){
                                                final Image image = Image(image: NetworkImage((item as List<String>).first));
                                                Completer<ui.Image> completer = new Completer<ui.Image>();
                                                image.image
                                                    .resolve(new ImageConfiguration())
                                                    .addListener(new ImageStreamListener((ImageInfo image, bool _) {
                                                  completer.complete(image.image);
                                                }));
                                                ui.Image info = await completer.future;
                                                int width = info.width;
                                                int height = info.height;
                                                model.navigateToProfileScreen(
                                                  height,
                                                  item,
                                                  model.matchName[model
                                                      .catalogImages
                                                      .indexOf(item)],
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .address ?? "",
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .favorite_alcohol_drinks!,
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .favorite_musics!,
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .favorite_party_vacation!,
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .id,
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .distance!.toInt(),
                                                  model
                                                      .discoverModel![model
                                                      .catalogImages
                                                      .indexOf(item)]
                                                      .drinking_motivation,
                                                    model.discoverModel![model.catalogImages.indexOf(item)]
                                                );
                                              }
                                            },
                                            right:undoSwipe ?undoRight.value: right.value,
                                            left: 0.0,
                                            addImg: addImg,
                                            bottom: undoSwipe?undoBottom.value:bottom.value,
                                            flag: flag,
                                            dismissImg: dismissImg,
                                            swipeRight: swipeRight,
                                            swipeLeft: swipeLeft,
                                            id: model.discoverModel![model.catalogImages.indexOf(item)].id,
                                            revertSwipe: ()async{
                                              if (model.removedImages.isNotEmpty){
                                                if (model.sentMatchRequests.last is int){
                                                  await model.UserDeleteSwipe(context, model.sentMatchRequests.last,doUndoSwipe, img: model.removedImages.last);
                                                }
                                                else {
                                                  model.catalogImages.add(model.removedImages.last);
                                                  await doUndoSwipe();
                                                  model.removedImages.remove(model.removedImages.last);
                                                  model.sentMatchRequests.removeLast();
                                                  model.notifyListeners();
                                                }
                                              }
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
    );
  }
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color});
}
