import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/data/services/validator.dart';
import 'package:flutter_lab/widgets/input.dart';

class StationDialog extends StatefulWidget {
  const StationDialog({
    required this.userId,
    super.key,
    this.existing,
  });

  final String userId;
  final Meteostation? existing;

  @override
  State<StationDialog> createState() => _StationDialogState();
}

class _StationDialogState extends State<StationDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _idController;

  String? _nameError;
  String? _locationError;
  String? _idError;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existing?.name ?? '');
    _locationController =
        TextEditingController(text: widget.existing?.location ?? '');
    _idController =
        TextEditingController(text: widget.existing?.id ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nameErr =
        Validator.validateStationName(_nameController.text.trim());
    final locErr =
        Validator.validateLocation(_locationController.text.trim());
    final idValue = _idController.text.trim();
    final idErr = idValue.isEmpty ? 'Device ID is required' : null;

    if (nameErr != null || locErr != null || idErr != null) {
      setState(() {
        _nameError = nameErr;
        _locationError = locErr;
        _idError = idErr;
      });
      return;
    }

    if (widget.existing == null) {
      await context.read<StationCubit>().addStation(
            Meteostation(
              id: idValue,
              name: _nameController.text.trim(),
              location: _locationController.text.trim(),
              userId: widget.userId,
            ),
          );
    } else {
      await context.read<StationCubit>().updateStation(
            widget.existing!.copyWith(
              name: _nameController.text.trim(),
              location: _locationController.text.trim(),
            ),
          );
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Station' : 'Add Station'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WeatherInput(
            label: 'Device ID',
            hintText: 'e.g. a1b2-c3d4-...',
            prefixIcon: Icons.fingerprint_outlined,
            controller: _idController,
            errorText: _idError,
            readOnly: isEdit,
          ),
          const SizedBox(height: 16),
          WeatherInput(
            label: 'Station Name',
            hintText: 'e.g. Roof Station',
            prefixIcon: Icons.sensors_outlined,
            controller: _nameController,
            errorText: _nameError,
          ),
          const SizedBox(height: 16),
          WeatherInput(
            label: 'Location',
            hintText: 'e.g. Lviv, Ukraine',
            prefixIcon: Icons.location_on_outlined,
            controller: _locationController,
            errorText: _locationError,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEdit ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
