import "package:flutter/material.dart";
import 'package:readmore/readmore.dart';

import "../utils/const.dart";
import "../models/cats_model.dart";

class Details extends StatefulWidget {
  final Cat cat;

  const Details({super.key, required this.cat});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            _itemsBackground(size),
            _backButton(size, context),
            _mainContent(size),
          ],
        ),
      ),
    );
  }

  Row _connectInfo() {
    return Row(
      children: [
        // 圆形头像
        CircleAvatar(
          radius: 30,
          backgroundColor: widget.cat.color,
          backgroundImage: AssetImage(widget.cat.owner.image),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cat.owner.name,
                style: const TextStyle(
                  fontSize: 18,
                  color: black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${widget.cat.name} Owner",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color3.withAlpha(77),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.chat_outlined,
            color: Colors.lightBlue,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withAlpha(51),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.phone_outlined, color: Colors.red, size: 16),
        ),
      ],
    );
  }

  Container _itemsBackground(Size size) {
    return Container(
      height: size.height * 0.50,
      width: size.width,
      decoration: BoxDecoration(color: widget.cat.color.withAlpha(128)),
      child: Stack(
        children: [
          Positioned(
            left: -60,
            top: 30,
            child: Transform.rotate(
              angle: -11.5,
              child: Image.asset(
                "assets/demo02/rTnrpap6c.png",
                color: widget.cat.color,
                height: 200,
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: 0,
            child: Transform.rotate(
              angle: 12,
              child: Image.asset(
                "assets/demo02/rTnrpap6c.png",
                color: widget.cat.color,
                height: 200,
              ),
            ),
          ),
          /**
           * 当 Positioned 组件的 left 和 right 都设置为 0 时，意味着该组件在水平方向上会拉伸以填满其父容器的整个宽度
           */
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            /**
             * Hero 组件是 Flutter 中用于实现页面间共享元素过渡动画的组件。
             * 它的主要作用是在页面跳转时，为相同的元素提供平滑的动画过渡效果。
             * 必须要两个页面都用到Hero 组件，并且tag属性值必须相同。
             */
            child: Container(
              /**
               * Alignment.center 表示将子组件在父容器中居中对齐。
               */
              alignment: Alignment.center,
              child: Hero(
                tag: widget.cat.image,
                child: Image.asset(
                  widget.cat.image,
                  height: size.height * 0.45,
                  fit: BoxFit.contain,  // 保持宽高比
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned _backButton(Size size, BuildContext context) {
    return Positioned(
      height: size.height * 0.14,
      right: 20,
      left: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_rounded, color: black),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: const Icon(Icons.more_horiz, color: black),
          ),
        ],
      ),
    );
  }

  Row _nameAndFavorite() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cat.name,
                style: const TextStyle(
                  fontSize: 25,
                  color: black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: blue),
                  Text(
                    '${widget.cat.location} (${widget.cat.distance} Km)',
                    style: TextStyle(
                      color: black.withOpacity(0.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            // 阴影
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: widget.cat.fav
                    ? Colors.red.withAlpha(26)
                    : black.withAlpha(52),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            widget.cat.fav
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: widget.cat.fav ? Colors.red : black.withAlpha(153),
          ),
        ),
      ],
    );
  }

  ClipRRect _cardItem(pawColor, backgroundColr, title, value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: 0,
            child: Transform.rotate(
              angle: 12,
              child: Image.asset(
                "assets/demo02/rTnrpap6c.png",
                color: pawColor,
                height: 55,
              ),
            ),
          ),
          Container(
            height: 100,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backgroundColr,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned _mainContent(Size size) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: size.height * 0.52,
        width: size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          // top 设置 上方圆角
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          // x 轴 内边距 20
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _nameAndFavorite(),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cardItem(
                      color1,
                      color1.withAlpha(128),
                      widget.cat.sex,
                      "Sex",
                    ),
                    _cardItem(
                      color2,
                      color2.withAlpha(128),
                      "${widget.cat.age.toString()} Years",
                      "Age",
                    ),
                    _cardItem(
                      color3,
                      color3.withAlpha(128),
                      "${widget.cat.weight.toString()} KG",
                      "Weight",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _connectInfo(),
                const SizedBox(height: 20),
                ReadMoreText(
                  widget.cat.description,
                  textAlign: TextAlign.justify,
                  trimCollapsedText: 'See More',
                  colorClickableText: Colors.orange,
                  trimLength: 100,
                  trimMode: TrimMode.Length,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: buttonColor,
                  ),
                  child: const Center(
                    child: Text(
                      'Adopt Me',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


