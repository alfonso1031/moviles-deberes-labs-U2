class Foto {
  final String path;
  final String nombre;
  final double latitud;
  final double longitud;
  final DateTime fecha;

  Foto({
    required this.path,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.fecha,
  });

  // Texto listo para mostrar las coordenadas en la interfaz.
  String get coordenadas =>
      "Lat: ${latitud.toStringAsFixed(6)}, Lng: ${longitud.toStringAsFixed(6)}";

  // URL de Google Maps para abrir la ubicacion en el navegador / app.
  String get urlGoogleMaps =>
      "https://www.google.com/maps/search/?api=1&query=$latitud,$longitud";
}
