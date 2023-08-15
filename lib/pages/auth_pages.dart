import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:gansabogo/main.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Position { paster, gansa }

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _name;
  Position? _position = Position.gansa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFCEA176),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    width: double.infinity,
                    color: const Color(0xFF2F6044),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40 > 600
                            ? 600
                            : MediaQuery.of(context).size.width - 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                                  0.1 >
                                              32
                                          ? 32
                                          : MediaQuery.of(context).size.height *
                                              0.1,
                                      bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05 >
                                              16
                                          ? 16
                                          : MediaQuery.of(context).size.height *
                                              0.05),
                                  child: Text(
                                    '회원가입',
                                    style: GoogleFonts.eastSeaDokdo(
                                        height: 0.8,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                        0.2 >
                                                    64
                                                ? 64
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                        color: Colors.white),
                                  ),
                                ),
                                Text(
                                  '어서오세요! 당신을 기다리고 있었어요!',
                                  style: GoogleFonts.eastSeaDokdo(
                                      height: 0.8,
                                      fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1 >
                                              32
                                          ? 32
                                          : MediaQuery.of(context).size.height *
                                              0.1,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1 >
                                              32
                                          ? 32
                                          : MediaQuery.of(context).size.height *
                                              0.1,
                                )
                              ],
                            ),
                            Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Form(
                                        key: formKey,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                inputForm(
                                                    context: context,
                                                    label: '아이디',
                                                    hint: '아이디를 입력해주세요',
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return '아이디를 입력해주세요';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _email = value;
                                                    },
                                                    keyboardType:
                                                        TextInputType.text),
                                                inputForm(
                                                    context: context,
                                                    label: '비밀번호',
                                                    hint: '비밀번호를 입력해주세요',
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return '비밀번호를 입력해주세요';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      _password = value;
                                                    },
                                                    keyboardType:
                                                        TextInputType.text,
                                                    obscureText: true),
                                                inputForm(
                                                    context: context,
                                                    label: '비밀번호 확인',
                                                    hint: '동일한 비밀번호를 입력해주세요',
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return '비밀번호를 입력해주세요';
                                                      }
                                                      if (value != _password) {
                                                        return '비밀번호가 일치하지 않습니다';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _password = value;
                                                    },
                                                    keyboardType:
                                                        TextInputType.text,
                                                    obscureText: true),
                                                inputForm(
                                                  context: context,
                                                  label: '이름',
                                                  hint: '이름을 입력해주세요',
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return '이름을 입력해주세요';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _name = value;
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(children: [
                                                    Expanded(
                                                        flex: 16,
                                                        child: Center(
                                                            child: Text(
                                                          '직분',
                                                          style: GoogleFonts.eastSeaDokdo(
                                                              height: 0.8,
                                                              fontSize: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.1 >
                                                                      32
                                                                  ? 32
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.1,
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                                    const Expanded(
                                                        flex: 4,
                                                        child:
                                                            SizedBox.shrink()),
                                                    Expanded(
                                                        flex: 9,
                                                        child: RadioListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: Text(
                                                              '간사',
                                                              style: GoogleFonts.eastSeaDokdo(
                                                                  height: 0.8,
                                                                  fontSize: MediaQuery.of(context).size.height *
                                                                              0.1 >
                                                                          32
                                                                      ? 32
                                                                      : MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.1,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            value:
                                                                Position.gansa,
                                                            groupValue:
                                                                _position,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _position =
                                                                    value;
                                                              });
                                                            })),
                                                    const Expanded(
                                                        flex: 2,
                                                        child:
                                                            SizedBox.shrink()),
                                                    Expanded(
                                                        flex: 9,
                                                        child: RadioListTile(
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            title: Text(
                                                              '목사',
                                                              style: GoogleFonts.eastSeaDokdo(
                                                                  height: 0.8,
                                                                  fontSize: MediaQuery.of(context).size.height *
                                                                              0.1 >
                                                                          32
                                                                      ? 32
                                                                      : MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.1,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            value:
                                                                Position.paster,
                                                            groupValue:
                                                                _position,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _position =
                                                                    value;
                                                              });
                                                            })),
                                                  ]),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: MediaQuery.of(context)
                                                                        .size
                                                                        .height *
                                                                    0.1 >
                                                                32
                                                            ? 32
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.1),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                            width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    60) /
                                                                2,
                                                            height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.2 >
                                                                    64
                                                                ? 64
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.2,
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .contain,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          // TODO: 대기 상태를 표시하는 로딩 화면 표시
                                                                          if (formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            formKey.currentState!.save();

                                                                            _email =
                                                                                '${_email!}@gansa.com';
                                                                            try {
                                                                              final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email!, password: _password!);

                                                                              await FirebaseFirestore.instance.runTransaction((transaction) async {
                                                                                transaction.set(FirebaseFirestore.instance.collection('user').doc(userCredential.user!.uid), {
                                                                                  'info': {
                                                                                    'name': _name,
                                                                                    'position': _position == Position.paster ? 'paster' : 'gansa',
                                                                                  }
                                                                                });
                                                                              }).then((_) {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return AlertDialog(
                                                                                        title: const Text('회원가입 완료!'),
                                                                                        content: const Text('회원가입에 성공했습니다!'),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: const Text('확인'))
                                                                                        ],
                                                                                      );
                                                                                    });

                                                                                Provider.of<CurrentUserModel>(context, listen: false).setUser(userCredential.user);
                                                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage()), (route) => false);
                                                                              });
                                                                            } catch (e) {
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return AlertDialog(
                                                                                      title: const Text('회원가입 실패!'),
                                                                                      content: const Text('회원가입에 실패했습니다!'),
                                                                                      actions: [
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: const Text('확인'))
                                                                                      ],
                                                                                    );
                                                                                  });

                                                                              await FirebaseAuth.instance.currentUser!.delete();
                                                                            }
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          '다 작성했어요!',
                                                                          style:
                                                                              GoogleFonts.eastSeaDokdo(color: Colors.white),
                                                                        )))),
                                                        SizedBox(
                                                            width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    60) /
                                                                2,
                                                            height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.2 >
                                                                    64
                                                                ? 64
                                                                : MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.2,
                                                            child: FittedBox(
                                                                fit: BoxFit
                                                                    .contain,
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const MyHomePage()),
                                                                              (route) => false);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          '돌아가기',
                                                                          style:
                                                                              GoogleFonts.eastSeaDokdo(color: Colors.white),
                                                                        )))),
                                                      ],
                                                    )),
                                              ],
                                            ))))),
                          ],
                        ))))));
  }

  Widget inputForm({
    required BuildContext context,
    required String label,
    required String hint,
    required String? Function(String?)? validator,
    void Function(String?)? onSaved,
    void Function(String?)? onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              label,
              style: GoogleFonts.eastSeaDokdo(
                  height: 0.8,
                  fontSize: MediaQuery.of(context).size.height * 0.1 > 32
                      ? 32
                      : MediaQuery.of(context).size.height * 0.1,
                  color: Colors.white),
            ))),
        const Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
            flex: 5,
            child: TextFormField(
              keyboardType: keyboardType,
              obscureText: obscureText,
              controller: controller,
              style: GoogleFonts.eastSeaDokdo(
                  height: 0.8,
                  fontSize: MediaQuery.of(context).size.height * 0.1 > 32
                      ? 32
                      : MediaQuery.of(context).size.height * 0.1,
                  color: Colors.white),
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.eastSeaDokdo(
                    color: Colors.white,
                    height: 0.8,
                    fontSize: MediaQuery.of(context).size.height * 0.05 > 16
                        ? 16
                        : MediaQuery.of(context).size.height * 0.05,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              onSaved: onSaved,
              onChanged: onChanged,
              validator: validator,
            ))
      ]),
    );
  }
}

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _email = prefs.getString('email');
        _emailController.text = _email ?? '';
      } else {
        prefs.remove('email');
      }
    });
  }

  Future<void> _saveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('email', _email!.split('@').first);
    } else {
      await prefs.remove('email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFFCEA176),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    width: double.infinity,
                    color: const Color(0xFF2F6044),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40 > 600
                            ? 600
                            : MediaQuery.of(context).size.width - 40,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1 >
                                                32
                                            ? 32
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                        0.05 >
                                                    16
                                                ? 16
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05),
                                    child: Text(
                                      '로그인',
                                      style: GoogleFonts.eastSeaDokdo(
                                          height: 0.8,
                                          fontSize: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2 >
                                                  64
                                              ? 64
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    '어서오세요! 당신을 기다리고 있었어요!',
                                    style: GoogleFonts.eastSeaDokdo(
                                        height: 0.8,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                        0.1 >
                                                    32
                                                ? 32
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                                0.1 >
                                            32
                                        ? 32
                                        : MediaQuery.of(context).size.height *
                                            0.1,
                                  )
                                ],
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Form(
                                          key: formKey,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    inputForm(
                                                        context: context,
                                                        label: '아이디',
                                                        hint: '아이디를 입력해주세요',
                                                        controller:
                                                            _emailController,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '아이디를 입력해주세요';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          _email = value;
                                                        },
                                                        keyboardType:
                                                            TextInputType.text),
                                                    inputForm(
                                                        context: context,
                                                        label: '비밀번호',
                                                        hint: '비밀번호를 입력해주세요',
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '비밀번호를 입력해주세요';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          _password = value;
                                                        },
                                                        keyboardType:
                                                            TextInputType.text,
                                                        obscureText: true),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Checkbox(
                                                                value:
                                                                    _rememberMe,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _rememberMe =
                                                                        value!;
                                                                  });
                                                                },
                                                                fillColor: MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                                checkColor:
                                                                    Colors
                                                                        .black,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                              ),
                                                              Text(
                                                                '아이디 기억할래요!',
                                                                style: GoogleFonts
                                                                    .eastSeaDokdo(
                                                                        color: Colors
                                                                            .white),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              width: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      60) /
                                                                  2,
                                                              height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.2 >
                                                                      64
                                                                  ? 64
                                                                  : MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.2,
                                                              child: FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // TODO: 대기 상태를 표시하는 로딩 화면 표시
                                                                            if (formKey.currentState!.validate()) {
                                                                              formKey.currentState!.save();

                                                                              _email = '$_email@gansa.com';
                                                                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email!, password: _password!).then((value) async {
                                                                                await Provider.of<CurrentUserModel>(context, listen: false).setUser(value.user);

                                                                                await _saveLoginInfo().then((_) {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return AlertDialog(
                                                                                          title: const Text('로그인 완료!'),
                                                                                          content: const Text('로그인에 성공했습니다!'),
                                                                                          actions: [
                                                                                            TextButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.pop(context);
                                                                                                },
                                                                                                child: const Text('확인'))
                                                                                          ],
                                                                                        );
                                                                                      });

                                                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage()), (route) => false);
                                                                                });
                                                                                // TODO: 로그인 실패시 실패 사유 표시하는 dialog 표시
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            '로그인',
                                                                            style:
                                                                                GoogleFonts.eastSeaDokdo(color: Colors.white),
                                                                          )))),
                                                        ]),
                                                    const Divider(
                                                      color: Colors.white,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          '아직 계정이 없으신가요? 괜찮아요!  ',
                                                          style: GoogleFonts
                                                              .eastSeaDokdo(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const SignUpPage()));
                                                            },
                                                            child: Text(
                                                              '계정 만들러 가기',
                                                              style: GoogleFonts
                                                                  .eastSeaDokdo(
                                                                      color: Colors
                                                                          .white),
                                                            ))
                                                      ],
                                                    )
                                                  ])))))
                            ]))))));
  }

  Widget inputForm({
    required BuildContext context,
    required String label,
    required String hint,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
    TextInputType? keyboardType,
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Expanded(
            flex: 4,
            child: Center(
                child: Text(
              label,
              style: GoogleFonts.eastSeaDokdo(
                  height: 0.8,
                  fontSize: MediaQuery.of(context).size.height * 0.1 > 32
                      ? 32
                      : MediaQuery.of(context).size.height * 0.1,
                  color: Colors.white),
            ))),
        const Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
            flex: 5,
            child: TextFormField(
              keyboardType: keyboardType,
              obscureText: obscureText,
              controller: controller,
              style: GoogleFonts.eastSeaDokdo(
                  height: 0.8,
                  fontSize: MediaQuery.of(context).size.height * 0.1 > 32
                      ? 32
                      : MediaQuery.of(context).size.height * 0.1,
                  color: Colors.white),
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.eastSeaDokdo(
                    color: Colors.white,
                    height: 0.8,
                    fontSize: MediaQuery.of(context).size.height * 0.05 > 16
                        ? 16
                        : MediaQuery.of(context).size.height * 0.05,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              onSaved: onSaved,
              validator: validator,
            ))
      ]),
    );
  }
}
