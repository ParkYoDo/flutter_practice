import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/dio/dio.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> pagenateRestaurant() async {
    final dio = Dio();
    dio.interceptors.add(CustomInterceptor(storage: storage));

    final repository =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate();

    return repository.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<RestaurantModel>>(
          future: pagenateRestaurant(),
          builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PRIMARY_COLOR,
                ),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final pItem = snapshot.data![index];

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
