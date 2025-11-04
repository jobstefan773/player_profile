import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_settings.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key, required this.initialSettings});

  final UserSettings initialSettings;

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _courtNameController;
  late final TextEditingController _courtRateController;
  late final TextEditingController _shuttlePriceController;
  late bool _divideEqually;

  @override
  void initState() {
    super.initState();
    _courtNameController = TextEditingController(
      text: widget.initialSettings.defaultCourtName,
    );
    _courtRateController = TextEditingController(
      text: widget.initialSettings.defaultCourtRate.toStringAsFixed(0),
    );
    _shuttlePriceController = TextEditingController(
      text: widget.initialSettings.defaultShuttlePrice.toStringAsFixed(0),
    );
    _divideEqually = widget.initialSettings.divideEqually;
  }

  @override
  void dispose() {
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttlePriceController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final settings = UserSettings(
      defaultCourtName: _courtNameController.text.trim(),
      defaultCourtRate: double.parse(_courtRateController.text.trim()),
      defaultShuttlePrice: double.parse(_shuttlePriceController.text.trim()),
      divideEqually: _divideEqually,
    );

    Navigator.of(context).pop(settings);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _courtNameController,
                decoration: const InputDecoration(
                  labelText: 'Default Court Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => _required(value, fieldName: 'Court name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _courtRateController,
                decoration: const InputDecoration(
                  labelText: 'Default Court Rate',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) =>
                    _doubleValidator(value, fieldName: 'Court rate'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _shuttlePriceController,
                decoration: const InputDecoration(
                  labelText: 'Default Shuttle Price',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) =>
                    _doubleValidator(value, fieldName: 'Shuttle price'),
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
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _saveSettings,
                child: const Text('Save Settings'),
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
