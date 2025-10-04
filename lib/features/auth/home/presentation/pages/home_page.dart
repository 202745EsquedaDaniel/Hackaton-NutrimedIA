import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/features/auth/home/presentation/components/my_drawer.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:nutrimedai/features/food_scanner/presentation/cubits/food_scanner_cubit.dart';
import 'package:nutrimedai/features/food_scanner/presentation/cubits/food_scanner_states.dart';
import 'package:nutrimedai/features/food_scanner/presentation/pages/food_scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadTodayMeals();
  }

  void _loadTodayMeals() {
    final user = context.read<AuthCubit>().currentUser;
    if (user != null) {
      context.read<FoodScannerCubit>().loadTodayMeals(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NutrimedIA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTodayMeals();
        },
        child: BlocBuilder<FoodScannerCubit, FoodScannerState>(
          builder: (context, state) {
            if (state is DailyMealsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DailyMealsLoaded) {
              return _buildDashboard(user, state);
            }

            // Initial or error state
            return _buildEmptyState(user);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodScannerPage()),
          ).then((_) => _loadTodayMeals());
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text('Escanear'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDashboard(dynamic user, DailyMealsLoaded state) {
    final dailyGoal =
        2000.0; // Meta diaria (podría venir del perfil del usuario)
    final progressPercent = (state.totalCalories / dailyGoal * 100)
        .clamp(0.0, 100.0)
        .toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Text(
            'Hola, ${user?.name ?? "Usuario"}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Hoy, ${_getTodayDate()}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Tarjeta de calorías del día
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Consumo de Hoy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  // Círculo de calorías
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: progressPercent / 100,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[200],
                            color: _getCaloriesColor(progressPercent),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${state.totalCalories.toInt()}',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Macros
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroChip(
                        'Proteína',
                        '${state.totalProtein.toInt()}g',
                        Colors.blue,
                      ),
                      _buildMacroChip(
                        'Carbos',
                        '${state.totalCarbs.toInt()}g',
                        Colors.orange,
                      ),
                      _buildMacroChip(
                        'Grasas',
                        '${state.totalFat.toInt()}g',
                        Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Meta diaria: ${dailyGoal.toInt()} kcal',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Comidas del día
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comidas de Hoy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${state.meals.length} comidas',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (state.meals.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.restaurant, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No hay comidas registradas hoy',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...state.meals.map(
              (meal) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getMealTypeColor(meal.mealType),
                    child: Icon(
                      _getMealTypeIcon(meal.mealType),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    meal.detectedFoods.map((f) => f.name).join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${meal.totalCalories.toInt()} kcal • ${_getMealTypeName(meal.mealType)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navegar a detalles de la comida
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(dynamic user) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text(
                'Hola, ${user.name}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(user.email, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 40),
            ],
            Icon(Icons.camera_alt, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 24),
            const Text(
              '¡Empieza a Escanear!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Toma una foto de tus alimentos para\nanalizar su valor nutricional',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getCaloriesColor(double percent) {
    if (percent < 50) return Colors.green;
    if (percent < 80) return Colors.orange;
    return Colors.red;
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.fastfood;
    }
  }

  String _getMealTypeName(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return 'Desayuno';
      case 'lunch':
        return 'Almuerzo';
      case 'dinner':
        return 'Cena';
      default:
        return 'Snack';
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${now.day} de ${months[now.month - 1]}';
  }
}
