import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/university.dart';
import '../providers/universities_provider.dart';
import '../core/app_colors.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication, // importante en web
  )) {
    throw Exception('No se pudo abrir $url');
  }
}

class UniversityDetailPage extends ConsumerStatefulWidget {
  const UniversityDetailPage({
    super.key,
    required this.university,
    required this.index,
  });

  final University university;
  final int index;

  @override
  ConsumerState<UniversityDetailPage> createState() =>
      _UniversityDetailPageState();
}

class _UniversityDetailPageState extends ConsumerState<UniversityDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _studentsController;

  File? _image;

  @override
  void initState() {
    super.initState();

    _studentsController = TextEditingController();

    if (widget.university.imagePath != null) {
      _image = File(widget.university.imagePath!);
    }
  }

  @override
  void dispose() {
    _studentsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updatedUniversity = widget.university.copyWith(
      students: int.parse(_studentsController.text),
      imagePath: _image?.path,
    );

    ref
        .read(universitiesProvider.notifier)
        .updateUniversity(widget.index, updatedUniversity);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final university = widget.university;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(university.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSection(image: _image, onPickImage: _pickImage),
              const SizedBox(height: 24),
              Text(
                university.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('Country: ${university.country}'),
              Text('Students: ${university.students ?? 0}'),
              const SizedBox(height: 24),
              Text('Domains', style: Theme.of(context).textTheme.titleMedium),
              ...university.domains.map(Text.new),
              const SizedBox(height: 16),
              Text('Web pages', style: Theme.of(context).textTheme.titleMedium),
              ...university.webPages.map(
                (url) => InkWell(
                  onTap: () => openUrl(url),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      url,
                      style: const TextStyle(
                        color: AppColors.link,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _studentsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of students',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter number of students';
                  }

                  final number = int.tryParse(value);
                  if (number == null) {
                    return 'Must be a valid number';
                  }

                  if (number <= 0) {
                    return 'Must be greater than zero';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({required this.image, required this.onPickImage});

  final File? image;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image!, fit: BoxFit.cover),
                )
              : const Center(
                  child: Icon(Icons.school, size: 64, color: AppColors.grey),
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: const Text('Select image from gallery'),
          onPressed: onPickImage,
        ),
      ],
    );
  }
}
