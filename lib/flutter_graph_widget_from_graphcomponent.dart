// Copyright (c) 2023- All flutter_graph_view authors. All rights reserved.
//
// This source code is licensed under Apache 2.0 License.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';

/// Provide an external Api interface to pass in data and policy specification.
///
/// 提供一个对外Api接口，用来传入数据与策略指定（风格策略、布局策略）
class FlutterGraphWidgetFromGraphComponent extends StatefulWidget {
  final GraphComponent graphComponent;

  const FlutterGraphWidgetFromGraphComponent({
    Key? key,
    required this.graphComponent,
  }) : super(key: key);

  @override
  State<FlutterGraphWidgetFromGraphComponent> createState() =>
      _FlutterGraphWidgetFromGraphComponentState();
}

class _FlutterGraphWidgetFromGraphComponentState
    extends State<FlutterGraphWidgetFromGraphComponent> {

  @override
  void initState() {
    super.initState();
  }

  late GraphComponent graphCpn;
  Map<String, Widget Function(BuildContext, GraphComponent)>
      overlayBuilderMap2 = {};

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      backgroundBuilder: widget.graphComponent.options.backgroundBuilder,
      overlayBuilderMap: overlayBuilderMap2,
      game: widget.graphComponent,
    );
  }
}
