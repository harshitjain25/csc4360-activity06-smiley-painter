
import 'dart:math' show pi, Random;
import 'package:flutter/material.dart';

// In-Class Activity 06: Drawing with Flutter
// Student: Harshit Jain
// Panther ID: 002916196

void main() {
  runApp(const SmileyApp());
}

// =====================================================
// MAIN APPLICATION
// =====================================================

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

// =====================================================
// DRAWING PLAYGROUND
// =====================================================

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() =>
      _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;

  String selectedFace = 'Classic';

  Color? customFaceColor;

  final Random random = Random();

  final List<String> faceTypes = [
    'Classic',
    'Sleepy',
    'Surprised',
  ];

  final List<Color> randomColors = [
    Colors.pinkAccent,
    Colors.lightBlue,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.yellow,
  ];

  // =====================================================
  // SNACKBAR HELPER
  // =====================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // =====================================================
  // LEVEL 4: TAP TO CYCLE FACES
  // =====================================================

  void _cycleFace() {
    setState(() {
      int currentIndex = faceTypes.indexOf(selectedFace);

      int nextIndex = (currentIndex + 1) % faceTypes.length;

      selectedFace = faceTypes[nextIndex];
    });

    _showMessage('Face changed to $selectedFace');
  }

  // =====================================================
  // LEVEL 4: LONG PRESS TO RANDOMIZE
  // =====================================================

  void _randomizeFace() {
    setState(() {
      mood = random.nextDouble();

      customFaceColor =
          randomColors[random.nextInt(randomColors.length)];
    });

    _showMessage(
      'Randomized! Mood: ${mood.toStringAsFixed(2)} | Face color changed',
    );
  }

  // =====================================================
  // BUILD METHOD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // INTERACTIVE SMILEY FACE
            // =====================================================

            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final side = constraints.biggest.shortestSide
                        .clamp(100.0, 300.0);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,

                      // Single tap changes face type
                      onTap: _cycleFace,

                      // Long press randomizes mood and color
                      onLongPress: _randomizeFace,

                      child: SizedBox(
                        width: side,
                        height: side,
                        child: CustomPaint(
                          size: Size(side, side),
                          painter: SmileyPainter(
                            mood: mood,
                            faceType: selectedFace,
                            customFaceColor: customFaceColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tap face to change | Long press to randomize',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            // =====================================================
            // MOOD SLIDER AND FACE SELECTOR
            // =====================================================

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Selected Face: $selectedFace',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Mood: ${mood.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  Slider(
                    value: mood,
                    min: 0,
                    max: 1,
                    onChanged: (double value) {
                      setState(() {
                        mood = value;

                        // Return to normal mood-based color.
                        customFaceColor = null;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // FACE SELECTION BUTTONS
                  // =================================================

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Classic',
                          label: Text('Classic'),
                          icon: Icon(Icons.sentiment_satisfied),
                        ),

                        ButtonSegment(
                          value: 'Sleepy',
                          label: Text('Sleepy'),
                          icon: Icon(Icons.bedtime),
                        ),

                        ButtonSegment(
                          value: 'Surprised',
                          label: Text('Surprised'),
                          icon: Icon(Icons.sentiment_very_dissatisfied),
                        ),
                      ],

                      selected: {selectedFace},

                      onSelectionChanged: (selection) {
                        setState(() {
                          selectedFace = selection.first;
                        });

                        _showMessage(
                          'Face changed to $selectedFace',
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// CUSTOM PAINTER
// =====================================================

class SmileyPainter extends CustomPainter {
  final double mood;
  final String faceType;
  final Color? customFaceColor;

  SmileyPainter({
    required this.mood,
    required this.faceType,
    required this.customFaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // =====================================================
    // FACE POSITION AND RADIUS
    // =====================================================

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.4;

    // =====================================================
    // FACE COLOR
    // =====================================================

    Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue;
    } else if (mood <= 0.70) {
      faceColor = Colors.yellow;
    } else {
      faceColor = Colors.orangeAccent;
    }

    // Use the randomized color if one is selected.
    faceColor = customFaceColor ?? faceColor;

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    // Draw face circle
    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // =====================================================
    // FACE BORDER
    // =====================================================

    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    // =====================================================
    // EYE AND MOUTH PAINT
    // =====================================================

    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.18;

    final eyeDx = radius * 0.35;

    final leftEye = Offset(
      center.dx - eyeDx,
      eyeY,
    );

    final rightEye = Offset(
      center.dx + eyeDx,
      eyeY,
    );

    // =====================================================
    // FACE 1: CLASSIC
    // =====================================================

    if (faceType == 'Classic') {
      // Left eye
      canvas.drawCircle(
        leftEye,
        radius * 0.06,
        eyePaint,
      );

      // Right eye
      canvas.drawCircle(
        rightEye,
        radius * 0.06,
        eyePaint,
      );

      final mouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.15,
        ),
        width: radius,
        height: radius * (0.4 + mood * 0.5),
      );

      // SAD
      if (mood < 0.35) {
        final frownRect = mouthRect.translate(
          0,
          radius * 0.25,
        );

        canvas.drawArc(
          frownRect,
          1.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      }

      // NEUTRAL
      else if (mood <= 0.70) {
        canvas.drawLine(
          Offset(
            center.dx - radius * 0.35,
            center.dy + radius * 0.35,
          ),
          Offset(
            center.dx + radius * 0.35,
            center.dy + radius * 0.35,
          ),
          mouthPaint,
        );
      }

      // HAPPY
      else {
        canvas.drawArc(
          mouthRect,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      }
    }

    // =====================================================
    // FACE 2: SLEEPY
    // =====================================================

    else if (faceType == 'Sleepy') {
      // Closed left eye
      canvas.drawArc(
        Rect.fromCenter(
          center: leftEye,
          width: radius * 0.30,
          height: radius * 0.15,
        ),
        0,
        pi,
        false,
        mouthPaint,
      );

      // Closed right eye
      canvas.drawArc(
        Rect.fromCenter(
          center: rightEye,
          width: radius * 0.30,
          height: radius * 0.15,
        ),
        0,
        pi,
        false,
        mouthPaint,
      );

      // Soft mouth
      final sleepyMouth = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.30,
        ),
        width: radius * 0.50,
        height: radius * 0.25,
      );

      canvas.drawArc(
        sleepyMouth,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }

    // =====================================================
    // FACE 3: SURPRISED
    // =====================================================

    else if (faceType == 'Surprised') {
      // Bigger left eye
      canvas.drawCircle(
        leftEye,
        radius * 0.10,
        eyePaint,
      );

      // Bigger right eye
      canvas.drawCircle(
        rightEye,
        radius * 0.10,
        eyePaint,
      );

      // Open mouth
      final openMouth = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.35,
        ),
        width: radius * 0.30,
        height: radius * (0.35 + mood * 0.20),
      );

      canvas.drawOval(
        openMouth,
        eyePaint,
      );
    }
  }

  // =====================================================
  // REPAINT ONLY WHEN PAINTER INPUTS CHANGE
  // =====================================================

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
      oldDelegate.faceType != faceType ||
      oldDelegate.customFaceColor != customFaceColor;
  }
}
