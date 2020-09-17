
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/user.dart';
import 'package:chat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class AvatarIcon extends StatelessWidget {
  const AvatarIcon({
    @required this.user,
    @required this.radius,
    this.placeholderColor,
    this.errorWidgetColor,
  });

  final User user;
  final double radius;

  final Color placeholderColor;
  final Color errorWidgetColor;
  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return ClipOval(
      child: user.imageType == ImageType.assets
          ? Image(
              image: Image.asset(user.imgUrl).image,
              width: deviceData.screenHeight * radius,
              height: deviceData.screenHeight * radius,
              fit: BoxFit.cover,
            )
          : CachedNetworkImage(
              useOldImageOnUrlChange: true,
              fadeInDuration: const Duration(microseconds: 100),
              fadeOutDuration: const Duration(microseconds: 100),
              imageUrl: user.imgUrl,
              placeholder: (context, url) => Opacity(
                    opacity: 0.3,
                    child: Icon(
                      Icons.account_circle,
                      color: placeholderColor ?? Colors.white,
                      size: deviceData.screenHeight * radius,
                    ),
                  ),
              errorWidget: (context, url, error) => Opacity(
                    opacity: 0.3,
                    child: Icon(
                      Icons.account_circle,
                      color: errorWidgetColor ?? Colors.white,
                      size: deviceData.screenHeight * radius,
                    ),
                  ),
              width: deviceData.screenHeight * radius,
              height: deviceData.screenHeight * radius,
              fit: BoxFit.cover),
    );
  }

 
}
