import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:gansabogo/model/provider_model.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:gansabogo/pages/auth_pages.dart';
import 'package:gansabogo/pages/member_list_view_page.dart';

import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CurrentUserModel()),
          ChangeNotifierProvider(create: (_) => CampGenerateModel()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.yellow.shade100),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPosition;

  @override
  void initState() {
    super.initState();

    // TODO: 페이지 초기 로드속도 개선 필요, fetchData 방식으로 해결 시도해볼 것
    // TODO: Shared Preferences를 이용한 로그인 정보 저장을 통해 반응속도 개선 시도해볼 것

    if (user != null) {
      if (Provider.of<CurrentUserModel>(context, listen: false).user == null) {
        Future.delayed(Duration.zero, () async {
          await Provider.of<CurrentUserModel>(context, listen: false)
              .setUser(user);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 세로가 짧은 화면에서의 레이아웃 비율 조정
    return Scaffold(
        body: Container(
            color: const Color(0xFFCEA176),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    color: const Color(0xFF2F6044),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                                0.04 >
                                            33.2
                                        ? 33.2
                                        : MediaQuery.of(context).size.height *
                                            0.04,
                                    left: 30),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 600
                                            ? 600
                                            : null,
                                    height: MediaQuery.of(context).size.height *
                                                0.3 >
                                            250
                                        ? 250
                                        : MediaQuery.of(context).size.height *
                                            0.3,
                                    child: Image.asset(
                                        'asset/images/title_logo.png'))),
                            if (user != null)
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04 >
                                              33.2
                                          ? 33.2
                                          : MediaQuery.of(context).size.height *
                                              0.04),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${Provider.of<CurrentUserModel>(context).displayName}안녕하세요!',
                                        style: GoogleFonts.eastSeaDokdo(
                                            height: 0.8,
                                            fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04 >
                                                    32
                                                ? 32
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                            color: Colors.white),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                            setState(() {
                                              user = null;
                                              Provider.of<CurrentUserModel>(
                                                      context,
                                                      listen: false)
                                                  .setUser(null);
                                            });
                                          },
                                          child: Text(
                                            '로그아웃',
                                            style: GoogleFonts.eastSeaDokdo(
                                                height: 0.8,
                                                fontSize: MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03 >
                                                        24
                                                    ? 24
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04,
                                                color: Colors.red[400]),
                                          )),
                                    ],
                                  )),
                          ],
                        ),
                        Expanded(
                            child: user == null
                                ? unloginedUserMenu()
                                : Provider.of<CurrentUserModel>(context)
                                            .userPosition ==
                                        'gansa'
                                    ? loginedGansaMenu()
                                    : loginedPasterMenu()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.height *
                                                      0.0012 >
                                                  10
                                              ? 10
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.012),
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2 >
                                                  100
                                              ? 100
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                          child: Image.asset(
                                              'asset/images/decoration_stamp.png'))),
                                ]),
                          ],
                        )
                      ],
                    )))));
  }

  Widget unloginedUserMenu() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15 > 120
                          ? 120
                          : MediaQuery.of(context).size.height * 0.15,
                      child:
                          Image.asset('asset/images/buttons/login_button.png')),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInPage()),
                        (route) => false);
                  })),
          Flexible(
              fit: FlexFit.loose,
              child: InkWell(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15 > 120
                          ? 120
                          : MediaQuery.of(context).size.height * 0.15,
                      child: Image.asset(
                          'asset/images/buttons/signup_button.png')),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                        (route) => false);
                  })),
        ]);
  }

  Widget loginedGansaMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            fit: FlexFit.loose,
            child: InkWell(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15 > 120
                        ? 120
                        : MediaQuery.of(context).size.height * 0.15,
                    child: Image.asset(
                        'asset/images/buttons/write_report_button.png')),
                onTap: () {})),
        Flexible(
            fit: FlexFit.loose,
            child: InkWell(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15 > 120
                        ? 120
                        : MediaQuery.of(context).size.height * 0.15,
                    child: Image.asset(
                        'asset/images/buttons/team_member_management_button.png')),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberListViewPage()));
                })),
      ],
    );
  }

  Widget loginedPasterMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            fit: FlexFit.loose,
            child: InkWell(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15 > 120
                        ? 120
                        : MediaQuery.of(context).size.height * 0.15,
                    child: Image.asset(
                        'asset/images/buttons/read_report_button.png')),
                onTap: () {})),
        Flexible(
            fit: FlexFit.loose,
            child: InkWell(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15 > 120
                        ? 120
                        : MediaQuery.of(context).size.height * 0.15,
                    child: Image.asset(
                        'asset/images/buttons/camp_member_management_button.png')),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberListViewPage()));
                })),
      ],
    );
  }
}
