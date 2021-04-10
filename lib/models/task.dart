class Task{
  final int id;
  final String title;
  final String discription;

  Task({this.id,this.title,this.discription});

  Map<String,dynamic>toMap(){
    return{
      "id":id,
      "title":title,
      "discription":discription,
      

    };
  }
}