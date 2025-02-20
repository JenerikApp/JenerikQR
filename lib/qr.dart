import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jenerik_qr/main.dart'; // main.dart dosyanızın yolunu doğrulayın
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class QRGeneratorPage extends StatefulWidget {
  const QRGeneratorPage({super.key});

  @override
  _QRGeneratorPageState createState() => _QRGeneratorPageState();
}

class _QRGeneratorPageState extends State<QRGeneratorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showQR = false;
  String _qrData = "";
  final GlobalKey _qrKey = GlobalKey();

  // Kartvizit Bilgileri
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  // E-Posta Taslağı
  TextEditingController emailToController = TextEditingController();
  TextEditingController emailSubjectController = TextEditingController();
  TextEditingController emailMessageController = TextEditingController();

  // Bağlantı
  TextEditingController urlController = TextEditingController();

  // WiFi
  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPasswordController = TextEditingController();
  String encryptionType = "WPA";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _generateQR() {
    setState(() {
      _showQR = true;
      int currentIndex = _tabController.index;

      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String company = companyController.text.trim();
      String title = titleController.text.trim();
      String address = addressController.text.trim();
      String website = websiteController.text.trim();

      if (currentIndex == 0) {
        if (name.isEmpty || phone.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Ad soyad ve iletişim bilgisi girilmelidir.")),
          );
          _showQR = false;
          return;
        }
        String displayName = name.isNotEmpty
          ? name
          : (company.isNotEmpty? company: "Ad Soyad/Şirket Bulunamadı");

        _qrData =
            "BEGIN:VCARD\nVERSION:3.0\nFN:$displayName\nN:$name\nTEL:${phone.isNotEmpty? phone: "Telefon Bulunamadı"}\nEMAIL:${email.isNotEmpty? email: "E-Posta Bulunamadı"}\nORG:${company.isNotEmpty? company: "Şirket Bulunamadı"}\nTITLE:${title.isNotEmpty? title: "Ünvan Bulunamadı"}\nADR:${address.isNotEmpty? address: "Adres Bulunamadı"}\nURL:${website.isNotEmpty? website: "Web Sitesi Bulunamadı"}\nEND:VCARD";
      } else if (currentIndex == 1) {
        if (emailToController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("E-Posta adresi girilmelidir.")),
          );
          _showQR = false;
          return;
        }
        _qrData =
            "mailto:${emailToController.text}?subject=${Uri.encodeComponent(emailSubjectController.text)}&body=${Uri.encodeComponent(emailMessageController.text)}";
      } else if (currentIndex == 2) {
        if (urlController.text.isEmpty ||
          !urlController.text.startsWith("https://")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Lütfen geçerli bir HTTPS bağlantısı girin.")),
          );
          _showQR = false;
          return;
        }
        _qrData = urlController.text;
      } else if (currentIndex == 3) {
        if (wifiNameController.text.isEmpty ||
            wifiPasswordController.text.isEmpty ||
            encryptionType.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("WiFi adı, şifresi ve şifreleme türü zorunludur.")),
          );
          _showQR = false;
          return;
        }
        _qrData =
            "WIFI:S:${wifiNameController.text};T:$encryptionType;P:${wifiPasswordController.text};;";
      }
    });
  }

  Future<void> _saveQR() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("QR kodunu kaydetme başarısız oldu.")));
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // QR kodu PNG olarak indirilecek
      final buffer = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(buffer);
      final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'jenerikQR.png';

      anchor.click(); // Web tarayıcısında indirmeyi başlatır

      // Kaydedilen dosya hakkında bildirim
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("QR Kodu İndirildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kaydetme Hatası: $e")),
      );
      print(e);
    }
  }

@override
Widget build(BuildContext context) {
  // Ekranın genişliğini kontrol et
  bool isMobile = MediaQuery.of(context).size.width < 600;

  return Scaffold(
    appBar: AppBar(
      title: const Text("QR Kod Oluşturucu"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyApp()),
            (route) => false,
          );
        },
      ),
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true, // Mobil cihazlarda tab'lerin kaydırılabilir olması için
        tabs: const [
          Tab(text: 'Kartvizit'),
          Tab(text: 'E-Posta Taslağı'),
          Tab(text: 'Bağlantı'),
          Tab(text: 'WiFi Şifresi'),
        ],
      ),
    ),
    body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView( // Taşmaları önlemek için SingleChildScrollView
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Widget'ları yatayda genişlet
            children: [
              // Ekranı ikiye bölecek Row
              Row(
                children: [
                  // Sol Taraf: TabBar ve QR Oluştur Butonu
                  Expanded(
                    flex: 1, // Sol tarafın daha küçük olması için flex değeri verdik
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: isMobile
                              ? MediaQuery.of(context).size.height * 0.4
                              : 350, // Mobilde ekran boyutuna göre dinamik yükseklik
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildKartvizitTab(),
                              _buildEmailTab(),
                              _buildBaglantiTab(),
                              _buildWifiTab(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                  // Sağ Taraf: QR kodu, "QR burada gözükecektir" yazısı ve "QR İndir" butonu
                  if (!isMobile) ...[
                    // Bu kısım yalnızca masaüstü için geçerli
                    Expanded(
                      flex: 1, // Sağ tarafın da eşit büyüklükte olması için
                      child: Center( // Sağdaki içeriği hem dikey hem yatayda ortala
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortalama
                          crossAxisAlignment: CrossAxisAlignment.center, // Yatayda ortalama
                          children: [
                            if (_showQR)
                              RepaintBoundary(
                                key: _qrKey,
                                child: QrImageView(
                                  data: _qrData,
                                  version: QrVersions.auto,
                                  size: 200,
                                  backgroundColor: Colors.white,
                                ),
                              )
                            else
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.qr_code, size: 80, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text("QR kodunuz burada oluşturulacaktır.",
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            const SizedBox(height: 10),
                            if (_showQR)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4DFFB5)),
                                onPressed: _saveQR,
                                child: const Text(
                                  "QR İndir",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              // QR Oluştur butonunu ekranın alt kısmında ortalamak için Align kullanıyoruz
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DFFB5),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _generateQR,
                  child: const Text(
                    "QR Oluştur",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    ),
  );
}










  // Kartvizit Tab içeriği
  Widget _buildKartvizitTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildTextField("Ad & Soyad", nameController)),
            const SizedBox(width: 10),
            Expanded(child: _buildTextField("İletişim", phoneController)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildTextField("Email", emailController)),
            const SizedBox(width: 10),
            Expanded(child: _buildTextField("Ünvan", titleController)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildTextField("Şirket", companyController)),
            const SizedBox(width: 10),
            Expanded(child: _buildTextField("Web Sitesi", websiteController)),
          ],
        ),
        const SizedBox(height: 10),
        _buildTextField("Adres", addressController),
      ],
    );
  }

  // E-Posta Tab içeriği
  Widget _buildEmailTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTextField("Alıcı E-Posta", emailToController),
        _buildTextField("Konu", emailSubjectController),
        _buildTextField("Mesaj", emailMessageController, maxLines: 5),
      ],
    );
  }

  // Bağlantı Tab içeriği
  Widget _buildBaglantiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTextField("HTTPS Bağlantısı", urlController),
      ],
    );
  }

  // WiFi Tab içeriği
  Widget _buildWifiTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTextField("WiFi Adı", wifiNameController),
        _buildTextField("Şifre", wifiPasswordController),
        DropdownButtonFormField(
          items: ["WPA", "WEP", "WPA-EAP", "Yok"].map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: (value) {
            setState(() {
              encryptionType = value!;
            });
          },
          decoration: const InputDecoration(labelText: "Şifreleme Türü"),
        ),
      ],
    );
  }

  // TextField Widget'ı
  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}


