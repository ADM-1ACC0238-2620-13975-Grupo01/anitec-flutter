// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'AniTec';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonLoading => 'Cargando…';

  @override
  String get commonShowPassword => 'Mostrar contraseña';

  @override
  String get commonHidePassword => 'Ocultar contraseña';

  @override
  String get errorNetwork =>
      'No se pudo conectar con el servidor. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get errorUnauthorized =>
      'Tu sesión no es válida. Inicia sesión de nuevo.';

  @override
  String get errorSessionExpired => 'Tu sesión expiró. Inicia sesión de nuevo.';

  @override
  String get errorForbidden => 'No tienes permiso para hacer esto.';

  @override
  String get errorNotFound => 'No se encontró el elemento solicitado.';

  @override
  String get errorConflict => 'Este elemento ya existe.';

  @override
  String get errorServer =>
      'El servidor tuvo un problema. Inténtalo más tarde.';

  @override
  String get errorUnknown => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get errorFieldRequired => 'Este campo es obligatorio';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get roleRancher => 'Ganadero';

  @override
  String get roleVeterinarian => 'Veterinario';

  @override
  String get authHeroChip => 'Gestión ganadera';

  @override
  String get authHeroTitle => 'Cuida a cada animal, desde cualquier campo.';

  @override
  String get authHeroSubtitle =>
      'Registros, historial sanitario y actividades para ganaderos y veterinarios.';

  @override
  String get authSignInTitle => 'Bienvenido de nuevo';

  @override
  String get authSignInSubtitle =>
      'Inicia sesión para continuar con tus registros ganaderos.';

  @override
  String get authSignInAction => 'Iniciar sesión';

  @override
  String get authUsername => 'Usuario';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authInvalidCredentials => 'Usuario o contraseña incorrectos.';

  @override
  String get authVeterinarianNotSupported =>
      'Esta app es solo para ganaderos. Las cuentas de veterinario aún no están disponibles aquí.';

  @override
  String get authUnsupportedRole => 'Este tipo de cuenta no es compatible.';

  @override
  String get authReadTerms => 'Leer los Términos de Servicio';

  @override
  String get termsTitle => 'Términos de Servicio';

  @override
  String get termsIntro =>
      'Al crear una cuenta de AniTec aceptas los siguientes términos. Este texto es un borrador de trabajo preparado por el equipo y debe revisarse antes de su publicación.';

  @override
  String get termsSectionUseTitle => '1. Finalidad';

  @override
  String get termsSectionUseBody =>
      'AniTec ayuda a ganaderos y veterinarios a registrar animales, eventos sanitarios y actividades de la finca. No reemplaza el criterio profesional veterinario.';

  @override
  String get termsSectionAccountTitle => '2. Tu cuenta';

  @override
  String get termsSectionAccountBody =>
      'Eres responsable de la veracidad de la información que registres y de mantener tus credenciales en privado. Cada cuenta pertenece a una persona y a un solo rol.';

  @override
  String get termsSectionDataTitle => '3. Datos y privacidad';

  @override
  String get termsSectionDataBody =>
      'Almacenamos solo los datos necesarios para prestar el servicio: tu perfil, tus animales, fincas, registros sanitarios, actividades e información de suscripción. Los veterinarios solo ven a los ganaderos vinculados con ellos. No vendemos datos personales.';

  @override
  String get termsSectionEthicsTitle => '4. Uso profesional y ético';

  @override
  String get termsSectionEthicsBody =>
      'Los usuarios deben registrar información sanitaria veraz y respetar el bienestar animal. Los veterinarios deben seguir los principios éticos de su profesión y el código de ética de ingeniería de software de ACM/IEEE aplicable al uso de esta herramienta.';

  @override
  String get termsSectionPaymentsTitle => '5. Suscripciones y pagos';

  @override
  String get termsSectionPaymentsBody =>
      'Los planes de pago los procesa Stripe. AniTec no almacena números de tarjeta. Actualmente los pagos funcionan en modo de prueba.';

  @override
  String get termsSectionAvailabilityTitle => '6. Disponibilidad';

  @override
  String get termsSectionAvailabilityBody =>
      'El servicio se ofrece tal como está y puede no estar disponible durante mantenimientos. Los datos guardados en el dispositivo pueden sincronizarse después, cuando haya conexión.';

  @override
  String get termsSectionChangesTitle => '7. Cambios';

  @override
  String get termsSectionChangesBody =>
      'Estos términos pueden cambiar. Avisaremos dentro de la aplicación cuando ocurra.';

  @override
  String get menuMore => 'Más opciones';

  @override
  String get menuTerms => 'Términos de Servicio';

  @override
  String get menuSignOut => 'Cerrar sesión';

  @override
  String homeGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get homeSubtitle => 'Así va tu ganado.';

  @override
  String get homeAllFarms => 'Todas las fincas';

  @override
  String get homeFarmFilter => 'Finca';

  @override
  String get homeMetricAnimals => 'Animales';

  @override
  String get homeMetricAttention => 'Requieren atención';

  @override
  String get homeMetricAttentionCaption => 'En observación o en tratamiento';

  @override
  String get homeMetricRecords => 'Registros sanitarios';

  @override
  String get homeMetricFollowUps => 'Seguimientos pendientes';

  @override
  String get homeMetricUpcoming => 'Próximas actividades';

  @override
  String get homeUpcomingTitle => 'Próximas actividades';

  @override
  String get homeUpcomingEmpty => 'No hay actividades próximas.';

  @override
  String get homeRecentTitle => 'Registros sanitarios recientes';

  @override
  String get homeRecentEmpty => 'Aún no hay registros sanitarios.';

  @override
  String get homeOfflineBanner =>
      'Sin conexión. Se muestran los últimos datos cargados.';

  @override
  String get homeRefreshFailedBanner =>
      'No se pudo actualizar. Se muestran los últimos datos cargados.';

  @override
  String get homeLoadingHint =>
      'Cargando tu ganado… el servidor puede tardar hasta un minuto en despertar.';

  @override
  String get healthType => 'Tipo';

  @override
  String get healthDescription => 'Descripción';

  @override
  String get healthVeterinarian => 'Veterinario';

  @override
  String get healthDiagnosis => 'Diagnóstico';

  @override
  String get healthTreatment => 'Tratamiento';

  @override
  String get healthPrescription => 'Receta';

  @override
  String get healthFollowUp => 'Notas de seguimiento';

  @override
  String get healthNextDue => 'Próxima fecha';

  @override
  String get healthTagFollowUp => 'Seguimiento';

  @override
  String get healthTagClosed => 'Cerrado';

  @override
  String get healthTypeIncident => 'Incidencia';

  @override
  String get healthTypeVaccine => 'Vacuna';

  @override
  String get healthTypeTreatment => 'Tratamiento';

  @override
  String get healthTypeDiagnosis => 'Diagnóstico';

  @override
  String get healthTypeCheckup => 'Revisión';

  @override
  String get activityType => 'Tipo';

  @override
  String get activityStatus => 'Estado';

  @override
  String get activityOverdue => 'Vencida';

  @override
  String get activityTypeHealth => 'Sanitario';

  @override
  String get activityTypeVetVisit => 'Visita veterinaria';

  @override
  String get activityTypeProduction => 'Productivo';

  @override
  String get activityTypeFinancial => 'Financiero';

  @override
  String get activityTypeReproductive => 'Reproductivo';

  @override
  String get activityTypeVaccination => 'Vacunación';

  @override
  String get activityTypeTreatmentFollowUp => 'Seguimiento de tratamiento';

  @override
  String get activityPriorityHigh => 'Alta';

  @override
  String get activityPriorityMedium => 'Media';

  @override
  String get activityPriorityLow => 'Baja';

  @override
  String get activityStatusPending => 'Pendiente';

  @override
  String get activityStatusScheduled => 'Programado';

  @override
  String get activityStatusCompleted => 'Completado';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
