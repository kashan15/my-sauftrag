// import 'dart:_http';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:pubnub/pubnub.dart';
import 'package:sauftrag/bar/views/Home/bar_news_feed.dart';
import 'package:sauftrag/utils/app_language.dart';

import 'package:sauftrag/utils/app_localization.dart';
import 'package:sauftrag/utils/extensions.dart';
import 'package:sauftrag/utils/screen_utils.dart';
import 'package:sauftrag/utils/size_config.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'package:sauftrag/views/Auth/signup.dart';
import 'package:sauftrag/views/Auth/splash.dart';
import 'package:sauftrag/views/UserProfile/gps.dart';
import 'package:sauftrag/widgets/notification_screen.dart';
import 'package:stacked/stacked.dart';
import 'app/locator.dart';
import 'bar/views/Drawer/barEvent.dart';
import 'bar/views/Drawer/barProfile.dart';
import 'bar/views/Drawer/bar_Rating.dart';
import 'bar/views/Drawer/bar_all_rating.dart';
import 'bar/views/Drawer/follower_profile.dart';
import 'bar/views/Drawer/followers.dart';
import 'bar/views/Drawer/list_of_followBar.dart';
import 'bar/views/Drawer/matched_screen.dart';
import 'bar/views/Drawer/notifications.dart';
import 'bar/views/Drawer/qr_code_scanner.dart';
import 'bar/views/Drawer/ranking_list.dart';
import 'bar/views/Drawer/upcoming_event.dart';
import 'bar/views/Home/bar_create_post.dart';
import 'bar/views/Home/bar_drinks.dart';
import 'bar/views/Home/bar_event.dart';
import 'bar/views/Home/main_view.dart';
import 'bar/views/Home/order_details.dart';
import 'bar/views/Profile/bar_account_ownership.dart';
import 'bar/views/Profile/bar_accounts.dart';
import 'bar/views/Profile/bar_details.dart';
import 'bar/views/Profile/bar_profile.dart';
import 'bar/views/Home/barCode2.dart';
import 'bar/views/Profile/faq_questions_list.dart';
import 'bar/widgets/bar_QR_scanner.dart';
import 'bar/widgets/my_side_menu.dart';
import 'views/NewsFeed/events.dart';
import 'widgets/zoom_drawer.dart';
import 'bar/views/Drawer/matched_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:device_info_plus/device_info_plus.dart';



NavigationViewModel navigationViewModel = NavigationViewModel();
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

MainViewModel mainViewModel = locator<MainViewModel>();



String? deviceToken;
Future<void> messageHandler(RemoteMessage message) async {
  print(message.messageId);
}


//
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();


  HttpOverrides.global = MyHttpOverrides();
  deviceToken = await NotificationService().configure(
    messageHandler,
    navigatorKey.currentContext,
  );
  print(deviceToken);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // For both Android + iOS
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light,
  ));
  //

  //
  await configure();

  runApp(
      Phoenix(
        child: ViewModelBuilder<AppLanguage>.reactive(
          builder: (context, model, child){
            // LocalJsonLocalization.delegate.directories = ['i18n'];
            return MaterialApp(
              locale: model.appLocale,
              navigatorKey: navigationViewModel.navigationKey,
              debugShowCheckedModeBanner: false,
              localeListResolutionCallback: (locales, supportedLocales) {
                for (Locale locale in locales!) {
                  // if device language is supported by the app,
                  // just return it to set it as current app language
                  if (supportedLocales.contains(locale)) {
                    return locale;
                  }
                }
                // if device language is not supported by the app,
                // the app will set it to english but return this to set to Bahasa instead
                return Locale('en');

              },
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', ''),
                Locale('de', '')],
              theme: ThemeData(
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                  })),
              home: MyApp(),
            );
          },
          viewModelBuilder: () => locator<AppLanguage>(),
          onModelReady: (model) async {
            //AppLanguage appLanguage = AppLanguage();
            await model.fetchLocale();
          },
          disposeViewModel: false,
        ),
      ));
  //
  // ErrorWidget.builder = (details) {
  //   return Material(
  //     child: Container(
  //         color: Colors.indigoAccent,
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 8.w),
  //           child: Center(
  //               child: Text(
  //                 details.exceptionAsString(),
  //                 style: TextStyle(color: Colors.white),
  //                 textAlign: TextAlign.center,
  //               )),
  //         )),
  //   );
  // };
  //
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // method();
    super.initState();
  }



  method()async{
    if(Platform.isAndroid){
      await mainViewModel.initDeepLinkData();
      await  mainViewModel.listenDynamicLinks();
      await mainViewModel.generateLink();
    }

  }




  Widget build(BuildContext context) {

    ScreenUtil.getInstance()..init(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Splash(token: deviceToken);
          },
        );
      },
    );
  }
}
