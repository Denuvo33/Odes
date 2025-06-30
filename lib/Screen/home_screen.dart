import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Todos App'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome Back, Syahid',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                      Text('Night Theme')
                    ],
                  )
                ],
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 180,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/yourtodos');
                      },
                      child: Card(
                        color: const Color.fromARGB(137, 7, 205, 255),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'Your Todos',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.person_2,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: InkWell(
                      child: Card(
                        color: const Color.fromARGB(136, 255, 251, 7),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'Todos Group',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.group,
                                size: 40,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      child: Card(
                        color: Colors.green,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'Interact with Odes',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.smart_toy_outlined,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (_) => false);
                        } on FirebaseAuthException catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        color: Colors.red,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.logout,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
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
