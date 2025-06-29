import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_nodejs/bloc/login/login_bloc.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({super.key});

  @override
  State<RegistScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegistScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordAgain = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _passwordAgain.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              var bloc = context.read<LoginBloc>();
              return state.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50)),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.red.shade200,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  spacing: 20,
                                  children: [
                                    Text(
                                      'Create Your Account For Free',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _email,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Please enter your email'
                                              : null,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          fillColor: Colors.red,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          contentPadding: EdgeInsets.all(10),
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.red,
                                          ),
                                          label: Text(
                                            'Email',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _password,
                                      obscureText: true,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Please enter your password'
                                              : null,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          fillColor: Colors.red,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          contentPadding: EdgeInsets.all(10),
                                          prefixIcon: Icon(
                                            Icons.password_rounded,
                                            color: Colors.red,
                                          ),
                                          label: Text(
                                            'Password',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: _passwordAgain,
                                      obscureText: true,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Please enter your password'
                                              : null,
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          fillColor: Colors.red,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 2)),
                                          contentPadding: EdgeInsets.all(10),
                                          prefixIcon: Icon(
                                            Icons.password_rounded,
                                            color: Colors.red,
                                          ),
                                          label: Text(
                                            'Repeat Password',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                    ),
                                    SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade600,
                                                foregroundColor: Colors.white),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                if (_password.text !=
                                                    _passwordAgain.text) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Password not match'),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                  ));
                                                  return;
                                                } else {
                                                  bloc.add(CreateAccount(
                                                    email: _email.text,
                                                    password: _password.text,
                                                  ));
                                                }
                                              }
                                            },
                                            child: Text('Create Account'))),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Already have an account?'),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, '/');
                                            },
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.red.shade600),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 200,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(10)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade200,
                                        Colors.red,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                ),
                              ),
                              Container(
                                height: 200,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(10)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade200,
                                        Colors.red,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
