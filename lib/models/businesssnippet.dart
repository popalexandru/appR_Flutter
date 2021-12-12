import 'dart:ffi';

class BusinessSnippet {
  String businessSnippetId;
  String businessId;
  String businessName;
  String businessImgUrl;
  double rating;
  List<dynamic> categoriesList;


  BusinessSnippet(
      this.businessSnippetId,
      this.businessId,
      this.businessName,
      this.businessImgUrl,
      this.rating,
      this.categoriesList
      );

  factory BusinessSnippet.fromJson(dynamic json) {
    return BusinessSnippet(
        json['businessSnippetId'] as String,
        json['businessId'] as String,
        json['businessName'] as String,
        json['businessImgUrl'] as String,
        json['rating'] as double,
        json['categoriesList'] as List<dynamic>
    );
  }
}
