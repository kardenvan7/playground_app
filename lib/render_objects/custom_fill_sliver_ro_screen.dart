import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class CustomFillSliverRoScreen extends StatelessWidget {
  const CustomFillSliverRoScreen({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            pinned: true,
            stretch: false,
            primary: false,
            expandedHeight: 250,
            toolbarHeight: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              expandedTitleScale: 1,
              background: Container(
                height: 200,
                width: 300,
                color: Colors.red,
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            floating: true,
            toolbarHeight: 112,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Container(
                  color: Colors.blue,
                  constraints: const BoxConstraints.expand(height: 80),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverList.separated(
            itemCount: 2,
            itemBuilder: (_, __) => Container(
              color: Colors.green,
              constraints: const BoxConstraints.expand(height: 80),
            ),
            separatorBuilder: (_, __) => Container(
              color: Colors.black,
              constraints: const BoxConstraints.expand(height: 2),
            ),
          ),
          DecoratedSliver(
            decoration: const BoxDecoration(color: Colors.orange),
            sliver: _CustomSliverFillRemainingAndOverscroll(child: child),
          ),
        ],
      ),
    );
  }
}

class _CustomSliverFillRemainingAndOverscroll
    extends SingleChildRenderObjectWidget {
  const _CustomSliverFillRemainingAndOverscroll({
    super.child,
  });

  @override
  _CustomRenderSliverFillRemainingAndOverscroll createRenderObject(
    BuildContext context,
  ) =>
      _CustomRenderSliverFillRemainingAndOverscroll();
}

class _CustomRenderSliverFillRemainingAndOverscroll
    extends RenderSliverSingleBoxAdapter {
  _CustomRenderSliverFillRemainingAndOverscroll();

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;

    double extent =
        constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;
    double maxExtent =
        constraints.remainingPaintExtent - math.min(constraints.overlap, 0.0);

    if (child != null) {
      final double childExtent;
      switch (constraints.axis) {
        case Axis.horizontal:
          childExtent =
              child!.getMaxIntrinsicWidth(constraints.crossAxisExtent);
        case Axis.vertical:
          childExtent =
              child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);
      }

      extent = math.max(extent, childExtent);
      maxExtent = math.max(extent, maxExtent);
      child!.layout(constraints.asBoxConstraints(
          minExtent: extent, maxExtent: maxExtent));
    }

    assert(
      extent.isFinite,
      'The calculated extent for the child of SliverFillRemaining is not finite. '
      'This can happen if the child is a scrollable, in which case, the '
      'hasScrollBody property of SliverFillRemaining should not be set to '
      'false.',
    );

    // Эта строка добавлена в стандартный рендер объект для того, чтобы экран не
    // падал в случае когда элементы в скролле уходят за экран.
    // В текущем юзкейсе ничего не ломает и позволяет удовлетворить дизайн
    extent = math.max(0, extent);

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: extent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: math.min(maxExtent, constraints.remainingPaintExtent),
      maxPaintExtent: maxExtent,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    if (child != null) {
      setChildParentData(child!, constraints, geometry!);
    }
  }
}
