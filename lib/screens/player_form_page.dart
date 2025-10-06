import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/badminton_levels.dart';
import '../models/player.dart';
import '../widgets/level_legend.dart';
import '../widgets/player_text_field.dart';

class PlayerFormPage extends StatefulWidget {
  const PlayerFormPage({
    super.key,
    required this.title,
    this.initialPlayer,
    required this.onSubmit,
    this.onDelete,
    required this.existingPlayers,
  });

  final String title;
  final Player? initialPlayer;
  final ValueChanged<Player> onSubmit;
  final ValueChanged<Player>? onDelete;
  final List<Player> existingPlayers;

  bool get isEditing => initialPlayer != null;

  @override
  State<PlayerFormPage> createState() => _PlayerFormPageState();
}

class _PlayerFormPageState extends State<PlayerFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nicknameController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _contactController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _remarksController;
  late RangeValues _levelRange;

  @override
  void initState() {
    super.initState();
    final player = widget.initialPlayer;
    _nicknameController = TextEditingController(text: player?.nickname ?? '');
    _fullNameController = TextEditingController(text: player?.fullName ?? '');
    _contactController = TextEditingController(
      text: player?.contactNumber ?? '',
    );
    _emailController = TextEditingController(text: player?.email ?? '');
    _addressController = TextEditingController(text: player?.address ?? '');
    _remarksController = TextEditingController(text: player?.remarks ?? '');
    _levelRange = player?.levelRange ?? const RangeValues(6, 8);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _savePlayer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final roundedRange = RangeValues(
      _levelRange.start.roundToDouble(),
      _levelRange.end.roundToDouble(),
    );

    final player = Player(
      id: widget.initialPlayer?.id,
      nickname: _nicknameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      contactNumber: _contactController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      remarks: _remarksController.text.trim(),
      levelRange: roundedRange,
    );

    widget.onSubmit(player);
    Navigator.of(context).pop();
  }

  Future<void> _deletePlayer() async {
    final player = widget.initialPlayer;
    final onDelete = widget.onDelete;
    if (player == null || onDelete == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text('Delete ${player.nickname}? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      onDelete(player);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  String? _requiredValidator(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _nicknameValidator(String? value) {
    final basic = _requiredValidator(value, fieldName: 'Nickname');
    if (basic != null) {
      return basic;
    }
    final trimmed = value!.trim().toLowerCase();
    final exists = widget.existingPlayers
        .where((player) => player.id != widget.initialPlayer?.id)
        .any((player) => player.nickname.toLowerCase() == trimmed);
    if (exists) {
      return 'Nickname already exists';
    }
    return null;
  }

  String? _fullNameValidator(String? value) {
    final basic = _requiredValidator(value, fieldName: 'Full name');
    if (basic != null) {
      return basic;
    }
    final trimmed = value!.trim().toLowerCase();
    final exists = widget.existingPlayers
        .where((player) => player.id != widget.initialPlayer?.id)
        .any((player) => player.fullName.toLowerCase() == trimmed);
    if (exists) {
      return 'Full name already exists';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final basic = _requiredValidator(value, fieldName: 'Email');
    if (basic != null) {
      return basic;
    }
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _contactValidator(String? value) {
    final basic = _requiredValidator(value, fieldName: 'Contact number');
    if (basic != null) {
      return basic;
    }
    final digitsOnly = RegExp(r'^\d+$');
    if (!digitsOnly.hasMatch(value!.trim())) {
      return 'Use digits only';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              PlayerTextField(
                controller: _nicknameController,
                label: 'Nickname',
                hint: 'Enter nickname',
                icon: Icons.person,
                textInputAction: TextInputAction.next,
                validator: _nicknameValidator,
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'Enter full name',
                icon: Icons.badge,
                textInputAction: TextInputAction.next,
                validator: _fullNameValidator,
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _contactController,
                label: 'Mobile Number',
                hint: 'Digits only',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _contactValidator,
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'name@email.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _emailValidator,
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _addressController,
                label: 'Home Address',
                hint: 'Street, City',
                icon: Icons.location_pin,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.streetAddress,
                minLines: 1,
                maxLines: 3,
                textAlignVertical: TextAlignVertical.top,
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _remarksController,
                label: 'Remarks',
                hint: 'Additional notes',
                icon: Icons.menu_book,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                maxLines: 3,
                textAlignVertical: TextAlignVertical.top,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Level', style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  showValueIndicator: ShowValueIndicator.onDrag,
                  trackHeight: 4,
                  overlayShape: SliderComponentShape.noOverlay,
                  overlayColor: Colors.transparent,
                  rangeTrackShape: const RectangularRangeSliderTrackShape(),
                ),
                child: RangeSlider(
                  values: _levelRange,
                  min: 0,
                  max: (kBadmintonLevelTicks.length - 1).toDouble(),
                  divisions: kBadmintonLevelTicks.length - 1,
                  labels: RangeLabels(
                    levelLabelForIndex(_levelRange.start.round()),
                    levelLabelForIndex(_levelRange.end.round()),
                  ),
                  onChanged: (values) {
                    setState(() {
                      _levelRange = RangeValues(
                        values.start.clamp(
                          0,
                          (kBadmintonLevelTicks.length - 1).toDouble(),
                        ),
                        values.end.clamp(
                          0,
                          (kBadmintonLevelTicks.length - 1).toDouble(),
                        ),
                      );
                    });
                  },
                ),
              ),
              LevelLegend(theme: theme),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  describeLevelRange(_levelRange),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _savePlayer,
                      child: Text(isEditing ? 'Update Player' : 'Save Player'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
              if (isEditing && widget.onDelete != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _deletePlayer,
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.errorContainer,
                      foregroundColor: theme.colorScheme.onErrorContainer,
                    ),
                    child: const Text('Delete Player'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
