/// Base class for all use cases.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}
