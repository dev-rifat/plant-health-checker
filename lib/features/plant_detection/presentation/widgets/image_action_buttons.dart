import 'package:flutter/material.dart';

/// Widget for image action buttons
class ImageActionButtons extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageActionButtons({
    Key? key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x332E7D32),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: onCameraPressed,
            icon: const Icon(Icons.camera_alt_rounded, size: 22),
            label: const Text('ক্যামেরা থেকে ধরুন / Take Photo'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: onGalleryPressed,
          icon: const Icon(Icons.image_rounded, size: 22),
          label: const Text('গ্যালারি থেকে বেছে নিন / Choose from Gallery'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(58),
            foregroundColor: const Color(0xFF1B5E20),
            side: const BorderSide(color: Color(0xFFB8D8BC), width: 1.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            backgroundColor: const Color(0xFFF5FBF6),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
