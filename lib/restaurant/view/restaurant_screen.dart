import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/utils/pagination_utils.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantProvider.notifier));
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final data = ref.watch(restaurantProvider);

    // 최초 로딩
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination, CursorPaginationFetchingMore, CursorPaginationRefetching
    final cp = data as CursorPagination;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: data is CursorPaginationFetchingMore
                      ? const CircularProgressIndicator(
                          color: PRIMARY_COLOR,
                        )
                      : const Text('마지막 데이터입니다 ㅠㅠ'),
                ),
              );
            }
            final pItem = cp.data[index];

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
