abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = "Server Failure"]);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = "Cache Failure"]);
}