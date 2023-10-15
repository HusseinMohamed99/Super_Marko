import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_marko/Screens/OnBoarding/on_boarding_screen.dart';
import 'package:super_marko/Screens/login/login_screen.dart';
import 'package:super_marko/network/cache_helper.dart';
import 'package:super_marko/network/dio_helper.dart';
import 'package:super_marko/shared/bloc_observer.dart';
import 'package:super_marko/shared/components/constants.dart';
import 'package:super_marko/shared/cubit/cubit.dart';
import 'package:super_marko/shared/cubit/internet_bloc.dart';
import 'package:super_marko/shared/cubit/state.dart';
import 'package:super_marko/shared/enum/enum.dart';
import 'package:super_marko/shared/styles/themes.dart';
import 'package:wakelock/wakelock.dart';
import 'Screens/HomePage/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await ScreenUtil.ensureScreenSize();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  Widget widget;

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');

  token = CacheHelper.getData(key: 'token');

  if (kDebugMode) {
    print(token);
  }

  if (onBoarding != null) {
    if (token != null) {
      widget = const HomePage();
    } else {
      widget = const LoginScreen();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(Myapp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class Myapp extends StatelessWidget {
  final bool? isDark;
  final Widget startWidget;

  const Myapp({Key? key, required this.startWidget, this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit()
            ..getFavoritesData()
            ..getOrders()
            ..getCartData()
            ..getUserData()
            ..getHomeData()
            ..getCategoriesData()
            ..getFaqData()
            ..getNotifications()
            ..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(create: (context) => InternetCubit())
      ],
      child: BlocConsumer<MainCubit, MainStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);

            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                  title: 'Super Marko',
                  theme: getThemeData[AppTheme.lightTheme],
                  darkTheme: getThemeData[AppTheme.darkTheme],
                  themeMode: token == null
                      ? ThemeMode.system
                      : MainCubit.get(context).isDark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                  debugShowCheckedModeBanner: false,
                  home: startWidget,
                );
              },
            );
          }),
    );
  }
}
