import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfb/dialoge_utils.dart';
import 'package:mfb/model/player_model.dart';

class RatePlayer extends StatefulWidget {
  static const String routeName = '/rateskil';
  const RatePlayer({super.key});

  @override
  State<RatePlayer> createState() => _RatePlayerState();
}

class _RatePlayerState extends State<RatePlayer> {
  double pace = 1;
  double shooting = 1;
  double overAll = 1;
  double passing = 1;
  double dribbling = 1;
  double defending = 1;
  double physical = 1;

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rate player skils',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PlayerModel userData = PlayerModel.fromMap(
                snapshot.data!.data() as Map<String, dynamic>);
            return Column(
              children: [
                ListTile(
                  leading: const Text('Over All'),
                  title: Slider(
                    value: overAll,
                    divisions: 100,
                    min: 1,
                    max: 100,
                    onChanged: (value) {
                      overAll = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(overAll.toStringAsFixed(0)),
                ),
                ListTile(
                  leading: const Text('Over All'),
                  title: Slider(
                    value: pace,
                    divisions: 100,
                    min: 1,
                    max: 100,
                    onChanged: (value) {
                      pace = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(pace.toStringAsFixed(0)),
                ),
                ListTile(
                  leading: const Text('Shooting'),
                  title: Slider(
                    divisions: 100,
                    min: 1,
                    max: 100,
                    value: shooting,
                    onChanged: (value) {
                      shooting = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(shooting.toStringAsFixed(0)),
                ),
                ListTile(
                  leading: const Text('Passing'),
                  title: Slider(
                    divisions: 100,
                    min: 1,
                    max: 100,
                    value: passing,
                    onChanged: (value) {
                      passing = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(passing.toStringAsFixed(0)),
                ),
                ListTile(
                  leading: const Text('Dribbling'),
                  title: Slider(
                    divisions: 100,
                    min: 1,
                    max: 100,
                    value: dribbling,
                    onChanged: (value) {
                      dribbling = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(dribbling.toStringAsFixed(0)),
                ),
                ListTile(
                  leading: const Text('Defending'),
                  title: Slider(
                    divisions: 100,
                    min: 1,
                    max: 100,
                    value: defending,
                    onChanged: (value) {
                      defending = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(defending.toStringAsFixed(0)),
                ),
                ListTile(
                  leading: const Text('Physical'),
                  title: Slider(
                    divisions: 100,
                    min: 1,
                    max: 100,
                    value: physical,
                    onChanged: (value) {
                      physical = value;
                      setState(() {});
                    },
                  ),
                  subtitle: Text(physical.toStringAsFixed(0)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showLoading(context, 'please wait adding');
                    userData.fanRating!.add(uid);

                    userData = calculateTotalRateSkil(userData);

                    userData = calculateAverageRateSkils(userData);

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update(userData.toMap())
                        .then(
                      (value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: const Text('Done'),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  PlayerModel calculateAverageRateSkils(PlayerModel userData) {
    userData.averageRateSkil.pace = double.parse(
        (userData.totalRateSkil.pace / userData.fanRating!.length)
            .toStringAsFixed(0));

    userData.averageRateSkil.overAll = double.parse(
        (userData.totalRateSkil.overAll / userData.fanRating!.length)
            .toStringAsFixed(0));

    userData.averageRateSkil.passing = double.parse(
        (userData.totalRateSkil.passing / userData.fanRating!.length)
            .toStringAsFixed(0));

    userData.averageRateSkil.defending = double.parse(
        (userData.totalRateSkil.defending / userData.fanRating!.length)
            .toStringAsFixed(0));

    userData.averageRateSkil.dribbling =
        userData.totalRateSkil.dribbling / userData.fanRating!.length;

    userData.averageRateSkil.physical = double.parse(
        (userData.totalRateSkil.physical / userData.fanRating!.length)
            .toStringAsFixed(0));

    userData.averageRateSkil.shooting = double.parse(
        (userData.totalRateSkil.shooting / userData.fanRating!.length)
            .toStringAsFixed(0));
    return userData;
  }

  PlayerModel calculateTotalRateSkil(PlayerModel userData) {
    userData.totalRateSkil.pace =
        userData.totalRateSkil.pace + double.parse(pace.toStringAsFixed(0));

    userData.totalRateSkil.overAll = userData.totalRateSkil.overAll +
        double.parse(overAll.toStringAsFixed(0));

    userData.totalRateSkil.passing = userData.totalRateSkil.passing +
        double.parse(passing.toStringAsFixed(0));

    userData.totalRateSkil.defending = userData.totalRateSkil.defending +
        double.parse(defending.toStringAsFixed(0));

    userData.totalRateSkil.dribbling = userData.totalRateSkil.dribbling +
        double.parse(dribbling.toStringAsFixed(0));

    userData.totalRateSkil.physical = userData.totalRateSkil.physical +
        double.parse(physical.toStringAsFixed(0));

    userData.totalRateSkil.shooting = userData.totalRateSkil.shooting +
        double.parse(shooting.toStringAsFixed(0));

    return userData;
  }
}
