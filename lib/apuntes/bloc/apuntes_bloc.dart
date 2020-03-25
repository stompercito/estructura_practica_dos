import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_dos/models/apunte.dart';
import 'package:path/path.dart' as Path;

part 'apuntes_event.dart';
part 'apuntes_state.dart';

class ApuntesBloc extends Bloc<ApuntesEvent, ApuntesState> {
  final Firestore _firestoreInstance = Firestore.instance;
  List<Apunte> _apuntesList;
  List<DocumentSnapshot> _documentsList;
  List<Apunte> get getApuntesList => _apuntesList;

  @override
  ApuntesState get initialState => ApuntesInitial();

  @override
  Stream<ApuntesState> mapEventToState(
    ApuntesEvent event,
  ) async* {
    if (event is GetDataEvent) {
      bool dataRetrieved = await _getData();
      if (dataRetrieved)
        yield CloudStoreGetData();
      else
        yield CloudStoreError(
          errorMessage: "No se ha podido conseguir datos.",
        );
    } else if (event is SaveDataEvent) {
      bool saved = await _saveApunte(
        event.materia,
        event.descripcion,
        event.imageUrl,
      );
      if (saved) {
        await _getData();
        yield CloudStoreSaved();
      } else
        yield CloudStoreError(
          errorMessage: "Ha ocurrido un error. Intente guardar mas tarde.",
        );
    } else if (event is UploadFile) {
        await _uploadFile(
        event.contx,
        event.materia,
        event.descripcion,
        event.choosenImage,
      );
        await _getData();
        yield CloudStoreSaved();
        
      
    } else if (event is RemoveDataEvent) {
      try {
        await _documentsList[event.index].reference.delete();
        _documentsList.removeAt(event.index);
        _apuntesList.removeAt(event.index);
        yield CloudStoreRemoved();
      } catch (err) {
        yield CloudStoreError(
          errorMessage: "Ha ocurrido un error. Intente borrar mas tarde.",
        );
      }
    }
  }

  Future<bool> _getData() async {
    try {
      var apuntes =
          await _firestoreInstance.collection("apuntes").getDocuments();
      _apuntesList = apuntes.documents
          .map(
            (apunte) => Apunte(
              materia: apunte["materia"],
              descripcion: apunte["descripcion"],
              imageUrl: apunte["imagen"],
            ),
          )
          .toList();
      _documentsList = apuntes.documents;
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<bool> _saveApunte(
    String materia,
    String descripcion,
    String imageUrl,
  ) async {
    try {
      await _firestoreInstance.collection("apuntes").document().setData({
        "materia": materia,
        "descripcion": descripcion,
        "imagen": imageUrl,
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future _uploadFile(
    dynamic contx,
    String materia,
    String descripcion,
    dynamic choosenImage,
    ) async {
    String url;
    String filePath = choosenImage.path;
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("apuntes/${Path.basename(filePath)}");
    StorageUploadTask uploadTask = reference.putFile(choosenImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((imageUrl) {
      print("Link>>>>> $imageUrl");
    });

    reference.getDownloadURL().then((fileURL) async {
      print("$fileURL");
        url = fileURL;      
        await _saveApunte(materia, descripcion, url);       
    });
  }

  
}
