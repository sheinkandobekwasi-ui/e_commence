import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ============================================================================
/// AppImage Widget
/// Coursework Concept: Fully Local & Dynamic Image Strategy
/// ============================================================================
/// Renders product images without incurring cloud storage costs:
/// 1. Prioritizes local assets located in `assets/images/`
/// 2. Supports dynamic desktop/laptop file paths and Base64 data URIs for Web & Android
/// 3. Gracefully falls back to network URLs or clean styled placeholder thumbnails
/// 4. Maintains uncropped [BoxFit.contain] presentation to prevent clipping
class AppImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AppImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cleanPath = imagePath.trim();

    if (cleanPath.isEmpty) {
      return _buildFallback(theme);
    }

    final isBase64 =
        cleanPath.startsWith('data:image') || cleanPath.startsWith('base64,');
    final isNetwork =
        cleanPath.startsWith('http://') || cleanPath.startsWith('https://');
    final isAsset = cleanPath.startsWith('assets/');
    final isDeviceFile =
        !kIsWeb &&
        (cleanPath.contains(':\\') ||
            cleanPath.contains(':/') ||
            cleanPath.startsWith('/') ||
            cleanPath.startsWith('file:'));

    Widget imageWidget;

    if (isBase64) {
      try {
        final commaIdx = cleanPath.indexOf(',');
        final base64String =
            commaIdx != -1 ? cleanPath.substring(commaIdx + 1) : cleanPath;
        final bytes = base64Decode(base64String);
        imageWidget = Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          alignment: alignment,
          errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
        );
      } catch (_) {
        return _buildFallback(theme);
      }
    } else if (isDeviceFile) {
      final sanitizedPath = cleanPath.startsWith('file://')
          ? cleanPath.replaceFirst('file://', '')
          : cleanPath;
      imageWidget = Image.file(
        File(sanitizedPath),
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
      );
    } else if (isAsset) {
      imageWidget = Image.asset(
        cleanPath,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          // If the image was uploaded locally to assets/images/ at runtime,
          // load it directly via File to display without waiting for an asset re-bundle
          if (!kIsWeb && File(cleanPath).existsSync()) {
            return Image.file(
              File(cleanPath),
              fit: fit,
              width: width,
              height: height,
              alignment: alignment,
              errorBuilder: (_, _, _) => _buildFallback(theme),
            );
          }
          return _buildFallback(theme);
        },
      );
    } else if (isNetwork) {
      imageWidget = Image.network(
        cleanPath,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF8FAFC),
            alignment: Alignment.center,
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.primaryColor,
              ),
            ),
          );
        },
      );
    } else {
      // Direct asset fallback if only filename is given (e.g. "sweater.png")
      final fullAssetPath = 'assets/images/$cleanPath';
      imageWidget = Image.asset(
        fullAssetPath,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          if (!kIsWeb && File(fullAssetPath).existsSync()) {
            return Image.file(
              File(fullAssetPath),
              fit: fit,
              width: width,
              height: height,
              alignment: alignment,
              errorBuilder: (_, _, _) => _buildFallback(theme),
            );
          }
          if (!kIsWeb && File(cleanPath).existsSync()) {
            return Image.file(
              File(cleanPath),
              fit: fit,
              width: width,
              height: height,
              alignment: alignment,
              errorBuilder: (_, _, _) => _buildFallback(theme),
            );
          }
          return _buildFallback(theme);
        },
      );
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    if (backgroundColor != null) {
      return Container(
        color: backgroundColor,
        width: width,
        height: height,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasTightConstraints =
            constraints.hasBoundedHeight && constraints.maxHeight < 80;
        final hasTightWidth =
            constraints.hasBoundedWidth && constraints.maxWidth < 80;
        final isMini =
            hasTightConstraints ||
            hasTightWidth ||
            (height != null && height! < 80) ||
            (width != null && width! < 80);

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          ),
          alignment: Alignment.center,
          child: isMini
              ? Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: const Color(0xFF64748B),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 24,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Product Image',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
