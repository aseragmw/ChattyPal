class BasicAuthException implements Exception {}

class InvalidEmailAuthException extends BasicAuthException {}

class UserDisabledAuthException extends BasicAuthException {}

class UserNotFoundAuthException extends BasicAuthException {}

class WrongPasswordAuthException extends BasicAuthException {}

class EmailAlreadyInUseAuthException extends BasicAuthException {}

class OperationNotAllowedAuthException extends BasicAuthException {}

class WeakPasswordAuthException extends BasicAuthException {}

class RequiresRecentLoginAuthException extends BasicAuthException {}

class OperationErrorAuthException extends BasicAuthException {}
