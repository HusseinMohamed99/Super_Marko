import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:super_marko/Screens/ProductDetails/product_details_screen.dart';
import 'package:super_marko/generated/assets.dart';
import 'package:super_marko/model/search/search_model.dart';
import 'package:super_marko/shared/components/image_with_shimmer.dart';
import 'package:super_marko/shared/components/my_divider.dart';
import 'package:super_marko/shared/components/navigator.dart';
import 'package:super_marko/shared/cubit/cubit.dart';
import 'package:super_marko/shared/cubit/state.dart';
import 'package:super_marko/shared/styles/colors.dart';
import 'package:super_marko/shared/styles/icon_broken.dart';

class SearchScreen extends StatelessWidget {
  MainCubit mainCubit;
  SearchScreen(this.mainCubit, {super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8).r,
                child: Row(
                  children: [
                    SizedBox(
                      height: 35.h,
                      width: 220.w,
                      child: TextFormField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: searchController,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'What are you looking for ?',
                          prefixIcon: Icon(IconBroken.Search,
                              color: AppMainColors.redColor),
                        ),
                        onChanged: (value) {
                          cubit.getSearch(value);
                        },
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),),
                  ],
                ),
              ),
            ),
            body: state is SearchLoadingStates
                ? const Center(child: CircularProgressIndicator())
                : cubit.searchModel != null
                    ? searchController.text.isEmpty
                        ? Column(
                            children: [
                              SvgPicture.asset(Assets.imagesNodata),
                              Text(
                                'What are you looking for ?',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => searchItemBuilder(
                                cubit.searchModel?.data.data[index],
                                mainCubit,
                                context),
                            separatorBuilder: (context, index) =>
                                const MyDivider(),
                            itemCount: cubit.searchModel!.data.data.length,
                          )
                    : Column(
                        children: [
                          SvgPicture.asset(Assets.imagesNodata),
                          Text(
                            'What are you looking for ?',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ));
      },
    );
  }

  Widget searchItemBuilder(SearchProduct? model, MainCubit mainCubit, context) {
    return InkWell(
      onTap: () {
        mainCubit.getProductData(model.id);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: Container(
        height: 120.h,
        padding: const EdgeInsets.all(10).r,
        child: Row(
          children: [
            ImageWithShimmer(
                imageUrl: '${model!.image}', width: 100.w, height: 100.h),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text(
                    'EGP ' '${model.price}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
