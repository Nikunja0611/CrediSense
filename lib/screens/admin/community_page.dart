import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference postsRef =
      FirebaseFirestore.instance.collection("community_posts");

  Future<void> _addPost() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) return;

    await postsRef.add({
      "title": _titleController.text.trim(),
      "message": _messageController.text.trim(),
      "createdAt": FieldValue.serverTimestamp(),
    });

    _titleController.clear();
    _messageController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post added successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Community',
          style: Theme.of(context).appBarTheme.titleTextStyle ?? 
                 const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Post new message form
            Card(
              elevation: 2,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create New Post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        )),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: "Message"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addPost,
                      child: const Text("Post to Community"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Show posts
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: postsRef.orderBy("createdAt", descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No posts yet."));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildPostCard(
                        data["title"] ?? "No Title",
                        data["message"] ?? "",
                        data["createdAt"] != null
                            ? (data["createdAt"] as Timestamp).toDate().toString().split(" ").first
                            : "N/A",
                        context,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(String title, String message, String date, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(message),
            const SizedBox(height: 6),
            Text("Posted on: $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
