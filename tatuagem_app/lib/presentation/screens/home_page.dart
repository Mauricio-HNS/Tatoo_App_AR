import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> works = List.generate(
    6,
    (i) => 'https://picsum.photos/seed/tattoo$i/400/400',
  );

  final List<String> styles = [
    'Realismo',
    'Fineline',
    'Old School',
    'Neotradicional',
    'Blackwork',
    'Aquarela',
    'Tribal',
    'Minimal',
  ];

  final List<String> bodyRegions = [
    'Braço',
    'Antebraço',
    'Mão',
    'Perna',
    'Coxa',
    'Pé',
    'Costas',
    'Peito',
    'Ombro',
    'Bumbum',
    'Axila',
    'Pescoço',
    'Face',
    'Partes íntimas (genitais / períneo / seios)',
  ];

  final List<Map<String, String>> piercingShop = [
    {
      'name': 'Argola 925',
      'price': 'R\$ 49',
      'img': 'https://picsum.photos/seed/pierce1/200/200',
    },
    {
      'name': 'Barbell Titânio',
      'price': 'R\$ 79',
      'img': 'https://picsum.photos/seed/pierce2/200/200',
    },
    {
      'name': 'Stud Cristal',
      'price': 'R\$ 39',
      'img': 'https://picsum.photos/seed/pierce3/200/200',
    },
  ];

  final Set<String> selectedStyles = {};
  final Set<String> selectedRegions = {};
  String? selectedWork;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void toggleStyle(String style) {
    setState(() {
      if (selectedStyles.contains(style))
        selectedStyles.remove(style);
      else
        selectedStyles.add(style);
    });
  }

  void toggleRegion(String region) {
    setState(() {
      if (selectedRegions.contains(region))
        selectedRegions.remove(region);
      else
        selectedRegions.add(region);
    });
  }

  void openBookingSheet(BuildContext context, {String? forItem}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        String _formatDateTime(DateTime d) =>
            '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: FractionallySizedBox(
            heightFactor: 0.6,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.brush),
                  title: Text(
                    forItem != null ? 'Agendar: $forItem' : 'Agendar serviço',
                  ),
                  subtitle: const Text('Escolha data e horário'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Selecione uma data',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setState(() => selectedDate = date);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    selectedTime != null
                        ? selectedTime!.format(ctx)
                        : 'Selecione horário',
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) setState(() => selectedTime = time);
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Confirmar agendamento'),
                    onPressed: () {
                      if (selectedDate == null || selectedTime == null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Selecione data e horário'),
                          ),
                        );
                        return;
                      }
                      Navigator.of(ctx).pop();
                      final dt = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Agendado para ${_formatDateTime(dt)}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(
              'https://picsum.photos/seed/artist/200/200',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Bem-vindo(a)',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Escolha seu próximo traço',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => openBookingSheet(context),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: works.length,
        itemBuilder: (context, index) {
          final img = works[index];
          return GestureDetector(
            onTap: () => setState(() => selectedWork = img),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              elevation: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(img, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.35),
                        ],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Ver detalhes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildStylesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Estilos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: styles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final style = styles[index];
              final selected = selectedStyles.contains(style);
              return ChoiceChip(
                label: Text(style),
                selected: selected,
                onSelected: (_) => toggleStyle(style),
                selectedColor: Colors.black87,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildRegionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Regiões do corpo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: bodyRegions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final region = bodyRegions[index];
              final selected = selectedRegions.contains(region);
              return FilterChip(
                label: Text(region, overflow: TextOverflow.ellipsis),
                selected: selected,
                onSelected: (_) => toggleRegion(region),
                selectedColor: Colors.deepPurple,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            selectedRegions.isEmpty
                ? 'Nenhuma região selecionada'
                : 'Selecionado: ${selectedRegions.join(', ')}',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget buildPiercingShop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Piercings à venda',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: piercingShop.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = piercingShop[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 4,
                child: SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(item['img']!, fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              item['name']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['price']!,
                              style: const TextStyle(color: Colors.deepPurple),
                            ),
                            const SizedBox(height: 6),
                            ElevatedButton(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${item['name']} adicionado ao carrinho',
                                      ),
                                    ),
                                  ),
                              child: const Text('Comprar'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Buscar trabalhos'),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade de busca futura')),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () => openBookingSheet(context),
            child: const Icon(Icons.calendar_today),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Tatuagem • Estúdio'),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            buildHeader(),
            buildCarousel(),
            buildActionBar(),
            buildStylesSelector(),
            buildRegionSelector(),
            buildPiercingShop(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Galeria completa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: works.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final img = works[index];
                  return GestureDetector(
                    onTap: () => openBookingSheet(
                      context,
                      forItem: 'Referência #${index + 1}',
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(img, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
