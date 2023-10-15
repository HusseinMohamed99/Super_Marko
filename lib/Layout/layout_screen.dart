import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_marko/Screens/search/search_screen.dart';
import 'package:super_marko/shared/components/navigator.dart';
import 'package:super_marko/shared/cubit/cubit.dart';
import 'package:super_marko/shared/cubit/state.dart';
import 'package:super_marko/shared/styles/colors.dart';
import 'package:super_marko/shared/styles/icon_broken.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  IconBroken.Search,
                  size: 24.sp,
                  color: AppMainColors.orangeColor,
                ),
                onPressed: () {
                  navigateTo(context, SearchScreen(MainCubit.get(context)));
                },
              ),
              IconButton(
                onPressed: () {
                  MainCubit.get(context).changeAppMode();
                },
                icon: Icon(
                  Icons.dark_mode_outlined,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          body: cubit.pages[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              cubit.changeNavBar(index);
            },
            currentIndex: cubit.currentIndex,
            items: cubit.bottomNavigationBarItem,
          ),
        );
      },
    );
  }
}
