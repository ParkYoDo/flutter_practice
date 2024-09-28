import 'package:codefactory/common/model/cursor_pagination_model.dart';
import 'package:codefactory/common/model/model_with_id.dart';
import 'package:codefactory/common/model/pagination_params.dart';
import 'package:retrofit/retrofit.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate(
      {@Queries()
      PaginationParams? paginationPrams = const PaginationParams()});
}
