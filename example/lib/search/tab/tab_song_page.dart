import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmusic_api_example/migu/migu_repository.dart';
import 'package:kmusic_api_example/player/player_controller.dart';
import 'package:kmusic_api_example/widget/page_list_view.dart';

class TabSongPage extends StatelessWidget {
  TabSongPage({Key? key}) : super(key: key);
  final TabSongController _controller = Get.put(TabSongController());
  final playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return _controller.obx((state) {
      final datas = (state?["songResultData"]?["result"] ?? []) as List;

      return PageListView(
        itemCount: datas.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              playerController.play(datas[index]);
            },
            title: Text(
              datas[index]["name"],
              maxLines: 1,
              style: Theme.of(context).textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "${(datas[index]["artists"] as List).map((e) => e["name"]).join(",")}",
              maxLines: 1,
            ),
          );
        },
        onRefresh: (int index) {
          return _controller.search();
        },
        onLoadMore: (index) {
          return _controller.search(page: index + 1);
        },
      );
    });
  }
}

class TabSongController extends GetxController with StateMixin<dynamic> {
  final migu = MiGuRepository();
  String _keyword = "";

  //搜索
  Future<void> search({String keyword: "", int type = 0, int page = 1, int size = 20}) async {
    if (keyword.isNotEmpty) {
      _keyword = keyword;
    }
    change([], status: RxStatus.loading());
    if (_keyword.isNotEmpty) {
      return migu.search(_keyword, type: type, page: page, size: size).then((value) {
        printInfo(info: json.encode(value));
        change(value, status: RxStatus.success());
      });
    } else {
      return Future.value();
    }
  }
}
