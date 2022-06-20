import 'dart:ui';

import 'package:flutter/material.dart';

import '../spref/spref.dart';

class HightScorePage extends StatefulWidget {
  const HightScorePage({Key? key}) : super(key: key);

  @override
  State<HightScorePage> createState() => _HightScorePageState();
}

class _HightScorePageState extends State<HightScorePage> {
  int? top1;
  int? top2;
  int? top3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      top1 = await SPref.instance.getInt("top1") ?? 0;

      top2 = await SPref.instance.getInt("top2") ?? 0;
      top3 = await SPref.instance.getInt("top3") ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIGH SCORE"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            "1st",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            "${top1 == null ? 0 : top1} Point",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          title: Text(
                            "2nd",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            "${top2 == null ? 0 : top2} Point",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          title: Text(
                            "3rd",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Text(
                            "${top3 == null ? 0 : top3} Point",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
