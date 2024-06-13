import 'package:cached_network_image/cached_network_image.dart';
import 'package:ems/constant/theme_constant.dart';
import 'package:ems/views/common/my_text.dart';
import 'package:flutter/material.dart';

class ShowPhotoScreen extends StatelessWidget {
  const ShowPhotoScreen({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText("Profile Photo",color: ThemeConstant.primaryColor,),
      ),
      body: InteractiveViewer(
        maxScale: 100,
        child: Center(
          child: CachedNetworkImage(imageUrl: url),
        ),
      ),
    );
  }
}