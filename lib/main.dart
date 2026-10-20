import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Kunci untuk mengontrol & memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil teks dari field
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // FocusNode untuk berpindah antar field
  final _namaFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // State untuk Radio, Dropdown, Checkbox
  String? _jenisKelamin;
  String? _programStudi;
  bool _setuju = false;
  bool _genderError = false;
  bool _obscurePassword = true;

  final List<String> _daftarProdi = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _namaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    // Jalankan semua validator pada Form
    final formValid = _formKey.currentState!.validate();

    // Validasi manual untuk radio jenis kelamin
    setState(() => _genderError = _jenisKelamin == null);

    // Cek checkbox syarat & ketentuan -> SnackBar peringatan
    if (!_setuju) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan terlebih dahulu.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!formValid || _genderError) return;

    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Lengkap : ${_namaController.text}'),
            const SizedBox(height: 6),
            Text('Email : ${_emailController.text}'),
            const SizedBox(height: 6),
            Text('Password : ${'*' * _passwordController.text.length}'),
            const SizedBox(height: 6),
            Text('Jenis Kelamin : $_jenisKelamin'),
            const SizedBox(height: 6),
            Text('Program Studi : $_programStudi'),
            const SizedBox(height: 12),
            const Text('Apakah data di atas sudah benar?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registrasi berhasil!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              _resetForm();
            },
            child: const Text('Ya, Daftar'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _namaController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _jenisKelamin = null;
      _programStudi = null;
      _setuju = false;
      _genderError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Nama Lengkap =====
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocus),
              ),
              const SizedBox(height: 16),

              // ===== Email =====
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung "@"';
                  }
                  return null;
                },
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocus),
              ),
              const SizedBox(height: 16),

              // ===== Password =====
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _passwordFocus.unfocus(),
              ),
              const SizedBox(height: 20),

              // ===== Jenis Kelamin (Radio) =====
              const Text('Jenis Kelamin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              RadioListTile<String>(
                title: const Text('Laki-laki'),
                value: 'Laki-laki',
                groupValue: _jenisKelamin,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() {
                  _jenisKelamin = v;
                  _genderError = false;
                }),
              ),
              RadioListTile<String>(
                title: const Text('Perempuan'),
                value: 'Perempuan',
                groupValue: _jenisKelamin,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() {
                  _jenisKelamin = v;
                  _genderError = false;
                }),
              ),
              if (_genderError)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Pilih jenis kelamin',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // ===== Program Studi (Dropdown) =====
              DropdownButtonFormField<String>(
                value: _programStudi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                items: _daftarProdi
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _programStudi = v),
                validator: (value) =>
                value == null ? 'Pilih program studi' : null,
              ),
              const SizedBox(height: 12),

              // ===== Checkbox Syarat & Ketentuan =====
              CheckboxListTile(
                value: _setuju,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Saya menyetujui Syarat & Ketentuan'),
                onChanged: (v) => setState(() => _setuju = v ?? false),
              ),
              const SizedBox(height: 16),

              // ===== Tombol Daftar =====
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}