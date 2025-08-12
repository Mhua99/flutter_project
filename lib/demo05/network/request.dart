import 'package:dio/dio.dart';

const List<Map<String, dynamic>> moviceList = [
  {
    "id": 1,
    "title": "肖生克的救赎",
    "originalTitle": "The Shawshank Redemption",
    "imageURL": "assets/demo05/3.webp",
    "playDate": "1994",
    "genres": ["犯罪", "剧情"],
    "director": {"name": "弗兰克·德拉邦特 Frank Darabont", "avatarUrl": "xxx"},
    "casts": [
      {"name": "蒂姆·罗宾斯", "avatarUrl": "xxx"},
      {"name": "Tim Robbins", "avatarUrl": "xxx"},
    ],
    "rating": 9.5,
  },
  {
    "id": 2,
    "title": "肖生克的救赎",
    "originalTitle": "The Shawshank Redemption",
    "imageURL": "assets/demo05/3.webp",
    "playDate": "1994",
    "genres": ["犯罪", "剧情"],
    "director": {"name": "弗兰克·德拉邦特 Frank Darabont", "avatarUrl": "xxx"},
    "casts": [
      {"name": "蒂姆·罗宾斯", "avatarUrl": "xxx"},
      {"name": "Tim Robbins", "avatarUrl": "xxx"},
    ],
    "rating": 9.0,
  },
];

const Map<String, dynamic> moviceRet = {
  "code": 200,
  "message": "获取成功",
  "data": moviceList,
};

class Request {
  static BaseOptions baseOptions = BaseOptions(
    baseUrl: 'https://api.github.com/',
    connectTimeout: Duration(milliseconds: 10000),
  );

  static Dio dio = Dio(baseOptions);

  static Future request(
    String url, {
    String method = 'get',
    Map<String, dynamic>? params,
  }) async {
    Options options = Options(
      method: method,
      headers: {'Content-Type': 'application/json'},
    );

    try {
      final result = await dio.request(
        url,
        queryParameters: params,
        options: options,
      );
      return result;
    } on DioException catch (err) {
      throw err;
    }
  }

  // 1. 基础GET请求模拟
  static final mockGetResponse = Response(
    data: moviceRet,
    statusCode: 200,
    requestOptions: RequestOptions(path: '/api/user'),
    headers: Headers.fromMap({
      'content-type': ['application/json'],
    }),
  );
}
