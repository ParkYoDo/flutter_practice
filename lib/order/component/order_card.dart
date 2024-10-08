import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/order/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final DateTime orderDate;
  final Image image;
  final String name;
  final String productDetail;
  final int price;

  const OrderCard(
      {super.key,
      required this.orderDate,
      required this.image,
      required this.name,
      required this.productDetail,
      required this.price});

  factory OrderCard.fromModel({required OrderModel model}) {
    final productsDetail = model.products.length < 2
        ? model.products.first.product.name
        : '${model.products.first.product.name} 외 ${model.products.length - 1}개';

    return OrderCard(
        orderDate: model.createdAt,
        image: Image.network(model.restaurant.thumbUrl,
            width: 50.0, height: 50.0, fit: BoxFit.cover),
        name: model.restaurant.name,
        productDetail: productsDetail,
        price: model.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ex: 2024-09-09
        Text(
            '${orderDate.year}.${orderDate.month.toString().padLeft(2, '0')}.${orderDate.day.toString().padLeft(2, '0')} 주문완료'),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: image,
            ),
            const SizedBox(
              width: 16.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14.0),
                ),
                Text(
                  '$productDetail $price원',
                  style: const TextStyle(
                      color: BODY_TEXT_COLOR, fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
