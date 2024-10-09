import 'package:codefactory/common/const/data.dart';
import 'package:codefactory/common/dio/dio.dart';
import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/model/pagination_params.dart';
import 'package:codefactory/common/repository/base_pagination_repository.dart';
import 'package:codefactory/order/model/order_model.dart';
import 'package:codefactory/order/model/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = OrderRepository(dio, baseUrl: 'http://$ip/order');

  return repository;
});

// baseUrl: http://$ip/order

@RestApi()
abstract class OrderRepository
    implements IBasePaginationRepository<OrderModel> {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;

  @override
  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<OrderModel>> paginate(
      {@Queries()
      PaginationParams? paginationPrams = const PaginationParams()});

  @POST('/')
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
