
class ReturnCartonList{
  var itemCompanyGUID;
  var quantity;
  var warehouseLocation;
  var trackingNumber;
  var cartonID;
  var assignedQty;

  ReturnCartonList({this.itemCompanyGUID,this.quantity,this.warehouseLocation,this.trackingNumber,
  this.cartonID,this.assignedQty});

  factory ReturnCartonList.fromJson(Map<String, dynamic> json) {
    return ReturnCartonList (
      itemCompanyGUID: json['itemCompanyGUID'],
      quantity: json['quantity'],
      warehouseLocation: json['warehouseLocation'],
      trackingNumber: json['trackingNumber'],
      cartonID: json['cartonID'],
      assignedQty: json['assignedQty'],
    );
  }
}