import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../screens/home_screen.dart';

class PinCodeAlertDialog {
  static Future<void> getPinCodeFromUser(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter Pincode", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Pinput(
                length: 6,
                showCursor: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 35,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onCompleted: (value) {
                  pinCode = value;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (int.tryParse(pinCode.toString()) != null &&
                          int.tryParse(pinCode.toString())! > 99999 &&
                          int.tryParse(pinCode.toString())! <= 125000) {
                        Navigator.of(context).pop(pinCode);
                      } else {
                        pinCode = '';
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            content: const Text(
                                "Please enter a valid 6-digit pincode\n( between 100000 to 125000)"),
                          ),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

