import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game.dart';
import '../models/user_settings.dart';
import '../widgets/player_text_field.dart';

class GameFormPage extends StatefulWidget {
  const GameFormPage({
    super.key,
    required this.title,
    required this.userSettings,
    required this.existingGames,
    this.initialGame,
  });

  final String title;
  final UserSettings userSettings;
  final List<Game> existingGames;
  final Game? initialGame;

  bool get isEditing => initialGame != null;

  @override
  State<GameFormPage> createState() => _GameFormPageState();
}

class _GameFormPageState extends State<GameFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _courtNameController;
  late final TextEditingController _courtRateController;
  late final TextEditingController _shuttlePriceController;
  late final TextEditingController _playerCountController;
  late bool _divideEqually;
  late List<GameSchedule> _schedules;

  @override
  void initState() {
    super.initState();
    final game = widget.initialGame;
    _titleController = TextEditingController(text: game?.title ?? '');
    _courtNameController = TextEditingController(
      text: game?.courtName ?? widget.userSettings.defaultCourtName,
    );
    _courtRateController = TextEditingController(
      text: (game?.courtRate ?? widget.userSettings.defaultCourtRate)
          .toStringAsFixed(0),
    );
    _shuttlePriceController = TextEditingController(
      text: (game?.shuttlePrice ?? widget.userSettings.defaultShuttlePrice)
          .toStringAsFixed(0),
    );
    _divideEqually = game?.divideEqually ?? widget.userSettings.divideEqually;
    _playerCountController = TextEditingController(
      text: (game?.playerCount ?? 4).toString(),
    );
    _schedules = List<GameSchedule>.from(game?.schedules ?? const []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttlePriceController.dispose();
    _playerCountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one schedule.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final courtRate = double.parse(_courtRateController.text.trim());
    final shuttlePrice = double.parse(_shuttlePriceController.text.trim());
    final playerCount = int.parse(_playerCountController.text.trim());

    final rawTitle = _titleController.text.trim();
    final resolvedTitle = rawTitle.isEmpty
        ? _schedules.first.formattedDate
        : rawTitle;
    final titleExists = widget.existingGames
        .where((game) => game.id != widget.initialGame?.id)
        .any((game) => game.title.toLowerCase() == resolvedTitle.toLowerCase());
    if (titleExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A game with this title already exists.')),
      );
      return;
    }

    final game = Game(
      id: widget.initialGame?.id,
      title: resolvedTitle,
      courtName: _courtNameController.text.trim(),
      courtRate: courtRate,
      shuttlePrice: shuttlePrice,
      divideEqually: _divideEqually,
      playerCount: playerCount,
      schedules: _schedules,
      playerIds: widget.initialGame?.playerIds ?? const [],
    );

    Navigator.of(context).pop(game);
  }

  Future<void> _addSchedule() async {
    final result = await showDialog<GameSchedule>(
      context: context,
      builder: (context) => _ScheduleDialog(),
    );
    if (result != null) {
      setState(() {
        _schedules = List<GameSchedule>.from(_schedules)..add(result);
      });
    }
  }

  void _removeSchedule(GameSchedule schedule) {
    setState(() {
      _schedules = List<GameSchedule>.from(_schedules)..remove(schedule);
    });
  }

  String? _required(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _doubleValidator(String? value, {required String fieldName}) {
    final requiredResult = _required(value, fieldName: fieldName);
    if (requiredResult != null) {
      return requiredResult;
    }
    final parsed = double.tryParse(value!.trim());
    if (parsed == null || parsed < 0) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _playerCountValidator(String? value) {
    final requiredResult = _required(value, fieldName: 'Number of players');
    if (requiredResult != null) {
      return requiredResult;
    }
    final parsed = int.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid whole number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PlayerTextField(
                controller: _titleController,
                label: 'Game Title',
                hint: 'Optional (defaults to schedule date)',
                icon: Icons.flag,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _courtNameController,
                label: 'Court Name',
                hint: 'Enter court name',
                icon: Icons.sports_tennis,
                textInputAction: TextInputAction.next,
                validator: (value) => _required(value, fieldName: 'Court name'),
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _courtRateController,
                label: 'Court Rate',
                hint: 'Per game cost',
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) =>
                    _doubleValidator(value, fieldName: 'Court rate'),
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _shuttlePriceController,
                label: 'Shuttle Price',
                hint: 'Shuttle cock per game',
                icon: Icons.sports,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) =>
                    _doubleValidator(value, fieldName: 'Shuttle price'),
              ),
              const SizedBox(height: 16),
              PlayerTextField(
                controller: _playerCountController,
                label: 'Number of Players',
                hint: 'e.g., 4',
                icon: Icons.group,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _playerCountValidator,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _divideEqually,
                onChanged: (value) {
                  setState(() {
                    _divideEqually = value ?? true;
                  });
                },
                title: const Text('Divide the court equally among players'),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Schedules',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    onPressed: _addSchedule,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Schedule'),
                  ),
                ],
              ),
              if (_schedules.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No schedules yet. Tap "Add Schedule".'),
                ),
              ..._schedules.map(
                (schedule) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      '${schedule.courtName} • ${schedule.formattedDate}',
                    ),
                    subtitle: Text(schedule.formattedTimeRange),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _removeSchedule(schedule),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(widget.isEditing ? 'Update Game' : 'Save Game'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleDialog extends StatefulWidget {
  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courtController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _start;
  TimeOfDay? _end;

  @override
  void dispose() {
    _courtController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (result != null) {
      setState(() => _date = result);
    }
  }

  Future<void> _pickTime({required bool start}) async {
    final initial = TimeOfDay.now();
    final result = await showTimePicker(
      context: context,
      initialTime: start ? (_start ?? initial) : (_end ?? initial),
    );
    if (result != null) {
      setState(() {
        if (start) {
          _start = result;
        } else {
          _end = result;
        }
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_date == null || _start == null || _end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select date, start, and end time.')),
      );
      return;
    }
    final startDateTime = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _start!.hour,
      _start!.minute,
    );
    final endDateTime = DateTime(
      _date!.year,
      _date!.month,
      _date!.day,
      _end!.hour,
      _end!.minute,
    );
    if (!endDateTime.isAfter(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }

    Navigator.of(context).pop(
      GameSchedule(
        courtName: _courtController.text.trim().isEmpty
            ? 'Court 1'
            : _courtController.text.trim(),
        start: startDateTime,
        end: endDateTime,
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Schedule'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _courtController,
              decoration: const InputDecoration(
                labelText: 'Court Name/Number',
                border: OutlineInputBorder(),
              ),
              validator: _required,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _date == null
                    ? 'Select Date'
                    : '${_date!.month}/${_date!.day}/${_date!.year}',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(start: true),
                    icon: const Icon(Icons.schedule),
                    label: Text(
                      _start == null ? 'Start Time' : _start!.format(context),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickTime(start: false),
                    icon: const Icon(Icons.schedule_outlined),
                    label: Text(
                      _end == null ? 'End Time' : _end!.format(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
