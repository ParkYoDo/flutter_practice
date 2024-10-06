import 'package:codefactory/product/model/product_model.dart';
import 'package:codefactory/user/model/basket_item_model.dart';
import 'package:codefactory/user/model/patch_basket_body.dart';
import 'package:codefactory/user/repository/user_me_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketProvider(repository: repository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({required this.repository}) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: PatchBasketBody(
            basket: state
                .map((e) => PatchBasketBodyBasket(
                    productId: e.product.id, count: e.count))
                .toList()));
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1. 장바구니에 해당 상품이 없으면 상품을 추가한다.
    // 2. 장바구니에 이미 들어있다면 장바구니에 있는 값을 +1 한다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [...state, BasketItemModel(product: product, count: 1)];
    }

    // Optimistic Response (Optimistic Update) : 응답이 성공할거라고 가정하고 상태를 먼저 업데이트
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // true면 count와 관계없이 삭제한다.
    bool isDelete = false,
  }) async {
    // 1. 장바구니에 상품이 존재할 때 상품
    //   1) 상품 count가 1보다 크면 -1
    //   2) 상품 count가 1이면 삭제
    // 2. 상품이 존재하지 않을 때 즉시 함수 반환하고 아무것도 하지 않는다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }

    await patchBasket();
  }
}
