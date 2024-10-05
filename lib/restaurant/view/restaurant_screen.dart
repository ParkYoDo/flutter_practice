import 'package:codefactory/common/component/pagination_list_view.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return PaginationListView(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(RestaurantDetailScreen.routeName,
                    pathParameters: {'rid': model.id},
                    queryParameters: {"title": model.name});
              },
              child: RestaurantCard.fromModel(model: model));
        });
  }
}
