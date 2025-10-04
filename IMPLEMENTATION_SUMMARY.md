# 🏥 NutrimedIA - Sistema de Registro Médico Implementado

## ✅ Funcionalidades Completadas

### 1. Modelo de Datos Actualizado (`AppUser`)
- ✅ Edad del usuario
- ✅ Peso (kg)
- ✅ Altura (cm)
- ✅ Lista de enfermedades
- ✅ Flag de información médica completada

### 2. Flujo de Registro Mejorado

#### Paso 1: Registro Básico
- Nombre
- Email
- Contraseña

#### Paso 2: Información Médica (Nuevo)
- **Datos físicos**:
  - Edad (años)
  - Peso (kg)
  - Altura (cm)

- **Condiciones médicas** (selección múltiple):
  - Diabetes tipo 1
  - Diabetes tipo 2
  - Hipertensión
  - Enfermedades del corazón
  - Colesterol alto
  - Obesidad
  - Enfermedad renal
  - Enfermedad hepática
  - Celiaquía
  - Intolerancia a la lactosa
  - Anemia
  - Hipotiroidismo
  - Hipertiroidismo
  - Gota
  - Ninguna

### 3. Integración con Firebase
- ✅ Almacenamiento de datos médicos en Firestore
- ✅ Recuperación de información completa en login
- ✅ Validación de información médica completada

### 4. Flujo de la Aplicación
```
Usuario Nuevo
    ↓
Registro Básico (email, password, nombre)
    ↓
Información Médica (edad, peso, altura, enfermedades)
    ↓
Home Page (con perfil completo)

Usuario Existente sin Info Médica
    ↓
Login
    ↓
Información Médica (redireccionado automáticamente)
    ↓
Home Page

Usuario Existente con Info Médica
    ↓
Login
    ↓
Home Page (directo)
```

## 📁 Archivos Modificados/Creados

### Creados:
- ✅ `lib/features/auth/presentation/pages/medical_info_page.dart`
- ✅ `HACKATON_INFO.md`

### Modificados:
- ✅ `lib/features/auth/domain/entities/app_user.dart`
- ✅ `lib/features/auth/domain/repos/auth_repo.dart`
- ✅ `lib/features/auth/data/firebase_auth_repo.dart`
- ✅ `lib/features/auth/presentation/cubits/auth_cubit.dart`
- ✅ `lib/features/profile/domain/entities/profile_user.dart`
- ✅ `lib/app.dart`

## 🎯 Próximos Pasos Sugeridos

1. **Integración de IA para Análisis de Alimentos**:
   - Implementar captura de fotos
   - Integrar API de visión por computadora (Google Vision API, Custom ML Model)
   - Crear sistema de evaluación basado en enfermedades

2. **Base de Datos de Alimentos**:
   - Crear colección en Firestore para alimentos escaneados
   - Guardar componentes nutricionales
   - Implementar historial de alimentos

3. **Sistema de Recomendaciones**:
   - Lógica de IA para evaluar alimentos según enfermedades
   - Sugerencias de alternativas más saludables
   - Alertas de componentes peligrosos para condiciones específicas

4. **UI/UX**:
   - Pantalla de cámara para escanear alimentos
   - Vista de resultados del análisis
   - Historial de alimentos escaneados
   - Dashboard de salud

## 🧪 Para Probar

1. Ejecutar la app: `flutter run`
2. Registrar un nuevo usuario
3. Completar información médica
4. Verificar que se guarde en Firebase
5. Hacer logout y login nuevamente
6. Verificar que la información persiste

## 📝 Formulario del Hackaton

**Nuestro proyecto ayuda a personas con enfermedades crónicas usando IA para analizar alimentos y proporcionar recomendaciones nutricionales personalizadas.**

**Lo logramos con**:
- Datos médicos del usuario (edad, peso, enfermedades)
- Firebase para almacenamiento seguro
- IA de visión por computadora (próximo)
- Análisis nutricional inteligente (próximo)

**En la demo mostraremos**:
- Registro con perfil médico completo ✅
- Análisis de alimentos con foto (próximo)
- Recomendaciones personalizadas (próximo)
- Historial de alimentos (próximo)
