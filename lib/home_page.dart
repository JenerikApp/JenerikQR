import 'package:flutter/material.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // **ESNEK DÜZEN** - Ekran genişliğine göre dinamik yapı
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;

                  if (constraints.maxWidth > 1200) {
                    crossAxisCount = 4; // 📌 **MASAÜSTÜ: 4 yan yana**
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2; // 📌 **TABLET: 2x2 düzen**
                  } else {
                    crossAxisCount = 1; // 📌 **MOBİL: Alt alta**
                  }

                  return Center(
                    child: GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8, // Kart oranı daha iyi olacak
                      children: _buildInfoCards(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // **QR OLUŞTUR BUTONU**
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4DFFB5),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                MyApp.of(context)?.showCreateQr();
              },
              child: const Text(
                "QR Oluştur",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **Kartları oluşturacak liste fonksiyonu**
  List<Widget> _buildInfoCards() {
    return [
      _buildInfoCard(
        "Kartvizit",
        "Ad, telefon, e-posta ve şirket bilgileriniz için kolayca QR oluşturun. Bilgilerinizin rehbere eklenmesini kolaylaştırın",
      ),
      _buildInfoCard(
        "E-Posta Taslağı",
        "E-posta adresi, konu başlığı ve mesaj içeriği girerek QR kod oluşturun. E-posta gönderimini kolaylaştırın.",
      ),
      _buildInfoCard(
        "Web Bağlantısı",
        "Dosya, medya, web sitesi ve diğer web bağlantılarınız için 'https' formatında bir URL girerek kolayca QR kod oluşturun. Web erişiminizi kolaylaştırın",
      ),
      _buildInfoCard(
        "WiFi Şifresi",
        "Kablosuz ağ adı ve şifresini girerek QR kod oluşturun. Wifi erişiminizi kolaylaştırın.",
      ),
    ];
  }

  // **Bilgi Kartı Bileşeni**
  Widget _buildInfoCard(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
