import 'dart:convert';
import 'dart:io' show Directory, File;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hettys_shop/data/mock_data.dart';
import 'package:hettys_shop/data/product_service.dart';
import 'package:hettys_shop/models/product.dart';
import 'package:hettys_shop/widgets/app_image.dart';
import 'package:hettys_shop/widgets/custom_button.dart';
import 'package:hettys_shop/widgets/custom_text_field.dart';

/// ============================================================================
/// AdminProductFormScreen
/// Coursework Concept: Admin Product Management, Form Validation & Local Storage
/// ============================================================================
/// Dedicated form screen for Administrator to:
/// 1. Add new products to the local inventory
/// 2. Edit & update existing products (pre-populating title, price, description,
///    functionality, quality specifications, durability, stock, and local image)
/// 3. Upload or replace desktop/PC images without incurring cloud storage billing
/// 4. Save updates directly to local device/PC storage (ProductService)
class AdminProductFormScreen extends StatefulWidget {
  final Product? productToEdit;

  const AdminProductFormScreen({super.key, this.productToEdit});

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descController;
  late final TextEditingController _functionalityController;
  late final TextEditingController _specsController;
  late final TextEditingController _durabilityController;
  late final TextEditingController _customImageController;

  late String _selectedCategory;
  late String _selectedImageAsset;
  String? _uploadedImageFileName;
  bool _isPickingImage = false;
  bool _isSaving = false;

  bool get isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
      text: p != null
          ? (p.price == p.price.roundToDouble()
              ? p.price.toInt().toString()
              : p.price.toStringAsFixed(2))
          : '',
    );
    _stockController = TextEditingController(
      text: p != null ? p.stock.toString() : '10',
    );
    _descController = TextEditingController(text: p?.description ?? '');
    _functionalityController = TextEditingController(
      text: p?.functionality ?? '',
    );

    // Format specifications map as "Key: Value" lines
    String initialSpecs =
        'Material: Premium Grade\nOrigin: Quality Sourced\nWarranty: 1 Year Shei Store';
    if (p != null && p.specifications.isNotEmpty) {
      initialSpecs = p.specifications.entries
          .map((e) => '${e.key}: ${e.value}')
          .join('\n');
    }
    _specsController = TextEditingController(text: initialSpecs);

    _durabilityController = TextEditingController(text: p?.durability ?? '');
    _customImageController = TextEditingController();

    // Category setup
    _selectedCategory = p?.category ?? 'Fashion';
    if (!MockData.categories.contains(_selectedCategory) ||
        _selectedCategory == 'All') {
      _selectedCategory = 'Fashion';
    }

    // Image setup
    if (p != null && p.image.isNotEmpty) {
      if (MockData.availableLocalAssets.contains(p.image)) {
        _selectedImageAsset = p.image;
      } else {
        _selectedImageAsset = MockData.availableLocalAssets.first;
        _customImageController.text = p.image;
        _uploadedImageFileName = p.image.split('/').last.split('\\').last;
      }
    } else {
      _selectedImageAsset = MockData.availableLocalAssets.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    _functionalityController.dispose();
    _specsController.dispose();
    _durabilityController.dispose();
    _customImageController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromDesktop() async {
    try {
      setState(() => _isPickingImage = true);

      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (file != null) {
        final fileName = file.name;
        _uploadedImageFileName = fileName;
        final fileBytes = await file.readAsBytes();

        String resolvedImagePath = '';

        if (kIsWeb) {
          // On Web: convert bytes to a Base64 Data URI
          final ext =
              (file.extension ?? fileName.split('.').last).toLowerCase();
          final mime =
              ext == 'png' ? 'png' : (ext == 'webp' ? 'webp' : 'jpeg');
          final base64Str = base64Encode(fileBytes);
          resolvedImagePath = 'data:image/$mime;base64,$base64Str';
        } else {
          // On Desktop (Windows/macOS/Linux) or mobile:
          // Try to copy/write to local project's assets/images folder if available,
          // or load via dynamic local file path
          final filePath = file.path;
          if (filePath != null && filePath.isNotEmpty) {
            try {
              final assetsDir = Directory('assets/images');
              if (!assetsDir.existsSync()) {
                assetsDir.createSync(recursive: true);
              }
              final safeFileName =
                  'custom_${DateTime.now().millisecondsSinceEpoch}_$fileName';
              final targetFile = File('${assetsDir.path}/$safeFileName');
              await targetFile.writeAsBytes(fileBytes);
              resolvedImagePath = 'assets/images/$safeFileName';
              debugPrint(
                '[Admin] Saved desktop file to local project assets: ${targetFile.path}',
              );
            } catch (copyErr) {
              debugPrint('[Admin] Copy fallback to direct file path: $copyErr');
              resolvedImagePath = filePath;
            }
          } else {
            final ext =
                (file.extension ?? fileName.split('.').last).toLowerCase();
            final mime =
                ext == 'png' ? 'png' : (ext == 'webp' ? 'webp' : 'jpeg');
            final base64Str = base64Encode(fileBytes);
            resolvedImagePath = 'data:image/$mime;base64,$base64Str';
          }
        }

        if (resolvedImagePath.isNotEmpty) {
          setState(() {
            _customImageController.text = resolvedImagePath;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected image from storage: $fileName'),
                backgroundColor: const Color(0xFF10B981),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('[Admin] File picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File picker error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _handleSaveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 1;

    // Parse simple key-value specifications from text lines
    final Map<String, String> specsMap = {};
    for (final line in _specsController.text.split('\n')) {
      if (line.contains(':')) {
        final parts = line.split(':');
        final key = parts[0].trim();
        final val = parts.sublist(1).join(':').trim();
        if (key.isNotEmpty && val.isNotEmpty) {
          specsMap[key] = val;
        }
      }
    }

    final customUrl = _customImageController.text.trim();
    final imageToUse = customUrl.isNotEmpty ? customUrl : _selectedImageAsset;

    if (isEditing) {
      // Update existing product
      final updatedProduct = widget.productToEdit!.copyWith(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: price,
        image: imageToUse,
        category: _selectedCategory,
        stock: stock,
        functionality: _functionalityController.text.trim(),
        specifications: specsMap,
        durability: _durabilityController.text.trim(),
      );

      await ProductService().updateProduct(updatedProduct);

      if (!mounted) return;
      setState(() => _isSaving = false);
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully updated "${updatedProduct.name}" in local inventory!',
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    } else {
      // Add new product
      final newProduct = Product(
        id: 'p-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: price,
        image: imageToUse,
        category: _selectedCategory,
        stock: stock,
        rating: 4.8,
        functionality: _functionalityController.text.trim(),
        specifications: specsMap,
        durability: _durabilityController.text.trim(),
      );

      await ProductService().addProduct(newProduct);

      if (!mounted) return;
      setState(() => _isSaving = false);
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully added "${newProduct.name}" to local store catalog!',
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = MockData.categories
        .where((c) => c != 'All')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Information Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A11CB).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isEditing
                              ? Icons.edit_note_rounded
                              : Icons.add_business_rounded,
                          color: const Color(0xFF6A11CB),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'Modifying: ${widget.productToEdit!.name}'
                                  : 'Add Product to Shei Store Catalog',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Managed 100% locally on PC/device • Zero cloud storage costs',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------- 1. PRODUCT IMAGE SOURCE ----------------
                const Text(
                  'Product Image Source (Zero Cloud Cost) *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),

                // Desktop / PC file upload button
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                _isPickingImage ? null : _pickImageFromDesktop,
                            icon: _isPickingImage
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload_file_rounded, size: 18),
                            label: Text(
                              _uploadedImageFileName != null ||
                                      (isEditing &&
                                          _customImageController.text.isNotEmpty)
                                  ? 'Replace PC Image'
                                  : 'Upload from PC',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A11CB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _uploadedImageFileName != null
                                  ? 'Selected: $_uploadedImageFileName'
                                  : 'Browse desktop/laptop storage (.png, .jpg, .webp)',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: _uploadedImageFileName != null
                                    ? const Color(0xFF047857)
                                    : const Color(0xFF64748B),
                                fontWeight: _uploadedImageFileName != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Image Preview & Local Asset Options
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: AppImage(
                          imagePath:
                              _customImageController.text.trim().isNotEmpty
                                  ? _customImageController.text.trim()
                                  : _selectedImageAsset,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedImageAsset,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Or Choose Local Asset File',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                          menuMaxHeight: 250,
                          items: MockData.availableLocalAssets.map((asset) {
                            final filename = asset.split('/').last;
                            return DropdownMenuItem<String>(
                              value: asset,
                              child: Text(
                                filename,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedImageAsset = val;
                                _uploadedImageFileName = null;
                                _customImageController.text = '';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Custom Image Path / URL
                CustomTextField(
                  controller: _customImageController,
                  label: 'Or Custom Image URL / Local Path',
                  hintText:
                      'e.g. assets/images/... or local PC path or https://...',
                  prefixIcon: Icons.link_rounded,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // ---------------- 2. PRODUCT NAME ----------------
                CustomTextField(
                  controller: _nameController,
                  label: 'Product Title *',
                  hintText: 'e.g. Heritage Gold Kente Blazer',
                  prefixIcon: Icons.title,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Product title required'
                      : null,
                ),

                const SizedBox(height: 16),

                // ---------------- 3. CATEGORY & PRICE (GH₵) ----------------
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        items: availableCategories.map((c) {
                          return DropdownMenuItem(value: c, child: Text(c));
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _selectedCategory = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        label: 'Price in GH₵ *',
                        hintText: 'e.g. 145.00',
                        prefixIcon: Icons.payments_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Price required';
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ---------------- 4. STOCK QUANTITY ----------------
                CustomTextField(
                  controller: _stockController,
                  label: 'Stock Quantity *',
                  hintText: 'e.g. 15',
                  prefixIcon: Icons.inventory_2_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || int.tryParse(v.trim()) == null) {
                      return 'Valid stock number required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ---------------- 5. GENERAL DESCRIPTION ----------------
                CustomTextField(
                  controller: _descController,
                  label: 'General Description *',
                  hintText:
                      'Explain the core aesthetics, design, and styling...',
                  prefixIcon: Icons.description_outlined,
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description required'
                      : null,
                ),

                const SizedBox(height: 16),

                // ---------------- 6. FUNCTIONALITY & PERFORMANCE ----------------
                CustomTextField(
                  controller: _functionalityController,
                  label: 'Functionality & Performance *',
                  hintText:
                      'e.g. Engineered for all-weather wear with windproof closure...',
                  prefixIcon: Icons.tune_rounded,
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Functionality details required'
                      : null,
                ),

                const SizedBox(height: 16),

                // ---------------- 7. QUALITY SPECIFICATIONS ----------------
                CustomTextField(
                  controller: _specsController,
                  label: 'Quality Specifications (Key: Value per line) *',
                  hintText:
                      'Material: 100% Wool\nWeight: 420 GSM\nHardware: Brass',
                  prefixIcon: Icons.format_list_bulleted,
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Specifications required'
                      : null,
                ),

                const SizedBox(height: 16),

                // ---------------- 8. DURABILITY & LONGEVITY ----------------
                CustomTextField(
                  controller: _durabilityController,
                  label: 'Durability & Longevity *',
                  hintText:
                      'e.g. Double-stitched seams tested for 5+ seasons of daily use...',
                  prefixIcon: Icons.shield_outlined,
                  maxLines: 2,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Durability details required'
                      : null,
                ),

                const SizedBox(height: 24),

                // ---------------- SAVE BUTTON ----------------
                CustomButton(
                  text: isEditing
                      ? 'Save & Update Product Inventory'
                      : 'Save & Publish Product to Store',
                  icon: isEditing
                      ? Icons.check_circle_outline
                      : Icons.publish_rounded,
                  isLoading: _isSaving,
                  backgroundColor: const Color(0xFF6A11CB),
                  onPressed: _handleSaveProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
