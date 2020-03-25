import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:practica_dos/apuntes/bloc/apuntes_bloc.dart';

class ItemApuntes extends StatefulWidget {
  final String imageUrl;
  final String materia;
  final String descripcion;
  final int index;
  ItemApuntes({
    Key key,
    @required this.imageUrl,
    @required this.index,
    @required this.materia,
    @required this.descripcion,
  }) : super(key: key);

  @override
  _ItemApuntesState createState() => _ItemApuntesState();
}

class _ItemApuntesState extends State<ItemApuntes> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<ApuntesBloc>(context).add(
                    RemoveDataEvent(index: widget.index),
                  );
                },
              )
            ],
          ),
          Container(
            height: 150,
            width: 250,
            child: AspectRatio(
             aspectRatio: 16 / 9,
            // Puts a "mask" on the child, so that it will keep its original, unzoomed size
            // even while it's being zoomed in
              child: ClipRect(child: PhotoView.customChild(
                child: Image.network(
                    widget.imageUrl ?? "https://via.placeholder.com/150",
                    fit: BoxFit.cover,
                  ),
                  childSize: const Size(150.0, 150.0),
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  customSize: MediaQuery.of(context).size,
                  enableRotation: false,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.8,
                  initialScale: PhotoViewComputedScale.contained,
                  basePosition: Alignment.center,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              "${widget.materia}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: Text("${widget.descripcion}"),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
