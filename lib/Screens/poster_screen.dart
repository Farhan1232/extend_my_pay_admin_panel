import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/poster_provider.dart';
import '../Widgets/admin_layout.dart';

class PosterScreen extends StatefulWidget {
  const PosterScreen({Key? key}) : super(key: key);

  @override
  State<PosterScreen> createState() => _PosterScreenState();
}

class _PosterScreenState extends State<PosterScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PosterProvider>(context, listen: false).loadPosters();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PosterProvider>(context);

    return AdminLayout(
      screenTitle: "Manage Posters",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: prov.isLoading ? null : () => prov.upload(),
            icon: const Icon(Icons.upload),
            label: Text(prov.isLoading ? "Uploading..." : "Upload Poster"),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: prov.posters.isEmpty
                ? const Center(child: Text("No posters uploaded yet."))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: prov.posters.length,
                    itemBuilder: (c, i) {
                      final p = prov.posters[i];
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(p.imageUrl, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => prov.delete(p.id),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
