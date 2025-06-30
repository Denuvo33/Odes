import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_with_nodejs/Model/intro_model.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<IntroModel> cardList = [
    IntroModel(text: 'Welcome To Todo App', color: Colors.green),
    IntroModel(
        text: 'Save your task anywhere and anytime', color: Colors.blueAccent),
    IntroModel(text: 'Do your task as soon as possible', color: Colors.red)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Swiper(
              itemCount: 3,
              control: SwiperControl(),
              pagination: SwiperPagination(
                alignment: Alignment.topCenter,
                builder: SwiperPagination.dots,
              ),
              itemBuilder: (context, index) {
                var card = cardList[index];
                return Card(
                  color: card.color,
                  child: Center(
                      child: Text(
                    card.text,
                    style: const TextStyle(color: Colors.white),
                  )),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  final pref = await SharedPreferences.getInstance();
                  pref.setString('intro', 'true');
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white),
                child: Text('Join Now'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
