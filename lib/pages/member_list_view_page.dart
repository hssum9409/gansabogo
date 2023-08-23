import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberListViewPage extends StatefulWidget {
  const MemberListViewPage({super.key});

  @override
  State<MemberListViewPage> createState() => _MemberListViewPageState();
}

class _MemberListViewPageState extends State<MemberListViewPage> {
  String? userPosition;

  bool isLoaded = false;
  Map<String, bool> isExpanded = {};

  Map<String, dynamic>? campMemberData;
  List<Map<String, dynamic>>? teamMemberData;

  String searchKeyword = '';
  String campID = '';

  @override
  void initState() {
    super.initState();

    userPosition =
        Provider.of<CurrentUserModel>(context, listen: false).userPosition;

    fetchData();
  }

  Future<void> fetchData() async {
    Provider.of<CurrentUserModel>(context, listen: false)
        .setUser(FirebaseAuth.instance.currentUser!);

    if (userPosition == 'paster') {
      campID = Provider.of<CurrentUserModel>(context, listen: false)
          .userData!['managedCamp']
          .keys
          .toList()[0];

      await FirebaseFirestore.instance
          .collection('camp')
          .doc(campID)
          .get()
          .then((value) {
        campMemberData = value.data()?['team'].cast<String, dynamic>();
      });

      campMemberData!.forEach((key, value) {
        isExpanded[key] = false;
      });

      campMemberData!.forEach((key, value) {
        value.sort(
            (a, b) => (a['name'] as String).compareTo(b['name'] as String));
      });
    } else {
      campID = Provider.of<CurrentUserModel>(context, listen: false)
          .userData!['managedTeam']
          .keys
          .toList()[0];

      String teamName = Provider.of<CurrentUserModel>(context, listen: false)
          .userData!['managedTeam'][campID];

      await FirebaseFirestore.instance
          .collection('camp')
          .doc(campID)
          .get()
          .then((value) {
        teamMemberData =
            value.data()?['team'][teamName].cast<Map<String, dynamic>>();

        teamMemberData!.sort((a, b) => a['name'].compareTo(b['name']));
      });
    }

    setState(() {
      isLoaded = true;
    });
  }

  Future<void> goToJungboGroup({
    required String campID,
    required String teamName,
    required String memberName,
  }) async {
    // TODO: 팀내 동명이인 처리방식 구상 필요
    setState(() {
      (campMemberData!['중보자'] as List<dynamic>).add(campMemberData![teamName]
          .firstWhere((element) => element['name'] == memberName));

      campMemberData![teamName]
          .removeWhere((element) => element['name'] == memberName);
    });

    await FirebaseFirestore.instance
        .collection('camp')
        .doc(campID)
        .update({'team': campMemberData});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 레이아웃 정리 필요
    return Scaffold(
        body: Container(
            color: const Color(0xFFCEA176),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    color: const Color(0xFF2F6044),
                    child: isLoaded
                        ? Column(
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05 >
                                                  16
                                              ? 16
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05),
                                      child: Center(
                                          child: Text(
                                        userPosition == 'paster'
                                            ? '진원 목록'
                                            : '팀원 목록',
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
                                      )),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1 >
                                              16
                                          ? 16
                                          : MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              userPosition == 'paster'
                                                  ? '진원 검색'
                                                  : '팀원 검색',
                                              style: GoogleFonts.eastSeaDokdo(
                                                  height: 0.8,
                                                  fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2 >
                                                          36
                                                      ? 36
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.eastSeaDokdo(
                                                  height: 0.8,
                                                  fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2 >
                                                          24
                                                      ? 24
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2,
                                                  color: Colors.white,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    searchKeyword = value;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ))
                                  ]),
                              Expanded(
                                  child: CustomScrollView(
                                slivers: <Widget>[
                                  SliverList(
                                      delegate: SliverChildListDelegate([
                                    userPosition == 'paster'
                                        ? pasterViewWidget()
                                        : gansaViewWidget(),
                                  ]))
                                ],
                              )),
                              const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Divider(
                                      color: Colors.white, thickness: 4)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2 >
                                                  48
                                              ? 48
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          userPosition == 'paster'
                                              ? '진원 추가'
                                              : '팀원 추가',
                                          style: GoogleFonts.eastSeaDokdo(
                                              height: 0.8,
                                              fontSize: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2 >
                                                      48
                                                  ? 48
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                              color: Colors.white),
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator())))));
  }

  Widget pasterViewWidget() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var teamName in campMemberData!.keys.toList())
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded[teamName] = !isExpanded[teamName]!;
                          });
                        },
                        child: Text(
                          teamName,
                          style: GoogleFonts.eastSeaDokdo(
                              height: 0.8,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.2 > 48
                                      ? 48
                                      : MediaQuery.of(context).size.height *
                                          0.2,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var teamMember
                                    in campMemberData![teamName])
                                  if (searchKeyword == '' ||
                                      teamMember['name']
                                          .contains(searchKeyword))
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: isExpanded[teamName]!
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 4, bottom: 4),
                                                  child: Divider(
                                                    color: Colors.white,
                                                    thickness: 1,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              teamMember[
                                                                  'name'],
                                                              style: GoogleFonts.eastSeaDokdo(
                                                                  height: 0.8,
                                                                  fontSize: MediaQuery.of(context).size.height *
                                                                              0.2 >
                                                                          36
                                                                      ? 36
                                                                      : MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.2,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 7,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // TODO : 버튼 기능구현
                                                                Expanded(
                                                                    flex: 1,
                                                                    child: FittedBox(
                                                                        fit: BoxFit.fitWidth,
                                                                        child: TextButton(
                                                                            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                                                            onPressed: () {},
                                                                            child: Text(
                                                                              '정보수정',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, color: Colors.blue[600]),
                                                                            )))),
                                                                Expanded(
                                                                    flex: 1,
                                                                    child: FittedBox(
                                                                        fit: BoxFit.fitWidth,
                                                                        child: TextButton(
                                                                            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                                                            onPressed: () {
                                                                              goToJungboGroup(campID: campID, teamName: teamName, memberName: teamMember['name']);
                                                                            },
                                                                            child: Text(
                                                                              '중보그룹',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, color: Colors.amber[800]),
                                                                            )))),
                                                                Expanded(
                                                                    flex: 1,
                                                                    child: FittedBox(
                                                                        fit: BoxFit.fitWidth,
                                                                        child: TextButton(
                                                                            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                                                            onPressed: () {},
                                                                            child: Text(
                                                                              '　삭제　',
                                                                              style: GoogleFonts.eastSeaDokdo(
                                                                                height: 0.8,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ))))
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 16,
                                                                left: 8,
                                                                right: 8),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: Text(
                                                                              '성별',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.white))),
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: Text(
                                                                              teamMember['gender'] != null && teamMember['gender'] != ''
                                                                                  ? teamMember['gender'] == '남'
                                                                                      ? '형제'
                                                                                      : '자매'
                                                                                  : '미입력',
                                                                              style: GoogleFonts.eastSeaDokdo(
                                                                                  height: 0.8,
                                                                                  fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2,
                                                                                  color: teamMember['gender'] != null
                                                                                      ? teamMember['gender'] == '남'
                                                                                          ? Colors.blue[600]
                                                                                          : Colors.red
                                                                                      : Colors.grey[600]))),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                    flex: 1,
                                                                    child: SizedBox
                                                                        .shrink()),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: Text(
                                                                              '기수',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.white))),
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: Text(
                                                                              teamMember['generation'] != null && teamMember['generation'] != '' ? '${teamMember['generation']} 기' : '미입력',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: teamMember['generation'] != null ? Colors.white : Colors.grey[600]))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: Text(
                                                                              '생일',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.white))),
                                                                      Expanded(
                                                                        flex: 5,
                                                                        child: teamMember['birthDate'] !=
                                                                                null
                                                                            ? FittedBox(
                                                                                fit: BoxFit.fitWidth,
                                                                                child: Text((teamMember['birthDate'] as Timestamp).toDate().toString().substring(0, 10), style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.white)))
                                                                            : Text('미입력', style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.grey[600])),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Expanded(
                                                                    flex: 1,
                                                                    child: SizedBox
                                                                        .shrink()),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: Text(
                                                                              '연락처',
                                                                              style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.white))),
                                                                      Expanded(
                                                                          flex:
                                                                              5,
                                                                          child: teamMember['phoneNumber'] != null && teamMember['phoneNumber'] != ''
                                                                              ? FittedBox(fit: BoxFit.fitWidth, child: Text(teamMember['phoneNumber'], style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.white)))
                                                                              : Text('미입력', style: GoogleFonts.eastSeaDokdo(height: 0.8, fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2, color: Colors.grey[600]))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 4, bottom: 4),
                                                  child: Divider(
                                                    color: Colors.white,
                                                    thickness: 1,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    )
                              ])),
                      const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Divider(color: Colors.white, thickness: 4))
                    ])
            ]));
  }

  Widget gansaViewWidget() {
    // TODO: 팀원 추가 기능구현
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var teamMember in teamMemberData!)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  teamMember['name'],
                                  style: GoogleFonts.eastSeaDokdo(
                                      height: 0.8,
                                      fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2 >
                                              48
                                          ? 48
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            // TODO : 버튼 기능구현
                            Expanded(
                                flex: 7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero)),
                                                onPressed: () {},
                                                child: Text(
                                                  '정보수정',
                                                  style:
                                                      GoogleFonts.eastSeaDokdo(
                                                          height: 0.8,
                                                          color: Colors
                                                              .amber[800]),
                                                )))),
                                    Expanded(
                                        flex: 1,
                                        child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets
                                                                .zero)),
                                                onPressed: () {},
                                                child: Text(
                                                  '출석관리',
                                                  style:
                                                      GoogleFonts.eastSeaDokdo(
                                                    height: 0.8,
                                                    color: Colors.red,
                                                  ),
                                                ))))
                                  ],
                                )),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 8, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Text('성별',
                                                  style: GoogleFonts.eastSeaDokdo(
                                                      height: 0.8,
                                                      fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2 >
                                                              32
                                                          ? 32
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      color: Colors.white))),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                  teamMember['gender'] !=
                                                              null &&
                                                          teamMember[
                                                                  'gender'] !=
                                                              ''
                                                      ? teamMember['gender'] ==
                                                              '남'
                                                          ? '형제'
                                                          : '자매'
                                                      : '미입력',
                                                  style:
                                                      GoogleFonts.eastSeaDokdo(
                                                          height: 0.8,
                                                          fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.2 >
                                                                  32
                                                              ? 32
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2,
                                                          color: teamMember[
                                                                      'gender'] !=
                                                                  null
                                                              ? teamMember['gender'] ==
                                                                      '남'
                                                                  ? Colors
                                                                      .blue[600]
                                                                  : Colors.red
                                                              : Colors
                                                                  .grey[600]))),
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                        flex: 1, child: SizedBox.shrink()),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Text('기수',
                                                  style: GoogleFonts.eastSeaDokdo(
                                                      height: 0.8,
                                                      fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2 >
                                                              32
                                                          ? 32
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      color: Colors.white))),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                  teamMember['generation'] != null &&
                                                          teamMember['generation'] !=
                                                              ''
                                                      ? '${teamMember['generation']} 기'
                                                      : '미입력',
                                                  style: GoogleFonts.eastSeaDokdo(
                                                      height: 0.8,
                                                      fontSize: MediaQuery.of(context)
                                                                      .size
                                                                      .height *
                                                                  0.2 >
                                                              32
                                                          ? 32
                                                          : MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      color: teamMember['generation'] !=
                                                              null
                                                          ? Colors.white
                                                          : Colors.grey[600]))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Text('생일',
                                                  style: GoogleFonts.eastSeaDokdo(
                                                      height: 0.8,
                                                      fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2 >
                                                              32
                                                          ? 32
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      color: Colors.white))),
                                          Expanded(
                                            flex: 5,
                                            child: teamMember['birthDate'] != null
                                                ? FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                        (teamMember['birthDate'] as Timestamp)
                                                            .toDate()
                                                            .toString()
                                                            .substring(0, 10),
                                                        style: GoogleFonts.eastSeaDokdo(
                                                            height: 0.8,
                                                            fontSize:
                                                                MediaQuery.of(context).size.height * 0.2 > 32
                                                                    ? 32
                                                                    : MediaQuery.of(context).size.height *
                                                                        0.2,
                                                            color:
                                                                Colors.white)))
                                                : Text('미입력',
                                                    style: GoogleFonts.eastSeaDokdo(
                                                        height: 0.8,
                                                        fontSize: MediaQuery.of(context).size.height * 0.2 > 32 ? 32 : MediaQuery.of(context).size.height * 0.2,
                                                        color: Colors.grey[600])),
                                          )
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                        flex: 1, child: SizedBox.shrink()),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Text('연락처',
                                                  style: GoogleFonts.eastSeaDokdo(
                                                      height: 0.8,
                                                      fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2 >
                                                              32
                                                          ? 32
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      color: Colors.white))),
                                          Expanded(
                                              flex: 5,
                                              child: teamMember['phoneNumber'] != null &&
                                                      teamMember['phoneNumber'] !=
                                                          ''
                                                  ? FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: Text(teamMember['phoneNumber'],
                                                          style: GoogleFonts.eastSeaDokdo(
                                                              height: 0.8,
                                                              fontSize: MediaQuery.of(context).size.height * 0.2 > 32
                                                                  ? 32
                                                                  : MediaQuery.of(context).size.height *
                                                                      0.2,
                                                              color: Colors
                                                                  .white)))
                                                  : Text('미입력',
                                                      style: GoogleFonts.eastSeaDokdo(
                                                          height: 0.8,
                                                          fontSize: MediaQuery.of(context).size.height * 0.2 > 32
                                                              ? 32
                                                              : MediaQuery.of(context).size.height * 0.2,
                                                          color: Colors.grey[600]))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                  ],
                )
            ]));
  }
}
