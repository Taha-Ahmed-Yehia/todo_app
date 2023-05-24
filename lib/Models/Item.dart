
class Item{
  final String name;
  bool isDone;

  factory Item.fromJson(Map<String,dynamic> json) => Item(json['name'], isDone:json['isDone']);
   Map<String, dynamic> toJson() => { 'name':name, 'isDone':isDone };

  Item(this.name,{this.isDone = false});

  void doneChange(){
    isDone = !isDone;
  }
}