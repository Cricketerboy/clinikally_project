import 'dart:async';

import 'package:clinikally_project/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/helpers.dart';
import '../providers/pincode_dialog.dart';
import 'home_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isAvailable;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.isAvailable,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  Map<String, dynamic> pinCodeDetails = Helpers.getPinCodeData(pinCode);
  int orderDeadlineHour = 0;
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    orderDeadlineHour =
        pinCodeDetails['Logistics Provider'] == 'Provider A' ? 17 : 9;
    _startCountdown();
  }

  void _startCountdown() {
    DateTime now = DateTime.now();
    DateTime orderDeadline = DateTime(
      now.year,
      now.month,
      now.day,
      orderDeadlineHour,
    );

    if (now.isBefore(orderDeadline)) {
      _timeLeft = orderDeadline.difference(now);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft = _timeLeft - const Duration(seconds: 1);
          } else {
            _timer?.cancel();
          }
        });
      });
    }
  }

  void _showPinCodeDialog() async {
    await PinCodeAlertDialog.getPinCodeFromUser(context);
    pinCodeDetails = Helpers.getPinCodeData(pinCode);
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String deliveryMsg = "Provider Not Available";
    int time = DateTime.now().hour;
    if (widget.isAvailable && pinCode.isNotEmpty) {
      if (pinCodeDetails['Logistics Provider'] == 'Provider A') {
        if (time < 17) {
          deliveryMsg = 'Delivery by TODAY, if ordered before 5 PM';
        } else {
          deliveryMsg = 'Delivery in ${pinCodeDetails['TAT']} days';
        }
      } else if (pinCodeDetails['Logistics Provider'] == 'Provider B') {
        if (time < 9) {
          deliveryMsg = 'Delivery by TODAY, if ordered before 9 AM';
        } else {
          deliveryMsg = 'Delivery by TOMORROW';
          orderDeadlineHour = 0;
        }
      } else {
        deliveryMsg = 'Delivery in ${pinCodeDetails['TAT']} days';
        orderDeadlineHour = 0;
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        title: const Text(
          'Clinikally',
          style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _showPinCodeDialog,
            child: Text(pinCode.isEmpty ? 'PIN CODE' : 'PIN: $pinCode'),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: widget.isAvailable ? () {} : null,
              icon: const Icon(Icons.shopping_cart_rounded),
              label: const Text('Add to cart'),
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(
                    widget.isAvailable ? Colors.black : Colors.black26),
                backgroundColor: MaterialStateProperty.all(widget.isAvailable
                    ? Colors.lightGreen
                    : Colors.lightGreen.shade300),
                foregroundColor: MaterialStateProperty.all(
                    widget.isAvailable ? Colors.black : Colors.black38),
              ),
            ),
            ElevatedButton.icon(
              onPressed: widget.isAvailable
                  ? () {
                      if (pinCode.isNotEmpty) {
                      } else {
                        _showPinCodeDialog();
                      }
                    }
                  : null,
              icon: const Icon(Icons.shopping_basket_rounded),
              label: const Text('Buy now'),
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(
                    widget.isAvailable ? Colors.black : Colors.black26),
                backgroundColor: MaterialStateProperty.all(Colors.amber),
                foregroundColor: MaterialStateProperty.all(
                    widget.isAvailable ? Colors.black : Colors.black38),
              ),
            ),
          ],
        ),
      ),
      body: body(deliveryMsg),
    );
  }

  Widget body(String deliveryMsg) => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView(
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                letterSpacing: 1,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Image slider
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: 5,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return const Icon(
                    Icons.shopping_bag_rounded,
                    size: 100,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Indicator for image slider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentImageIndex == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'MRP: ',
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          '₹${widget.product.price}',
                          style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 25,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
                            tooltip: 'Add to favourites',
                            icon: const Icon(Icons.favorite_border_rounded)),
                        IconButton(
                            onPressed: () {},
                            tooltip: 'Share',
                            icon: const Icon(Icons.share_outlined)),
                      ],
                    ),
                  ],
                ),
                const Text(
                  '(incl. of all taxes.)',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.isAvailable == true ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        widget.isAvailable == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (pinCode.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.local_shipping_outlined),
                title: Text(
                  deliveryMsg,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: (_timeLeft != Duration.zero && widget.isAvailable)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined, color: Colors.red),
                          const Text(
                            ' Time left: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '${_timeLeft.inHours.toString().padLeft(2, '0')}:${(_timeLeft.inMinutes % 60).toString().padLeft(2, '0')}:${(_timeLeft.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )
                    : null,
              )
          ],
        ),
      );
}
