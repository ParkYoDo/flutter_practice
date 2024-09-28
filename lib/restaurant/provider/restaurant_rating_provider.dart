import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/provider/pagination_provider.dart';
import 'package:codefactory/rating/model/rating_model.dart';
import 'package:codefactory/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, id) {
  final repository = ref.watch(restaurantRatingRepositoryProvider(id));
  final notifier = RestaurantRatingStateNotifier(repository: repository);

  return notifier;
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  @override
  RestaurantRatingStateNotifier({required super.repository});
}
