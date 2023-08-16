import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CampGeneratePage extends StatefulWidget {
  const CampGeneratePage({super.key});

  @override
  _CampGeneratePageState createState() => _CampGeneratePageState();
}

//state of the stateful widget named 'CampGeneratePage'
class _CampGeneratePageState extends State<CampGeneratePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    String? campName;
    String? campType;
    String? campEtcType;
    String? campProfileMessage;

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
                                      '새로운 진 만들기',
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
                                    '진을 만들고 간사님들을 초대해보세요!',
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
                                                        label: '진 이름',
                                                        hint: '진 이름을 입력해주세요',
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '진 이름을 입력해주세요';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          campName = value;
                                                        }),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0),
                                                        child: Row(children: [
                                                          Expanded(
                                                              flex: 4,
                                                              child: Center(
                                                                  child: Text(
                                                                '소속',
                                                                style: GoogleFonts.eastSeaDokdo(
                                                                    height: 0.8,
                                                                    fontSize: MediaQuery.of(context).size.height *
                                                                                0.1 >
                                                                            32
                                                                        ? 32
                                                                        : MediaQuery.of(context).size.height *
                                                                            0.1,
                                                                    color: Colors
                                                                        .white),
                                                              ))),
                                                          const Expanded(
                                                              flex: 1,
                                                              child: SizedBox
                                                                  .shrink()),
                                                          Expanded(
                                                            flex: 5,
                                                            child:
                                                                DropdownButtonFormField(
                                                              dropdownColor:
                                                                  const Color(
                                                                      0xFF2F6044),
                                                              iconEnabledColor:
                                                                  Colors.white,
                                                              hint: Text(
                                                                '소속을 선택해주세요',
                                                                style: GoogleFonts.eastSeaDokdo(
                                                                    height: 0.8,
                                                                    fontSize: MediaQuery.of(context).size.height *
                                                                                0.05 >
                                                                            16
                                                                        ? 16
                                                                        : MediaQuery.of(context).size.height *
                                                                            0.05,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              value: Provider.of<
                                                                          CampGenerateModel>(
                                                                      context,
                                                                      listen:
                                                                          true)
                                                                  .campType,
                                                              items: [
                                                                '청년1부',
                                                                '청년2부',
                                                                '청년3부',
                                                                '청장년진',
                                                                '장년진',
                                                                '장년심방',
                                                                '교회학교',
                                                                '기타'
                                                              ].map((e) {
                                                                return DropdownMenuItem(
                                                                    value: e,
                                                                    child: Text(
                                                                      e,
                                                                      style: GoogleFonts.eastSeaDokdo(
                                                                          height:
                                                                              0.8,
                                                                          fontSize: MediaQuery.of(context).size.height * 0.05 > 32
                                                                              ? 32
                                                                              : MediaQuery.of(context).size.height *
                                                                                  0.05,
                                                                          color:
                                                                              Colors.white),
                                                                    ));
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                Provider.of<CampGenerateModel>(
                                                                        listen:
                                                                            false,
                                                                        context)
                                                                    .setCampType(
                                                                        value!);
                                                              },
                                                            ),
                                                          )
                                                        ])),
                                                    if (!Provider.of<
                                                                CampGenerateModel>(
                                                            context,
                                                            listen: true)
                                                        .campEtcTypeFormFolded)
                                                      // TODO: 드롭다운 선택하면 모든 폼이 다시 렌더링되는 문제 해결하기
                                                      // TODO: campEtcType 값이 정상저장되지 않는 문제 해결하기
                                                      Row(
                                                        children: [
                                                          const Expanded(
                                                              flex: 5,
                                                              child: SizedBox
                                                                  .shrink()),
                                                          Expanded(
                                                              flex: 5,
                                                              child:
                                                                  TextFormField(
                                                                style: GoogleFonts.eastSeaDokdo(
                                                                    height: 0.8,
                                                                    fontSize: MediaQuery.of(context).size.height *
                                                                                0.1 >
                                                                            32
                                                                        ? 32
                                                                        : MediaQuery.of(context).size.height *
                                                                            0.1,
                                                                    color: Colors
                                                                        .white),
                                                                decoration: InputDecoration(
                                                                    hintText:
                                                                        '소속을 입력해주세요',
                                                                    hintStyle: GoogleFonts.eastSeaDokdo(
                                                                        color: Colors
                                                                            .white,
                                                                        height:
                                                                            0.8,
                                                                        fontSize: MediaQuery.of(context).size.height * 0.05 >
                                                                                16
                                                                            ? 16
                                                                            : MediaQuery.of(context).size.height *
                                                                                0.05),
                                                                    enabledBorder:
                                                                        const UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.white))),
                                                                onSaved:
                                                                    (value) {
                                                                  campEtcType =
                                                                      value;
                                                                },
                                                              ))
                                                        ],
                                                      ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                                flex: 4,
                                                                child: Center(
                                                                    child: Text(
                                                                  '진 소개문구',
                                                                  style: GoogleFonts.eastSeaDokdo(
                                                                      height:
                                                                          0.8,
                                                                      fontSize: MediaQuery.of(context).size.height * 0.1 >
                                                                              32
                                                                          ? 32
                                                                          : MediaQuery.of(context).size.height *
                                                                              0.1,
                                                                      color: Colors
                                                                          .white),
                                                                ))),
                                                            const Expanded(
                                                                flex: 1,
                                                                child: SizedBox
                                                                    .shrink()),
                                                            Expanded(
                                                                flex: 5,
                                                                child:
                                                                    TextFormField(
                                                                  maxLines: 5,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .multiline,
                                                                  style: GoogleFonts.eastSeaDokdo(
                                                                      height:
                                                                          0.8,
                                                                      fontSize: MediaQuery.of(context).size.height * 0.1 >
                                                                              32
                                                                          ? 32
                                                                          : MediaQuery.of(context).size.height *
                                                                              0.1,
                                                                      color: Colors
                                                                          .white),
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText:
                                                                              '진 소개문구를 적어주세요',
                                                                          hintStyle: GoogleFonts
                                                                              .eastSeaDokdo(
                                                                            color:
                                                                                Colors.white,
                                                                            height:
                                                                                0.8,
                                                                            fontSize: MediaQuery.of(context).size.height * 0.05 > 16
                                                                                ? 16
                                                                                : MediaQuery.of(context).size.height * 0.05,
                                                                          ),
                                                                          enabledBorder:
                                                                              const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                                                  onSaved:
                                                                      (value) {
                                                                    campProfileMessage =
                                                                        value;
                                                                  },
                                                                ))
                                                          ]),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 32),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                '취소',
                                                                style: GoogleFonts.eastSeaDokdo(
                                                                    height: 0.8,
                                                                    fontSize: MediaQuery.of(context).size.height *
                                                                                0.1 >
                                                                            32
                                                                        ? 32
                                                                        : MediaQuery.of(context).size.height *
                                                                            0.1,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  formKey
                                                                      .currentState!
                                                                      .save();

                                                                  try {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .runTransaction(
                                                                            (transaction) async {
                                                                      final campId =
                                                                          const Uuid()
                                                                              .v4();
                                                                      transaction.set(
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('camp')
                                                                              .doc(campId),
                                                                          {
                                                                            'info':
                                                                                {
                                                                              'campId': campId,
                                                                              'campName': campName,
                                                                              'campType': campType != '기타' ? campType : campEtcType ?? '',
                                                                              'campProfileMessage': campProfileMessage ?? '',
                                                                              'campAdmin': {
                                                                                'uid': Provider.of<CurrentUserModel>(context, listen: false).user!.uid,
                                                                                'name': Provider.of<CurrentUserModel>(context, listen: false).userName,
                                                                              }
                                                                            },
                                                                            'campMember':
                                                                                [],
                                                                            'team':
                                                                                {
                                                                              '중보자': [],
                                                                            }
                                                                          });

                                                                      transaction.set(
                                                                          FirebaseFirestore.instance.collection('user').doc(Provider.of<CurrentUserModel>(context, listen: false).user!.uid),
                                                                          {
                                                                            'managedCamp':
                                                                                {
                                                                              campId: {
                                                                                'campName': campName,
                                                                                'campProfileMessage': campProfileMessage ?? '',
                                                                              }
                                                                            }
                                                                          },
                                                                          SetOptions(merge: true));
                                                                    }).then((_) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                                title: Text(
                                                                                  '진 만들기 성공',
                                                                                  style: GoogleFonts.eastSeaDokdo(
                                                                                    height: 0.8,
                                                                                    fontSize: MediaQuery.of(context).size.height * 0.1 > 32 ? 32 : MediaQuery.of(context).size.height * 0.1,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                content: Text(
                                                                                  '진을 만들었습니다. 간사님들을 초대해보세요!',
                                                                                  style: GoogleFonts.eastSeaDokdo(
                                                                                    height: 0.8,
                                                                                    fontSize: MediaQuery.of(context).size.height * 0.05 > 16 ? 16 : MediaQuery.of(context).size.height * 0.05,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        '확인',
                                                                                        style: GoogleFonts.eastSeaDokdo(
                                                                                          height: 0.8,
                                                                                          fontSize: MediaQuery.of(context).size.height * 0.05 > 16 ? 16 : MediaQuery.of(context).size.height * 0.05,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ))
                                                                                ]);
                                                                          });
                                                                    });
                                                                  } on Exception catch (_) {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                              title: Text(
                                                                                '진 만들기 실패',
                                                                                style: GoogleFonts.eastSeaDokdo(
                                                                                  height: 0.8,
                                                                                  fontSize: MediaQuery.of(context).size.height * 0.1 > 32 ? 32 : MediaQuery.of(context).size.height * 0.1,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              content: Text(
                                                                                '진 만들기에 실패했습니다. 다시 시도해주세요.',
                                                                                style: GoogleFonts.eastSeaDokdo(
                                                                                  height: 0.8,
                                                                                  fontSize: MediaQuery.of(context).size.height * 0.05 > 16 ? 16 : MediaQuery.of(context).size.height * 0.05,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      '확인',
                                                                                      style: GoogleFonts.eastSeaDokdo(
                                                                                        height: 0.8,
                                                                                        fontSize: MediaQuery.of(context).size.height * 0.05 > 16 ? 16 : MediaQuery.of(context).size.height * 0.05,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ))
                                                                              ]);
                                                                        });
                                                                  }
                                                                }
                                                              },
                                                              child: Text(
                                                                '만들기',
                                                                style: GoogleFonts.eastSeaDokdo(
                                                                    height: 0.8,
                                                                    fontSize: MediaQuery.of(context).size.height *
                                                                                0.1 >
                                                                            32
                                                                        ? 32
                                                                        : MediaQuery.of(context).size.height *
                                                                            0.1,
                                                                    color: Colors
                                                                        .white),
                                                              )),
                                                        ],
                                                      ),
                                                    )
                                                  ])))))
                            ]))))));
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
