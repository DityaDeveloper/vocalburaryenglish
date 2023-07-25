import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocalbularyquiz/ui/screen/learn.dart';
import 'package:vocalbularyquiz/ui/widget/primary_button.dart';

import '../../constant/app_color_contants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.currentUser})
      : super(key: key);
  final User? currentUser;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Query _items = FirebaseFirestore.instance
      .collection('ranking')
      .orderBy("rank", descending: true);

  String buttonLabel = "tampil peringkat";
  String toHiragana = "hiragana";
  String toKatakana = "katakana";
  String toKosakata = "kosakata";
  String headerLabel = "Mau belajar apa hari ini";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: [_buildHeader(), _buildBody()],
      )),
    );
  }

  Widget iconLogo = Container(
    height: 250,
    width: 250,
    decoration: const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/home_icon.jpg"), fit: BoxFit.fitWidth),
    ),
  );

  Widget _buildHeader() {
    return Column(
      children: [
        iconLogo,
        const Divider(
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: const [
              Text("Game edukasi vocabulary english",
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
          child: Row(
            children: const [
              Text("Welcome (Selamat Datang)",
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Text("${widget.currentUser!.email}",
                  style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          /*
          _buttonPeringkat(),
          //_ranking(),
          buttonLabel == "tutup" ? _ranking() : Container(),
          const SizedBox(
            height: 20,
          ),
          _msgHeader(),
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
              onpressed: () {
                debugPrint(toKatakana);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LearnScreen(
                            labelHeader: toHiragana,
                            pathFoto: toHiragana,
                          )),
                );
              },
              textLabel: "Belajar Mengenal Hiragana"),
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
              onpressed: () {
                debugPrint(toKatakana);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LearnScreen(
                            labelHeader: toKatakana,
                            pathFoto: toKatakana,
                          )),
                );
              },
              textLabel: "Belajar Mengenal Katakana"),
          const SizedBox(
            height: 20,
          ),
          PrimaryButton(
              onpressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LearnScreen(
                            labelHeader: toKosakata,
                            pathFoto: toKosakata,
                          )),
                );
              },
              textLabel: "Belajar Mengenal Kosakata"),
              */
              _ranking()
        ],
      ),
    );
  }

  Widget _buttonPeringkat() {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.red)))),
      onPressed: () {
        if (buttonLabel == "tutup") {
          setState(() {
            buttonLabel = "tampil peringkat";
          });
        } else {
          setState(() {
            buttonLabel = "tutup";
          });
        }
      },
      child: Text(
        buttonLabel == "tutup"
            ? "tutup".toUpperCase()
            : "tampil peringkat".toUpperCase(),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _msgHeader() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Center(
          child: Text(
        headerLabel,
        style: const TextStyle(
            color: AppColor.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _ranking() {
    return SizedBox(
      height: 280,
      child: StreamBuilder(
        stream: _items.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 1.0));
          }
          if (streamSnapshot.connectionState == ConnectionState.none) {
            return const Text('Server not found - Error 500');
          }
          if (streamSnapshot.hasData) {
            
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length >= 3 ? 3 : streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Peringkat ${index + 1}",
                          style: const TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(documentSnapshot['name'].toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "(${documentSnapshot['tipe'].toString()})",
                              style: const TextStyle(
                                  color: AppColor.secondColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            const Text("Nilai : "),
                            Text(
                              documentSnapshot['rank'].toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox(
                height: 200,
                child:  Text('Belum ada peringkat'),);
          }
          

        },
      ),
    );
  }
}
