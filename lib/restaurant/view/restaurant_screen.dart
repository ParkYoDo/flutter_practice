import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<CursorPagination<RestaurantModel>>(
          future: ref.watch(restaurantRepositoryProvider).paginate(),
          builder: (context,
              AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PRIMARY_COLOR,
                ),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (_, index) {
                final pItem = snapshot.data!.data[index];

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
            );
          },
        ),
      ),
    ));
  }
}
