import 'package:adv_11am_firebase_app/helpers/firebase_auth_helper.dart';
import 'package:adv_11am_firebase_app/helpers/local_notification_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  Future<void> initNotifications() async {
    await LocalNotificationHelper.localNotificationHelper
        .initLocalNotifications();
  }

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text("Simple Notification"),
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .showSimpleNotification();
              },
            ),
            OutlinedButton(
              child: Text("Scheduled Notification"),
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .showScheduledNotification();
              },
            ),
            OutlinedButton(
              child: Text("Big Picture Notification"),
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .showBigPictureNotification();
              },
            ),
            OutlinedButton(
              child: Text("Media Style Notification"),
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .showMediaStyleNotification();
              },
            ),
            ElevatedButton(
              child: Text("Anonymous Login"),
              onPressed: () async {
                Map<String, dynamic> data = await FirebaseAuthHelper
                    .firebaseAuthHelper
                    .logInAnonymously();

                if (data['user'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: data);
                } else if (data['msg'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(data['msg']),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login Failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: Text("Sign Up"),
                  onPressed: validateAndSignUp,
                ),
                ElevatedButton(
                  child: Text("Sign In"),
                  onPressed: validateAndSignIn,
                ),
              ],
            ),
            ElevatedButton(
              child: Text("Sign in with Google"),
              onPressed: () async {
                Map<String, dynamic> data = await FirebaseAuthHelper
                    .firebaseAuthHelper
                    .logInWithGoogle();

                if (data['user'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: data);
                } else if (data['msg'] != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(data['msg']),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login Failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void validateAndSignUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Sign Up"),
        ),
        content: Form(
          key: signUpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your email first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val;
                },
                decoration: InputDecoration(
                  hintText: "Enter email here...",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter password first...";
                  } else if (val.length <= 6) {
                    return "Enter more than 6 letters...";
                  }
                  return null;
                },
                onSaved: (val) {
                  password = val;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password here...",
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            child: Text("Sign Up"),
            onPressed: () async {
              if (signUpFormKey.currentState!.validate()) {
                signUpFormKey.currentState!.save();

                User? user = await FirebaseAuthHelper.firebaseAuthHelper
                    .signUp(email: email!, password: password!);

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign Up Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign Up Failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                emailController.clear();
                passwordController.clear();

                setState(() {
                  email = null;
                  password = null;
                });

                Navigator.of(context).pop();
              }
            },
          ),
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              emailController.clear();
              passwordController.clear();

              setState(() {
                email = null;
                password = null;
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void validateAndSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Sign In"),
        ),
        content: Form(
          key: signInFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your email first...";
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val;
                },
                decoration: InputDecoration(
                  hintText: "Enter email here...",
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter password first...";
                  } else if (val.length <= 6) {
                    return "Enter more than 6 letters...";
                  }
                  return null;
                },
                onSaved: (val) {
                  password = val;
                },
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password here...",
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            child: Text("Sign In"),
            onPressed: () async {
              if (signInFormKey.currentState!.validate()) {
                signInFormKey.currentState!.save();

                User? user = await FirebaseAuthHelper.firebaseAuthHelper
                    .logIn(email: email!, password: password!);

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In Successfully..."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  Navigator.of(context).pushReplacementNamed('/');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In Failed..."),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                emailController.clear();
                passwordController.clear();

                setState(() {
                  email = null;
                  password = null;
                });

                Navigator.of(context).pop();
              }
            },
          ),
          OutlinedButton(
            child: Text("Cancel"),
            onPressed: () {
              emailController.clear();
              passwordController.clear();

              setState(() {
                email = null;
                password = null;
              });

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
