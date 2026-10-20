import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _numberPhoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _agreeController = TextEditingController();
  DateTime? _birthDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  double _passwordStrength = 0;
  String _passwordStrengthLabel = '';

  Color get _passwordStrengthColor {
    if (_passwordStrength >= 1.0) return Colors.green;
    if (_passwordStrength >= 0.6) return Colors.orange;
    return Colors.red;
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _numberPhoneController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _agreeController.dispose();
    super.dispose();
  }

  // Validasi nama
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi nomor telepon
  String? _validateNumberPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (value.trim().length < 10 || value.trim().length > 13) {
      return 'Nomor telepon minimal 10 karakter dan maksimal 13 karakter';
    }
    final numberPhoneRegex = RegExp(r'^[0-9]+$');
    if (!numberPhoneRegex.hasMatch(value.trim())) {
      return 'Nomor telepon hanya boleh berisi angka';
    }
    return null;
  }

  // Validasi tanggal lahir
  String? _validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tanggal lahir tidak boleh kosong';
    }
    return null;
  }

  // Validasi gender
  String? _validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Gender tidak boleh kosong';
    }
    return null;
  }

  // Validasi persetujuan
  String? _validateAgree(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Persetujuan tidak boleh kosong';
    }
    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Hitung kekuatan password
  void _updatePasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _passwordStrengthLabel = '';
      });
      return;
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    final hasSymbol = RegExp(r'[^A-Za-z0-9\s]').hasMatch(value);

    final isStrong = value.length >= 8 &&
        hasUppercase &&
        hasLowercase &&
        hasDigit &&
        hasSymbol;
    final isMedium =
        value.length >= 8 && (hasUppercase || hasLowercase) && hasDigit;

    setState(() {
      if (isStrong) {
        _passwordStrength = 1.0;
        _passwordStrengthLabel = 'Kuat';
      } else if (isMedium) {
        _passwordStrength = 0.6;
        _passwordStrengthLabel = 'Sedang';
      } else {
        _passwordStrength = 0.3;
        _passwordStrengthLabel = 'Lemah';
      }
    });
  }

  // Validasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Handler submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulasi proses registrasi
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil'),
            content: Text(
              'Selamat, ${_nameController.text}!\n'
              'Email: ${_emailController.text}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  // Reset form
  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _numberPhoneController.clear();
    _birthDateController.clear();
    _birthDate = null;
    _genderController.clear();
    _agreeController.clear();
    _updatePasswordStrength('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // Header
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(fontSize: 14, color: Colors.grey),

                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),
                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                // Field Nomor Telepon
                CustomTextField(
                  controller: _numberPhoneController,
                  label: 'Nomor Telepon',
                  hint: 'Masukkan nomor telepon Anda',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: _validateNumberPhone,
                ),
                // Field Tanggal Lahir
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: () async {
                      final today = DateUtils.dateOnly(DateTime.now());
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _birthDate ?? today,
                        firstDate: DateTime(1900),
                        lastDate: today,
                        helpText: 'Pilih Tanggal Lahir',
                      );

                      if (pickedDate == null || !mounted) return;

                      setState(() {
                        _birthDate = pickedDate;
                        _birthDateController.text =
                            '${pickedDate.day.toString().padLeft(2, '0')}/'
                            '${pickedDate.month.toString().padLeft(2, '0')}/'
                            '${pickedDate.year}';
                      });
                    },
                    validator: _validateBirthDate,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
                      hintText: 'Masukkan tanggal lahir Anda',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                // Field Gender
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    validator: _validateGender,
                    onChanged: (value) {
                      setState(() {
                        _genderController.text = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      hintText: 'Pilih gender Anda',
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Laki-laki',
                        child: Text('Laki-laki'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Perempuan',
                        child: Text('Perempuan'),
                      ),
                    ],
                  ),
                ),
                // Field Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimal 8 karakter, huruf kapital, angka',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),

                      border: const OutlineInputBorder(),

                      filled: true,
                      fillColor: Colors.grey[50],
                    ),

                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                    onChanged: _updatePasswordStrength,
                  ),
                ),
                if (_passwordStrengthLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      left: 4.0,
                      right: 4.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: _passwordStrength,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                          backgroundColor: Colors.grey[300],
                          color: _passwordStrengthColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kekuatan password: $_passwordStrengthLabel',
                          style: TextStyle(
                            color: _passwordStrengthColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),

                      border: const OutlineInputBorder(),

                      filled: true,
                      fillColor: Colors.grey[50],
                    ),

                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                ),
                // Field Persetujuan
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: FormField<bool>(
                    initialValue: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        _validateAgree(value == true ? 'true' : null),
                    builder: (field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            value: field.value ?? false,
                            onChanged: (value) {
                              field.didChange(value);
                              setState(() {
                                _agreeController.text = value == true
                                    ? 'true'
                                    : '';
                              });
                            },
                            title: const Text(
                              'Setuju dengan Syarat & Ketentuan',
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 4.0,
                              ),
                              child: Text(
                                field.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
