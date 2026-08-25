import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton1 extends StatelessWidget {
  final String text;

  final VoidCallback onTap;

  const PrimaryButton1({

    required this.text,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child:Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}