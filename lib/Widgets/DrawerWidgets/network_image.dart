
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../../Data/network_image_data.dart';
import '../../Data/size_config.dart';
import '../../Data/AppThemeData.dart';

class NetworkImageView extends StatelessWidget {
  const NetworkImageView({
    super.key,
    required this.sizeConfig,
    required this.appThemeData,
  });

  final SizeConfig sizeConfig;
  final AppThemeData appThemeData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NetworkImageData(),
      child: Consumer<NetworkImageData>(
        builder: (context, networkImageData, child) {
          int width = (400 * sizeConfig.safeBlockSmallest).toInt();
          int height = (200 * sizeConfig.safeBlockSmallest).toInt();
          var src = networkImageData.getCurrentImageURL(width, height);
          return GestureDetector(
          onTapUp: (tapUpDetails){
            networkImageData.refreshImage();
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appThemeData.selectedTheme.primaryDarkColor,
                    appThemeData.selectedTheme.primaryColor,
                    appThemeData.selectedTheme.primaryLightColor,
                  ],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                )
            ),
            child: CachedNetworkImage(
              imageUrl: src,
              key: UniqueKey(),
              width: width.toDouble(),
              height: height.toDouble(),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                //TODO: check if connected to wifi or not then return widget type depending on error type
                return Center(
                    child: SizedBox(
                      width: width.toDouble(),
                      height: height.toDouble(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off_rounded, color: appThemeData.selectedTheme.textColor),
                          FittedBox(child: Text("No Internet Connection.", textAlign: TextAlign.center,style: TextStyle(color: appThemeData.selectedTheme.textColor)))
                        ],
                      ),
                    )
                );
              },
              progressIndicatorBuilder: (context, url, progress) => Container(
                  margin: EdgeInsetsDirectional.all(20 * sizeConfig.blockSmallest),
                  child: Center(child: CircularProgressIndicator(color: appThemeData.selectedTheme.primaryLightColor,))
              ),
            ),
          ),
        );
        },
      ),
    );
  }

  void clearImageCache(){
    imageCache.clearLiveImages();
    imageCache.clear();
    DefaultCacheManager manager = DefaultCacheManager();
    manager.emptyCache(); //clears all data in cache.
  }

}