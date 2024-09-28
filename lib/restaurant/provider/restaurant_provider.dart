import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/provider/pagination_provider.dart';
import 'package:codefactory/restaurant/model/restaurant_model.dart';
import 'package:codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) return null;

  return state.data.firstWhereOrNull((e) => e.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  @override
  RestaurantStateNotifier({required super.repository});

  void getDetail({required String id}) async {
    //만약 데이터가 없는 상태라면, State가 CursorPagination이 아니라면 => 데이터를 가져오는 시도를 한다
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아닐 때 => 그냥 return
    if (state is! CursorPagination) return;

    final pState = state as CursorPagination;

    final res = await repository.getRestaurantDetail(id: id);

    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(data: <RestaurantModel>[...pState.data, res]);
    } else {
      state = pState.copyWith(
          data: pState.data
              .map<RestaurantModel>((e) => e.id == id ? res : e)
              .toList());
    }
  }
}
