import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatelessWidget {
  const MyPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio | Taufiq Ikhsan Muzaky',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF030014),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
      ),
      home: const PreloaderScreen(),
    );
  }
}

// ==========================================
// 1. PRELOADER SCREEN (KILAT & GLITCHY)
// ==========================================
class PreloaderScreen extends StatefulWidget {
  const PreloaderScreen({super.key});
  @override
  State<PreloaderScreen> createState() => _PreloaderScreenState();
}
class _PreloaderScreenState extends State<PreloaderScreen> {
  double progress = 0;
  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }
  void _simulateLoading() async {
    for (int i = 0; i <= 100; i += 4) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (mounted) setState(() => progress = i.toDouble());
    }
    if (mounted) {
      Navigator.pushReplacement(context, PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1500),
        pageBuilder: (_, __, ___) => const MainPortfolioScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: ScaleTransition(scale: Tween<double>(begin: 1.2, end: 1.0).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutExpo)), child: child)),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030014),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${progress.toInt()}%", style: GoogleFonts.outfit(fontSize: 120, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 20)])),
            const Text("S Y S T E M   B O O T I N G", style: TextStyle(color: Colors.blueAccent, letterSpacing: 8, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 40),
            Container(width: 250, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: Align(alignment: Alignment.centerLeft, child: Container(width: (progress / 100) * 250, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.red, Colors.purple, Colors.blue]), borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.blue, blurRadius: 10)])))),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. MAIN SCREEN
// ==========================================
class MainPortfolioScreen extends StatefulWidget {
  const MainPortfolioScreen({super.key});
  @override
  State<MainPortfolioScreen> createState() => _MainPortfolioScreenState();
}

class _MainPortfolioScreenState extends State<MainPortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedTabIndex = 0;

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) debugPrint('Could not launch $url');
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(key.currentContext!, duration: const Duration(milliseconds: 1200), curve: Curves.easeInOutCubic);
  }

  void _kirimPesan() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi semua kolom dulu bos!"), backgroundColor: Colors.red));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pesan meluncur ke server! 🚀"), backgroundColor: Colors.green));
    _nameController.clear(); _emailController.clear(); _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND BERGERAK (DYNAMIC FLOATING)
          FloatingBackground(color: Colors.red[800]!, size: 400, speed: 0.5, startOffset: const Offset(-100, -100)),
          FloatingBackground(color: Colors.blue[800]!, size: 450, speed: 0.7, startOffset: const Offset(200, 300)),
          FloatingBackground(color: Colors.purple[900]!, size: 500, speed: 0.6, startOffset: const Offset(-50, 600)),

          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 120),
                Container(key: _homeKey, child: _buildHeroSection()),
                const SizedBox(height: 100),
                Container(key: _aboutKey, child: _buildAboutSection()),
                const SizedBox(height: 100),
                Container(key: _portfolioKey, child: _buildPortfolioSection()),
                const SizedBox(height: 100),
                Container(key: _contactKey, child: _buildContactSection()),
                const SizedBox(height: 50),
                _buildFooter(),
              ],
            ),
          ),
          Positioned(top: 24, left: 0, right: 0, child: Center(child: _buildNavbar())),
        ],
      ),
    );
  }

  Widget _buildNavbar() {
    return CapCutReveal(
      scrollController: _scrollController,
      delay: 500,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.white24)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _navItem("Home", () => _scrollToSection(_homeKey)),
                _navItem("About", () => _scrollToSection(_aboutKey)),
                _navItem("Portfolio", () => _scrollToSection(_portfolioKey)),
                _navItem("Contact", () => _scrollToSection(_contactKey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(String title, VoidCallback onTap) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: GestureDetector(onTap: onTap, child: Text(title.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5))));

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          CapCutReveal(scrollController: _scrollController, child: Text("Taufiq Ikhsan\nMuzaky".toUpperCase(), textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 44, fontWeight: FontWeight.w900, height: 1.1, shadows: [const Shadow(color: Colors.blueAccent, blurRadius: 30)]))),
          const SizedBox(height: 10),
          
          // EFEK NGETIK YANG REPLAY TIAP SCROLL
          CapCutReveal(
            scrollController: _scrollController,
            delay: 200,
            onVisible: () => setState(() {}), // Paksa rebuild buat restart ngetik
            child: SizedBox(
              height: 40,
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent, fontStyle: FontStyle.italic),
                child: AnimatedTextKit(
                  key: UniqueKey(), // Ini rahasianya biar restart terus
                  isRepeatingAnimation: true,
                  animatedTexts: [TypewriterAnimatedText('Kreatif'), TypewriterAnimatedText('Inovatif'), TypewriterAnimatedText('Usaha')],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          CapCutReveal(
            scrollController: _scrollController, delay: 400,
            child: GlowingBorder(
              child: ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.asset('assets/website_mzkyzak.gif', width: 300, height: 300, fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.network('https://cdn.dribbble.com/users/1059583/screenshots/4171367/coding.gif', width: 300, height: 300, fit: BoxFit.cover))),
            ),
          ),
          const SizedBox(height: 40),
          CapCutReveal(scrollController: _scrollController, delay: 600, child: _buildGlassCard(child: const Text("Kepribadian saya terbentuk melalui kegiatan yang melatih kedisiplinan, kerja sama tim, tanggung jawab, kepemimpinan, serta kepedulian sosial. Saya menciptakan dan mengembangkan website, game, serta aplikasi untuk membangun solusi digital yang fungsional dan ramah pengguna.", textAlign: TextAlign.justify, style: TextStyle(color: Colors.white70, height: 1.8)))),
          const SizedBox(height: 30),
          CapCutReveal(
            scrollController: _scrollController, delay: 800,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(onTap: () => _scrollToSection(_portfolioKey), child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.red, Colors.blue]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.6), blurRadius: 20, offset: const Offset(0, 5))]), child: const Text("PORTFOLIO ME", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 11, color: Colors.white)))),
                const SizedBox(width: 16),
                GestureDetector(onTap: () => _scrollToSection(_aboutKey), child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.white.withOpacity(0.2)), borderRadius: BorderRadius.circular(12)), child: const Text("PROFILE", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 11, color: Colors.white)))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          CapCutReveal(scrollController: _scrollController, child: GlowingBorder(isCircle: true, child: Container(width: 250, height: 250, decoration: const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/Profile.jpg'), fit: BoxFit.cover))))),
          const SizedBox(height: 40),
          CapCutReveal(scrollController: _scrollController, delay: 200, child: RichText(text: const TextSpan(style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white), children: [TextSpan(text: "About "), TextSpan(text: "Me", style: TextStyle(color: Colors.blueAccent))]))),
          const SizedBox(height: 30),
          CapCutReveal(
            scrollController: _scrollController, delay: 400,
            child: _buildGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.white70, height: 1.8, fontSize: 14), children: [TextSpan(text: "Perkenalkan, nama saya "), TextSpan(text: "Taufiq Ikhsan Muzaky (Zaky)\n\n", style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white)), TextSpan(text: "Saya adalah Seorang siswa Dari jurusan Rekayasa Perangkat Lunak Di sekolah Smkn 2 Jakarta Pusat karena saya memiliki minat dalam pengembangan aplikasi, game dan website. Dan Berpengalaman mengerjakan berbagai proyek sekolah dan mandiri, saya berfokus pada pembuatan solusi digital yang responsif, fungsional, dan ramah pengguna.")])),
                  const SizedBox(height: 20),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), border: Border.all(color: Colors.red.withOpacity(0.5)), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 15)]), child: const Text("DOWNLOAD CV", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white)))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    List<String> tabs = ["Projects", "Certificates", "Tech", "Design", "OS"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          CapCutReveal(scrollController: _scrollController, child: const Text("Portfolio", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))),
          CapCutReveal(scrollController: _scrollController, delay: 100, child: Container(margin: const EdgeInsets.only(top: 10, bottom: 30), width: 120, height: 4, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.red, Colors.blue]), borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.blue, blurRadius: 10)]))),
          
          CapCutReveal(
            scrollController: _scrollController, delay: 200,
            child: Wrap(
              spacing: 8, runSpacing: 10, alignment: WrapAlignment.center,
              children: List.generate(tabs.length, (index) {
                bool isActive = _selectedTabIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = index),
                  child: AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(gradient: isActive ? const LinearGradient(colors: [Colors.red, Colors.blue]) : null, color: isActive ? null : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: isActive ? Colors.transparent : Colors.white10), boxShadow: isActive ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 10)] : []), child: Text(tabs[index].toUpperCase(), style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5))),
                );
              }),
            ),
          ),
          const SizedBox(height: 40),
          
          if (_selectedTabIndex == 0) _buildProjectsGrid(),
          if (_selectedTabIndex == 1) _buildCertificatesGrid(),
          if (_selectedTabIndex == 2) _buildToolsGrid(listTools),
          if (_selectedTabIndex == 3) _buildToolsGrid(listDesignTools),
          if (_selectedTabIndex == 4) _buildToolsGrid(listOS),
        ],
      ),
    );
  }

  Widget _buildProjectsGrid() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: listProyek.length,
      itemBuilder: (context, index) {
        final p = listProyek[index];
        return CapCutReveal(
          scrollController: _scrollController, delay: index * 150,
          child: GestureDetector(
            onTap: () => _openProjectOverview(p),
            child: GlowingBorder(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: AspectRatio(aspectRatio: 16/9, child: Image.asset(p.img, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.red.withOpacity(0.1))))),
                    Padding(padding: const EdgeInsets.all(20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.subtitle, style: const TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)), const SizedBox(height: 8), Text(p.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))]), const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 16)]))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCertificatesGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75), itemCount: listCertificates.length,
      itemBuilder: (context, index) {
        final c = listCertificates[index];
        return CapCutReveal(
          scrollController: _scrollController, delay: index * 100,
          child: GestureDetector(
            onTap: () => _openCertificateZoom(c), // 🔥 TRIGGER ZOOM DI SINI
            child: GlowingBorder(
              child: Container(
                decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.asset(c.img, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image, color: Colors.white24, size: 40))))), 
                    Padding(
                      padding: const EdgeInsets.all(12), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), border: Border.all(color: Colors.red.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)), child: const Text("Verifikasi ✅", style: TextStyle(color: Colors.redAccent, fontSize: 8, fontWeight: FontWeight.bold))), 
                          const SizedBox(height: 6), 
                          Text(c.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)), 
                          const SizedBox(height: 6), 
                          Text(c.issuer, style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))
                        ]
                      )
                    )
                  ]
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolsGrid(List<Tool> list) {
    return Wrap(
      spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
      children: list.asMap().entries.map((entry) => CapCutReveal(
        scrollController: _scrollController, delay: entry.key * 100,
        child: GlowingBorder(
          child: Container(
            width: 110, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                SizedBox(width: 40, height: 40, child: entry.value.logo.contains('.svg') ? SvgPicture.network(entry.value.logo, placeholderBuilder: (context) => const CircularProgressIndicator(strokeWidth: 2)) : (entry.value.logo.startsWith('http') ? Image.network(entry.value.logo) : Image.asset(entry.value.logo))),
                const SizedBox(height: 16),
                Text(entry.value.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.white)),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  void _openProjectOverview(Project project) {
    showGeneralDialog(
      context: context, barrierDismissible: true, barrierLabel: '', transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: a1, curve: Curves.elasticOut).value,
          child: Opacity(
            opacity: a1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dialog(
                backgroundColor: const Color(0xFF05011a), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.blueAccent, width: 2)),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500), padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
                        ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset(project.img, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 200, color: Colors.red.withOpacity(0.1)))),
                        const SizedBox(height: 20),
                        const Text("Project Overview", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        const SizedBox(height: 10),
                        Text(project.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 15),
                        Text(project.description, style: const TextStyle(color: Colors.white70, height: 1.6), textAlign: TextAlign.justify),
                        const SizedBox(height: 30),
                        if (project.link != null && project.link!.isNotEmpty)
                          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _launchURL(project.link!), icon: const Icon(Icons.bolt, color: Colors.white), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), shadowColor: Colors.blue, elevation: 10), label: const Text("Lihat Project", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔥 FUNGSI BARU: ZOOM SERTIFIKAT DENGAN ANIMASI ELASTIS & BLUR 🔥
  void _openCertificateZoom(Certificate c) {
    showGeneralDialog(
      context: context, barrierDismissible: true, barrierLabel: '', transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: a1, curve: Curves.elasticOut).value,
          child: Opacity(
            opacity: a1.value,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dialog(
                backgroundColor: const Color(0xFF05011a), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: const BorderSide(color: Colors.redAccent, width: 2)),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500), padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))),
                        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(c.img, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => Container(height: 200, color: Colors.red.withOpacity(0.1), child: const Center(child: Icon(Icons.broken_image, color: Colors.white24, size: 50))))),
                        const SizedBox(height: 20),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), border: Border.all(color: Colors.red.withOpacity(0.5)), borderRadius: BorderRadius.circular(10)), child: const Text("Sertifikat Terverifikasi ✅", style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold))), 
                        const SizedBox(height: 15),
                        Text(c.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        Text("Diterbitkan oleh: ${c.issuer}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CapCutReveal(
        scrollController: _scrollController,
        child: GlowingBorder(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hubungi Kami", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text("Ada yang ingin ditanyakan? Kirimin saya pesan dan mari Diskusi?\nLet's go to connect with me❤️", style: TextStyle(color: Colors.white70, height: 1.5)),
                const SizedBox(height: 30),
                
                Wrap(
                  spacing: 10, runSpacing: 10,
                  children: listSocials.map((s) => InkWell(
                    onTap: () => _launchURL(s.url),
                    child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white24)), child: Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 16, height: 16, child: s.logo.contains('.svg') ? SvgPicture.network(s.logo, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)) : const Icon(Icons.link, color: Colors.white, size: 16)), const SizedBox(width: 8), Text(s.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))])),
                  )).toList(),
                ),
                const SizedBox(height: 40),
                TextField(controller: _nameController, style: const TextStyle(color: Colors.white), decoration: _inputStyle("Nama Lengkap")),
                const SizedBox(height: 16),
                TextField(controller: _emailController, style: const TextStyle(color: Colors.white), decoration: _inputStyle("Alamat Email")),
                const SizedBox(height: 16),
                TextField(controller: _messageController, style: const TextStyle(color: Colors.white), maxLines: 4, decoration: _inputStyle("Pesan Anda")),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _kirimPesan, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 20), backgroundColor: Colors.red[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), shadowColor: Colors.red, elevation: 15), child: const Text("Kirim Sekarang", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2))))
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) => InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white38), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blueAccent)));

  Widget _buildFooter() {
    return CapCutReveal(
      scrollController: _scrollController,
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
        child: Column(
          children: [
            const Text("WEBSITE PORFOLIO Taufiq ikhsan muzaky", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 12),
            const Text("© 2026", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            RichText(text: const TextSpan(style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold), children: [TextSpan(text: "Website Portfolio By: "), TextSpan(text: "mzkyzak", style: TextStyle(color: Colors.redAccent))]))
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, double padding = 24}) {
    return GlowingBorder(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(padding: EdgeInsets.all(padding), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(24)), child: child),
        ),
      ),
    );
  }
}

// ==========================================
// CUSTOM ENGINE: BACKGROUND MELAYANG (DYNAMIC)
// ==========================================
class FloatingBackground extends StatefulWidget {
  final Color color; final double size; final double speed; final Offset startOffset;
  const FloatingBackground({super.key, required this.color, required this.size, required this.speed, required this.startOffset});
  @override
  State<FloatingBackground> createState() => _FloatingBackgroundState();
}
class _FloatingBackgroundState extends State<FloatingBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double x = widget.startOffset.dx + math.sin(_controller.value * 2 * math.pi * widget.speed) * 120;
        final double y = widget.startOffset.dy + math.cos(_controller.value * 2 * math.pi * widget.speed) * 120;
        return Positioned(
          left: x, top: y,
          child: Container(width: widget.size, height: widget.size, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withOpacity(0.15)), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent))),
        );
      },
    );
  }
}

// ==========================================
// CUSTOM ENGINE: CAPCUT REVEAL (BOUNCE & REPEAT PADA SCROLL)
// ==========================================
class CapCutReveal extends StatefulWidget {
  final Widget child; final ScrollController scrollController; final int delay; final VoidCallback? onVisible;
  const CapCutReveal({super.key, required this.child, required this.scrollController, this.delay = 0, this.onVisible});
  @override
  State<CapCutReveal> createState() => _CapCutRevealState();
}
class _CapCutRevealState extends State<CapCutReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    widget.scrollController.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }
  void _checkVisibility() {
    if (!mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final position = renderObject.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isVisible = position < screenHeight * 0.85 && (position + renderObject.size.height) > 0;
    if (isVisible && !_isVisible) {
      _isVisible = true;
      if (widget.onVisible != null) widget.onVisible!();
      Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted && _isVisible) _controller.forward(); });
    } else if (!isVisible && _isVisible) {
      _isVisible = false; _controller.reset(); // RESET untuk REPEAT!
    }
  }
  @override
  void dispose() { widget.scrollController.removeListener(_checkVisibility); _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curve = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
        return Transform.scale(scale: 0.8 + (0.2 * curve.value), child: Transform.translate(offset: Offset(0, 50 * (1 - curve.value)), child: Opacity(opacity: _controller.value.clamp(0.0, 1.0), child: child)));
      },
      child: widget.child,
    );
  }
}

// ==========================================
// CUSTOM ENGINE: GLOWING BORDER (CAPCUT STYLE)
// ==========================================
class GlowingBorder extends StatefulWidget {
  final Widget child; final bool isCircle;
  const GlowingBorder({super.key, required this.child, this.isCircle = false});
  @override
  State<GlowingBorder> createState() => _GlowingBorderState();
}
class _GlowingBorderState extends State<GlowingBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() { super.initState(); _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(); }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(2), // Ketebalan border
          decoration: BoxDecoration(
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isCircle ? null : BorderRadius.circular(26),
            gradient: SweepGradient(center: FractionalOffset.center, colors: const [Colors.red, Colors.blue, Colors.purple, Colors.red], stops: const [0.0, 0.33, 0.66, 1.0], transform: GradientRotation(_controller.value * 2 * math.pi)),
            boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// ==========================================
// 3. SEMUA DATA ASLI (TIDAK DIUBAH SAMA SEKALI)
// ==========================================
class Project { final int id; final String title, subtitle, img; final List<String> images; final String description; final String? link; Project({required this.id, required this.title, required this.subtitle, required this.img, required this.images, required this.description, this.link}); }
class Tool { final String name, logo; Tool({required this.name, required this.logo}); }
class Certificate { final int id; final String title, issuer, img, date; Certificate({required this.id, required this.title, required this.issuer, required this.img, required this.date}); }
class Social { final String name, logo, url; Social({required this.name, required this.logo, required this.url}); }

final List<Project> listProyek = [
  Project(id: 1, title: "Terdeteksi Kamera", subtitle: "Mediapipe Hand Terdeteksi Camera", img: "assets/Project mediapipe_kamera.png", images: ["assets/Project mediapipe_kamera.png"], description: "Sistem ini menggunakan deteksi wajah untuk mengenali Gestur Tangan secara real-time, serta MediaPipe Hand Pose untuk mendeteksi tangan dan posisi jari dengan presisi. Selain itu juga Mampu mengenali berbagai gestur tangan, termasuk gestur yang mewakili nama Saya atau simbol tangan tertentu.", link: "https://github.com/mzkyzak/mediapipe-hand-terdeteksi-kamera.git"),
  Project(id: 2, title: "Website transaksi_Canva", subtitle: "CRUD Dengan Php dan sql", img: "assets/CRUDlogin.png", images: ["assets/CRUDadmin.png", "assets/CRUDadmin2.png", "assets/CRUDuser.png"], description: "Website ini merupakan sistem penjualan Kolase Canva berbasis PHP, MySQL, dan CSS dengan tampilan menarik. Sistem CRUD memungkinkan pengguna untuk membeli kolase Canva dengan mudah, sekaligus memudahkan admin dalam mengelola data melalui dashboard untuk pencatatan, pengeditan, dan penghapusan data secara efisien.", link: "https://github.com/mzkyzak/Tugas-crud-database-transaksi_canva.git"),
  Project(id: 3, title: "Dinozak", subtitle: "Game engine 2D", img: "assets/projectwelcome.jpg", images: ["assets/projectlevel.jpg", "assets/project1.png", "assets/project2.png", "assets/project3.jpg", "assets/project4.jpg", "assets/project5.jpg", "assets/project6.jpg"], description: "Project ini mengembangkan game 2D menggunakan Unity dengan sistem level bertahap hingga level 6. Di setiap level, pemain harus mengalahkan Enemy terlebih dahulu agar memudahkan Dino dapat menuju telur dan memenangkan level tersebut. Jika levelnya meningkat Bisa mendapatkan kesulitan Dan memberikan tantangan progresif dan pengalaman bermain yang seru bagi pemain."),
  Project(id: 4, title: "Home_zak", subtitle: "Sketchware", img: "assets/Homezak.png", images: ["assets/Homezak.png"], description: "HomeZak adalah aplikasi Android yang dikembangkan menggunakan Sketchware dengan fokus pada antarmuka yang menarik dan fungsional. Aplikasi ini menyediakan browser internet dan home screen yang memungkinkan akses cepat ke berbagai platform sosial media, termasuk Instagram, LinkedIn, YouTube, Telegram, Facebook, TikTok, WhatsApp, dan GitHub. Dengan begitu, pengguna dapat menjelajahi Broswer Internet dalam satu tempat secara mudah dan efisien.", link: "https://github.com/mzkyzak/Homezak.git"),
  Project(id: 5, title: "App_Lock", subtitle: "Sketchware", img: "assets/App_lock.jpg", images: ["assets/App_lock.jpg"], description: "AppLock adalah aplikasi terkunci Dikembangkan menggunakan Sketchware Dengan berfokus antara load stres cpu/gpu agar perangkat pengguna mendapatkan lag and crash dan tidak dapat keluar dari aplikasi ini, tanpa memasukkan password yang benar, Jika passwordnya benar aplikasi ini bakal Keluar secara otomatis. Dan jika aplikasi ini tidak mampu di wajibkan reboot agar kembali normal.", link: "https://github.com/mzkyzak/App-lock-.git"),
  Project(id: 6, title: "Hack_camera", subtitle: "Kali Linux", img: "assets/Hack_camera.jpg", images: ["assets/Hack_camera.jpg"], description: "Hack camera Adalah link phising menggunakan Shell. Sebuah link phising itu, kaya Sebuah Website zoom meeting. jika ada pengguna memberikan izin akses kamera di website itu tanpa verifikasi yang jelas. kamera bakal otomatis ke photo di dalam folder Hack camera atau Di dalam photo files.", link: "https://github.com/mzkyzak/Hack-camera.git"),
];

final List<Tool> listTools = [
  Tool(name: "HTML", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg"), Tool(name: "CSS", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg"), Tool(name: "JavaScript", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg"), Tool(name: "React", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg"), Tool(name: "Tailwind", logo: "https://raw.githubusercontent.com/devicons/devicon/v2.16.0/icons/tailwindcss/tailwindcss-original.svg"), Tool(name: "PHP", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/php/php-original.svg"), Tool(name: "MySQL", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg"), Tool(name: "Android Studio", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/androidstudio/androidstudio-original.svg"), Tool(name: "Sketchware", logo: "assets/sketchware.jpg"), Tool(name: "Visual Code", logo: "https://upload.wikimedia.org/wikipedia/commons/9/9a/Visual_Studio_Code_1.35_icon.svg"),
];

final List<Tool> listOS = [ Tool(name: "Windows", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/windows8/windows8-original.svg"), Tool(name: "Android", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg"), Tool(name: "Ubuntu", logo: "https://upload.wikimedia.org/wikipedia/commons/9/9e/UbuntuCoF.svg"), Tool(name: "Linux", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg") ];
final List<Tool> listDesignTools = [ Tool(name: "Figma", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/figma/figma-original.svg"), Tool(name: "Unity", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/unity/unity-original.svg"), Tool(name: "Canva", logo: "https://www.vectorlogo.zone/logos/canva/canva-icon.svg"), Tool(name: "Lightroom", logo: "https://upload.wikimedia.org/wikipedia/commons/b/b6/Adobe_Photoshop_Lightroom_CC_logo.svg"), Tool(name: "Capcut", logo: "https://upload.wikimedia.org/wikipedia/commons/1/1c/Capcut-icon.svg") ];

final List<Certificate> listCertificates = [
  Certificate(id: 1, title: "Membangun aplikasi Gen Ai Dengan microsoft azure", issuer: "Dicoding Indonesia", img: "assets/sertifikat_ microsoft_azure.jpg", date: "01-03-2026"), Certificate(id: 2, title: "Belajar Microsoft Fabric", issuer: "Dicoding Indonesia", img: "assets/sertifikat_microsoft_belajar.jpg", date: "28-02-2026"), Certificate(id: 3, title: "AI READY ASEAN", issuer: "ASEAN FOUNDATION", img: "assets/certificate_asean.jpg", date: "20-02-2026"), Certificate(id: 4, title: "DFS 48 Design: UI/UX", issuer: "Dibimbing Id", img: "assets/certificate_Ui-Ux_11-feb.jpg", date: "11-02-2026"), Certificate(id: 5, title: "Back End", issuer: "Myskill", img: "assets/certificate_backendmyskill-19-des.jpg", date: "19-01-2026"), Certificate(id: 6, title: "Data Analyst", issuer: "MySkill", img: "assets/certificate_datamyskill-13-jan.jpg", date: "13-01-2026"), Certificate(id: 7, title: "DSF 46 Back-end", issuer: "Dibimbing Id", img: "assets/certificate_backend_19-des.jpg", date: "19-12-2025"), Certificate(id: 10, title: "DSF 46 Data Enginner", issuer: "Dibimbing Id", img: "assets/certificate_data_12-des.jpg", date: "12-12-2025"), Certificate(id: 11, title: "DSF 46 Design: UI/UX", issuer: "Dibimbing Id", img: "assets/certificate_12-des.jpg", date: "12-12-2025"), Certificate(id: 12, title: "Memulai Pemrograman java", issuer: "Dicoding Indonesia", img: "assets/sertifikat_java.jpg", date: "11-12-2025"), Certificate(id: 13, title: "Belajar Ai", issuer: "Dicoding Indonesia", img: "assets/sertifikat belajar_ai.jpg", date: "30-10-2025"), Certificate(id: 14, title: "Virtual Bootcamp UNSIA x UNAS", issuer: "Universitas Siber Asia", img: "assets/Sertifikat-Cyber_Security.jpg", date: "16-08-2024"), Certificate(id: 15, title: "Bimasakti Cup 1 Chapter PU-PK ", issuer: "founder Bimasakti Foundation.", img: "assets/SMPN 23 JAKARTA - Taufiq ikhsan muzaky.jpg", date: "24-03-2024"), Certificate(id: 16, title: "Jambore Ranting Pramuka", issuer: "Gerakan Pramuka tingkat kwarran Pademangan", img: "assets/sertifikat_Jambore-ragunan.jpg", date: "19-11-2023"), Certificate(id: 17, title: "Ujian PMR Tingkat madya", issuer: "PMI Kota Jakarta utara", img: "assets/sertifikat_ujian-pmr.jpg", date: "02-10-2023"), Certificate(id: 18, title: "Latihan Gabungan Tingkat madya", issuer: "SMP NURUL IMAN ARHANUD", img: "assets/sertifikat_Latihan-pmr-2022.jpg", date: "10-10-2022"), Certificate(id: 19, title: "ANBK", issuer: "Smpn 23 Jakarta", img: "assets/sertifikat_ANBK-2022.jpg", date: "20-09-2022"), Certificate(id: 20, title: "UKBI", issuer: "Smpn 23 Jakarta", img: "assets/sertifikat_UKBI-2022.jpg", date: "05-09-2022"),
];

final List<Social> listSocials = [
  Social(name: "LinkedIn", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg", url: "https://www.linkedin.com/in/taufiq-ikhsan-muzaky-42ab26388"), Social(name: "WhatsApp", logo: "https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg", url: "https://wa.me/6285810192529"), Social(name: "Instagram", logo: "https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg", url: "https://www.instagram.com/mzky_zak?igsh=eWN2cjlzeXhuMmR0"), Social(name: "GitHub", logo: "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg", url: "https://github.com/mzkyzak"), Social(name: "TikTok", logo: "https://upload.wikimedia.org/wikipedia/commons/3/34/Ionicons_logo-tiktok.svg", url: "https://www.tiktok.com/@mzky896?_r=1&_t=ZS-94NhHqsvv1R"), Social(name: "Youtube", logo: "https://upload.wikimedia.org/wikipedia/commons/0/09/YouTube_full-color_icon_%282017%29.svg", url: "https://youtube.com/@muzaky_2023?si=oe32_JqtG5jXNakL"),
];