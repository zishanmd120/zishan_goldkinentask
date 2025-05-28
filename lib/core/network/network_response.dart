class NetworkResponse<T> {

  T? data;
  String? message;
  int? status;

  NetworkResponse.empty();

  NetworkResponse.withSuccess(this.data, this.message, this.status);

  NetworkResponse.withFailure(this.message, this.status);
}
