import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zero_to_mastery/models/tweet.dart';
import 'package:zero_to_mastery/pages/create.dart';
import 'package:zero_to_mastery/pages/settings.dart';
import 'package:zero_to_mastery/providers/tweet_provider.dart';
import 'package:zero_to_mastery/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 1,
            )),
        title: const Image(
          image: AssetImage('assets/Download.jpeg'),
          width: 50,
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  currentUser.user.profilePic,
                ),
                onBackgroundImageError: (exception, stackTrace) {},
              ),
            ),
          );
        }),
      ),
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                itemCount: tweets.length,
                itemBuilder: (context, count) {
                  return ListTile(
                    leading: CircleAvatar(
                        foregroundImage:
                            NetworkImage(tweets[count].profilePic)),
                    title: Text(
                      tweets[count].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tweets[count].tweet,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  );
                });
          },
          error: (error, StackTrace) => const Center(child: Text("error")),
          loading: () => const CircularProgressIndicator()),
      drawer: Drawer(
          child: Column(
        children: [
          Image.network(
            currentUser.user.profilePic,
          ),
          ListTile(
            title: Text(
              "Hello, ${currentUser.user.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            title: const Text("Sign Out"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).logout();
            },
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CreateTweet()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
