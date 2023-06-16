
import 'package:cloud_storage_demo/screens/filePage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/cloud_storage_services.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
   final StorageServices storage=StorageServices();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: const Text("Firebase Storage"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          final results = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png','jpg','pdf'],
          );
          if(results==null){
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("no file selected")));
            return;
          }
          final path = results.files.single.path!;
         final filename=results.files.single.name;
         print(path);
         print(filename);
         storage.uploadFile(filePath: path, fileName: filename).then((value) {
           ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text("store successfully")));
           setState(() {

           });
         });

        },

        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Container(
           padding: const EdgeInsets.all(10),
          child: StreamBuilder(
            stream: storage.listFiles(),
            builder: (BuildContext context,AsyncSnapshot<ListResult> snapshot){
if(snapshot.hasData){
return ListView.builder(
  physics: const ClampingScrollPhysics(),
  shrinkWrap: true,
    itemCount: snapshot.data?.items.length??0,
    itemBuilder:(BuildContext context,int index){

return InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
    FilePage(fileName: snapshot.data?.items[index].name??'')
    ));
  },
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.pink[200],
        ),
        height: 50,
        width: 250,
        margin: const EdgeInsets.only(bottom: 10),
        child: Center(child: Text(snapshot.data?.items[index].name??'',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white
        ),
        )),
      ),
      IconButton(onPressed: (){
        print(snapshot.data?.items[index].fullPath);
        FirebaseStorage.instance.
        ref(snapshot.data?.items[index].fullPath).delete().then((value) {
          ScaffoldMessenger.of(context).
          showSnackBar(const SnackBar(content: Text("Delete Successfully")));
          setState(() {

          });
        });

      }, icon:
      Icon(Icons.delete,
      color: Colors.pink[200],
        size: 40,
      )
      )
    ],
  ),
);
    },
);


}
return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      )
    );
  }

}
