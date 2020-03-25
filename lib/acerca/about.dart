import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class About extends StatefulWidget {
  About({Key key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  bool _isLoading = false;
  TextEditingController _comentarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Stack(
            alignment: FractionalOffset.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 12),
                  Container(child: Text('Esta app sirve para guardar recordatorios en tu telefono. En otra de las pestañas se pueden guardara notas con imagenes para recordar algo en especifico.'),),
                  SizedBox(height: 12),
                  Container(child: Text('Desarrollador: @stomper'),),
                  SizedBox(height: 12),
                  TextField(
                    controller: _comentarioController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Comentarios...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Enviar"),
                          onPressed: () async {
                            await _sendEmail();
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              _isLoading ? CircularProgressIndicator() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future _sendEmail() async {
    setState(() {
      _isLoading = true;
    });
    final MailOptions mailOptions = MailOptions(
      body: '$_comentarioController',
      subject: 'Comentary',
      recipients: ['is709571@iteso.mx'],
      isHTML: true,
    );

    await FlutterMailer.send(mailOptions);
    
    setState(() {
      _isLoading = false;
    });
    Future.delayed(Duration(milliseconds: 1500)).then((_) {
      Navigator.of(context).pop();
    });
  }
}
  