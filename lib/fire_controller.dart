import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class FireController {
  final void Function(void Function()) setState;
  final Random random = Random();

  FireController({required this.setState});

  final List<int> firePixelList = [];
  List<TableRow> tableRows = [];
  int fireWidth = 0;
  int fireHeight = 100;
  final List<Color> fireColorsPalette = [
    const Color.fromARGB(255, 7, 7, 7),
    const Color.fromARGB(255, 31, 7, 7),
    const Color.fromARGB(255, 47, 15, 7),
    const Color.fromARGB(255, 71, 15, 7),
    const Color.fromARGB(255, 87, 23, 7),
    const Color.fromARGB(255, 103, 31, 7),
    const Color.fromARGB(255, 119, 31, 7),
    const Color.fromARGB(255, 143, 39, 7),
    const Color.fromARGB(255, 159, 47, 7),
    const Color.fromARGB(255, 175, 63, 7),
    const Color.fromARGB(255, 191, 71, 7),
    const Color.fromARGB(255, 199, 71, 7),
    const Color.fromARGB(255, 223, 79, 7),
    const Color.fromARGB(255, 223, 87, 7),
    const Color.fromARGB(255, 223, 87, 7),
    const Color.fromARGB(255, 215, 95, 7),
    const Color.fromARGB(255, 215, 95, 7),
    const Color.fromARGB(255, 215, 103, 15),
    const Color.fromARGB(255, 207, 111, 15),
    const Color.fromARGB(255, 207, 119, 15),
    const Color.fromARGB(255, 207, 127, 15),
    const Color.fromARGB(255, 207, 135, 23),
    const Color.fromARGB(255, 199, 135, 23),
    const Color.fromARGB(255, 199, 143, 23),
    const Color.fromARGB(255, 199, 151, 31),
    const Color.fromARGB(255, 191, 159, 31),
    const Color.fromARGB(255, 191, 159, 31),
    const Color.fromARGB(255, 191, 167, 39),
    const Color.fromARGB(255, 191, 167, 39),
    const Color.fromARGB(255, 191, 175, 47),
    const Color.fromARGB(255, 183, 175, 47),
    const Color.fromARGB(255, 183, 183, 47),
    const Color.fromARGB(255, 183, 183, 55),
    const Color.fromARGB(255, 207, 207, 111),
    const Color.fromARGB(255, 223, 223, 159),
    const Color.fromARGB(255, 239, 239, 199),
    const Color.fromARGB(255, 255, 255, 255),
  ];

  bool isDebugging = false;
  double tableCellDimension = 50;

  Future<void> start() async {
    createFireDataStructure();
    createFireSource();
    setState(() {
      renderFire();
    });

    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      calculateFirePropagation();
    });
  }

  void createFireDataStructure() {
    firePixelList.clear();
    final numberOfPixels = fireWidth * fireHeight;

    for (int i = 0; i < numberOfPixels; i++) {
      firePixelList.add(0);
    }
  }

  void calculateFirePropagation() {
    for (int column = 0; column < fireWidth; column++) {
      for (int row = 0; row < fireHeight; row++) {
        final pixelIndex = column + (row * fireWidth);
        updateFireIntensityPerPixel(pixelIndex);
      }
    }
    setState(() {
      renderFire();
    });
  }

  void updateFireIntensityPerPixel(currentPixelIndex) {
    final belowPixelIndex = currentPixelIndex + fireWidth;

    if (belowPixelIndex >= fireWidth * fireHeight) {
      return;
    }

    final decay = random.nextInt(3);
    final belowPixelIntensity = firePixelList[belowPixelIndex];
    final newFireIntensity =
        belowPixelIntensity - decay >= 0 ? belowPixelIntensity - decay : 0;

    firePixelList[currentPixelIndex - decay < 0
        ? currentPixelIndex
        : currentPixelIndex + decay] = newFireIntensity;
  }

  void createFireSource() {
    for (int column = 0; column < fireWidth; column++) {
      final overflowPixelIndex = fireWidth * fireHeight;
      final pixelIndex = (overflowPixelIndex - fireWidth) + column;

      firePixelList[pixelIndex] = 36;
    }
  }

  void renderFire() {
    tableRows.clear();
    for (int row = 0; row < fireHeight; row++) {
      tableRows.add(TableRow(
        children: List.generate(
          fireWidth,
          (column) {
            final pixelIndex = column + (row * fireWidth);
            final fireIntensity = firePixelList[pixelIndex];
            return SizedBox.square(
              dimension: tableCellDimension,
              child: Visibility(
                visible: isDebugging,
                replacement: Container(
                  color: fireColorsPalette[fireIntensity],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 3,
                      right: 3,
                      child: Text(
                        pixelIndex.toString(),
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                      ),
                    ),
                    Center(
                      child: Text(
                        fireIntensity.toString(),
                        style: TextStyle(
                            color: fireColorsPalette[fireIntensity],
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ));
    }
  }
}
