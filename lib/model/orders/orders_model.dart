class OrdersModel {
  bool? status;
  Data? data;

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<OrdersDetails> ordersDetails = [];

  Data.fromJson(Map<String, dynamic> json) {
    json['data'];
    json['data'].forEach((v) {
      ordersDetails.add(OrdersDetails.fromJson(v));
    });
    if (json['data'] != null) {
      ordersDetails = [];
      json['data'].forEach((v) {
        ordersDetails.add(OrdersDetails.fromJson(v));
      });
    }
    json['data'].forEach((value) {
      ordersDetails.add(OrdersDetails.fromJson(value));
    });
  }
}

class OrdersDetails {
  int? id;
  dynamic total;
  String? date;
  String? status;

  OrdersDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    date = json['date'];
    status = json['status'];
  }
}
