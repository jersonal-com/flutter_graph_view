// Copyright (c) 2023- All flutter_graph_view authors. All rights reserved.
//
// This source code is licensed under Apache 2.0 License.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';

class DecoratorDemo extends StatelessWidget {
  const DecoratorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    var vertexes = <Map>{};
    var r = Random();
    for (var i = 0; i < 50; i++) {
      vertexes.add(
        {
          'id': 'node$i',
          'tag': 'tag${r.nextInt(9)}',
          'tags': [
            'tag${r.nextInt(9)}',
            if (r.nextBool()) 'tag${r.nextInt(4)}',
            if (r.nextBool()) 'tag${r.nextInt(8)}'
          ],
        },
      );
    }
    for (var i = 0; i < 50; i++) {
      vertexes.add(
        {
          'id': 'node$i',
          'tag': 'tag${r.nextInt(9)}',
          'tags': [
            'tag${r.nextInt(9)}',
            if (r.nextBool()) 'tag${r.nextInt(4)}',
            if (r.nextBool()) 'tag${r.nextInt(8)}'
          ],
        },
      );
    }
    var edges = <Map>{};

    for (var i = 0; i < 50; i++) {
      edges.add({
        'srcId': 'node${i % 8}',
        'dstId': 'node$i',
        'edgeName': 'edge${r.nextInt(3)}',
        'ranking': DateTime.now().millisecond,
      });
    }

    var data = {
      'vertexes': vertexes,
      'edges': edges,
    };

    /// Your can use different decorators to get different effects.
    // ignore: unused_local_variable
    var decorators2 = [
      CoulombDecorator(),
      HookeDecorator(),
      HookeCenterDecorator(),
      ForceDecorator(),
      ForceMotionDecorator(),
      TimeCounterDecorator(),
    ];

    var decorators1 = [
      CoulombDecorator(),
      HookeDecorator(),
      CoulombReverseDecorator(),
      HookeBorderDecorator(alwaysInScreen: false),
      ForceDecorator(),
      ForceMotionDecorator(),
      TimeCounterDecorator(),
    ];
    return FlutterGraphWidget(
      data: data,
      algorithm: RandomAlgorithm(
        decorators: decorators1,
      ),
      convertor: MapConvertor(),
      options: Options()
        ..onVertexTapUp = ((vertex, event) {
          vertex.cpn?.graphComponent?.mergeGraph(genData(vertex.id));
        })
        ..enableHit = false
        ..panelDelay = const Duration(milliseconds: 500)
        ..graphStyle = (GraphStyle()
          // tagColor is prior to tagColorByIndex. use vertex.tags to get color
          ..tagColor = {'tag8': Colors.orangeAccent.shade200}
          ..tagColorByIndex = [
            Colors.red.shade200,
            Colors.orange.shade200,
            Colors.yellow.shade200,
            Colors.green.shade200,
            Colors.blue.shade200,
            Colors.blueAccent.shade200,
            Colors.purple.shade200,
            Colors.pink.shade200,
            Colors.blueGrey.shade200,
            Colors.deepOrange.shade200,
          ])
        ..useLegend = true // default true
        ..edgePanelBuilder = edgePanelBuilder
        ..vertexPanelBuilder = vertexPanelBuilder
        ..edgeShape = EdgeLineShape() // default is EdgeLineShape.
        ..vertexShape = VertexCircleShape(), // default is VertexCircleShape.
    );
  }

  Widget edgePanelBuilder(Edge edge, Viewfinder viewfinder) {
    var c = viewfinder.localToGlobal(edge.position);

    return Stack(
      children: [
        Positioned(
          left: c.x + 5,
          top: c.y,
          child: SizedBox(
            width: 200,
            child: ColoredBox(
              color: Colors.grey.shade900.withAlpha(200),
              child: ListTile(
                title: Text(
                    '${edge.edgeName} @${edge.ranking}\nDelay controlled by \noptions.panelDelay\ndefault to 300ms'),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget vertexPanelBuilder(hoverVertex, Viewfinder viewfinder) {
    var c = viewfinder.localToGlobal(hoverVertex.cpn!.position);
    return Stack(
      children: [
        Positioned(
          left: c.x + hoverVertex.radius + 5,
          top: c.y - 20,
          child: SizedBox(
            width: 120,
            child: ColoredBox(
              color: Colors.grey.shade900.withAlpha(200),
              child: ListTile(
                title: Text(
                  'Id: ${hoverVertex.id}',
                ),
                subtitle: Text(
                    'Tag: ${hoverVertex.data['tag']}\nDegree: ${hoverVertex.degree} ${hoverVertex.prevVertex?.id}'),
              ),
            ),
          ),
        )
      ],
    );
  }

  genData(srcId) {
    var vertexes = <Map>{};
    var edges = <Map>{};
    var r = Random();
    for (var i = 0; i < 5; i++) {
      var dstId = r.nextInt(30) + 40;
      var newTag = 'tag${r.nextInt(12) + 9}';
      vertexes.add(
        {
          'id': 'node$dstId',
          'tag': newTag,
          'tags': [
            newTag,
            if (r.nextBool()) 'tag${r.nextInt(4)}',
            if (r.nextBool()) 'tag${r.nextInt(8)}'
          ],
        },
      );
      edges.add({
        'srcId': srcId,
        'dstId': 'node$dstId',
        'edgeName': 'edge${r.nextInt(3)}',
        'ranking': DateTime.now().millisecond,
      });
    }
    return {
      'vertexes': vertexes,
      'edges': edges,
    };
  }
}
