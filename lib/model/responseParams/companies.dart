class CompanyList{

  var companyID;
  String companyName;
  String companyShortName;
  String companyLogo;

  CompanyList({required this.companyID, required this.companyName, required this.companyShortName
    , required this.companyLogo});

  factory CompanyList.fromJson(Map<String, dynamic> json) {
    return CompanyList(
      companyID: json['companyID'],
      companyName: json['companyName'].toString(),
      companyShortName: json['companyShortName'].toString(),
      companyLogo: json['companyLogo'].toString(),
    );
  }
}