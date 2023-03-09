import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sauftrag/app/locator.dart';
import 'package:sauftrag/utils/color_utils.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/font_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/views/Home/swipe.dart';
import 'package:sauftrag/views/MapSearch/map_screen.dart';
import 'package:sauftrag/views/MapSearch/search.dart';
import 'package:sauftrag/views/NewsFeed/news_feed.dart';
import 'package:sauftrag/bar/views/BarChat/friend_list.dart';
import 'package:sauftrag/views/UserFriendList/friend_list_for_user.dart';
import 'package:sauftrag/views/UserProfile/user_profile.dart';
import 'package:sauftrag/widgets/my_curved_nav_bar.dart';
import 'package:sauftrag/utils/dimensions.dart';
import 'package:sauftrag/utils/image_utils.dart';
import 'package:sauftrag/widgets/my_side_menu.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:stacked/stacked.dart';

class MainView extends StatefulWidget {
  int index;
  MainView({Key? key, required this.index}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;
  Widget body = MapScreen();

  @override
  void initState() {
    currentIndex = widget.index;
    onClick(currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (model)async {
        model.getUserData();
        model.getDrinkStatus();
        // var position = await model.determinePosition();
        // print(position);
        Position? position = await model.updateCurrentLocation();
        if (position!=null){
          model.kGooglePlex = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 7,
          );
        }
        model.notifyListeners();
        model.initUserGrpPubNub();
      },
      viewModelBuilder: () => locator<MainViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: body,
                ),
                MyCurvedNavBar(
                  barIconColor: ColorUtils.icon_color,
                  selectedIconColor: ColorUtils.white,
                  color: ColorUtils.white,
                  buttonBackgroundColor: ColorUtils.text_red,
                  index: currentIndex,
                  animationCurve: Curves.ease,
                  animationDuration: Duration(milliseconds: 300),
                  height: SizeConfig.heightMultiplier * 8,
                  //backgroundColor: Colors.redAccent,
                  parentDecoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color(0xFFefefef),
                        blurRadius: 3 * SizeConfig.imageSizeMultiplier,
                        offset: Offset(0, -10))
                  ]),
                  items: <String>[
                    ImageUtils.homeIcon,
                    ImageUtils.chatIcon,
                    ImageUtils.swipeIcon,
                    ImageUtils.mapIcon,
                    ImageUtils.profileIcon
                  ],
                  onTap: (index) {
                    currentIndex = index;
                    //MainView(index: 3,);
                    onClick(currentIndex);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onClick(int selectedIndex) {
    currentIndex = selectedIndex;
    switch (currentIndex) {
      case 0:
        body = NewsFeed();
        break;
      case 1:
        body = FriendListForUser();
        break;
      case 2:
        body = Swipe();
        break;
      case 3:
        body = MapScreen();
        break;
      case 4:
        body = UserProfile();
        break;
    }
    setState(() {

    });
  }
}
