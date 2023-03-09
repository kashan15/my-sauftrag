
import 'package:get_it/get_it.dart';
import 'package:sauftrag/utils/app_language.dart';
import 'package:sauftrag/viewModels/authentication_view_model.dart';
import 'package:sauftrag/viewModels/main_view_model.dart';
import 'package:sauftrag/viewModels/navigation_view_model.dart';
import 'package:sauftrag/viewModels/prefrences_view_model.dart';
import 'package:sauftrag/viewModels/registrationViewModel.dart';

import '../models/listOfFollowing_Bars.dart';

Future<void> $initGetIt(GetIt g, {String? environment}) async{
  PrefrencesViewModel prefrencesViewModel = PrefrencesViewModel();
  await prefrencesViewModel.init();
  g.registerLazySingleton<PrefrencesViewModel>(() => prefrencesViewModel);
  g.registerLazySingleton<NavigationViewModel>(() => NavigationViewModel());
  g.registerLazySingleton<AuthenticationViewModel>(() => AuthenticationViewModel());
  g.registerLazySingleton<MainViewModel>(() => MainViewModel());

  g.registerLazySingleton<ListOfBarsModel>(() => ListOfBarsModel());

  g.registerLazySingleton<AppLanguage>(() => AppLanguage());

  g.registerLazySingleton<RegistrationViewModel>(() => RegistrationViewModel());
  //g.registerLazySingleton<MainViewModel>(() => MainViewModel());
}

