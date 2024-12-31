const String baseurl = 'https://api.openrouteservice.org/v2/directions/driving-car';
const String apikey = '5b3ce3597851110001cf62485ac35b0a5cac4ae89175daa80db4d8a3';

getRouteUrl(String startPoint, String endpoint) {
  return Uri.parse('$baseurl?api_key=$apikey&start=$startPoint&end=$endpoint');
}
