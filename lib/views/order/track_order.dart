import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temis_special_snacks/base/custom_app_bar.dart';
import 'package:temis_special_snacks/utils/dimensions.dart';
import 'package:timelines/timelines.dart';

const completeColor = Color(0xff5e6172);
const inProgressColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);

class TrackOrder extends StatefulWidget {
  const TrackOrder({Key? key}) : super(key: key);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  List<dynamic> track = Get.arguments;
  late Stream<DocumentSnapshot> cartDocStream;

  late int _processIndex;

  final _processes = [
    'Preparing',
    'Ready',
    'Delivering',
    'Delivered',
  ];

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  void initState() {
    super.initState();

    cartDocStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(track[3])
        .snapshots();

    if(track[4] == "preparing order"){
      setState(() {
        _processIndex = 0;
      });
    }else if(track[4] == "order ready"){
      setState(() {
        _processIndex = 1;
      });
    }else if(track[4]== "delivering order"){
      setState(() {
        _processIndex = 2;
      });
    }else{
      setState(() {
        _processIndex = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //trigger leaving and use own data
        Navigator.pushReplacementNamed(context, "/initial");
        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Track Order"),
        body: StreamBuilder<DocumentSnapshot>(
            stream: cartDocStream,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                // get cart document
                var cartDocument = snapshot.data!;
                // get cart from the document
                var cart = cartDocument['cart'];
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Order Details",
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).disabledColor)),
                      ),
                      SizedBox(
                        height: Dimensions.height160,
                        child: ListView.builder(
                            itemCount: cart != null ? cart.length : 0,
                            itemBuilder: (_, int index) {
                              return SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Dimensions.height15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  "${cart[index]['quantity']}x  "),
                                              Text(cart[index]['name']),
                                            ],
                                          ),
                                          Text(
                                            "₦${cart[index]['price']}",
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).disabledColor)),
                            Text("₦${track[2]}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: Dimensions.width350,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Delivery Address",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).disabledColor)),
                              SizedBox(
                                height: Dimensions.height10,
                              ),
                              Text(track[1],
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reference",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).disabledColor)),
                            Text(track[0],
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      //Process timeline tracker
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.5,
                        child: Timeline.tileBuilder(
                          theme: TimelineThemeData(
                            direction: Axis.horizontal,
                            connectorTheme: const ConnectorThemeData(
                              space: 30.0,
                              thickness: 5.0,
                            ),
                          ),
                          builder: TimelineTileBuilder.connected(
                            connectionDirection: ConnectionDirection.before,
                            itemExtentBuilder: (_, __) =>
                            MediaQuery.of(context).size.width / _processes.length,
                            contentsBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  _processes[index],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColor(index),
                                  ),
                                ),
                              );
                            },
                            indicatorBuilder: (_, index) {
                              var color;
                              var child;
                              if (index == _processIndex) {
                                color = inProgressColor;
                                child = const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                );
                              } else if (index < _processIndex) {
                                color = completeColor;
                                child = const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 15.0,
                                );
                              } else {
                                color = todoColor;
                              }
                              if (index <= _processIndex) {
                                return Stack(
                                  children: [
                                    CustomPaint(
                                      size: const Size(30.0, 30.0),
                                      painter: _BezierPainter(
                                        color: color,
                                        drawStart: index > 0,
                                        drawEnd: index < _processIndex,
                                      ),
                                    ),
                                    DotIndicator(
                                      size: 30.0,
                                      color: color,
                                      child: child,
                                    ),
                                  ],
                                );
                              } else {
                                return Stack(
                                  children: [
                                    CustomPaint(
                                      size: const Size(15.0, 15.0),
                                      painter: _BezierPainter(
                                        color: color,
                                        drawEnd: index < _processes.length - 1,
                                      ),
                                    ),
                                    OutlinedDotIndicator(
                                      borderWidth: 4.0,
                                      color: color,
                                    ),
                                  ],
                                );
                              }
                            },
                            connectorBuilder: (_, index, type) {
                              if (index > 0) {
                                if (index == _processIndex) {
                                  final prevColor = getColor(index - 1);
                                  final color = getColor(index);
                                  List<Color> gradientColors;
                                  if (type == ConnectorType.start) {
                                    gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                                  } else {
                                    gradientColors = [
                                      prevColor,
                                      Color.lerp(prevColor, color, 0.5)!
                                    ];
                                  }
                                  return DecoratedLineConnector(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: gradientColors,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SolidLineConnector(
                                    color: getColor(index),
                                  );
                                }
                              } else {
                                return null;
                              }
                            },
                            itemCount: _processes.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}
