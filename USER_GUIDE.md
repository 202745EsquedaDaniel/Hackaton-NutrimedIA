# 🎯 Guía de Uso - NutrimedIA

## 📱 Flujo de Usuario Implementado

### Para Nuevos Usuarios

1. **Pantalla de Bienvenida**
   - Opciones: Login / Registro

2. **Registro (AuthPage → RegisterPage)**
   - Ingresar nombre completo
   - Ingresar email
   - Crear contraseña
   - Confirmar contraseña
   - Clic en "Sign Up"

3. **Información Médica (MedicalInfoPage)** ⭐ NUEVO
   - **Datos Físicos:**
     - Edad (años)
     - Peso (kg)
     - Altura (cm)
   
   - **Condiciones Médicas:**
     - Seleccionar todas las que apliquen
     - Opciones incluyen: Diabetes, Hipertensión, etc.
     - Si no tienes ninguna, seleccionar "Ninguna"
   
   - Clic en "Guardar y Continuar"

4. **Home Page**
   - Acceso completo a la aplicación

### Para Usuarios Existentes

#### Con Información Médica Completa
```
Login → Home Page
```

#### Sin Información Médica Completa
```
Login → MedicalInfoPage → Home Page
```

## 🔧 Configuración de Firebase

Asegúrate de tener configurado:

1. **Firebase Authentication**
   - Email/Password habilitado

2. **Cloud Firestore**
   - Colección `users` con permisos adecuados
   - Estructura de documento:
     ```json
     {
       "uid": "string",
       "email": "string",
       "name": "string",
       "age": number,
       "weight": number,
       "height": number,
       "diseases": ["string"],
       "medicalInfoCompleted": boolean
     }
     ```

3. **Reglas de Seguridad Sugeridas**
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

## 🧪 Testing

### Caso de Prueba 1: Registro Nuevo Usuario
1. Abrir app
2. Ir a Register
3. Completar formulario básico
4. Verificar redirección a MedicalInfoPage
5. Completar información médica
6. Verificar acceso a Home
7. Verificar datos en Firebase Console

### Caso de Prueba 2: Login Usuario Existente
1. Logout si es necesario
2. Login con credenciales
3. Verificar que se cargue información médica
4. Si medicalInfoCompleted = true → Home
5. Si medicalInfoCompleted = false → MedicalInfoPage

### Caso de Prueba 3: Validaciones
1. Intentar guardar información médica sin completar campos
2. Verificar mensajes de error
3. Intentar guardar sin seleccionar enfermedades
4. Verificar validación

## 📊 Estructura de Datos en Firebase

### Colección: `users`

#### Documento de Usuario:
```json
{
  "uid": "abc123...",
  "email": "usuario@example.com",
  "name": "Juan Pérez",
  "age": 35,
  "weight": 75.5,
  "height": 175.0,
  "diseases": [
    "Diabetes tipo 2",
    "Hipertensión"
  ],
  "medicalInfoCompleted": true,
  "bio": "",
  "profileImageUrl": ""
}
```

## 🎨 Personalización

### Agregar Nuevas Enfermedades
Editar: `lib/core/constants/app_constants.dart`
```dart
static const List<String> supportedDiseases = [
  // ... enfermedades existentes
  'Nueva Enfermedad',
];
```

### Modificar Validaciones
Editar constantes en `app_constants.dart`:
```dart
static const int minAge = 1;
static const int maxAge = 120;
// ... etc
```

## 🚀 Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Ejecutar en dispositivo específico
flutter devices
flutter run -d <device-id>

# Limpiar build
flutter clean

# Actualizar dependencias
flutter pub upgrade
```

## 📝 Checklist de Implementación Completada

- ✅ Modelo de datos actualizado con información médica
- ✅ Página de registro médico con UI/UX completa
- ✅ Integración con Firebase Firestore
- ✅ Validaciones de campos
- ✅ Flujo de autenticación actualizado
- ✅ Persistencia de datos médicos
- ✅ Compatibilidad con ProfileUser existente

## 🔜 Próximas Funcionalidades Sugeridas

1. **Módulo de Cámara**
   - Integrar `image_picker` o `camera` package
   - Captura de fotos de alimentos

2. **Análisis con IA**
   - Integrar Google ML Kit o Cloud Vision API
   - Reconocimiento de alimentos

3. **Base de Datos Nutricional**
   - Crear colección de alimentos
   - Información nutricional completa

4. **Sistema de Recomendaciones**
   - Lógica de evaluación por enfermedad
   - Sugerencias personalizadas

5. **Dashboard de Salud**
   - Visualización de IMC
   - Historial de alimentos
   - Estadísticas personalizadas
