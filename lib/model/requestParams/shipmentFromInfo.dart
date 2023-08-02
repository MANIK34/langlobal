
class ShipmentFromInfo{

  var shipFromAddress;
  var shipFromContactName;
  var shipFromCity;
  var shipFromState;
  var shipFromZip;
  var shipFromCountry;
  var shipFromPhone;

  ShipmentFromInfo({required this.shipFromAddress,required this.shipFromContactName,
    required this.shipFromCity, required this.shipFromState,
    required this.shipFromZip,required this.shipFromCountry,required this.shipFromPhone});

  ShipmentFromInfo.fromJson(Map<String, dynamic> json):
        shipFromAddress = json['shipFromAddress'],
        shipFromContactName = json['shipFromContactName'],
        shipFromCity = json['shipFromCity'],
        shipFromState = json['shipFromState'],
        shipFromZip = json['shipFromZip'],
        shipFromCountry = json['shipFromCountry'],
        shipFromPhone = json['shipFromPhone'];

  Map<String, dynamic> toJson() {
    return {
      'shipFromAddress': shipFromAddress,
      'shipFromContactName': shipFromContactName,
      'shipFromCity': shipFromCity,
      'shipFromState': shipFromState,
      'shipFromZip': shipFromZip,
      'shipFromCountry': shipFromCountry,
      'shipFromPhone': shipFromPhone,
    };
  }

}