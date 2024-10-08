import 'package:codefactory/common/const/colors.dart';
import 'package:codefactory/common/layout/default_layout.dart';
import 'package:codefactory/order/provider/order_provider.dart';
import 'package:codefactory/order/view/order_done_screen.dart';
import 'package:codefactory/product/component/product_card.dart';
import 'package:codefactory/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';

  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);

    if (basket.isEmpty) {
      return const DefaultLayout(
          title: '장바구니',
          child: Center(
              child: Text(
            "장바구니가 비어있습니다",
          )));
    }
    final productsTotal = basket.fold<int>(
        0, (prev, next) => prev + (next.product.price * next.count));
    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: '장바구니',
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                    color: BODY_TEXT_COLOR,
                    height: 32.0,
                  ),
                  itemBuilder: (_, index) {
                    final model = basket[index];
                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                  itemCount: basket.length,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '장바구니 금액',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text('₩${productsTotal.toString()}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '배달비',
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      if (basket.isNotEmpty) Text('₩${deliveryFee.toString()}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '총액',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('₩${(productsTotal + deliveryFee).toString()}')
                    ],
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () async {
                            final res = await ref
                                .read(orderProvider.notifier)
                                .postOrder();

                            if (res) {
                              context.goNamed(OrderDoneScreen.routeName);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('결제 실패!')));
                            }
                          },
                          child: const Text(
                            '결제하기',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
