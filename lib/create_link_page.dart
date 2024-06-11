import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';
import 'graphql_queries.dart';

class CreateLinkPage extends StatefulWidget {
  final String token;
  final VoidCallback onLinkCreated;

  CreateLinkPage({required this.token, required this.onLinkCreated});

  @override
  _CreateLinkPageState createState() => _CreateLinkPageState();
}

class _CreateLinkPageState extends State<CreateLinkPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String errorMessage = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _imageController.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    _imageController.removeListener(_updateImageUrl);
    _imageController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    setState(() {
      imageUrl = _imageController.text;
    });
  }

  void _createLink() async {
    final client = getGraphQLClient(token: widget.token);
    final QueryResult result = await client.mutate(
      MutationOptions(
        document: gql(createLinkMutation),
        variables: {
          'name': _nameController.text,
          'image': _imageController.text,
          'genre': _genreController.text,
          'species': _speciesController.text,
          'status': _statusController.text,
        },
      ),
    );

    if (result.hasException) {
      setState(() {
        errorMessage = result.exception.toString();
      });
    } else {
      widget.onLinkCreated(); // Llamamos a la función para refrescar los datos
      Navigator.pop(context); // Cerramos CreateLinkPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear nuevo personaje',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(
            color: Colors.white), // Esto hace que el ícono de volver sea blanco
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Nombre'),
              _buildTextField(_imageController, 'Url de la imagen'),
              if (imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error cargando la imagen');
                    },
                  ),
                ),
              _buildTextField(_genreController, 'Género'),
              _buildTextField(_speciesController, 'Especie'),
              _buildTextField(_statusController, 'Estatus'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Crear personaje',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[800]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green[800]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}
