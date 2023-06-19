import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:mfb/home/chat/chat_room.dart';
import 'package:mfb/model/player_model.dart';
import 'package:mfb/player%20details/rate_player.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../model/post_model.dart';

class PlayerDetails extends StatefulWidget {
  static const String routeName = 'player details';
  const PlayerDetails({super.key});

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  String userId = '';

  @override
  Widget build(BuildContext context) {
    userId = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final userData = PlayerModel.fromMap(
                snapshot.data!.data() as Map<String, dynamic>);
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(226, 0, 48, 1),
                  title: const Text(
                    'Player Deatails',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                floatingActionButton: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final currentUser = PlayerModel.fromMap(
                          snapshot.data!.data() as Map<String, dynamic>);
                      return currentUser.userType != 'fan'
                          ? FloatingActionButton(
                              onPressed: () {
                                Navigator.pushNamed(context, ChatRoom.routeName,
                                    arguments: userId);
                              },
                              backgroundColor:
                                  const Color.fromRGBO(226, 0, 48, 1),
                              child: const Icon(Icons.chat_bubble_outline),
                            )
                          : const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        userData.imageUrl == ''
                            ? Image.asset('assets/images/player.png')
                            : Image.network(userData.imageUrl),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userData.userName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '( ${userData.playerPosition!} )',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${userData.age} (year)',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Image.asset('assets/images/egypt.png')
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'About Player :',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  userData.about.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text('Rate: 3.4'),
                                      ],
                                    ),
                                    Visibility(
                                      visible: userData.fanRating!.contains(
                                          FirebaseAuth
                                              .instance.currentUser!.uid),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, RatePlayer.routeName);
                                          },
                                          child: const Text('Rate skils')),
                                    )
                                  ],
                                ),
                                _buildMedia()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container();
        });
  }

  _buildMedia() {
    return Column(
      children: [
        ListTile(
          leading: const Text('Photos'),
          trailing: const Text('see More'),
          onTap: () {},
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('postTyp', isEqualTo: 'image')
              .where('ownerId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: double.infinity,
                height: 25.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((doc) {
                    final post =
                        PostModel.fromMap(doc.data() as Map<String, dynamic>);
                    return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            post.mediaUrl,
                            fit: BoxFit.fill,
                          ),
                        ));
                  }).toList(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox(
              child: Text('this test'),
            );
          },
        ),
        ListTile(
          leading: const Text('Videos'),
          trailing: const Text('see More'),
          onTap: () {},
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('postTyp', isEqualTo: 'video')
              .where('ownerId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((doc) {
                    final post =
                        PostModel.fromMap(doc.data() as Map<String, dynamic>);
                    final flickManager = FlickManager(
                      autoPlay: false,
                      videoPlayerController:
                          VideoPlayerController.network(post.mediaUrl),
                    );

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlickVideoPlayer(
                        flickManager: flickManager,
                      ),
                    );
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const SizedBox(child: Text('unable to load video'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox(
              child: Text('this test'),
            );
          },
        )
      ],
    );
  }
}
