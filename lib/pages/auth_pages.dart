import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:gansabogo/main.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//position enum 생성, 'paster'와 'gansa'로 구분
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
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Center(
                                                            child: Text(
                                                          '아이디',
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
                                                        flex: 1,
                                                        child:
                                                            SizedBox.shrink()),
                                                    Expanded(
                                                        flex: 5,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
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
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  '아이디를 입력해주세요',
                                                              hintStyle: GoogleFonts
                                                                  .eastSeaDokdo(
                                                                      color: Colors
                                                                          .white),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                          onSaved: (value) {
                                                            _email = value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '아이디를 입력해주세요';
                                                            }
                                                            return null;
                                                          },
                                                        ))
                                                  ]),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Center(
                                                            child: Text(
                                                          '비밀번호',
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
                                                        flex: 1,
                                                        child:
                                                            SizedBox.shrink()),
                                                    Expanded(
                                                        flex: 5,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          obscureText: true,
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
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  '비밀번호를 입력해주세요',
                                                              hintStyle: GoogleFonts
                                                                  .eastSeaDokdo(
                                                                      color: Colors
                                                                          .white),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                          onChanged: (value) {
                                                            _password = value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '비밀번호를 입력해주세요';
                                                            }
                                                            return null;
                                                          },
                                                        ))
                                                  ]),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Center(
                                                            child: Text(
                                                          '비밀번호 확인',
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
                                                        flex: 1,
                                                        child:
                                                            SizedBox.shrink()),
                                                    Expanded(
                                                        flex: 5,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          obscureText: true,
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
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  '동일한 비밀번호를 입력해주세요',
                                                              hintStyle: GoogleFonts
                                                                  .eastSeaDokdo(
                                                                      color: Colors
                                                                          .white),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                          onSaved: (value) {
                                                            _password = value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '비밀번호를 입력해주세요';
                                                            }
                                                            if (value !=
                                                                _password) {
                                                              return '비밀번호가 일치하지 않습니다';
                                                            }
                                                            return null;
                                                          },
                                                        ))
                                                  ]),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Row(children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Center(
                                                            child: Text(
                                                          '이름',
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
                                                        flex: 1,
                                                        child:
                                                            SizedBox.shrink()),
                                                    Expanded(
                                                        flex: 5,
                                                        child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
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
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  '이름을 입력해주세요',
                                                              hintStyle: GoogleFonts
                                                                  .eastSeaDokdo(
                                                                      color: Colors
                                                                          .white),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                          onSaved: (value) {
                                                            _name = value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '이름을 입력해주세요';
                                                            }
                                                            return null;
                                                          },
                                                        ))
                                                  ]),
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
                                                                          if (formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            formKey.currentState!.save();

                                                                            _email =
                                                                                '${_email!}@gansa.com';
                                                                            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email!, password: _password!).then((value) async {
                                                                              //TODO : 트랜잭션으로 구현
                                                                              await FirebaseFirestore.instance.collection('user').doc(value.user!.uid).set({
                                                                                'info': {
                                                                                  'name': _name,
                                                                                  'position': _position == Position.paster ? 'paster' : 'gansa',
                                                                                  'email': _email,
                                                                                },
                                                                              }).then((_) {
                                                                                Provider.of<CurrentUserModel>(context, listen: false).setUser(value.user);
                                                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage()), (route) => false);
                                                                              });
                                                                            });
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
}

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // TODO: 로그인 페이지 구현
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFFCEA176),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    color: const Color(0xFF2F6044),
                    child: const Text('hello')))));
  }
}
