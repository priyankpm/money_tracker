import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/modules/addEntry/controllers/add_entry_controller.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';

class ImageView extends GetView<AddEntryController> {
  const ImageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: AppText.attachment.styleSemiBold(
            size: 20.sp,
            color: AppColors.whiteColor,
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.whiteColor,
                size: 18.h,
              ),
            ),
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        body: Center(
          child:
              Get.arguments != null
                  ? Get.arguments["file"] != null
                      ? Image.file(Get.arguments["file"])
                      : (Get.arguments["imageUrl"] != null &&
                          Get.arguments["imageUrl"].toString().isNotEmpty)
                      ? CachedNetworkImage(
                        imageUrl: Get.arguments["imageUrl"],
                        placeholder:
                            (context, url) => CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                        errorWidget:
                            (context, url, error) => "No attachment found"
                                .styleSemiBold(color: AppColors.greyColor),
                      )
                      : SizedBox()
                  : SizedBox(),
        ),
      ),
    );
  }
}
