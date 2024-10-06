import 'package:badges/badges.dart' as badges;
import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/utils/pagination_utils.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/product/model/product_model.dart';
import 'package:codefactory/rating/component/rating_card.dart';
import 'package:codefactory/rating/model/rating_model.dart';
import 'package:codefactory/restaurant/component/restaurant_card.dart';
import 'package:codefactory/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/provider/restaurant_provider.dart';
import 'package:codefactory/restaurant/provider/restaurant_rating_provider.dart';
import 'package:codefactory/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

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
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        shape: const CircleBorder(),
        onPressed: () {},
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold<int>(0, (prev, next) => prev + next.count).toString(),
            style: const TextStyle(color: PRIMARY_COLOR, fontSize: 10.0),
          ),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
          child: const Icon(
            Icons.shopping_basket_outlined,
            color: Colors.white,
          ),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(products: state.products, restaurant: state),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data)
        ],
      ),
    );
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate(childCount: models.length + 1,
                (_, index) {
          if (index == models.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                  child: CircularProgressIndicator(
                color: PRIMARY_COLOR,
              )),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: RatingCard.fromModel(model: models[index]),
          );
        })));
  }

  SliverPadding renderLoading() {
    return SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate(List.generate(
                10,
                (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Skeletonizer(
                      enabled: true,
                      child: Container(
                          width: double.infinity,
                          height: 20.0,
                          color: Colors.black),
                    ))))));
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding renderProducts(
      {required RestaurantModel restaurant,
      required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                    product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        imgUrl: model.imgUrl,
                        price: model.price,
                        restaurant: restaurant));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
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
