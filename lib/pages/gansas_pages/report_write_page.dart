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
  Map<String, Map<String, Map<String, bool>>> memberAttendanceData = {};
  Map<String, dynamic> situationData = {};

  Map<String, String> recentReportData = {};
  Map<String, Map<String, bool>> recentAttendanceData = {};
  Map<String, Map<String, dynamic>> reportTextInfo = {};

  String teamSituation = '';
  String gansaSituation = '';

  String? campId;
  String? teamName;

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
      campId = Provider.of<CurrentUserModel>(context, listen: false)
          .userData!['managedTeam']
          .keys
          .toList()[0];
      teamName = Provider.of<CurrentUserModel>(context, listen: false)
          .userData!['managedTeam'][campId];

      await FirebaseFirestore.instance
          .collection('camp')
          .doc(campId)
          .get()
          .then((value) {
        teamMemberData =
            value.data()!['team'][teamName].cast<Map<String, dynamic>>() ?? [];

        teamMemberData!.sort((a, b) => a['name'].compareTo(b['name']));
      });

      weekNumString = getWeekString();

      reportTextInfo['teamSituation'] = {
        'controller':
            TextEditingController(text: situationData['teamSituation']),
        'isChanged': false
      };

      reportTextInfo['gansaSituation'] = {
        'controller':
            TextEditingController(text: situationData['gansaSituation']),
        'isChanged': false
      };

      for (var element in teamMemberData!) {
        recentReportData[element['name']] = element['recentReport'] ?? '';

        var attendanceMap = (element['attendance'] as Map<String, dynamic>?)
                ?.map((key, value) => MapEntry(key,
                    (value as Map<String, dynamic>).cast<String, bool>())) ??
            {};

        memberAttendanceData[element['name']] = attendanceMap;

        reportTextInfo[element['name']] = {};

        reportTextInfo[element['name']]!['controller'] =
            TextEditingController(text: recentReportData[element['name']]);
        reportTextInfo[element['name']]!['isChanged'] = false;

        if (memberAttendanceData[element['name']]!.isNotEmpty) {
          recentAttendanceData[element['name']] =
              memberAttendanceData[element['name']]![weekNumString] ??
                  {'대예배': false, '진예배': false, '팀모임': false};
        } else {
          memberAttendanceData[element['name']]![weekNumString] = {
            '대예배': false,
            '진예배': false,
            '팀모임': false
          };
          recentAttendanceData[element['name']] = {
            '대예배': false,
            '진예배': false,
            '팀모임': false
          };
        }
      }

      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    for (var element in reportTextInfo.values) {
      element['controller'].dispose();
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
      DateTime temp = DateTime(now.year, now.month, i);

      if (temp.weekday == 3) {
        weekNum++;
      }
    }

    return '$year년 $month월 $weekNum주차';
  }

  Future<void> reportUpdate(
      {required String memberName, required String weekNumString}) async {
    for (var element in teamMemberData!) {
      if (element['name'] == memberName) {
        element['attendance'] = memberAttendanceData[memberName];
        element['recentReport'] = reportTextInfo[memberName]!['controller']!
            .text
            .replaceAll('\n', ' ');
      }
    }

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction
          .update(FirebaseFirestore.instance.collection('camp').doc(campId), {
        'team.$teamName': teamMemberData,
      });

      transaction.set(
          FirebaseFirestore.instance
              .collection('camp')
              .doc(campId)
              .collection('report')
              .doc(memberName),
          {
            weekNumString: {
              'report': reportTextInfo[memberName]!['controller']!.text,
              'attendance': memberAttendanceData[memberName]![weekNumString]
            }
          },
          SetOptions(merge: true));
    });
  }

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
                    IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '팀 보고사항',
                              style: GoogleFonts.eastSeaDokdo(
                                  height: 0.9,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.2 >
                                              64
                                          ? 64
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                  color: Colors.white),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                // TODO: 팀 보고사항 및 기도요청 수정 기능구현
                              },
                              child: Text(
                                '저장',
                                style: GoogleFonts.eastSeaDokdo(
                                    fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2 >
                                            36
                                        ? 36
                                        : MediaQuery.of(context).size.height *
                                            0.2,
                                    color: Colors.red),
                              ),
                            ),
                          ]),
                    ),
                    TextFormField(
                      controller:
                          reportTextInfo['teamSituation']!['controller']!,
                      maxLines: 3,
                      maxLength: 1000,
                      style: GoogleFonts.eastSeaDokdo(
                        height: 0.8,
                        fontSize: MediaQuery.of(context).size.height * 0.2 > 24
                            ? 24
                            : MediaQuery.of(context).size.height * 0.2,
                        color: reportTextInfo['teamSituation']!['isChanged']
                            ? Colors.white
                            : Colors.blue,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          counterStyle: TextStyle(color: Colors.white)),
                      onChanged: (value) {
                        if (!reportTextInfo['teamSituation']!['isChanged']) {
                          setState(() {
                            reportTextInfo['teamSituation']!['isChanged'] =
                                true;
                          });
                        }
                      },
                    ),
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
            ),
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
                    IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '간사 보고사항',
                              style: GoogleFonts.eastSeaDokdo(
                                  height: 0.9,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.2 >
                                              64
                                          ? 64
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                  color: Colors.white),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero)),
                              onPressed: () {
                                // TODO: 간사 보고사항 및 기도요청 수정 기능구현
                              },
                              child: Text(
                                '저장',
                                style: GoogleFonts.eastSeaDokdo(
                                    fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2 >
                                            36
                                        ? 36
                                        : MediaQuery.of(context).size.height *
                                            0.2,
                                    color: Colors.red),
                              ),
                            ),
                          ]),
                    ),
                    TextFormField(
                      controller:
                          reportTextInfo['gansaSituation']!['controller']!,
                      maxLines: 3,
                      maxLength: 1000,
                      style: GoogleFonts.eastSeaDokdo(
                        height: 0.8,
                        fontSize: MediaQuery.of(context).size.height * 0.2 > 24
                            ? 24
                            : MediaQuery.of(context).size.height * 0.2,
                        color: reportTextInfo['gansaSituation']!['isChanged']
                            ? Colors.white
                            : Colors.blue,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          counterStyle: TextStyle(color: Colors.white)),
                      onChanged: (value) {
                        if (!reportTextInfo['gansaSituation']!['isChanged']) {
                          setState(() {
                            reportTextInfo['gansaSituation']!['isChanged'] =
                                true;
                          });
                        }
                      },
                    ),
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
            ),
            for (var teamMember in teamMemberData!)
              if (teamMember['isGansa'] == false)
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
                        IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  teamMember['name'],
                                  style: GoogleFonts.eastSeaDokdo(
                                      height: 0.9,
                                      fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2 >
                                              64
                                          ? 64
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                      color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero)),
                                      onPressed: () {},
                                      child: Text(
                                        '정보수정',
                                        style: GoogleFonts.eastSeaDokdo(
                                            fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.2 >
                                                    36
                                                ? 36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                            color: Colors.amber[800]),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2 >
                                              16
                                          ? 16
                                          : MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero)),
                                      onPressed: () {
                                        memberAttendanceData[teamMember[
                                                'name']]![weekNumString] =
                                            recentAttendanceData[
                                                teamMember['name']]!;

                                        reportUpdate(
                                            memberName: teamMember['name'],
                                            weekNumString: weekNumString);
                                      },
                                      child: Text(
                                        '저장',
                                        style: GoogleFonts.eastSeaDokdo(
                                            fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.2 >
                                                    36
                                                ? 36
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '출석',
                                style: GoogleFonts.eastSeaDokdo(
                                    fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2 >
                                            36
                                        ? 36
                                        : MediaQuery.of(context).size.height *
                                            0.2,
                                    color: Colors.amber[800]),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(children: [
                                    FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          '대예배',
                                          style: GoogleFonts.eastSeaDokdo(
                                              fontSize: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2 >
                                                      24
                                                  ? 24
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                              color: Colors.blue),
                                        )),
                                    Checkbox(
                                        value: recentAttendanceData[
                                            teamMember['name']]!['대예배']!,
                                        onChanged: (value) {
                                          setState(() {
                                            recentAttendanceData[teamMember[
                                                'name']]!['대예배'] = value!;
                                          });
                                        })
                                  ]),
                                  Row(children: [
                                    FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          '진예배',
                                          style: GoogleFonts.eastSeaDokdo(
                                              fontSize: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2 >
                                                      24
                                                  ? 24
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                              color: Colors.blue),
                                        )),
                                    Checkbox(
                                        value: recentAttendanceData[
                                            teamMember['name']]!['진예배']!,
                                        onChanged: (value) {
                                          setState(() {
                                            recentAttendanceData[teamMember[
                                                'name']]!['진예배'] = value!;
                                          });
                                        })
                                  ]),
                                  Row(children: [
                                    FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          '팀모임',
                                          style: GoogleFonts.eastSeaDokdo(
                                              fontSize: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2 >
                                                      24
                                                  ? 24
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                              color: Colors.blue),
                                        )),
                                    Checkbox(
                                        value: recentAttendanceData[
                                            teamMember['name']]!['팀모임']!,
                                        onChanged: (value) {
                                          setState(() {
                                            recentAttendanceData[teamMember[
                                                'name']]!['팀모임'] = value!;
                                          });
                                        })
                                  ]),
                                ],
                              )
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: reportTextInfo[teamMember['name']]![
                              'controller']!,
                          maxLines: 3,
                          maxLength: 1000,
                          style: GoogleFonts.eastSeaDokdo(
                            height: 0.8,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.2 > 24
                                    ? 24
                                    : MediaQuery.of(context).size.height * 0.2,
                            color:
                                reportTextInfo[teamMember['name']]!['isChanged']
                                    ? Colors.white
                                    : Colors.blue,
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              counterStyle: TextStyle(color: Colors.white)),
                          onChanged: (value) {
                            if (!reportTextInfo[teamMember['name']]![
                                'isChanged']) {
                              setState(() {
                                reportTextInfo[teamMember['name']]![
                                    'isChanged'] = true;
                              });
                            }
                          },
                        ),
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
                ),
          ],
        ));
  }
}
