import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimedai/core/constants/app_constants.dart';
import 'package:nutrimedai/features/auth/presentation/components/my_button.dart';
import 'package:nutrimedai/features/auth/presentation/cubits/auth_cubit.dart';

class MedicalInfoPage extends StatefulWidget {
  const MedicalInfoPage({super.key});

  @override
  State<MedicalInfoPage> createState() => _MedicalInfoPageState();
}

class _MedicalInfoPageState extends State<MedicalInfoPage> {
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  Set<String> selectedDiseases = {};

  void saveMedicalInfo() {
    final int? age = int.tryParse(ageController.text);
    final double? weight = double.tryParse(weightController.text);
    final double? height = double.tryParse(heightController.text);

    // Validar que los campos no estén vacíos
    if (age == null || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      return;
    }

    if (selectedDiseases.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Por favor selecciona al menos una opción (puede ser 'Ninguna')",
          ),
        ),
      );
      return;
    }

    // Guardar información médica
    final authCubit = context.read<AuthCubit>();
    authCubit.updateMedicalInfo(
      age: age,
      weight: weight,
      height: height,
      diseases: selectedDiseases.toList(),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Información Médica"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono y mensaje
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Completa tu perfil médico",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Esta información nos ayudará a brindarte recomendaciones personalizadas",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Edad
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Edad (años)",
                  hintText: "Ejemplo: 25",
                  prefixIcon: const Icon(Icons.cake),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 15),

              // Peso
              TextField(
                controller: weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Peso (kg)",
                  hintText: "Ejemplo: 70.5",
                  prefixIcon: const Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 15),

              // Altura
              TextField(
                controller: heightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Altura (cm)",
                  hintText: "Ejemplo: 170",
                  prefixIcon: const Icon(Icons.height),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                ),
              ),

              const SizedBox(height: 25),

              // Lista de enfermedades
              Text(
                "Selecciona tus condiciones médicas:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),

              const SizedBox(height: 10),

              // Chips de enfermedades
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.supportedDiseases.map((disease) {
                  final isSelected = selectedDiseases.contains(disease);
                  return FilterChip(
                    label: Text(disease),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (disease == 'Ninguna') {
                          if (selected) {
                            selectedDiseases.clear();
                            selectedDiseases.add(disease);
                          } else {
                            selectedDiseases.remove(disease);
                          }
                        } else {
                          selectedDiseases.remove('Ninguna');
                          if (selected) {
                            selectedDiseases.add(disease);
                          } else {
                            selectedDiseases.remove(disease);
                          }
                        }
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.inversePrimary,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Botón para guardar
              MyButton(text: "Guardar y Continuar", onTap: saveMedicalInfo),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
