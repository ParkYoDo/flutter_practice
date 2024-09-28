import 'package:codefactory/common/component/pagination_list_view.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/product/provider/product_provider.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                      id: model.restaurant.id, title: model.restaurant.name))),
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
