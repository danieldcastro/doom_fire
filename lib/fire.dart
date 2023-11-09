import 'package:doom_fire/fire_controller.dart';
import 'package:flutter/material.dart';

class Fire extends StatefulWidget {
  const Fire({super.key});

  @override
  State<Fire> createState() => _FireState();
}

class _FireState extends State<Fire> {
  late FireController controller;

  @override
  void initState() {
    super.initState();
    controller = FireController(setState: setState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.tableCellDimension = controller.isDebugging
          ? MediaQuery.sizeOf(context).width * 0.03
          : MediaQuery.sizeOf(context).width * 0.01;
      controller.fireWidth =
          (MediaQuery.sizeOf(context).width / controller.tableCellDimension)
              .round();
      controller.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 7, 7),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(
              color: Colors.transparent, width: 0, style: BorderStyle.none),
          children: controller.tableRows,
        ),
      ),
    );
  }
}
