import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_marko/Screens/cart/cart_screen.dart';
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
        return SafeArea(
          child: Scaffold(
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
                    navigateTo(context, const SearchScreen());
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
            floatingActionButton: FloatingActionButton(
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.white,
                  width: 2.w,
                ),
              ),
              backgroundColor: AppMainColors.orangeColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              child: Icon(
                Icons.add_shopping_cart,
                size: 24.sp,
                color: AppMainColors.whiteColor,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10.r,
              child: BottomNavigationBar(
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                onTap: (index) {
                  cubit.changeNavBar(index);
                },
                currentIndex: cubit.currentIndex,
                items: cubit.bottomNavigationBarItem,
              ),
            ),
          ),
        );
      },
    );
  }
}
