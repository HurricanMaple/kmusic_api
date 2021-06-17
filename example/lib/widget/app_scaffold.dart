import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmusic_api_example/player/player_controller.dart';
import 'package:kmusic_api_example/player/player_page.dart';

import 'blur_widget.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final double opacity;
  final PreferredSizeWidget appBar;
  final bool withPlayer;
  final String imageUrl;

  AppScaffold({@required this.body, this.appBar, this.withPlayer, this.imageUrl, this.opacity});

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        widget.imageUrl == null || widget.imageUrl.isBlank
            ? Container()
            : AnimatedOpacity(
                // 使用一个AnimatedOpacity Widget
                opacity: widget.opacity,
                duration: Duration(milliseconds: 500), //过渡时间：1
                child: CachedNetworkImage(
                  width: Get.width,
                  height: Get.height,
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
        BlurWidget(
            color: Colors.white70,
            blur: 50,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: widget.appBar,
              body: widget.body,
            ))
      ],
    );

    return widget.withPlayer == true ? PlayerPage(child: body) : Container(color: Colors.white, child: body);
  }
}
