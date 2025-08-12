import 'package:flutter/material.dart';
import '../../models/home_models.dart';
import '../../views/home/child/movie_list_item.dart';

import '../../network/request.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("首页"), centerTitle: true),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  List<MovieItem> movies = [];

  @override
  void initState() {
    super.initState();
    final data = Request.mockGetResponse.data?["data"] as List<dynamic>?;
    if (data != null) {
      setState(() {
        movies = data.map((item) => MovieItem.fromMap(item)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return MovieListItem(item: movies[index]);
        },
      ),
    );
  }
}
