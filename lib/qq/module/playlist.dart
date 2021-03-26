part of '../module.dart';

Handler playlist = (Map query, cookie) {
  final page = query['page'] ?? 1;
  final size = query['size'] ?? 60;
  final sin = (page - 1) * size;

  final data = {
    "data": json.encode({
      "playlist": {
        "method": "get_playlist_by_tag",
        "param": {
          "id": 10000000,
          "sin": sin,
          "size": size,
          //5,最新，2最热
          "order": 5,
          "is_parent": 0,
        },
        "module": "playlist.PlayListPlazaServer"
      },
      "tag": {
        "method": "get_category_grid",
        "module": "playlist.PlayListNavigateServer",
        "param": {},
      },
      "comm": {
        "ct": 20,
        "cv": 1803,
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  );
};

Handler playlistByTag = (Map query, cookie) {
  final page = query['page'] ?? 1;
  final size = query['size'] ?? 60;
  final sin = (page - 1) * size;

  final data = {
    "data": json.encode({
      "playlist": {
        "method": "get_category_content",
        "param": {"last_id": "", "size": size, "order": 5, "is_parent": 0, "caller": "0", "titleid": 3270, "category_id": 3270},
        "module": "playlist.PlayListCategoryServer"
      },
      "tag": {
        "method": "get_category_basic",
        "module": "playlist.PlayListCategoryServer",
        "param": {"caller": "0", "category_id": 3270}
      },
      "comm": {
        "uin": "0",
        "ct": 20,
        "cv": 1803,
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  );
};

Handler playlistDetail = (Map query, cookie) {
  final page = query['page'] ?? 1;
  final size = query['size'] ?? 60;
  final sin = (page - 1) * size;

  final data = {
    "data": json.encode({
      "playlist": {
        "module": "srf_diss_info.DissInfoServer",
        "method": "CgiGetDiss",
        "param": {
          "disstid": 3584864556,
          "userinfo": 1,
          "tag": 1,
        }
      },
      "comm": {
        "g_tk": 5381,
        "uin": 0,
        "format": "json",
        "ct": 20,
        "cv": 1807,
        "platform": "wk_v17",
      }
    })
  };
  return request(
    'GET',
    "https://u.y.qq.com/cgi-bin/musicu.fcg",
    data,
    cookies: cookie,
  );
};
