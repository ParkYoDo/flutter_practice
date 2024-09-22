import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> pagenateRestaurant() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();
    final res = await dio.get('http://$ip/restaurant',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));

    return res.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List>(
          future: pagenateRestaurant(),
          builder: (context, AsyncSnapshot<List> snapshot) {
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
                final item = snapshot.data![index];
                final pItem = RestaurantModel.fromJson(json: item);

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
