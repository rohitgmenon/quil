import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<String> compiler(String input, String lang, [String stdin = '']) async {
  try {
    // Use the correct public Piston endpoint
    var url = Uri.parse('https://emkc.org/api/v2/piston/execute');

    var versions = {
      'python': '3.10.0',
      'javascript': '18.15.0',
      'java': '15.0.2',
      'c': '10.2.0',
      'cpp': '10.2.0',
    };

    var body = convert.jsonEncode({
      'language': lang,
      'version': versions[lang] ?? '3.10.0',
      'files': [
        {'content': input},
      ],
      'stdin': stdin,
    });

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Status Code: ${response.statusCode}'); // Debug line
    print('Response Body: ${response.body}'); // Debug line

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map;
      var output = jsonResponse['run']['output'] ?? 'No output';
      var stderr = jsonResponse['run']['stderr'] ?? '';

      if (stderr.isNotEmpty) {
        return 'Errors:\n$stderr\n\nOutput:\n$output';
      }
      return output;
    } else {
      return 'Request failed with status: ${response.statusCode}\nBody: ${response.body}';
    }
  } catch (e) {
    return 'Error: $e';
  }
}
