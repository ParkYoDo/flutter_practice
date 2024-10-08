import 'package:codefactory/common/view/root_tab.dart';
import 'package:codefactory/common/view/splash_screen.dart';
import 'package:codefactory/order/view/order_done_screen.dart';
import 'package:codefactory/restaurant/view/basket_screen.dart';
import 'package:codefactory/restaurant/view/restaurant_detail_screen.dart';
import 'package:codefactory/user/model/user_model.dart';
import 'package:codefactory/user/provider/user_me_provider.dart';
import 'package:codefactory/user/view/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (prev, next) {
      if (prev != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, __) => const RootTab(),
            routes: [
              GoRoute(
                  path: 'restaurant/:rid',
                  name: RestaurantDetailScreen.routeName,
                  builder: (_, state) => RestaurantDetailScreen(
                      id: state.pathParameters['rid']!,
                      title: state.uri.queryParameters['title']!))
            ]),
        GoRoute(
            path: '/basket',
            name: BasketScreen.routeName,
            builder: (_, __) => const BasketScreen()),
        GoRoute(
            path: '/order_done',
            name: OrderDoneScreen.routeName,
            builder: (_, __) => const OrderDoneScreen())
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  // splashScreen : 앱을 처음 시작했을 때 토큰이 존재하는지 확인 후 로그인 혹은 홈으로 보내줄지 확인하는 과정 필요
  String? redirectLogic(_, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final logginIn = state.uri.toString() == '/login';

    // 유저 정보가 없는데 로그인 페이지면 그대로 두고, 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }
    // user가 null이 아닐 때 사용자 정보가 있고 로그인 중이거나 현재 위치가 splashScreen이면 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.uri.toString() == '/splash' ? '/' : null;
    }
    // userModelError
    if (user is UserModelError) {
      return logginIn ? null : '/login';
    }

    return null;
  }
}
