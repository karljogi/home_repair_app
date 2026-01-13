import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';

//Other custom imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_repair_app/main.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math_64.dart';

class CreateSessionPage extends ConsumerStatefulWidget {
  const CreateSessionPage({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  ConsumerState<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends ConsumerState<CreateSessionPage> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  ScreenshotController _screenshotController = ScreenshotController();
  List<Uint8List> _images = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: onRemoveEverything,
                      child: Text("Remove Everything"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ref
                            .read(sessionsProvider.notifier)
                            .add(
                              Session(
                                uuid: Uuid().v4(),
                                images: _images,
                                comments: List.generate(
                                  _images.length,
                                  (_) => '',
                                ),
                              ),
                            );
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: Text("Close page"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) async {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: true,
    );

    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;
  }

  Future<void> onRemoveEverything() async {
    anchors.forEach((anchor) {
      arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<void> onNodeTapped(List<String> nodes) async {
    var number = nodes.length;
    AlertDialog(
      title: Text("Information"),
      content: Text("Tapped $number node(s)"),
    );
  }

  Future<void> onPlaneOrPointTapped(
    List<ARHitTestResult> hitTestResults,
  ) async {
    var singleHitTestResult = hitTestResults.firstWhere(
      (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
    );

    var newAnchor = ARPlaneAnchor(
      transformation: singleHitTestResult.worldTransform,
    );
    bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
    if (didAddAnchor!) {
      anchors.add(newAnchor);

      var newNode = ARNode(
        type: NodeType.webGLB,
        uri:
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/refs/heads/main/2.0/Duck/glTF-Binary/Duck.glb",
        scale: Vector3(0.2, 0.2, 0.2),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(1.0, 0.0, 0.0, 0.0),
      );
      bool? didAddNodeToAnchor = await arObjectManager!.addNode(
        newNode,
        planeAnchor: newAnchor,
      );
      if (didAddNodeToAnchor!) {
        nodes.add(newNode);
        _takeScreenshot();
      } else {
        AlertDialog(
          title: Text("Error"),
          content: Text("Adding Node to Anchor failed"),
        );
      }
    } else {
      AlertDialog(title: Text("Error"), content: Text("Adding Anchor failed"));
    }
  }

  void _takeScreenshot() async {
    Future.delayed(Duration(milliseconds: 100), () async {
      final Uint8List? imageFile = await _screenshotController.capture();
      if (imageFile != null) _images.add(imageFile);
    });
  }
}
