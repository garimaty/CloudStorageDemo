import 'package:cloud_storage_demo/services/cloud_storage_services.dart';
import 'package:flutter/material.dart';


class FilePage extends StatefulWidget {
  const FilePage({Key? key,
  required this.fileName
  }) : super(key: key);
  final String fileName;
  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text("Required file"),
      ),
      body: StreamBuilder(
        stream: StorageServices().downloadUrl(widget.fileName),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasData){
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Image.network(snapshot.data!,
              fit: BoxFit.fill,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
