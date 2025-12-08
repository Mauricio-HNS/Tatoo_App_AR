import 'package:flutter/material.dart';
import 'dart:math';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
  bool _loading = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe seu nome';
    if (v.trim().length < 2) return 'Nome muito curto';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe seu e-mail';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(v.trim())) return 'E-mail inválido';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final phone = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.length < 8) return 'Telefone muito curto';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha';
    if (v.length < 8) return 'Senha precisa ter ao menos 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(v))
      return 'Inclua ao menos 1 letra maiúscula';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Inclua ao menos 1 número';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirme a senha';
    if (v != _passwordCtrl.text) return 'As senhas não coincidem';
    return null;
  }

  double _passwordStrength(String password) {
    if (password.isEmpty) return 0.0;
    double score = 0;
    if (password.length >= 8) score += 0.4;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.2;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += 0.2;
    return score.clamp(0.0, 1.0);
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aceite os termos para continuar')),
      );
      return;
    }
    if (!form.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _loading = false);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bem-vindo!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            Text('Conta criada para ${_nameCtrl.text.trim()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final name = _nameCtrl.text.trim();
    final initials = name.isEmpty
        ? 'U'
        : name
              .split(' ')
              .where((s) => s.isNotEmpty)
              .map((s) => s[0])
              .take(2)
              .join();
    final color = Colors.primaries[name.length % Colors.primaries.length];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Avatar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Usar avatar padrão'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Gerar aleatório'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _nameCtrl.text = 'User ${Random().nextInt(999)}';
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: CircleAvatar(
        radius: 40,
        backgroundColor: color.shade400,
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label não implementado')));
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.purple.shade700, Colors.pinkAccent.shade100],
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: BoxDecoration(gradient: gradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Criar conta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildAvatar(),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Nome completo',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateName,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              validator: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Telefone (opcional)',
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: _validatePhone,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: _passwordStrength(
                                        _passwordCtrl.text,
                                      ),
                                      minHeight: 6,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _passwordStrength(_passwordCtrl.text) <=
                                                0.4
                                            ? Colors.red
                                            : _passwordStrength(
                                                    _passwordCtrl.text,
                                                  ) <=
                                                  0.7
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _passwordCtrl.text.isEmpty
                                      ? ''
                                      : (_passwordStrength(
                                                  _passwordCtrl.text,
                                                ) <=
                                                0.4
                                            ? 'Fraca'
                                            : _passwordStrength(
                                                    _passwordCtrl.text,
                                                  ) <=
                                                  0.7
                                            ? 'Boa'
                                            : 'Forte'),
                                  style: TextStyle(
                                    color:
                                        _passwordStrength(_passwordCtrl.text) <=
                                            0.4
                                        ? Colors.red
                                        : _passwordStrength(
                                                _passwordCtrl.text,
                                              ) <=
                                              0.7
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _confirmCtrl,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                labelText: 'Confirmar senha',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                ),
                              ),
                              validator: _validateConfirm,
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (v) =>
                                      setState(() => _acceptTerms = v ?? false),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _acceptTerms = !_acceptTerms,
                                    ),
                                    child: const Text(
                                      'Aceito os termos de uso e a política de privacidade',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Criar conta',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'ou entrar com',
                              style: TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialButton(
                                  Icons.apple,
                                  'Apple',
                                  Colors.black,
                                ),
                                const SizedBox(width: 12),
                                _socialButton(
                                  Icons.facebook,
                                  'Facebook',
                                  Colors.blue,
                                ),
                                const SizedBox(width: 12),
                                _socialButton(
                                  Icons.g_mobiledata,
                                  'Google',
                                  Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text(
                        'Já tem conta? Entrar',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
