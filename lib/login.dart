import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _firebase = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool agree = false;
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  var enteredemail = "";
  var enteredpassword = "";
  var enteredphone = "";
  bool terms = true;
  var entereduser = "";
  bool isAuthenticating = false;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  void _login() async {
    bool isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formkey.currentState!.save();
    try {
      setState(() {
        isAuthenticating = true;
      });
      await _firebase.signInWithEmailAndPassword(
          email: enteredemail, password: enteredpassword);
      setState(() {
        isAuthenticating = false;
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Connection Lost")));
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Trigger the sign-in flow

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  void _register() async {
    bool isValid = _formkey2.currentState!.validate();
    if (!isValid) {
      return;
    } else if (isValid && !agree) {
      setState(() {
        terms = false;
      });
      return;
    }
    _formkey2.currentState!.save();

    try {
      setState(() {
        isAuthenticating = true;
      });

      final _userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: enteredemail, password: enteredpassword);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userCredentials.user!.uid)
          .set({
        'username': entereduser,
        'email': enteredemail,
        'phone': enteredphone,
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? "Authentication Failed")));
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  _getlogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Sign In to Your Account",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "rohitm@gmail.com",
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18),
                            suffix: Icon(
                              Icons.email,
                              color: Colors.red,
                            )),
                        onSaved: (newValue) {
                          enteredemail = newValue!;
                        },
                        validator: (value) {
                          if (value == null ||
                              !value.contains("@") ||
                              value.trim().isEmpty) {
                            return ("Please Enter valid Mail ID");
                          }
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          suffix: Icon(
                            Icons.lock,
                            color: Colors.red,
                          )),
                      onSaved: (newValue) {
                        enteredpassword = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (value.trim().length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return "Password must contain at least one special character";
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Password must contain at least one uppercase character";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Forgot Password?",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        "Login With",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              signInWithGoogle();
                            },
                            icon: Image.asset("assets/icons/google.png")),
                        IconButton(
                            onPressed: () {
                              signInWithFacebook();
                            },
                            icon: Image.asset("assets/icons/facebook.png"))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have An Account? ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: const Text(
                              'Create Now',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getregister() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formkey2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create an Account",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Rohit Mundhra",
                          labelText: "Name",
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          suffix: Icon(
                            Icons.person,
                            color: Colors.red,
                          )),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return ("This Field is mandatory");
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        entereduser = newValue!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "rohitm@gmail.com",
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          suffix: Icon(
                            Icons.email,
                            color: Colors.red,
                          )),
                      onSaved: (newValue) {
                        enteredemail = newValue!;
                      },
                      validator: (value) {
                        if (value == null ||
                            !value.contains("@") ||
                            value.trim().isEmpty) {
                          return ("Please Enter valid Mail ID");
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15, right: 10),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Text(
                                    "${selectedCountry.flagEmoji} ${selectedCountry.countryCode} +${selectedCountry.phoneCode}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "1234567890",
                              labelText: "Contact No",
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                              suffix: Icon(
                                Icons.phone,
                                color: Colors.red,
                              ),
                            ),
                            onSaved: (newValue) {
                              enteredphone =
                                  selectedCountry.phoneCode + newValue!;
                            },
                            validator: (value) {
                              if (value == null || value.trim().length != 10) {
                                return "Enter Valid 10 Digit Mobile Number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18),
                          suffix: Icon(
                            Icons.lock,
                            color: Colors.red,
                          )),
                      onSaved: (newValue) {
                        enteredpassword = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (value.trim().length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                            .hasMatch(value)) {
                          return "Password must contain at least one special character";
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Password must contain at least one uppercase character";
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value ?? false;
                            });
                          },
                        ),
                        const Text("I agree with "),
                        const Text(
                          "terms and conditions",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        )
                      ],
                    ),
                    if (!terms)
                      const Text(
                        "Please agree to the terms and conditions",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already Have an Account? ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _switch() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    color: isLogin ? Colors.red : Colors.white,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isLogin ? Colors.white : Colors.grey),
                  )),
                )),
          )),
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Container(
                decoration: BoxDecoration(
                    color: isLogin ? Colors.white : Colors.red,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                      child: Text(
                    "Sign UP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: isLogin ? Colors.grey : Colors.white),
                  )),
                )),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Row(
            children: [
              Text(
                "   Social",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "X",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            _switch(),
            const SizedBox(height: 20),
            isLogin ? _getlogin() : _getregister(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      if (isLogin == true) {
                        _login();
                      } else {
                        _register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.red),
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: isAuthenticating
                            ? const CircularProgressIndicator()
                            : isLogin
                                ? const Text(
                                    "Login",
                                    style: TextStyle(fontSize: 20),
                                  )
                                : const Text(
                                    "Register",
                                    style: TextStyle(fontSize: 20),
                                  )),
                  )),
                ],
              ),
            )
          ]),
        ));
  }
}
