import 'package:flutter/material.dart';
import 'package:jenerik_qr/beyan.dart';
import 'home_page.dart';
import 'qr.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }
}

class _MyAppState extends State<MyApp> {
  Widget _currentWidget = const HomePage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/yazisiz_seffaf.png', height: 40),
                  const SizedBox(width: 10),
                  const Text(
                    "Jenerik QR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
  onTap: () {
    // Text ve Icon'a tıklanınca yapılacak işlem
    setState(() {
      _currentWidget = BeyanPage();
    });
  },
  child: Row(
    children: const [
      Text(
        "Beyan Metni",
        style: TextStyle(color: Colors.black), // Metnin rengini mavi yapıyoruz
      ),
      SizedBox(width: 10),
      Icon(
        Icons.info_outline,
        color: Colors.black, // İkonun rengini mavi yapıyoruz
      ),
    ],
  ),
)

            ],
          ),
          backgroundColor: const Color(0xFF4DFFB5),
          automaticallyImplyLeading: _currentWidget is QRGeneratorPage,
        ),
        body: _currentWidget,
        bottomNavigationBar: const Footer(),
      ),
    );
  }

  void showCreateQr() {
    setState(() {
      _currentWidget = QRGeneratorPage();
    });
  }

  void showHomePage() {
    setState(() {
      _currentWidget = const HomePage();
    });
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            Image.asset('assets/logo_flutter.png', height: 100),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Jenerik Ambalaj Matbaa ve Tic. Ltd. Şti.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                const Text(
                  "KVKK (Kişisel Verileri Koruma Kanunu) gereği bilgileriniz diğer kişi/kurumlarla paylaşılmamaktadır.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                InkWell(
                  onTap: () async {
                    const url = 'https://www.jenerikambalaj.com/';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text(
                    "www.jenerikambalaj.com",
                    style: TextStyle(
                        color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}