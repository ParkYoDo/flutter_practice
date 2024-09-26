import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          itemCount: data.length,
          itemBuilder: (_, index) {
            final pItem = data[index];

            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                          id: pItem.id, title: pItem.name)));
                },
                child: RestaurantCard.fromModel(model: pItem));
          },
          separatorBuilder: (_, index) => const SizedBox(
            height: 16.0,
          ),
        ));
  }
}
