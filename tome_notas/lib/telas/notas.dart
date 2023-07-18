import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Notas',
    theme: ThemeData(
      primaryColor: Color.fromARGB(255, 255, 94, 7),
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 114, 7),
    ),
    home: Notas(),
  ));
}

class Note {
  late String title;
  late String content;

  Note({
    required this.title,
    required this.content,
  });
}

class Notas extends StatefulWidget {
  @override
  _NotasState createState() => _NotasState();
}

class _NotasState extends State<Notas> {
  List<Note> _notes = [];
  Note? _currentNote;
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  late String conteudo;
  late String titulo;

  late TextEditingController contentController;
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    try {
      final notesSnapshot =
          await FirebaseFirestore.instance.collection('notas').get();
      setState(() {
        _notes = notesSnapshot.docs.map((doc) {
          return Note(
            title: doc.data()['titulo'],
            content: doc.data()['conteudo'],
          );
        }).toList();
      });
    } catch (e) {
      print('Erro ao carregar as notas: $e');
    }
  }

  void _addNote() async {
    try {
      await FirebaseFirestore.instance.collection('notas').add({
        'titulo': _titleController.text,
        'conteudo': _contentController.text,
      });

      setState(() {
        _notes.add(Note(
          title: _titleController.text,
          content: _contentController.text,
        ));
        _titleController.clear();
        _contentController.clear();
      });
    } catch (e) {
      print('Erro ao adicionar a nota: $e');
    }
  }

  void _editNote() async {
    try {
      await FirebaseFirestore.instance
          .collection('notas')
          .doc('5g3Gmq3j8znEYUvrV9oE')
          .update({
        'titulo': _titleController.text,
        'conteudo': _contentController.text,
      });

      setState(() {
        _currentNote!.title = _titleController.text;
        _currentNote!.content = _contentController.text;
        _titleController.clear();
        _contentController.clear();
        _currentNote = null;
      });
    } catch (e) {
      print('Erro ao editar a nota: $e');
    }
  }

  void _deleteNote() async {
    try {
      await FirebaseFirestore.instance
          .collection('notas')
          .doc('$_titleController.text')
          .delete();

      setState(() {
        _notes.remove(_currentNote);
        _titleController.clear();
        _contentController.clear();
        _currentNote = null;
      });
    } catch (e) {
      print('Erro ao excluir a nota: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 94, 7),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Procura o que?",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade100)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index].title),
                  subtitle: Text(_notes[index].content),
                  onTap: () {
                    setState(() {
                      _currentNote = _notes[index];
                      _titleController.text = _currentNote!.title;
                      _contentController.text = _currentNote!.content;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 255, 213, 179),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Conteúdo',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_currentNote == null) {
                      _addNote();
                    } else {
                      _editNote();
                    }
                  },
                  child: Text(_currentNote == null ? 'Adicionar' : 'Editar'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 255, 147, 7),
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                if (_currentNote != null)
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Apagar Nota'),
                            content: Text(
                              'Tem certeza de que deseja apagar esta nota?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Apagar'),
                                onPressed: () {
                                  _deleteNote();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Apagar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print('Erro ao fazer logout: $e');
  }
}
//como configurar para salvar as notas no firebase no meu banco com o nome de notas, 
//com campos "conteudo" e "titulo"