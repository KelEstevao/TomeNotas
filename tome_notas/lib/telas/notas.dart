import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Notas',
    theme: ThemeData(
      primaryColor: Colors.amber,
      scaffoldBackgroundColor: Colors.amber,
    ),
    home: Extra1(),
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

class Extra1 extends StatefulWidget {
  @override
  _Extra1State createState() => _Extra1State();
}

class _Extra1State extends State<Extra1> {
  List<Note> _notes = [];
  Note? _currentNote;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addNote() {
    setState(() {
      _notes.add(Note(
        title: _titleController.text,
        content: _contentController.text,
      ));
      _titleController.clear();
      _contentController.clear();
    });
  }

  void _editNote() {
    setState(() {
      _currentNote!.title = _titleController.text;
      _currentNote!.content = _contentController.text;
      _titleController.clear();
      _contentController.clear();
      _currentNote = null;
    });
  }

  void _deleteNote() {
    setState(() {
      _notes.remove(_currentNote);
      _titleController.clear();
      _contentController.clear();
      _currentNote = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
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
            color: Colors.amber[100],
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
                  onPressed: () {
                    if (_currentNote == null) {
                      _addNote();
                    } else {
                      _editNote();
                    }
                  },
                  child: Text(_currentNote == null ? 'Adicionar' : 'Editar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
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
