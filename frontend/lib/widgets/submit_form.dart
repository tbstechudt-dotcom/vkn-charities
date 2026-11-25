import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart';
import '../theme.dart';

enum FieldKind { text, email, phone, multiline, amount, dropdown }

class FieldSpec {
  const FieldSpec(
    this.key,
    this.label, {
    this.kind = FieldKind.text,
    this.required = false,
    this.options = const [],
    this.half = false,
  });

  final String key;
  final String label;
  final FieldKind kind;
  final bool required;

  /// For dropdowns: (value, label) pairs.
  final List<(String, String)> options;

  /// Shown side-by-side with the next half field on wide screens.
  final bool half;
}

/// Generic form card that validates input and posts it through [onSubmit].
class SubmitForm extends StatefulWidget {
  const SubmitForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    required this.buttonLabel,
    this.onChanged,
  });

  final List<FieldSpec> fields;
  final Future<String> Function(Map<String, dynamic> data) onSubmit;
  final String buttonLabel;
  final void Function(String key, String value)? onChanged;

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _text = {};
  final Map<String, String?> _drop = {};
  bool _busy = false;
  String? _success;
  String? _error;

  static final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      if (f.kind == FieldKind.dropdown) {
        _drop[f.key] = f.options.isNotEmpty ? f.options.first.$1 : null;
      } else {
        _text[f.key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validate(FieldSpec f, String? v) {
    final value = v?.trim() ?? '';
    if (f.required && value.isEmpty) return '${f.label} is required';
    if (value.isEmpty) return null;
    switch (f.kind) {
      case FieldKind.email:
        return _emailRe.hasMatch(value) ? null : 'Enter a valid email';
      case FieldKind.phone:
        return RegExp(r'^[+0-9()\-\s]{6,20}$').hasMatch(value) ? null : 'Enter a valid phone number';
      case FieldKind.amount:
        final n = double.tryParse(value);
        return (n == null || n <= 0) ? 'Enter a valid amount' : null;
      default:
        return null;
    }
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _success = null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = <String, dynamic>{
      for (final e in _text.entries) e.key: e.value.text.trim(),
      for (final e in _drop.entries) e.key: e.value,
    };

    setState(() => _busy = true);
    try {
      final msg = await widget.onSubmit(data);
      if (!mounted) return;
      _formKey.currentState?.reset();
      for (final c in _text.values) {
        c.clear();
      }
      setState(() {
        for (final f in widget.fields.where((f) => f.kind == FieldKind.dropdown)) {
          _drop[f.key] = f.options.isNotEmpty ? f.options.first.$1 : null;
        }
        _success = msg;
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _field(FieldSpec f) {
    final label = f.required ? '${f.label} *' : f.label;
    if (f.kind == FieldKind.dropdown) {
      return DropdownButtonFormField<String>(
        initialValue: _drop[f.key],
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final o in f.options)
            DropdownMenuItem(value: o.$1, child: Text(o.$2, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
        onChanged: (v) {
          setState(() => _drop[f.key] = v);
          if (v != null) widget.onChanged?.call(f.key, v);
        },
      );
    }
    return TextFormField(
      controller: _text[f.key],
      decoration: InputDecoration(labelText: label, alignLabelWithHint: f.kind == FieldKind.multiline),
      maxLines: f.kind == FieldKind.multiline ? 5 : 1,
      keyboardType: switch (f.kind) {
        FieldKind.email => TextInputType.emailAddress,
        FieldKind.phone => TextInputType.phone,
        FieldKind.amount => const TextInputType.numberWithOptions(decimal: true),
        FieldKind.multiline => TextInputType.multiline,
        _ => TextInputType.text,
      },
      inputFormatters: f.kind == FieldKind.amount ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
      validator: (v) => _validate(f, v),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 520;
      final rows = <Widget>[];
      for (var i = 0; i < widget.fields.length; i++) {
        final f = widget.fields[i];
        final next = i + 1 < widget.fields.length ? widget.fields[i + 1] : null;
        if (wide && f.half && next != null && next.half) {
          rows.add(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _field(f)),
            const SizedBox(width: 16),
            Expanded(child: _field(next)),
          ]));
          i++;
        } else {
          rows.add(_field(f));
        }
        rows.add(const SizedBox(height: 16));
      }

      return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ...rows,
          if (_success != null) _Banner(text: _success!, ok: true),
          if (_error != null) _Banner(text: _error!, ok: false),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox(
                      width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(widget.buttonLabel),
            ),
          ),
        ]),
      );
    });
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text, required this.ok});
  final String text;
  final bool ok;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ok ? AppColors.sage : const Color(0xFFFBE9E7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Icon(ok ? Icons.check_circle : Icons.error_outline, color: ok ? AppColors.forest : const Color(0xFFB3261E)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: AppColors.ink))),
        ]),
      );
}
