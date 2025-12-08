import 'package:flutter/material.dart';

/// Tela de detalhe de uma tatuagem.
/// Uso:
/// Navigator.of(context).push(TattooDetailScreen.route(tattoo));
class TattooDetailScreen extends StatelessWidget {
  final Tattoo tattoo;

  const TattooDetailScreen({Key? key, required this.tattoo}) : super(key: key);

  static Route route(Tattoo tattoo) {
    return MaterialPageRoute(
      builder: (_) => TattooDetailScreen(tattoo: tattoo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tattoo.title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Integrar com share plugin se necessário
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageSection(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildInfoSection(context),
              ),
              if (tattoo.gallery.isNotEmpty) _buildGallerySection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Hero(
      tag: 'tattoo_${tattoo.id}',
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: tattoo.imageUrl.isNotEmpty
            ? Image.network(
                tattoo.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _imagePlaceholder();
                },
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image, size: 64, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tattoo.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: tattoo.artistAvatarUrl.isNotEmpty
                  ? NetworkImage(tattoo.artistAvatarUrl)
                  : null,
              child: tattoo.artistAvatarUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tattoo.artistName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              tattoo.price != null
                  ? 'R\$ ${tattoo.price!.toStringAsFixed(2)}'
                  : '',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(tattoo.description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tattoo.tags
              .map(
                (t) =>
                    Chip(label: Text(t), visualDensity: VisualDensity.compact),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Galeria',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: tattoo.gallery.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final url = tattoo.gallery[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url,
                  width: 140,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 140,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                tattoo.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
              ),
              onPressed: () {
                // Toggling de favorito: integrar com estado/serviço
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Abrir fluxo de agendamento
                },
                child: const Text('Agendar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modelo simples de Tattoo para demo.
/// Substitua por seu modelo do domínio se existir.
class Tattoo {
  final String id;
  final String title;
  final String description;
  final String artistName;
  final String artistAvatarUrl;
  final String imageUrl;
  final List<String> gallery;
  final List<String> tags;
  final double? price;
  final bool isFavorite;

  Tattoo({
    required this.id,
    required this.title,
    this.description = '',
    this.artistName = '',
    this.artistAvatarUrl = '',
    this.imageUrl = '',
    this.gallery = const [],
    this.tags = const [],
    this.price,
    this.isFavorite = false,
  });

  /// Exemplo estático para testes rápidos.
  static Tattoo example() => Tattoo(
    id: '1',
    title: 'Rosa Tradicional',
    description:
        'Tatuagem tradicional de rosa com sombreamento e linhas limpas.',
    artistName: 'Artista Exemplo',
    artistAvatarUrl: '',
    imageUrl: 'https://via.placeholder.com/800x450.png?text=Tattoo',
    gallery: [
      'https://via.placeholder.com/400.png?text=1',
      'https://via.placeholder.com/400.png?text=2',
    ],
    tags: ['tradicional', 'floral', 'preto'],
    price: 350.0,
  );
}
