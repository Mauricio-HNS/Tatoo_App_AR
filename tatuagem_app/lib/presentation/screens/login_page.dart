// File: /lib/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginScreenState();
}

enum UserRole { user, admin }

class _LoginScreenState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  UserRole _role = UserRole.user;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() {
      _loading = true;
    });

    // Fake authentication delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple example logic:
    // - If role is admin, require specific admin credentials (for demo).
    // - Otherwise accept any valid-looking email/password.
    if (_role == UserRole.admin) {
      if (email == 'admin@example.com' && password == 'admin123') {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
      } else {
        setState(() {
          _error = 'Credenciais de administrador inválidas.';
        });
      }
    } else {
      // basic validation already done by form, accept as "logged in"
      if (email.endsWith('@example.com') || email.contains('@')) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => UserHomeScreen(email: email)),
        );
      } else {
        setState(() {
          _error = 'Email inválido para usuário.';
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _roleToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Usuário'),
          selected: _role == UserRole.user,
          onSelected: (v) {
            setState(() {
              _role = UserRole.user;
            });
          },
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: const Text('Administrador'),
          selected: _role == UserRole.admin,
          onSelected: (v) {
            setState(() {
              _role = UserRole.admin;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _role == UserRole.admin ? 'Login — Admin' : 'Login — Usuário';
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    _roleToggle(),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Informe o email.';
                              if (!v.contains('@')) return 'Email inválido.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return 'Informe a senha.';
                              if (v.length < 6)
                                return 'Senha deve ter ao menos 6 caracteres.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _role == UserRole.admin
                                          ? 'Entrar como Admin'
                                          : 'Entrar',
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () {
                                        // placeholder: recover password flow
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Fluxo de recuperação não implementado.',
                                            ),
                                          ),
                                        );
                                      },
                                child: const Text('Esqueci a senha'),
                              ),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () {
                                        // placeholder: registration flow
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Cadastro não implementado.',
                                            ),
                                          ),
                                        );
                                      },
                                child: const Text('Criar conta'),
                              ),
                            ],
                          ),
                        ],
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

/// Simple placeholder user home screen
class UserHomeScreen extends StatelessWidget {
  final String email;
  const UserHomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home do Usuário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Bem-vindo, $email', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

/// Simple placeholder admin home screen
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Bem-vindo, Administrador', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
