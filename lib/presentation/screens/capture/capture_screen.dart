import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'capture_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isFlashOn = false;
  bool _cameraReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
    if (mounted) setState(() => _cameraReady = true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _onCapture() async {
    if (_controller == null || !_cameraReady) return;
    final captureState = ref.read(captureNotifierProvider);
    if (captureState is CaptureStateScanning) return;

    final xFile = await _controller!.takePicture();
    await ref.read(captureNotifierProvider.notifier).onCapture(File(xFile.path));
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    _isFlashOn = !_isFlashOn;
    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }

  Future<void> _pickFromGallery() async {
    // TODO: Task 1.D.3 — menggunakan image_picker dari galeri
  }

  @override
  Widget build(BuildContext context) {
    final captureState = ref.watch(captureNotifierProvider);
    final isScanning = captureState is CaptureStateScanning;

    ref.listen<CaptureState>(captureNotifierProvider, (_, next) async {
      if (next is CaptureStateSuccess && mounted) {
        context.go('/reveal', extra: next.creature);
      } else if (next is CaptureStateFailed) {
        _showFailedSnackbar(next.reason);
      } else if (next is CaptureStateAmbiguous && mounted) {
        _showAmbiguousSheet(next);
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ─── Camera Viewfinder ─────────────────────────────────────
          if (_cameraReady && _controller != null)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize!.height,
                  height: _controller!.value.previewSize!.width,
                  child: CameraPreview(_controller!),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // ─── Overlay Crosshair ─────────────────────────────────────
          if (!isScanning) ...[
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CrosshairWidget(),
                  const SizedBox(height: 16),
                  Text(
                    'Arahkan ke hewan...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      shadows: [const Shadow(color: Colors.black54, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ─── AI Scanning Overlay ───────────────────────────────────
          if (isScanning)
            Container(
              color: Colors.black.withValues(alpha: 0.65),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'AI Menganalisis...',
                      style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mendeteksi spesies hewan',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ─── Top AppBar ────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                    onPressed: () => context.go('/home'),
                  ),
                  const Spacer(),
                  Text(
                    'Capture',
                    style: AppTextStyles.headingMedium.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // ─── Bottom Control Bar ────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gallery
                  _ControlButton(
                    icon: Icons.photo_library_rounded,
                    onTap: _pickFromGallery,
                  ),

                  // Capture button
                  GestureDetector(
                    onTap: isScanning ? null : _onCapture,
                    child: AnimatedScale(
                      scale: isScanning ? 0.9 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isScanning ? Colors.grey : Colors.white,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: isScanning
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white70,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Flash toggle
                  _ControlButton(
                    icon: _isFlashOn
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    onTap: _toggleFlash,
                    isActive: _isFlashOn,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAmbiguousSheet(CaptureStateAmbiguous state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceLow,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Spesies',
              style: AppTextStyles.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'AI tidak yakin dengan spesies ini.\nPilih yang paling cocok:',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
            ),
            const SizedBox(height: 16),
            ...state.options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    ref
                        .read(captureNotifierProvider.notifier)
                        .selectDetection(opt, state.imageFile);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.captureOrange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.captureOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.pets_rounded,
                                color: AppColors.captureOrange),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opt.commonName,
                                style: AppTextStyles.labelLarge,
                              ),
                              Text(
                                '${(opt.confidence * 100).toStringAsFixed(0)}% yakin',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.onSurfaceMed,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.onSurfaceLow),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFailedSnackbar(CaptureFailReason reason) {
    final msg = switch (reason) {
      CaptureFailReason.blurry   => '📷 Foto terlalu blur, coba lagi!',
      CaptureFailReason.notAnimal => '🔍 Tidak terdeteksi sebagai hewan',
      CaptureFailReason.unknown  => '❌ Terjadi kesalahan, coba lagi',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CrosshairWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(painter: _CrosshairPainter()),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const corner = 30.0;
    const r = 12.0;

    final paths = [
      // top-left
      [const Offset(0, corner), const Offset(0, r), const Offset(r, 0), const Offset(corner, 0)],
      // top-right
      [
        Offset(size.width - corner, 0), Offset(size.width - r, 0),
        Offset(size.width, r), Offset(size.width, corner)
      ],
      // bottom-left
      [
        Offset(0, size.height - corner), Offset(0, size.height - r),
        Offset(r, size.height), Offset(corner, size.height)
      ],
      // bottom-right
      [
        Offset(size.width - corner, size.height),
        Offset(size.width - r, size.height),
        Offset(size.width, size.height - r),
        Offset(size.width, size.height - corner)
      ],
    ];

    for (final pts in paths) {
      canvas.drawLine(pts[0], pts[1], paint);
      canvas.drawLine(pts[2], pts[3], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.4),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
