import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationListViewPage extends StatefulWidget {
  @override
  _OrganizationListViewPageState createState() =>
      _OrganizationListViewPageState();
}

class _OrganizationListViewPageState extends State<OrganizationListViewPage> {
  String? userPosition;
  Map<String, dynamic>? userData;

  int? itemCount;

  @override
  void initState() {
    super.initState();

    userPosition =
        Provider.of<CurrentUserModel>(context, listen: false).userPosition!;
    userData = Provider.of<CurrentUserModel>(context, listen: false).userData!;

    itemCount = userPosition == 'paster'
        ? userData!['managedCamp']?.length ?? 0
        : userData!['managedTeam']?.length ?? 0;
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
                                    '목록 확인',
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
                                  userPosition == 'paster'
                                      ? '어떤 진을 확인하시나요?'
                                      : '어떤 팀을 확인하시나요?',
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
                                ),
                                if (itemCount == 0)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                        0.1 >
                                                    32
                                                ? 32
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                      ),
                                      Text(
                                        userPosition == 'paster'
                                            ? '관리중인 진이 없습니다 (;ㅅ;)'
                                            : '관리중인 팀이 없습니다 (;ㅅ;)\n목사님께 진에 초대해달라고 요청해보세요.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.eastSeaDokdo(
                                            height: 0.8,
                                            fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                        0.1 >
                                                    32
                                                ? 32
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                      ),
                                      if (userPosition == 'paster')
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              '새로운 진 만들러 가기',
                                              style: GoogleFonts.eastSeaDokdo(
                                                  height: 0.8,
                                                  fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1 >
                                                          32
                                                      ? 32
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.1,
                                                  color: Colors.white),
                                            )),
                                    ],
                                  )
                                else
                                  ListView.builder(
                                    itemCount: itemCount,
                                    itemBuilder: (context, index) {
                                      return Padding(
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
                                                        0.1 >
                                                    32
                                                ? 32
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, '/organization',
                                                  arguments: {
                                                    'index': index,
                                                    'userPosition':
                                                        userPosition,
                                                    'userData': userData
                                                  });
                                            },
                                            child: Text(
                                              userPosition == 'paster'
                                                  ? userData!['managedCamp']
                                                      [index]['name']
                                                  : userData!['managedTeam']
                                                      [index]['name'],
                                              style: GoogleFonts.eastSeaDokdo(
                                                  height: 0.8,
                                                  fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1 >
                                                          32
                                                      ? 32
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.1,
                                                  color: Colors.white),
                                            )),
                                      );
                                    },
                                  )
                              ],
                            ),
                          ]))))),
    );
  }
}
