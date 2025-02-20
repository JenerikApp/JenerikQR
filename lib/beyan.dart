import 'package:flutter/material.dart';
import 'package:jenerik_qr/main.dart';
// MyApp'ın bulunduğu dosya

class BeyanPage extends StatelessWidget {
  const BeyanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geri'),
        backgroundColor: Colors.white,
        // BeyanPage içinde geri butonunu şu şekilde değiştirebilirsiniz
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()), // MyApp'a yönlendirme
      (route) => false, // Diğer tüm sayfaları temizler
    );
  },
),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Jenerik QR uygulaması 'Jenerik Ambalaj Matbaa ve Tic. Ltd. Şti ' tarafından tamamen ücretsiz olarak hizmete sunulmuştur.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "Verilerin İşlenmesi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                "KVKK (Kişisel Verileri Koruma Kanunu) gereği 'Jenerik QR' uygulaması girmiş olduğunuz bilgileri göremez ve herhangi bir veritabanına kayıt etmez. ",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "3. Taraf Paylaşımı",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Bilgileriniz 'Jenerik QR' uygulaması tarafından kayıt edilmediği gibi 3.taraf kişilerlede paylaşılmamaktadır.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              Text(
                "'Jenerik Ambalaj Matbaa ve Tic. Ltd. Şti', 'Jenerik QR' uygulamasını kullanan kişiye ait bilgileri herhangi bir amaçla kullanmadığını, işlemediğini ve saklamadığını beyan eder.",
                style: TextStyle(fontSize: 16),
              ),
              // Burada daha fazla başlık ve metin ekleyebilirsiniz.
            ],
          ),
        ),
      ),
    );
  }
}
