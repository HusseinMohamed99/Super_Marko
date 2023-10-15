import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_marko/generated/assets.dart';
import 'package:super_marko/shared/components/constants.dart';
import 'package:super_marko/shared/components/navigator.dart';
import 'package:super_marko/shared/cubit/cubit.dart';
import 'package:super_marko/shared/cubit/state.dart';
import 'package:super_marko/shared/styles/colors.dart';
import 'package:super_marko/shared/styles/icon_broken.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        orderLength = cubit.ordersModel!.data!.ordersDetails.length;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Orders',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            leading: IconButton(
              onPressed: () {
                pop(context);
              },
              icon: Icon(
                IconBroken.Arrow___Left_Circle,
                size: 24.sp,
                color: cubit.isDark
                    ? AppMainColors.orangeColor
                    : AppMainColors.whiteColor,
              ),
            ),
          ),
          body: cubit.ordersModel!.data!.ordersDetails.isEmpty ||
                  MainCubit.get(context).ordersModel == null
              ? Column(
                  children: [
                    SvgPicture.asset(Assets.imagesNodata),
                    Text(
                      'Your Order is empty',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'Be Sure to fill your order with something you like',
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  ],
                )
              : ConditionalBuilder(
                  condition: state is! GetOrdersLoadingState ||
                      MainCubit.get(context).ordersModel != null,
                  builder: (BuildContext context) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(15.0).r,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MyOrderItem(index: index);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10.h);
                      },
                      itemCount: cubit.ordersModel!.data!.ordersDetails.length,
                    );
                  },
                  fallback: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
        );
      },
    );
  }
}

class MyOrderItem extends StatelessWidget {
  const MyOrderItem({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    MainCubit cubit = MainCubit.get(context);
    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              cubit.cancelOrder(
                  id: cubit.ordersModel!.data!.ordersDetails[index].id!);
              cubit.getOrders();
            },
            foregroundColor: AppMainColors.redColor,
            icon: IconBroken.Close_Square,
            label: 'Cancel',
            borderRadius: BorderRadius.circular(8).r,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8).r,
          color: cubit.isDark
              ? AppMainColors.mainColor
              : AppMainColors.greyDarkColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Date :',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        cubit.ordersModel!.data!.ordersDetails[index].date!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppMainColors.dividerColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Product ID :',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        cubit.ordersModel!.data!.ordersDetails[index].id
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppMainColors.whiteColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Total :',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        cubit.ordersModel!.data!.ordersDetails[index].total
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppMainColors.whiteColor),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                cubit.ordersModel!.data!.ordersDetails[index].status!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: cubit.ordersModel!.data!.ordersDetails[index]
                                  .status ==
                              'New'
                          ? AppMainColors.greenColor
                          : AppMainColors.redColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
