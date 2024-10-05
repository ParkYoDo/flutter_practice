import 'package:codefactory/common/component/pagination_list_view.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/product/provider/product_provider.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(RestaurantDetailScreen.routeName,
                    pathParameters: {'rid': model.restaurant.id},
                    queryParameters: {"title": model.restaurant.name});
              },
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
