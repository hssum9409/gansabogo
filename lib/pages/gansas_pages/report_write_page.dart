import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportWritePage extends StatefulWidget {
  const ReportWritePage({super.key});

  @override
  State<ReportWritePage> createState() => _ReportWritePageState();
}

class _ReportWritePageState extends State<ReportWritePage> {
  bool isLoaded = false;

  String weekNumString = '';

  List<Map<String, dynamic>>? teamMemberData;
  Map<String, List<String>> memberAttendanceData = {};

  Map<String, String> recentReportData = {};
  Map<String, bool> recentAttendanceData = {};

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    Provider.of<CurrentUserModel>(context, listen: false)
        .setUser(FirebaseAuth.instance.currentUser!);

    if (Provider.of<CurrentUserModel>(context, listen: false)
            .userData!['managedTeam'] !=
        null) {
      String campID = Provider.of<CurrentUserModel>(context, listen: false)
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

      weekNumString = getWeekString();

      for (var element in teamMemberData!) {
        recentReportData[element['name']] = element['recentReport'] ?? '';
        memberAttendanceData[element['name']] = element['attendance'] ?? [];

        memberAttendanceData[element['name']]!.sort((a, b) => b.compareTo(a));

        if (memberAttendanceData[element['name']]!.length > 0) {
          recentAttendanceData[element['name']] =
              memberAttendanceData[element['name']]![0] == weekNumString;
        } else {
          recentAttendanceData[element['name']] = false;
        }
      }

      setState(() {
        isLoaded = true;
      });
    }
  }

  /// 수요일을 기준으로 몇 주차인지 반환하는 함수
  /// ex) 2023년 10월 1주차
  String getWeekString() {
    DateTime now = DateTime.now();

    String year = now.year.toString();
    String month = now.month.toString();

    int weekNum = 1;

    if (month.length == 1) {
      month = '0$month';
    }

    for (var i = 1; i < now.day; i++) {
      DateTime temp = DateTime.parse('$year-$month-$i');

      if (temp.weekday == 3) {
        weekNum++;
      }
    }

    return '$year년 $month월 $weekNum주차';
  }

  Future<void> attendanceUpdate(
    String campID,
    String memberName,
    String weekNumString,
    bool isAttend,
  ) async {}

  @override
  Widget build(BuildContext context) {
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
                                        '간사 보고서',
                                        style: GoogleFonts.eastSeaDokdo(
                                            height: 0.8,
                                            fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.2 >
                                                    96
                                                ? 96
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                            color: Colors.white),
                                      )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
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
                                        '$weekNumString 간사보고서',
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
                                      )),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1 >
                                              32
                                          ? 32
                                          : MediaQuery.of(context).size.height *
                                              0.1,
                                    )
                                  ]),
                              Expanded(
                                  child: CustomScrollView(
                                slivers: <Widget>[
                                  SliverList(
                                      delegate: SliverChildListDelegate([
                                    gansaViewWidget(),
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
                                  // TODO: 팀원 추가 기능구현
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
                                          '팀원 추가',
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

  Widget gansaViewWidget() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              // TODO: 간사 본인에 대한 내용 쓰는 공간, 기타 특이사항 쓰는 공간 맨 위에 배치
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
                            const Expanded(flex: 1, child: SizedBox.shrink()),
                            Expanded(
                                flex: 6,
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
                                        child: Row(children: [
                                          Expanded(
                                              flex: 1,
                                              child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Text(
                                                    '출석',
                                                    style: GoogleFonts
                                                        .eastSeaDokdo(
                                                            height: 0.8,
                                                            color: Colors
                                                                .blue[800]),
                                                  ))),
                                          Expanded(
                                              flex: 1,
                                              child: Checkbox(
                                                  value: recentAttendanceData[
                                                      teamMember['name']]!,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      recentAttendanceData[
                                                          teamMember[
                                                              'name']] = value!;
                                                    });

                                                    attendanceUpdate(
                                                        Provider.of<CurrentUserModel>(
                                                                context,
                                                                listen: false)
                                                            .userData![
                                                                'managedTeam']
                                                            .keys
                                                            .toList()[0],
                                                        teamMember['name'],
                                                        weekNumString,
                                                        value!);
                                                  }))
                                        ]))
                                  ],
                                )),
                          ],
                        ),
                        // TODO: 팀원 보고서 작성 공간
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
