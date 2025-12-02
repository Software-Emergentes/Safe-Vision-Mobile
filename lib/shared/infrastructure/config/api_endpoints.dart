/// Configuración de endpoints de la API
/// Contiene todas las rutas y parámetros de ejemplo para cada endpoint
class ApiEndpoints {
  // URL base del servidor
  // Para desarrollo local:
  // - Emulador Android: usar 'http://10.0.2.2:5272' (10.0.2.2 apunta al localhost de la máquina host)
  // - Emulador iOS/Web: usar 'http://localhost:5272'
  // - Dispositivo físico: usar la IP de tu red (ej: 'http://192.168.18.12:5272')
  // Para producción, cambiar por la IP del servidor
  // static const String baseUrl = 'http://10.0.2.2:5272'; // Android Emulator
  static const String baseUrl = 'http://localhost:5272'; // iOS/Web
  // static const String baseUrl = 'http://192.168.18.12:5272'; // Dispositivo físico
  static const String apiV1Base = '$baseUrl/api/v1';
  static const String apiBase = '$baseUrl/api';

  // ==================== IAM - Authentication ====================
  
  /// POST /api/v1/authentication/sign-in
  /// Autenticación de usuario
  static const String signIn = '$apiV1Base/authentication/sign-in';
  static Map<String, dynamic> get signInParams => {
    'username': 'usuario_ejemplo',
    'password': 'password123',
  };

  /// POST /api/v1/authentication/sign-up
  /// Registro de nuevo usuario
  static const String signUp = '$apiV1Base/authentication/sign-up';
  static Map<String, dynamic> get signUpParams => {
    'username': 'nuevo_usuario',
    'password': 'password123',
    'email': 'usuario@ejemplo.com',
  };

  /// POST /api/v1/authentication/verify-mfa
  /// Verificar código MFA
  static const String verifyMfa = '$apiV1Base/authentication/verify-mfa';
  static Map<String, dynamic> get verifyMfaParams => {
    'userId': 1,
    'mfaCode': '123456',
  };

  /// POST /api/v1/authentication/mfa/enable
  /// Habilitar MFA para un usuario
  static const String enableMfa = '$apiV1Base/authentication/mfa/enable';
  static Map<String, dynamic> get enableMfaParams => {
    'userId': 1,
  };

  // ==================== IAM - MFA ====================
  
  /// POST /api/v1/mfa/verify
  /// Verificar código MFA
  static const String mfaVerify = '$apiV1Base/mfa/verify';
  static Map<String, dynamic> get mfaVerifyParams => {
    'userId': 1,
    'mfaCode': '123456',
  };

  /// GET /api/v1/mfa/setup/{userId}
  /// Configurar MFA para un usuario
  static String mfaSetup(int userId) => '$apiV1Base/mfa/setup/$userId';
  static const int mfaSetupExampleUserId = 1;

  // ==================== IAM - Users ====================
  
  /// GET /api/v1/users/{userId}
  /// Obtener usuario por ID
  static String getUserById(int userId) => '$apiV1Base/users/$userId';
  static const int getUserByIdExampleUserId = 1;

  /// GET /api/v1/users
  /// Obtener todos los usuarios
  static const String getAllUsers = '$apiV1Base/users';

  /// GET /api/v1/users/get-username/{userId}
  /// Obtener nombre de usuario por ID
  static String getUsernameById(int userId) => '$apiV1Base/users/get-username/$userId';
  static const int getUsernameByIdExampleUserId = 1;

  /// PUT /api/v1/users/{userId}
  /// Actualizar usuario
  static String updateUser(int userId) => '$apiV1Base/users/$userId';
  static Map<String, dynamic> get updateUserParams => {
    'username': 'usuario_actualizado',
  };
  static const int updateUserExampleUserId = 1;

  // ==================== Driver ====================
  
  /// POST /api/v1/drivers/register
  /// Registrar nuevo conductor
  static const String registerDriver = '$apiV1Base/drivers/register';
  static Map<String, dynamic> get registerDriverParams => {
    'userId': 1,
    'licenseNumber': 'ABC123456',
    'licenseExpiryDate': '2025-12-31',
    'phoneNumber': '+1234567890',
    'address': 'Calle Ejemplo 123',
  };

  /// GET /api/v1/drivers/{driverId}
  /// Obtener conductor por ID
  static String getDriverById(int driverId) => '$apiV1Base/drivers/$driverId';
  static const int getDriverByIdExampleDriverId = 1;

  /// GET /api/v1/drivers
  /// Obtener todos los conductores
  static const String getAllDrivers = '$apiV1Base/drivers';

  /// GET /api/v1/drivers/by-user/{userId}
  /// Obtener conductor por ID de usuario
  static String getDriverByUserId(int userId) => '$apiV1Base/drivers/by-user/$userId';
  static const int getDriverByUserIdExampleUserId = 1;

  /// GET /api/v1/drivers/by-status/{statusValue}
  /// Obtener conductores por estado
  static String getDriversByStatus(int statusValue) => '$apiV1Base/drivers/by-status/$statusValue';
  static const int getDriversByStatusExampleStatus = 1; // 1=Activo, 2=Inactivo, etc.

  /// PUT /api/v1/drivers/{driverId}/profile
  /// Actualizar perfil del conductor
  static String updateDriverProfile(int driverId) => '$apiV1Base/drivers/$driverId/profile';
  static Map<String, dynamic> get updateDriverProfileParams => {
    'phoneNumber': '+1234567890',
    'address': 'Nueva Dirección 456',
  };
  static const int updateDriverProfileExampleDriverId = 1;

  /// PUT /api/v1/drivers/{driverId}/license
  /// Actualizar licencia del conductor
  static String updateDriverLicense(int driverId) => '$apiV1Base/drivers/$driverId/license';
  static Map<String, dynamic> get updateDriverLicenseParams => {
    'licenseNumber': 'XYZ789012',
    'expiryDate': '2026-12-31',
  };
  static const int updateDriverLicenseExampleDriverId = 1;

  /// GET /api/v1/drivers/{driverId}/license
  /// Obtener licencia del conductor
  static String getDriverLicense(int driverId) => '$apiV1Base/drivers/$driverId/license';
  static const int getDriverLicenseExampleDriverId = 1;

  /// POST /api/v1/drivers/{driverId}/validate-license
  /// Validar licencia del conductor
  static String validateDriverLicense(int driverId) => '$apiV1Base/drivers/$driverId/validate-license';
  static const int validateDriverLicenseExampleDriverId = 1;

  /// PUT /api/v1/drivers/{driverId}/status
  /// Cambiar estado del conductor
  static String changeDriverStatus(int driverId) => '$apiV1Base/drivers/$driverId/status';
  static Map<String, dynamic> get changeDriverStatusParams => {
    'status': 1, // 1=Activo, 2=Inactivo, 3=Suspendido
  };
  static const int changeDriverStatusExampleDriverId = 1;

  /// POST /api/v1/drivers/{driverId}/activate
  /// Activar conductor
  static String activateDriver(int driverId) => '$apiV1Base/drivers/$driverId/activate';
  static const int activateDriverExampleDriverId = 1;

  /// POST /api/v1/drivers/{driverId}/deactivate
  /// Desactivar conductor
  static String deactivateDriver(int driverId) => '$apiV1Base/drivers/$driverId/deactivate';
  static const int deactivateDriverExampleDriverId = 1;

  /// POST /api/v1/drivers/{driverId}/suspend
  /// Suspender conductor
  static String suspendDriver(int driverId) => '$apiV1Base/drivers/$driverId/suspend';
  static const int suspendDriverExampleDriverId = 1;

  /// GET /api/v1/drivers/{driverId}/availability
  /// Verificar disponibilidad del conductor
  static String checkDriverAvailability(int driverId) => '$apiV1Base/drivers/$driverId/availability';
  static const int checkDriverAvailabilityExampleDriverId = 1;

  // ==================== Trip ====================
  
  /// POST /api/trips/start
  /// Iniciar un nuevo viaje
  static const String startTrip = '$apiBase/trips/start';
  static Map<String, dynamic> get startTripParams => {
    'driverId': 1,
    'vehicleId': 1,
    'startLocation': 'Origen del viaje',
    'destination': 'Destino del viaje',
  };

  /// PUT /api/trips/{id}/end
  /// Finalizar un viaje
  static String endTrip(int tripId) => '$apiBase/trips/$tripId/end';
  static const int endTripExampleTripId = 1;

  /// PUT /api/trips/{id}/cancel
  /// Cancelar un viaje
  static String cancelTrip(int tripId) => '$apiBase/trips/$tripId/cancel';
  static String cancelTripWithReason(int tripId, String reason) => '$apiBase/trips/$tripId/cancel?reason=$reason';
  static const int cancelTripExampleTripId = 1;
  static const String cancelTripExampleReason = 'Emergencia familiar';

  /// GET /api/trips/{id}
  /// Obtener detalles de un viaje
  static String getTripById(int tripId) => '$apiBase/trips/$tripId';
  static const int getTripByIdExampleTripId = 1;

  /// GET /api/trips/driver/{driverId}
  /// Obtener viajes de un conductor
  static String getTripsByDriver(int driverId) => '$apiBase/trips/driver/$driverId';
  static const int getTripsByDriverExampleDriverId = 1;

  /// GET /api/trips/vehicle/{vehicleId}
  /// Obtener viajes de un vehículo
  static String getTripsByVehicle(int vehicleId) => '$apiBase/trips/vehicle/$vehicleId';
  static const int getTripsByVehicleExampleVehicleId = 1;

  /// POST /api/trips/{id}/sync
  /// Sincronizar datos del viaje
  static String syncTripData(int tripId) => '$apiBase/trips/$tripId/sync';
  static const int syncTripDataExampleTripId = 1;
  static Map<String, dynamic> get syncTripDataParams => {
    'tripId': 1,
  };

  /// GET /api/trips/{id}/recommendations
  /// Obtener recomendaciones del viaje
  static String getTripRecommendations(int tripId) => '$apiBase/trips/$tripId/recommendations';
  static const int getTripRecommendationsExampleTripId = 1;

  // ==================== Trip - Driver History ====================
  
  /// GET /api/drivers/{driverId}/history
  /// Obtener historial completo del conductor
  static String getDriverHistory(int driverId) => '$apiBase/drivers/$driverId/history';
  static const int getDriverHistoryExampleDriverId = 1;

  /// GET /api/drivers/{driverId}/history/date-range
  /// Obtener historial del conductor por rango de fechas
  static String getDriverHistoryByDateRange(int driverId, DateTime startDate, DateTime endDate) {
    final start = startDate.toIso8601String().split('T')[0];
    final end = endDate.toIso8601String().split('T')[0];
    return '$apiBase/drivers/$driverId/history/date-range?startDate=$start&endDate=$end';
  }
  static const int getDriverHistoryByDateRangeExampleDriverId = 1;
  static DateTime get getDriverHistoryByDateRangeExampleStartDate => DateTime.now().subtract(const Duration(days: 30));
  static DateTime get getDriverHistoryByDateRangeExampleEndDate => DateTime.now();

  /// GET /api/drivers/{driverId}/history/fatigue-patterns
  /// Obtener patrones de fatiga del conductor
  static String getDriverFatiguePatterns(int driverId) => '$apiBase/drivers/$driverId/history/fatigue-patterns';
  static const int getDriverFatiguePatternsExampleDriverId = 1;

  // ==================== Fatigue Monitoring ====================
  
  /// GET /api/fatigue/status/{driverId}
  /// Obtener estado de fatiga del conductor
  static String getFatigueStatus(int driverId) => '$apiBase/fatigue/status/$driverId';
  static const int getFatigueStatusExampleDriverId = 1;

  /// GET /api/fatigue/events/trip/{tripId}
  /// Obtener eventos de somnolencia de un viaje
  static String getDrowsinessEventsByTrip(int tripId) => '$apiBase/fatigue/events/trip/$tripId';
  static const int getDrowsinessEventsByTripExampleTripId = 1;

  // ==================== Alerts ====================
  
  /// GET /api/alerts/reports
  /// Obtener reportes de alertas
  static String getAlertReports({DateTime? startDate, DateTime? endDate}) {
    String url = '$apiBase/alerts/reports';
    if (startDate != null && endDate != null) {
      final start = startDate.toIso8601String().split('T')[0];
      final end = endDate.toIso8601String().split('T')[0];
      url += '?startDate=$start&endDate=$end';
    }
    return url;
  }
  static DateTime get getAlertReportsExampleStartDate => DateTime.now().subtract(const Duration(days: 30));
  static DateTime get getAlertReportsExampleEndDate => DateTime.now();

  /// GET /api/alerts/reports/driver/{driverId}
  /// Obtener reportes de alertas por conductor
  static String getAlertReportsByDriver(int driverId) => '$apiBase/alerts/reports/driver/$driverId';
  static const int getAlertReportsByDriverExampleDriverId = 1;

  /// GET /api/alerts/pending/manager/{managerId}
  /// Obtener alertas pendientes para un gerente
  static String getPendingAlertsForManager(int managerId) => '$apiBase/alerts/pending/manager/$managerId';
  static const int getPendingAlertsForManagerExampleManagerId = 1;

  /// GET /api/alerts/metrics
  /// Obtener métricas de alertas
  static String getAlertMetrics({DateTime? startDate, DateTime? endDate}) {
    String url = '$apiBase/alerts/metrics';
    if (startDate != null && endDate != null) {
      final start = startDate.toIso8601String().split('T')[0];
      final end = endDate.toIso8601String().split('T')[0];
      url += '?startDate=$start&endDate=$end';
    }
    return url;
  }
  static DateTime get getAlertMetricsExampleStartDate => DateTime.now().subtract(const Duration(days: 30));
  static DateTime get getAlertMetricsExampleEndDate => DateTime.now();

  /// POST /api/alerts/sensor-data
  /// Procesar datos del sensor para detección de fatiga
  static const String processSensorData = '$apiBase/alerts/sensor-data';
  static Map<String, dynamic> get processSensorDataParams => {
    'driverId': 1,
    'tripId': 1,
    'timestamp': DateTime.now().toIso8601String(),
    'fatigueLevel': 0.75,
    'drowsinessDetected': true,
  };

  /// POST /api/alerts/{alertId}/acknowledge
  /// Reconocer una alerta crítica
  static String acknowledgeAlert(int alertId, int userId, {String? actionTaken}) {
    String url = '$apiBase/alerts/$alertId/acknowledge?userId=$userId';
    if (actionTaken != null) {
      url += '&actionTaken=$actionTaken';
    }
    return url;
  }
  static const int acknowledgeAlertExampleAlertId = 1;
  static const int acknowledgeAlertExampleUserId = 1;
  static const String acknowledgeAlertExampleActionTaken = 'Conductor notificado';

  /// POST /api/alerts/{alertId}/resolve
  /// Resolver una alerta crítica
  static String resolveAlert(int alertId) => '$apiBase/alerts/$alertId/resolve';
  static Map<String, dynamic> get resolveAlertParams => {
    'actionTaken': 'Alerta resuelta - conductor descansó',
  };
  static const int resolveAlertExampleAlertId = 1;

  // ==================== Critical Events ====================
  
  /// GET /api/critical-events/pending
  /// Obtener eventos críticos pendientes
  static const String getPendingEvents = '$apiBase/critical-events/pending';

  /// GET /api/critical-events/manager/{managerId}
  /// Obtener eventos asignados a un gerente
  static String getEventsByManager(int managerId) => '$apiBase/critical-events/manager/$managerId';
  static const int getEventsByManagerExampleManagerId = 1;

  /// GET /api/critical-events/{id}
  /// Obtener un evento crítico por ID
  static String getEventById(int eventId) => '$apiBase/critical-events/$eventId';
  static const int getEventByIdExampleEventId = 1;

  /// POST /api/critical-events/handle
  /// Registrar y gestionar un evento crítico
  static const String handleCriticalEvent = '$apiBase/critical-events/handle';
  static Map<String, dynamic> get handleCriticalEventParams => {
    'tripId': 1,
    'driverId': 1,
    'eventType': 'Accidente',
    'severity': 'High',
    'description': 'Descripción del evento crítico',
    'location': 'Ubicación del evento',
  };

  /// POST /api/critical-events/{id}/assign-manager
  /// Asignar gerente a un evento
  static String assignManagerToEvent(int eventId, int managerId) => '$apiBase/critical-events/$eventId/assign-manager?managerId=$managerId';
  static const int assignManagerToEventExampleEventId = 1;
  static const int assignManagerToEventExampleManagerId = 1;

  /// POST /api/critical-events/{id}/add-action
  /// Agregar acción a un evento
  static String addActionToEvent(int eventId) => '$apiBase/critical-events/$eventId/add-action';
  static Map<String, dynamic> get addActionToEventParams => {
    'action': 'Acción tomada para resolver el evento',
  };
  static const int addActionToEventExampleEventId = 1;

  /// POST /api/critical-events/{id}/dispatch-emergency
  /// Despachar respuesta de emergencia
  static String dispatchEmergency(int eventId) => '$apiBase/critical-events/$eventId/dispatch-emergency';
  static const int dispatchEmergencyExampleEventId = 1;

  /// POST /api/critical-events/{id}/notify-insurance
  /// Notificar a la aseguradora
  static String notifyInsurance(int eventId) => '$apiBase/critical-events/$eventId/notify-insurance';
  static Map<String, dynamic> get notifyInsuranceParams => {
    'insuranceReference': 'REF-123456',
  };
  static const int notifyInsuranceExampleEventId = 1;

  /// POST /api/critical-events/{id}/resolve
  /// Resolver un evento crítico
  static String resolveEvent(int eventId) => '$apiBase/critical-events/$eventId/resolve';
  static Map<String, dynamic> get resolveEventParams => {
    'notes': 'Evento resuelto exitosamente',
  };
  static const int resolveEventExampleEventId = 1;
}

