import 'package:flutter/material.dart';
import 'package:dakikadeger/models/note.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  final DataService dataService;

  const NotesPage({Key? key, required this.dataService}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Notlar'),
        backgroundColor: Colors.purple.shade700,
      ),
      body: _buildNotesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(),
        backgroundColor: Colors.purple.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList() {
    final notes = widget.dataService.getNotes();
    final sortedNotes = List<Note>.from(notes)
      ..sort((a, b) => b.date.compareTo(a.date));

    if (sortedNotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Henüz bir not eklenmedi',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sortedNotes.length,
      itemBuilder: (context, index) {
        final note = sortedNotes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showEditNoteDialog(note),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('dd MMMM yyyy', 'tr_TR').format(note.date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteNote(note.id),
                    tooltip: 'Sil',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (note.content.length > 100)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Devamını görmek için dokunun',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    final controller = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Yeni Not'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tarih',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      locale: const Locale('tr', 'TR'),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat(
                            'dd MMMM yyyy',
                            'tr_TR',
                          ).format(selectedDate),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Not',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Notunuzu yazın...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen bir not yazın'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final note = Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: selectedDate,
                  content: controller.text.trim(),
                  createdAt: DateTime.now(),
                );

                widget.dataService.saveNote(note);
                setState(() {});
                Navigator.pop(context);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Not eklendi'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
              ),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final controller = TextEditingController(text: note.content);
    DateTime selectedDate = note.date;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Notu Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tarih',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      locale: const Locale('tr', 'TR'),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat(
                            'dd MMMM yyyy',
                            'tr_TR',
                          ).format(selectedDate),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Not',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Notunuzu yazın...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen bir not yazın'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final updatedNote = Note(
                  id: note.id,
                  date: selectedDate,
                  content: controller.text.trim(),
                  createdAt: note.createdAt,
                );

                widget.dataService.saveNote(updatedNote);
                Navigator.pop(context);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Not güncellendi'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
              ),
              child: const Text('Güncelle'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteNote(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sil'),
        content: const Text('Bu notu silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.dataService.deleteNote(id);
              Navigator.pop(context);
              setState(() {});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Not silindi'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
