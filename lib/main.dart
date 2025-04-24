import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PasswordSaver());
  }
}

class PasswordEntry {
  final String description;
  final String encryptedPassword;
  final String iv; // Store IV with each entry

  PasswordEntry(this.description, this.encryptedPassword, this.iv);
}

class PasswordSaver extends StatefulWidget {
  @override
  _PasswordSaverState createState() => _PasswordSaverState();
}

class _PasswordSaverState extends State<PasswordSaver> {
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<PasswordEntry> _entries = [];

  void _encryptAndSave(String key) {
    final aesKey = enc.Key.fromUtf8(_padKey(key));
    final iv = enc.IV.fromSecureRandom(16); // Generate random IV
    final encrypter = enc.Encrypter(enc.AES(aesKey));

    setState(() {
      _entries.add(PasswordEntry(
          _descriptionController.text,
          encrypter.encrypt(_passwordController.text, iv: iv).base64,
          iv.base64 // Store IV with the entry
          ));
      _passwordController.clear();
      _descriptionController.clear();
    });
  }

  String? _decrypt(PasswordEntry entry, String key) {
    try {
      final aesKey = enc.Key.fromUtf8(_padKey(key));
      final iv = enc.IV.fromBase64(entry.iv); // Use stored IV
      final encrypter = enc.Encrypter(enc.AES(aesKey));
      return encrypter.decrypt64(entry.encryptedPassword, iv: iv);
    } catch (e) {
      return null;
    }
  }

  String _padKey(String key) {
    // Ensure key is exactly 32 bytes long
    if (key.length < 32) {
      return key.padRight(32, '0').substring(0, 32);
    }
    return key.substring(0, 32);
  }

  Future<void> _showKeyDialog(PasswordEntry entry) async {
    final keyController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Private Key'),
        content: TextField(
          controller: keyController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Private key'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final decrypted = _decrypt(entry, keyController.text);

              if (!context.mounted) return;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Decrypted Password'),
                  content: SelectableText(decrypted ?? '❌ Invalid key!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    )
                  ],
                ),
              );
            },
            child: const Text('Decrypt'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEncryptDialog() async {
    final keyController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Private Key'),
        content: TextField(
          controller: keyController,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Private key'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _encryptAndSave(keyController.text);
            },
            child: const Text('Encrypt'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Vault')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _showEncryptDialog,
              child: const Text('Encrypt & Save'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return ListTile(
                    title: Text(entry.description),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Encrypted: ${entry.encryptedPassword}'),
                        Text('IV: ${entry.iv}',
                            style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.lock_open),
                      onPressed: () => _showKeyDialog(entry),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
