class ShipmentToInfo{

  var contactName;
  var contactPhone;
  var shipToAttn;
  var shipToAddress;
  var shipToAddress2;
  var shipToCity;
  var shipToState;
  var shipToZip;

  ShipmentToInfo({required this.contactName,required this.contactPhone,
    required this.shipToAttn, required this.shipToAddress,
    required this.shipToAddress2,required this.shipToCity,required this.shipToState,
    required this.shipToZip});

  ShipmentToInfo.fromJson(Map<String, dynamic> json):
        contactName = json['contactName'],
        contactPhone = json['contactPhone'],
        shipToAttn = json['shipToAttn'],
        shipToAddress = json['shipToAddress'],
        shipToAddress2 = json['shipToAddress2'],
        shipToCity = json['shipToCity'],
        shipToState = json['shipToState'],
        shipToZip = json['shipToZip'];

  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'contactPhone': contactPhone,
      'shipToAttn': shipToAttn,
      'shipToAddress': shipToAddress,
      'shipToAddress2': shipToAddress2,
      'shipToCity': shipToCity,
      'shipToState': shipToState,
      'shipToZip': shipToZip,
    };
  }
}