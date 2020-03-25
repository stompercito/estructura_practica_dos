part of 'apuntes_bloc.dart';

abstract class ApuntesEvent extends Equatable {
  const ApuntesEvent();
}

class GetDataEvent extends ApuntesEvent {
  @override
  List<Object> get props => [];
}

class RemoveDataEvent extends ApuntesEvent {
  final int index;

  RemoveDataEvent({
    @required this.index,
  });
  @override
  List<Object> get props => [index];
}

class SaveDataEvent extends ApuntesEvent {
  final String materia;
  final String descripcion;
  final String imageUrl;

  SaveDataEvent({
    @required this.materia,
    @required this.descripcion,
    @required this.imageUrl,
  });

  @override
  List<Object> get props => [materia, descripcion, imageUrl];
}

class UploadFile extends ApuntesEvent {
  final dynamic contx;
  final dynamic choosenImage;
  final String descripcion;
  final String materia;

  UploadFile({
    @required this.contx,
    @required this.materia,
    @required this.descripcion,
    @required this.choosenImage,
  });

  @override
  List<Object> get props => [materia, descripcion, choosenImage];
}
