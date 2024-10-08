import 'package:codefactory/order/model/order_model.dart';
import 'package:codefactory/order/model/post_order_body.dart';
import 'package:codefactory/order/repository/order_repository.dart';
import 'package:codefactory/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({required this.ref, required this.repository}) : super([]);

  Future<bool> postOrder() async {
    try {
      const uuid = Uuid();
      final state = ref.read(basketProvider);

      final id = uuid.v4();

      final res = await repository.postOrder(
          body: PostOrderBody(
              id: id,
              products: state
                  .map((e) => PostOrderBodyProduct(
                      productId: e.product.id, count: e.count))
                  .toList(),
              totalPrice: state.fold<int>(
                  0, (prev, next) => prev + (next.product.price * next.count)),
              createdAt: DateTime.now().toString()));

      return true;
    } catch (e) {
      return false;
    }
  }
}
