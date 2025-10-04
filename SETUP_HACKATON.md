# 🍎 NutrimedIA - Sistema de Escaneo de Alimentos con IA

## ✅ IMPLEMENTACIÓN COMPLETADA

### 🎉 Funcionalidades Implementadas

1. **✅ Sistema de Registro Médico**
   - Formulario completo con edad, peso, altura
   - Selección múltiple de enfermedades (15 opciones)
   - Integración con Firebase Firestore
   - Validaciones y flujo completo

2. **✅ Escaneo de Alimentos con IA**
   - Captura desde cámara o galería
   - Análisis con Gemini AI
   - Detección de múltiples alimentos
   - Información nutricional detallada
   - Recomendaciones personalizadas basadas en enfermedades

3. **✅ Dashboard de Nutrición**
   - Visualización de calorías del día
   - Gráfico circular de progreso
   - Desglose de macronutrientes (Proteínas, Carbos, Grasas)
   - Lista de comidas escaneadas (Desayuno, Almuerzo, Cena, Snacks)
   - Actualización en tiempo real

4. **✅ Navegación Completa**
   - Drawer con opciones: Home, Escanear, Profile, Settings, Logout
   - FAB para acceso rápido a scanner
   - Navegación fluida entre pantallas

## 🚀 CONFIGURACIÓN PARA EL HACKATON

### Paso 1: Obtener API Key de Gemini

1. Visita: https://makersuite.google.com/app/apikey
2. Crea un nuevo proyecto en Google AI Studio (es GRATIS)
3. Genera tu API Key
4. Copia la key

### Paso 2: Configurar la API Key

Abre el archivo:
```
lib/core/constants/api_constants.dart
```

Reemplaza `'TU_API_KEY_AQUI'` con tu API key real:

```dart
class ApiConstants {
  static const String geminiApiKey = 'AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXX'; // Tu key aquí
}
```

### Paso 3: Instalar Dependencias

```bash
flutter pub get
```

### Paso 4: Configurar Firebase (Ya está hecho)

✅ Firebase ya está configurado con:
- Authentication (Email/Password)
- Cloud Firestore
- Storage

### Paso 5: Ejecutar la App

```bash
flutter run
```

## 📱 FLUJO DE LA APLICACIÓN

### 1. Registro de Usuario
```
Registro → Email/Password → Información Médica → Home
```

- **Información Médica incluye:**
  - Edad
  - Peso (kg)
  - Altura (cm)
  - Enfermedades (Diabetes, Hipertensión, etc.)

### 2. Escanear Alimentos
```
Home → Botón "Escanear" → Tomar/Seleccionar Foto → Análisis IA → Resultados → Guardar
```

- **El análisis incluye:**
  - Alimentos detectados con cantidades
  - Información nutricional completa
  - Nivel de recomendación (Verde/Amarillo/Rojo)
  - Advertencias específicas para tus enfermedades
  - Beneficios del alimento
  - Alternativas más saludables
  - Consejos personalizados por enfermedad

### 3. Dashboard
```
Home → Ver calorías del día → Ver comidas → Macronutrientes
```

- **Muestra:**
  - Calorías consumidas vs meta diaria
  - Gráfico circular de progreso
  - Desglose de Proteínas, Carbohidratos, Grasas
  - Lista de todas las comidas del día
  - Iconos por tipo de comida

## 🎯 PARA LA DEMO DEL HACKATON

### Guión Sugerido:

**1. Mostrar el Problema (30 seg)**
```
"Las personas con enfermedades crónicas como diabetes o hipertensión 
necesitan controlar su alimentación, pero no siempre saben si un alimento 
es seguro para ellos."
```

**2. Presentar la Solución (1 min)**
```
"NutrimedIA usa IA para analizar alimentos mediante fotos y proporciona 
recomendaciones personalizadas basadas en las condiciones médicas del usuario."
```

**3. Demo en Vivo (2-3 min)**

#### Parte 1: Registro (30 seg)
- Registrar usuario de prueba
- Completar perfil médico (ejemplo: Diabetes tipo 2, Hipertensión)

#### Parte 2: Escanear Alimento (1 min)
- Tomar foto de un alimento (ej: refresco, hamburguesa, o ensalada)
- Mostrar análisis de IA
- Destacar:
  - Detección automática
  - Info nutricional
  - **⚠️ Advertencia personalizada** (ej: "Alto en azúcar, no recomendado para diabetes")
  - Alternativas sugeridas

#### Parte 3: Dashboard (1 min)
- Mostrar dashboard con comidas del día
- Destacar:
  - Seguimiento de calorías
  - Macronutrientes
  - Historial de comidas

**4. Impacto (30 seg)**
```
"Democratiza el acceso a recomendaciones nutricionales personalizadas,
empoderando a personas con condiciones médicas a tomar decisiones 
informadas sobre su alimentación de forma instantánea."
```

## 📊 ESTRUCTURA DE DATOS EN FIREBASE

### Colección: `users`
```json
{
  "uid": "abc123",
  "email": "usuario@example.com",
  "name": "Juan Pérez",
  "age": 35,
  "weight": 75.5,
  "height": 175.0,
  "diseases": ["Diabetes tipo 2", "Hipertensión"],
  "medicalInfoCompleted": true
}
```

### Colección: `scanned_foods`
```json
{
  "id": "1696847234567",
  "userId": "abc123",
  "imageUrl": "https://...",
  "scannedAt": "2025-10-04T10:30:00.000Z",
  "mealType": "lunch",
  "detectedFoods": [
    {
      "name": "Hamburguesa con queso",
      "quantity": "1 pieza",
      "calories": 540,
      "protein": 25,
      "carbs": 45,
      "fat": 28,
      "sugar": 8,
      "sodium": 980,
      "foodQuality": 45,
      "insulinImpact": 8
    }
  ],
  "analysis": {
    "level": "notRecommended",
    "summary": "Este alimento tiene alto contenido de sodio y grasas saturadas...",
    "warnings": [
      "Alto en sodio (980mg) - No recomendado para hipertensión",
      "Alto impacto en insulina - Cuidado con diabetes"
    ],
    "benefits": [],
    "alternatives": [
      "Ensalada de pollo a la plancha",
      "Pescado al horno con verduras"
    ]
  }
}
```

## 🎨 TECNOLOGÍAS UTILIZADAS

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore
  - Storage
- **IA**: Google Gemini 1.5 Flash
- **Dependencias**:
  - `flutter_bloc` - Gestión de estado
  - `image_picker` - Captura de fotos
  - `dio` - HTTP requests
  - `fl_chart` - Gráficas (para futuras mejoras)

## 🔧 TROUBLESHOOTING

### Error: "Failed to analyze image: 429"
**Causa**: Límite de requests de Gemini API excedido
**Solución**: La app automáticamente usa datos mock para desarrollo

### Error: "No se detectaron alimentos"
**Causa**: La foto no tiene alimentos visibles o es muy oscura
**Solución**: Tomar otra foto con mejor iluminación

### Error de Firebase
**Causa**: Reglas de seguridad muy restrictivas
**Solución**: En Firebase Console → Firestore → Rules, usar:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /scanned_foods/{foodId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📝 FORMULARIO DEL HACKATON

**Nuestro proyecto ayuda a:**
> Personas con enfermedades crónicas como diabetes, hipertensión y enfermedades del corazón

**Usando IA para:**
> Analizar alimentos mediante fotografías y proporcionar recomendaciones nutricionales personalizadas basadas en sus condiciones de salud específicas

**Lo logramos con:**
- Perfil médico personalizado del usuario
- Firebase para almacenamiento seguro de datos
- Google Gemini AI para análisis de imágenes y generación de recomendaciones
- Algoritmos de evaluación nutricional basados en enfermedades

**En la demo mostraremos:**
1. Registro de usuario con perfil médico completo ✅
2. Captura de foto de alimento ✅
3. Análisis nutricional con IA ✅
4. Recomendaciones personalizadas según enfermedades ✅
5. Dashboard con seguimiento diario de nutrición ✅

## 🎯 PRÓXIMAS MEJORAS (Post-Hackaton)

1. **Gráficas Avanzadas**
   - Usar fl_chart para visualizaciones más sofisticadas
   - Gráficas de progreso semanal/mensual

2. **Reconocimiento de Código de Barras**
   - Escanear productos empaquetados
   - Base de datos nutricional

3. **Notificaciones**
   - Recordatorios de comidas
   - Alertas de consumo excesivo

4. **Exportar Reportes**
   - PDF con historial nutricional
   - Compartir con médico

5. **Modo Offline**
   - Caché de alimentos frecuentes
   - Análisis básico sin internet

## 📞 SOPORTE

Si tienes problemas durante el hackaton:
1. Verifica que la API key esté correctamente configurada
2. Revisa que Firebase esté inicializado
3. Asegúrate de tener conexión a internet
4. Consulta los logs de Flutter: `flutter logs`

## 🏆 ¡BUENA SUERTE EN EL HACKATON!

¡Tu app está lista para impresionar a los jueces! 🚀
