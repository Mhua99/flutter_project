import "package:flutter/material.dart";
import "../../../components/dashed_line.dart";
import "../../../models/home_models.dart";

import "../../../components/star_rating.dart";

class MovieListItem extends StatelessWidget {
  final MovieItem item;

  const MovieListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 10 内边距
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffe2e2e2), width: 10)),
      ),
      child: Column(
        // 交叉轴（水平轴）靠左显示
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getRankWidget(),
          SizedBox(height: 10),
          getContentWidget(),
          SizedBox(height: 10),
          getOriginalTitleWidget(),
        ],
      ),
    );
  }

  // 1 获取排名
  Widget getRankWidget() {
    return Container(
      // left top right bottom
      padding: EdgeInsets.fromLTRB(9, 4, 9, 4),
      decoration: BoxDecoration(
        // 背景颜色
        color: Color.fromARGB(255, 238, 205, 144),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "NO.${item.rank}",
        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 131, 95, 36)),
      ),
    );
  }

  // 2. 获取内容区域
  Widget getContentWidget() {
    return Row(
      // 交叉轴对齐方式
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getImageWidget(),
        getContentTextWidget(),
        getDividerWidget(),
        getWishWidget(),
      ],
    );
  }

  // 2.1 图片
  Widget getImageWidget() {
    return ClipRRect(
      // 圆角
      borderRadius: BorderRadius.circular(8),
      // BoxFit.cover 保持宽高比 完全覆盖福容器 可能被裁剪
      child: Image.asset(item.imageURL, height: 150, fit: BoxFit.cover),
    );
  }

  // 2.2 内容
  Widget getContentTextWidget() {
    final genres = item.genres.join(" ");
    final director = item.director.name;
    final casts = item.casts.join(" ");

    // 占满剩余空间
    return Expanded(
      child: Container(
        // horizontal x 轴内边距
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.play_circle_outline, color: Colors.red),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " (${item.playDate})",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    // maxLines: null,
                    // softWrap: true - 允许文本在换行符或单词边界处自动换行
                    softWrap: true,
                  ),
                ),
              ],
            ),
            StarRating(rating: item.rating),
            Text(
              "$genres / $director / $casts",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // 2.3 分割线
  Widget getDividerWidget() {
    return SizedBox(
      height: 120,
      width: 1,
      child: DashedLine(
        axis: Axis.vertical,
        dashedHeight: 8,
        color: Colors.red,
        count: 12,
      ),
    );
  }

  // 2.4 想看
  Widget getWishWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Color.fromARGB(255, 238, 205, 144),
            size: 36,
          ),
          SizedBox(height: 2),
          Text(
            "想看",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 235, 170, 20),
            ),
          ),
        ],
      ),
    );
  }

  // 3. 获取原始电影名称的widget
  Widget getOriginalTitleWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      // 无限大小, 占满父级
      width: double.infinity,
      decoration: BoxDecoration(
        // 背景色
        color: Color(0xffeeeeee),
        // 圆角
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        item.originalTitle,
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
}
