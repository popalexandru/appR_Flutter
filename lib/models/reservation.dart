import 'package:appreservations/models/service.dart';

class Reservation {
  String reservationId;
  String userId;
  String businessId;
  String serviceId;
  String businessName;
  int timestampDone;
  int timestampDue;
  Service service;


  Reservation(
      this.reservationId,
      this.userId,
      this.businessId,
      this.serviceId,
      this.businessName,
      this.timestampDone,
      this.timestampDue,
      this.service
      );

  factory Reservation.fromJson(dynamic json) {
    return Reservation(
        json['reservationId'] as String,
        json['userId'] as String,
        json['businessId'] as String,
        json['serviceId'] as String,
        json['businessName'] as String,
        json['timestampDone'] as int,
        json['timestampDue'] as int,
        Service.fromJson(json['service'])
    );
  }
}
