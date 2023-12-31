import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_marko/shared/components/buttons.dart';
import 'package:super_marko/shared/components/constants.dart';
import 'package:super_marko/shared/components/select_photo.dart';
import 'package:super_marko/shared/components/show_toast.dart';
import 'package:super_marko/shared/components/text_form_field.dart';
import 'package:super_marko/shared/cubit/cubit.dart';
import 'package:super_marko/shared/cubit/state.dart';
import 'package:super_marko/shared/styles/colors.dart';
import 'package:super_marko/shared/styles/icon_broken.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is UserUpdateSuccessStates) {
          showToast(
              text: 'Update Data Successfully', state: ToastStates.success);
        }
        if (state is UserUpdateErrorStates) {
          showToast(text: state.error, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);

        emailController.text = cubit.userData!.data!.email!;
        phoneController.text = cubit.userData!.data!.phone!;
        nameController.text = cubit.userData!.data!.name!;

        return ConditionalBuilder(
          condition: MainCubit.get(context).userData != null,
          builder: (context) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20).r,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (state is UserUpdateLoadingStates)
                        const LinearProgressIndicator(),
                      if (state is UserUpdateLoadingStates)
                        SizedBox(height: 10.h),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 100.r,
                            backgroundColor: AppMainColors.mainColor,
                            child: CircleAvatar(
                              radius: 95.r,
                              backgroundImage: cubit.profileImage != null
                                  ? Image.file(
                                      cubit.profileImage!,
                                      fit: BoxFit.fill,
                                    ).image
                                  : NetworkImage(cubit.userData!.data!.image!),
                            ),
                          ),
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: AppMainColors.orangeColor,
                            child: CircleAvatar(
                              radius: 22.r,
                              backgroundColor: AppMainColors.whiteColor,
                              child: IconButton(
                                splashRadius: 22.r,
                                onPressed: () {
                                  showSelectPhotoOptions(context);
                                },
                                icon: Icon(
                                  IconBroken.Camera,
                                  size: 30.sp,
                                  color: AppMainColors.blueColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      DefaultTextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: IconBroken.User,
                      ),
                      SizedBox(height: 20.h),
                      DefaultTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                        label: 'Email',
                        prefix: IconBroken.Message,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      DefaultTextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Phone is required";
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      defaultMaterialButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            MainCubit.get(context).updateUserData(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              image: base64Image,
                            );
                          }
                          return null;
                        },
                        text: 'Update',
                        context: context,
                        textColor: AppMainColors.whiteColor,
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)).r,
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.28.spMax,
        minChildSize: 0.20.spMin,
        expand: false,
        builder: (context, scrollController) {
          return const SelectPhotoOptions();
        },
      ),
    );
  }
}
