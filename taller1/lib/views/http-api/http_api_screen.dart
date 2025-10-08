import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/joke.dart';
import '../../services/chuck_norris_service.dart';
import '../../widgets/base_view.dart';

enum LoadingState { initial, loading, success, error }

class HttpApiScreen extends StatefulWidget {
  const HttpApiScreen({super.key});

  @override
  State<HttpApiScreen> createState() => _HttpApiScreenState();
}

class _HttpApiScreenState extends State<HttpApiScreen> {
  LoadingState _loadingState = LoadingState.initial;
  List<Joke> _jokes = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mostrar configuración del servicio en debug
    ChuckNorrisService.logConfiguration();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _loadingState = LoadingState.loading;
    });

    try {
      // Cargar categorías y chistes iniciales en paralelo
      final results = await Future.wait([
        ChuckNorrisService.getCategories(),
        ChuckNorrisService.getMultipleRandomJokes(count: 10),
      ]);

      final categories = results[0] as List<String>;
      final jokes = results[1] as List<Joke>;

      setState(() {
        _categories = categories;
        _jokes = jokes;
        _loadingState = LoadingState.success;
      });
    } catch (e) {
      setState(() {
        _loadingState = LoadingState.error;
        _errorMessage = e.toString();
      });
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _refreshJokes() async {
    try {
      final jokes = await ChuckNorrisService.getMultipleRandomJokes(count: 10);
      setState(() {
        _jokes = jokes;
        _selectedCategory = null;
        _searchController.clear();
      });
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _loadJokesByCategory(String category) async {
    setState(() {
      _loadingState = LoadingState.loading;
    });

    try {
      final joke = await ChuckNorrisService.getJokeByCategory(category);
      setState(() {
        _jokes = [joke];
        _selectedCategory = category;
        _loadingState = LoadingState.success;
        _searchController.clear();
      });
    } catch (e) {
      setState(() {
        _loadingState = LoadingState.error;
        _errorMessage = e.toString();
      });
      _showErrorSnackBar(e.toString());
    }
  }

  Future<void> _searchJokes(String query) async {
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa un término de búsqueda'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _loadingState = LoadingState.loading;
    });

    try {
      final jokes = await ChuckNorrisService.searchJokes(query);
      setState(() {
        _jokes = jokes;
        _selectedCategory = null;
        _loadingState = LoadingState.success;
      });

      if (jokes.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se encontraron chistes para "$query"'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _loadingState = LoadingState.error;
        _errorMessage = e.toString();
      });
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: _loadInitialData,
        ),
      ),
    );
  }

  void _navigateToDetail(Joke joke) {
    context.push('/joke_detail', extra: joke);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Chuck Norris API',
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar chistes...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _refreshJokes();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: _searchJokes,
          ),
          const SizedBox(height: 16),
          
          // Filtros por categoría
          if (_categories.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  'Categoría: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: DropdownButton<String?>(
                    value: _selectedCategory,
                    hint: const Text('Todas las categorías'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todas las categorías'),
                      ),
                      ..._categories.map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.toUpperCase()),
                        ),
                      ),
                    ],
                    onChanged: (category) {
                      if (category == null) {
                        _refreshJokes();
                      } else {
                        _loadJokesByCategory(category);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          
          // Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _loadingState == LoadingState.loading ? null : _refreshJokes,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
              ElevatedButton.icon(
                onPressed: _loadingState == LoadingState.loading
                    ? null
                    : () => _searchJokes(_searchController.text),
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_loadingState) {
      case LoadingState.initial:
      case LoadingState.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando chistes de Chuck Norris...'),
            ],
          ),
        );

      case LoadingState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Algo salió mal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadInitialData,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        );

      case LoadingState.success:
        if (_jokes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No se encontraron chistes',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshJokes,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _jokes.length,
            itemBuilder: (context, index) {
              final joke = _jokes[index];
              return _buildJokeCard(joke, index);
            },
          ),
        );
    }
  }

  Widget _buildJokeCard(Joke joke, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(joke),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con imagen y número
              Row(
                children: [
                  // Imagen de Chuck Norris
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      joke.iconUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chiste #${index + 1}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        if (joke.categories?.isNotEmpty == true)
                          Wrap(
                            spacing: 4,
                            children: joke.categories!
                                .map((category) => Chip(
                                      label: Text(
                                        category.toUpperCase(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: Colors.blue[100],
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 16),
              
              // Texto del chiste (preview)
              Text(
                joke.value.length > 150
                    ? '${joke.value.substring(0, 150)}...'
                    : joke.value,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Footer con botón
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToDetail(joke),
                    icon: const Icon(Icons.read_more, size: 16),
                    label: const Text('Ver completo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}