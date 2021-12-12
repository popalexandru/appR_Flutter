import 'dart:ffi';

class Service {
  String serviceId;
  String serviceName;
  String businessId;
  double servicePrice;


  Service(
      this.serviceId,
      this.serviceName,
      this.businessId,
      this.servicePrice,
      );

  factory Service.fromJson(dynamic json) {
    return Service(
        json['serviceId'] as String,
        json['serviceName'] as String,
        json['businessId'] as String,
        json['servicePrice'] as double,
    );
  }
}
