import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Function() onPressed;

  const EventCard(
      {required this.text,
        required this.imageUrl,
        required this.onPressed,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 75,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.lightBlue.withOpacity(.08)),
          ],
        ),
        child: Row(
          children: [
            Image.network(imageUrl, height: 59, fit: BoxFit.fill),
            const SizedBox(
              width: 15,
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}