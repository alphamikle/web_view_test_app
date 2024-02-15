import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController urlController = TextEditingController();
  String? error;
  WebViewController? webViewController;

  String? urlValidator(String? url) {
    if (url == null) {
      error = 'Url should not be empty';
      return error;
    }
    final Uri? uri = Uri.tryParse(url ?? '');
    if (uri == null) {
      error = 'Url is not correct';
      return error;
    } else {
      if (uri.hasScheme == false) {
        error = 'Invalid scheme';
        return error;
      }
    }
    error = null;
    return null;
  }

  Future<void> runWebView(Uri uri) async {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);
  }

  Future<void> tryToRunWebView() async {
    final String? error = urlValidator(urlController.text);
    if (error == null) {
      final url = Uri.parse(urlController.text);
      runWebView(url);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: urlController,
                    validator: urlValidator,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      errorText: error,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: tryToRunWebView,
                  child: const Text('Open'),
                ),
              ],
            ),
          ),
          Expanded(
            child: webViewController == null
                ? const SizedBox()
                : WebViewWidget(
                    controller: webViewController!,
                  ),
          ),
        ],
      ),
    );
  }
}
