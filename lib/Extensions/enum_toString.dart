
extension EnumToName on String {
  enumNameToString({String splitPattern = '_'}){
    String name = this;
    var splitString = name.split(splitPattern);
    for(int i = 0; i < splitString.length; i++){
      var sString = splitString[i];
      sString = sString.replaceFirst(sString[0], sString[0].toUpperCase());
      if(i==0) {
        name = sString;
      } else {
        name += " $sString";
      }
    }
    return name;
  }
}