import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final String title;

  const RestaurantDetailScreen(
      {super.key, required this.id, required this.title});

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        ),
      ));
    }

    return DefaultLayout(
        title: widget.title,
        child: CustomScrollView(
          slivers: [
            renderTop(model: state),
            if (state is RestaurantDetailModel) renderLabel(),
            if (state is RestaurantDetailModel)
              renderProducts(products: state.products)
          ],
        ));
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding renderProducts(
      {required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model: model),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
