// Copyright (c) 2023- All flutter_graph_view authors. All rights reserved.
//
// This source code is licensed under Apache 2.0 License.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';

// Global variable for demo puposes only.
// Replace with state management solution
Map<String, dynamic> data = {};
Map<String, Vertex> vertexStorage = {};

class PersistenceDemo extends StatefulWidget {
  const PersistenceDemo({super.key});

  @override
  State<PersistenceDemo> createState() => _PersistenceDemoState();
}

class _PersistenceDemoState extends State<PersistenceDemo> {
  GraphComponent? graphComponent;

  saveVertex(Vertex v) {
    vertexStorage[v.id as String] = v;
  }

  Map<String, Vertex?> loadVertex() {
    return vertexStorage;
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      var vertexes = <Map>{};
      var r = Random();
      for (var i = 0; i < 10; i++) {
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
      for (var i = 0; i < 10; i++) {
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

      for (var i = 0; i < 20; i++) {
        edges.add({
          'srcId': 'node${i % 8}',
          'dstId': 'node${i % 10}',
          'edgeName': 'edge${r.nextInt(3)}',
          'ranking': DateTime.now().millisecond,
        });
      }

      data = {
        'vertexes': vertexes,
        'edges': edges,
      };
    }

    /// Your can use different decorators to get different effects.
    // ignore: unused_local_variable
    var decorators = [
      PersistenceDecorator(saveVertex, loadVertex),
      CoulombDecorator(),
      HookeDecorator(),
      HookeCenterDecorator(),
      // ForceMotionDecorator(),
    ];

    graphComponent = GraphComponent(
      data: data,
      convertor: MapConvertor(),
      algorithm: ForceDirected(
        decorators: decorators,
      ),
      cameraComponent: graphComponent?.camera,
      options: Options()
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
        ..vertexShape = VertexCircleShape(),
      context: context,
    );

    return Stack(
      children: [
        FlutterGraphWidgetFromGraphComponent(
          graphComponent: graphComponent!,
        ),
        Positioned(
            bottom: 50,
            right: 50,
            child: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    addNewRandomVertex();
                  });
                },
                icon: const Icon(Icons.add),
              ),
            )),
      ],
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

  addNewRandomVertex() {
    final r = Random();
    final existingNodeId = r.nextInt(9);
    final newNodeId = r.nextInt(500) + 10;
    final newVertex = {
      'id': 'node$newNodeId',
      'tag': 'tag${r.nextInt(9)}',
      'tags': [
        'tag${r.nextInt(9)}',
        if (r.nextBool()) 'tag${r.nextInt(4)}',
        if (r.nextBool()) 'tag${r.nextInt(8)}'
      ],
    };
    final newEdge = {
      'srcId': 'node$existingNodeId',
      'dstId': 'node$newNodeId',
      'edgeName': 'edge${r.nextInt(3)}',
      'ranking': DateTime.now().millisecond,
    };
    data['vertexes'].add(newVertex);
    data['edges'].add(newEdge);
  }
}
