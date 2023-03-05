
class CartonList{

  var cartonID;
  var warehouseLocation;
  var isDelete;
  var palletID;
  var quantityPerCarton;

  CartonList({this.cartonID, this.warehouseLocation,this.isDelete,this.palletID,this.quantityPerCarton});

  factory CartonList.fromJson(Map<String, dynamic> json) {
    return CartonList(
      cartonID: json['cartonID'],
      warehouseLocation: json['warehouseLocation'],
      isDelete: json['isDelete'],
      palletID: json['palletID'],
      quantityPerCarton: json['quantityPerCarton'],
    );
  }
}