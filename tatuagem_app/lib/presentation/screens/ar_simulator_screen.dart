import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ARSimulatorScreen extends StatefulWidget {
  const ARSimulatorScreen({Key? key}) : super(key: key);

  @override
  State<ARSimulatorScreen> createState() => _ARSimulatorScreenState();
}

class _ARSimulatorScreenState extends State<ARSimulatorScreen> {
  // Tattoo transform state
  Offset _tattooOffset = Offset.zero;
  double _tattooScale = 1.0;
  double _tattooRotation = 0.0;

  // Para gestos
  Offset _initialFocalPoint = Offset.zero;
  Offset _initialTattooOffset = Offset.zero;
  double _initialScale = 1.0;
  double _initialRotation = 0.0;

  final GlobalKey _previewContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _initialTattooOffset = _tattooOffset;
    _initialScale = _tattooScale;
    _initialRotation = _tattooRotation;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _initialFocalPoint = details.focalPoint;
    _initialTattooOffset = _tattooOffset;
    _initialScale = _tattooScale;
    _initialRotation = _tattooRotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final dx = details.focalPoint.dx - _initialFocalPoint.dx;
    final dy = details.focalPoint.dy - _initialFocalPoint.dy;
    setState(() {
      _tattooOffset = _initialTattooOffset + Offset(dx, dy);
      _tattooScale = (_initialScale * details.scale).clamp(0.2, 5.0);
      _tattooRotation = _initialRotation + details.rotation;
    });
  }

  void _resetTattoo() {
    setState(() {
      _tattooOffset = Offset.zero;
      _tattooScale = 1.0;
      _tattooRotation = 0.0;
    });
  }

  Future<String?> _captureScreenshot() async {
    try {
      final boundary =
          _previewContainerKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(
        pixelRatio: ui.window.devicePixelRatio,
      );
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return null;
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = Directory.systemTemp;
      final file = File(
        '${dir.path}/tattoo_snapshot_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);
      return file.path;
    } catch (e) {
      debugPrint('Screenshot error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerOffset = Offset(
      screenSize.width / 2 - 75,
      screenSize.height / 2 - 75,
    );
    if (_tattooOffset == Offset.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tattooOffset == Offset.zero) {
          setState(() => _tattooOffset = centerOffset);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulação AR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: null, // câmera não implementada
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetTattoo,
            tooltip: 'Resetar posição',
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _previewContainerKey,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Câmera não disponível',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            // Dica de controle
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Arraste, amplie com dois dedos e rode para posicionar',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            // Tattoo manipulável
            Positioned(
              left: _tattooOffset.dx,
              top: _tattooOffset.dy,
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(_tattooRotation)
                    ..scale(_tattooScale),
                  origin: const Offset(75, 75),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/tattoo.png'),
                        fit: BoxFit.contain,
                      ),
                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.camera_alt),
        label: const Text('Salvar'),
        onPressed: () async {
          final path = await _captureScreenshot();
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                path != null ? 'Salvo: $path' : 'Falha ao salvar imagem',
              ),
            ),
          );
        },
      ),
    );
  }
}
