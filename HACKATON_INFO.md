# NutrimedIA - Hackaton Submission

## Descripción del Proyecto

**Nuestro proyecto ayuda a [personas con enfermedades crónicas y condiciones médicas específicas] usando IA para [analizar alimentos mediante fotografías y proporcionar recomendaciones nutricionales personalizadas basadas en sus condiciones de salud].**

Lo logramos con:
- **Datos**: Perfil médico del usuario (edad, peso, altura, enfermedades como diabetes, hipertensión, enfermedades del corazón, etc.)
- **Tecnología**: 
  - Flutter para desarrollo móvil multiplataforma
  - Firebase (Auth, Firestore, Storage) para backend
  - IA de visión por computadora para reconocimiento de alimentos
  - Análisis nutricional mediante IA basado en condiciones médicas

## Demo - Lo que mostraremos:

1. **Registro personalizado**: 
   - Usuario crea cuenta con email/contraseña
   - Completa perfil médico: edad, peso, altura
   - Selecciona sus condiciones médicas de una lista

2. **Análisis de alimentos con IA**:
   - Usuario toma foto de un alimento
   - La IA identifica el alimento y analiza sus componentes nutricionales
   - Sistema evalúa si es recomendable según las enfermedades del usuario
   - Proporciona alternativas más saludables

3. **Historial personalizado**:
   - Todos los alimentos escaneados se guardan en Firebase
   - Registro completo con componentes nutricionales
   - Recomendaciones históricas

## Enfermedades Soportadas

La aplicación actualmente soporta análisis para:
- Diabetes tipo 1 y tipo 2
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

## Stack Técnico

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore (Base de datos)
  - Storage (Imágenes)
- **Estado**: BLoC/Cubit pattern
- **IA**: [Por definir - Vision API / Custom ML Model]

## Impacto Social

NutrimedIA democratiza el acceso a recomendaciones nutricionales personalizadas, permitiendo que personas con condiciones médicas específicas tomen decisiones informadas sobre su alimentación de forma instantánea y accesible.
